"""Vade uygulama ikonunu üretir: lacivert-turkuaz zemin üzerinde katlanmış köşeli belge,
belgede bitişe kalan süreyi gösteren amber halka ve onay işareti.

Kullanım: python3 make_icon.py <AppIcon.appiconset klasörü>
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

S = 4096  # 4 kat büyük çizip küçültüyoruz; kenarlar yumuşak çıkar.
NAVY = (23, 37, 84)
TEAL = (13, 148, 136)
AMBER = (245, 158, 11)
PAPER = (255, 255, 255)
RING_BG = (226, 232, 240)
INK = (30, 58, 138)
LINE = (203, 213, 225)


def gradient(size):
    """Sol üstten sağ alta lacivert → turkuaz."""
    small = Image.new("RGB", (256, 256))
    px = small.load()
    for y in range(256):
        for x in range(256):
            t = (x + y) / 510
            px[x, y] = tuple(round(a + (b - a) * t) for a, b in zip(NAVY, TEAL))
    return small.resize((size, size), Image.BICUBIC)


def artwork(size):
    k = size / 1024
    img = gradient(size).convert("RGBA")

    left, top, right, bottom, fold = 242 * k, 168 * k, 782 * k, 848 * k, 150 * k
    # Belge şekli: yuvarlak köşeli dikdörtgen, sağ üst köşesi kesik. Gölge de aynı şekilden üretilir.
    shape = Image.new("L", (size, size), 0)
    sd = ImageDraw.Draw(shape)
    sd.rounded_rectangle([left, top, right, bottom], radius=56 * k, fill=255)
    sd.polygon([(right - fold, top - 4), (right + 4, top - 4), (right + 4, top + fold)], fill=0)

    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    offset = shape.transform(shape.size, Image.AFFINE, (1, 0, -14 * k, 0, 1, -26 * k))
    shadow.putalpha(offset.point(lambda v: v * 110 // 255).filter(ImageFilter.GaussianBlur(28 * k)))
    img.alpha_composite(shadow)
    img.paste(PAPER, (0, 0), shape)

    d = ImageDraw.Draw(img)
    # Kıvrık köşe
    d.polygon([(right - fold, top), (right - fold, top + fold - 24 * k), (right - 24 * k, top + fold)], fill=(203, 213, 225))

    # Geri sayım halkası
    cx, cy, rr, w = 512 * k, 452 * k, 150 * k, 44 * k
    box = [cx - rr, cy - rr, cx + rr, cy + rr]
    d.ellipse(box, outline=RING_BG, width=int(w))
    d.arc(box, start=-90, end=180, fill=AMBER, width=int(w))
    # Yay uçlarını yuvarla
    import math
    for ang in (-90, 180):
        a = math.radians(ang)
        ex, ey = cx + (rr - w / 2) * math.cos(a), cy + (rr - w / 2) * math.sin(a)
        d.ellipse([ex - w / 2, ey - w / 2, ex + w / 2, ey + w / 2], fill=AMBER)

    # Onay işareti
    pts = [(cx - 54 * k, cy + 8 * k), (cx - 16 * k, cy + 46 * k), (cx + 56 * k, cy - 38 * k)]
    cw = 36 * k
    d.line(pts, fill=INK, width=int(cw), joint="curve")
    for x, y in (pts[0], pts[-1]):
        d.ellipse([x - cw / 2, y - cw / 2, x + cw / 2, y + cw / 2], fill=INK)

    # Metin satırları
    for i, (x0, x1) in enumerate([(330, 694), (330, 620)]):
        y = (690 + i * 70) * k
        d.rounded_rectangle([x0 * k, y - 15 * k, x1 * k, y + 15 * k], radius=15 * k, fill=LINE)
    return img


def ios_icon():
    return artwork(S).convert("RGB").resize((1024, 1024), Image.LANCZOS)


def mac_icon():
    """macOS ikonları kare değil: şeffaf kenarlı, yuvarlak köşeli 'squircle' + gölge."""
    inner = 824 * S // 1024
    art = artwork(inner)
    mask = Image.new("L", (inner, inner), 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, inner - 1, inner - 1], radius=int(inner * 0.225), fill=255)
    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    off = (S - inner) // 2
    shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    shadow.paste((0, 0, 0, 90), (off, off + S // 64), mask)
    canvas.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(S // 80)))
    canvas.paste(art, (off, off), mask)
    return canvas.resize((1024, 1024), Image.LANCZOS)


def main(out):
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    ios_icon().save(out / "icon-ios-1024.png")
    mac = mac_icon()
    for size in (16, 32, 64, 128, 256, 512, 1024):
        mac.resize((size, size), Image.LANCZOS).save(out / f"icon-mac-{size}.png")


if __name__ == "__main__":
    main(sys.argv[1])
