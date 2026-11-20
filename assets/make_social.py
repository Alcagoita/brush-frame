"""GitHub social preview for Brush Frame (1280x640 PNG).
Run: python3 assets/make_social.py  ->  assets/social-preview.png
Upload it in the repository's Settings > General > Social preview."""
import math, pathlib
from PIL import Image, ImageDraw, ImageFont

S = 2                       # draw at 2x, downscale for smooth edges
W, H = 1280, 640
BG, INK, MUTED, LINE = "#fbfaf6", "#1a1a18", "#6b675e", "#e6e3d9"
ACCENT, BRAND, AMBER = "#b87524", "#c1802e", "#e8a86a"
FONT = "/System/Library/Fonts/SFNS.ttf"   # Geist is the brand face; SF stands in where Geist isn't installed


def font(size, weight, opsz=None):
    f = ImageFont.truetype(FONT, size * S)
    f.set_variation_by_axes([100, opsz or min(max(size, 17), 96), 400, weight])
    return f


img = Image.new("RGB", (W * S, H * S), BG)
d = ImageDraw.Draw(img)
P = lambda v: v * S


def text(x, y, s, f, fill, tracking=0):
    """Draw text with optional tracking (px at 1x); returns the end x at 1x."""
    if not tracking:
        d.text((P(x), P(y)), s, font=f, fill=fill)
        return x + d.textlength(s, font=f) / S
    for ch in s:
        d.text((P(x), P(y)), ch, font=f, fill=fill)
        x += d.textlength(ch, font=f) / S + tracking
    return x


def bezier(p0, p1, p2, p3, n=40):
    return [tuple((1 - t) ** 3 * a + 3 * (1 - t) ** 2 * t * b + 3 * (1 - t) * t ** 2 * c + t ** 3 * e
                  for a, b, c, e in zip(p0, p1, p2, p3)) for t in (i / n for i in range(n + 1))]


def stroke(points, width, fill):
    pts = [(P(x), P(y)) for x, y in points]
    d.line(pts, fill=fill, width=round(P(width)), joint="curve")
    for x, y in (pts[0], pts[-1]):
        r = P(width) / 2
        d.ellipse((x - r, y - r, x + r, y + r), fill=fill)


# frame
d.rounded_rectangle((P(0.5), P(0.5), P(W - 1), P(H - 1)), radius=P(28), outline=LINE, width=P(2))

# Brush mark (the "h" of the logo) + label
mx, my, ms = 80, 84, 0.5
stroke([(mx + 9 * ms, my + 6 * ms), (mx + 9 * ms, my + 76 * ms)], 4.5, ACCENT)
h = (bezier((9, 40), (9, 30), (18, 24), (30, 24)) + bezier((30, 24), (42, 24), (49, 31), (49, 42))
     + [(49, 68)] + bezier((49, 68), (49, 74.5), (53.5, 77), (60, 74)) + bezier((60, 74), (64, 72), (66.5, 68.5), (68, 64)))
stroke([(mx + x * ms, my + y * ms) for x, y in h], 4.5, ACCENT)
text(126, 94, "Built for Brush", font(22, 600), INK)

# title, subtitle
text(76, 168, "Brush Frame", font(112, 650, 96), INK, tracking=-3.2)
text(80, 318, "A human-led way to build software with AI.", font(30, 500), MUTED)

# tagline, with the stroke under "brush."
f = font(34, 620)
x = text(80, 392, "You build the frame; the AI holds the ", f, INK)
x2 = text(x, 392, "brush.", f, ACCENT)
y = 442
stroke(bezier((x - 4, y), (x + 20, y - 7), (x + 48, y - 9), (x + (x2 - x) * .72, y - 5))
       + bezier((x + (x2 - x) * .72, y - 5), (x2 - 10, y), (x2 - 4, y + 1), (x2 + 4, y - 3)), 7, AMBER)

# footer line
fx = text(80, 530, "Eight steps · two gates · one decider", font(22, 500), MUTED)
text(fx, 530, "   ·   github.com/Alcagoita/brush-frame", font(22, 500), ACCENT)

# ring
cx, cy, r, nr = 1035, 300, 165, 23
d.ellipse((P(cx - r), P(cy - r), P(cx + r), P(cy + r)), outline=LINE, width=round(P(2.5)))
pt = lambda i, rr=r: (cx + rr * math.cos(math.radians(-90 + i * 45)), cy + rr * math.sin(math.radians(-90 + i * 45)))
# dashed return from 7 to 5, along an inner circle
ri = r - nr - 12
for k in range(0, 90, 6):
    a0, a1 = math.radians(180 - k), math.radians(180 - k - 3)
    stroke([(cx + ri * math.cos(a0), cy + ri * math.sin(a0)), (cx + ri * math.cos(a1), cy + ri * math.sin(a1))], 2, "#dfc29f")
# gates after steps 1 and 2
for g in (1, 2):
    a = math.radians(-90 + (g - 1) * 45 + 22.5)
    gx, gy = cx + r * math.cos(a), cy + r * math.sin(a)
    q = 8
    d.polygon([(P(gx), P(gy - q)), (P(gx + q), P(gy)), (P(gx), P(gy + q)), (P(gx - q), P(gy))], fill=BG, outline=ACCENT, width=P(2))
# nodes; step 5, the build loop, is lit
nf = font(20, 560)
for i in range(8):
    x, y = pt(i)
    lit = i == 4
    if lit:
        d.ellipse((P(x - nr - 9), P(y - nr - 9), P(x + nr + 9), P(y + nr + 9)), fill="#f1dcc3")
    d.ellipse((P(x - nr), P(y - nr), P(x + nr), P(y + nr)), fill=BRAND if lit else BG, outline=BRAND if lit else LINE, width=P(2))
    s = str(i + 1)
    tw = d.textlength(s, font=nf) / S
    text(x - tw / 2, y - 13, s, nf, "#ffffff" if lit else MUTED)
cf = font(28, 620)
for s, yy, fnt, col in (("Eight steps", cy - 26, cf, INK), ("People decide,", cy + 12, font(18, 500), MUTED),
                        ("AI makes them faster", cy + 36, font(18, 500), ACCENT)):
    tw = d.textlength(s, font=fnt) / S
    text(cx - tw / 2, yy, s, fnt, col)

out = pathlib.Path(__file__).with_name("social-preview.png")
img.resize((W, H), Image.LANCZOS).save(out, optimize=True)
print(out, out.stat().st_size // 1024, "KB")
