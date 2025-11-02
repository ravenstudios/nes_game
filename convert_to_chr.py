from PIL import Image
import sys, math

def to_chr(img):
    # Ensure indexed 0..3 (you can pre-quantize precisely if you want consistent mapping)
    im = Image.open(img).convert("RGBA")
    # Drop alpha to a background color if needed
    bg = Image.new("RGBA", im.size, (0,0,0,0))
    bg.paste(im, mask=im.split()[3])
    im = bg.convert("RGB").quantize(colors=4, dither=Image.Dither.NONE)
    w, h = im.size
    # Pad to multiples of 8
    W = (w + 7) & ~7
    H = (h + 7) & ~7
    if (W, H) != (w, h):
        pad = Image.new("P", (W, H), 0)
        pad.paste(im, (0,0))
        im = pad
        w, h = W, H

    px = im.load()
    data = bytearray()
    tiles_x, tiles_y = w // 8, h // 8

    for ty in range(tiles_y):
        for tx in range(tiles_x):
            # low plane rows
            lows = []
            highs = []
            for y in range(8):
                low = high = 0
                for x in range(8):
                    ix = px[tx*8 + x, ty*8 + y] & 3
                    low  = (low  << 1) | ( ix       & 1)
                    high = (high << 1) | ((ix >> 1) & 1)
                lows.append(low)
                highs.append(high)
            data.extend(lows + highs)
    return data

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: img2chr.py input.png output.chr")
        sys.exit(1)
    out = to_chr(sys.argv[1])
    with open(sys.argv[2], "wb") as f:
        f.write(out)
    print(f"Wrote {len(out)} bytes ({len(out)//16} tiles)")
