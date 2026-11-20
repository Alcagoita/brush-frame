"""Generate README artwork for Brush Frame: hero banner and the eight-step loop,
each in light and dark. Run: python3 make_assets.py <out_dir>"""
import math, sys, pathlib

OUT = pathlib.Path(sys.argv[1]); OUT.mkdir(parents=True, exist_ok=True)

THEMES = {
    "light": dict(bg="#fbfaf6", surface="#f4f2ec", ink="#1a1a18", muted="#6b675e", line="#e6e3d9",
                  accent="#b87524", brand="#c1802e", amber="#e8a86a", node="#fbfaf6", on_text="#ffffff",
                  glow="rgba(232,168,106,.28)"),
    "dark":  dict(bg="#0e0e0c", surface="#171715", ink="#f6f5f2", muted="#a3a39b", line="rgba(255,255,255,.14)",
                  accent="#e8a86a", brand="#d4955a", amber="#e8a86a", node="#171715", on_text="#2a1c0a",
                  glow="rgba(232,168,106,.16)"),
}
FONT = "Geist, -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif"
STEPS = ["Idea check", "Design", "Planning", "Setup", "Build loop", "Field test", "Learn", "Release"]
GATES = (1, 2)     # a person decides after these steps
HOLD_LONG = (1, 2, 5)
LOGO = ('<path d="M 9 6 L 9 76"/>'
        '<path d="M 9 40 C 9 30 18 24 30 24 C 42 24 49 31 49 42 L 49 68 C 49 74.5 53.5 77 60 74 C 64 72 66.5 68.5 68 64"/>')


def timeline():
    """Keyframe stops for a marker that travels node to node and holds, longer at gates and step 5."""
    segs = []  # (kind, weight, from_step, to_step)
    for i in range(8):
        segs.append(("hold", 3.0 if (i + 1) in HOLD_LONG else 1.4, i, i))
        segs.append(("move", 1.0, i, i + 1))
    total = sum(w for _, w, _, _ in segs)
    t, out = 0.0, []
    for kind, w, a, b in segs:
        out.append((t / total * 100, kind, a, b, (t + w) / total * 100))
        t += w
    return out


def marker_css(name, dur):
    tl = timeline()
    frames = []
    for start, kind, a, b, end in tl:
        frames.append(f"{start:.2f}%{{transform:rotate({a*45}deg)}}")
        frames.append(f"{end:.2f}%{{transform:rotate({b*45}deg)}}")
    css = f"@keyframes {name}{{{''.join(frames)}}}"
    # each node lights while the marker holds on it
    for start, kind, a, b, end in tl:
        if kind != "hold":
            continue
        s, e = max(start - 0.01, 0), end
        css += (f"@keyframes on{a}{{0%,{s:.2f}%{{fill:var(--node);stroke:var(--line)}}"
                f"{s+0.6:.2f}%,{e:.2f}%{{fill:var(--brand);stroke:var(--brand)}}"
                f"{min(e+1.2,100):.2f}%,100%{{fill:var(--node);stroke:var(--line)}}}}"
                f".n{a} circle{{animation:on{a} {dur}s linear infinite}}"
                f"@keyframes tx{a}{{0%,{s:.2f}%{{fill:var(--muted)}}{s+0.6:.2f}%,{e:.2f}%{{fill:var(--on)}}"
                f"{min(e+1.2,100):.2f}%,100%{{fill:var(--muted)}}}}"
                f".n{a} text.num{{animation:tx{a} {dur}s linear infinite}}")
    return css


def vars_css(t):
    return ";".join(f"--{k.replace('_','-') if k!='on_text' else 'on'}:{v}" for k, v in t.items())


def ring(cx, cy, r, node_r, labels, t, label_size=15):
    """Ring, inner 7->5 arc, gate ticks, nodes, rotating marker. Returns svg fragment."""
    def pt(i, rr=r):
        a = math.radians(-90 + i * 45)
        return cx + rr * math.cos(a), cy + rr * math.sin(a)
    g = [f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="none" stroke="var(--line)" stroke-width="2"/>']
    # inner arc from step 7 back to step 5 (indices 6 -> 4), bowed toward the centre
    (x7, y7), (x5, y5) = pt(6, r - node_r - 10), pt(4, r - node_r - 10)
    ri = r - node_r - 10
    g.append(f'<path d="M {x7:.1f} {y7:.1f} A {ri} {ri} 0 0 0 {x5:.1f} {y5:.1f}" fill="none" '
             f'stroke="var(--brand)" stroke-opacity=".6" stroke-width="1.5" stroke-dasharray="3 6"/>')
    # gates: small diamonds on the ring between step n and n+1
    for gte in GATES:
        a = math.radians(-90 + (gte - 1) * 45 + 22.5)
        gx, gy = cx + r * math.cos(a), cy + r * math.sin(a)
        g.append(f'<rect x="{gx-6:.1f}" y="{gy-6:.1f}" width="12" height="12" transform="rotate(45 {gx:.1f} {gy:.1f})" '
                 f'fill="var(--bg)" stroke="var(--accent)" stroke-width="1.5"/>')
    # marker (rotates around the centre)
    g.append(f'<g class="marker" style="transform-origin:{cx}px {cy}px">'
             f'<circle cx="{cx}" cy="{cy-r}" r="{node_r+7}" fill="var(--brand)" fill-opacity=".18"/></g>')
    for i in range(8):
        x, y = pt(i)
        g.append(f'<g class="n{i}"><circle cx="{x:.1f}" cy="{y:.1f}" r="{node_r}" fill="var(--node)" '
                 f'stroke="var(--line)" stroke-width="1.5"/>'
                 f'<text class="num" x="{x:.1f}" y="{y+5:.1f}" text-anchor="middle" font-size="{node_r*0.85:.0f}" '
                 f'font-weight="500" fill="var(--muted)">{i+1}</text></g>')
        if labels:
            lx, ly = pt(i, r + node_r + 18)
            anchor = "middle" if abs(lx - cx) < 4 else ("start" if lx > cx else "end")
            dy = -4 if ly < cy - r * 0.9 else (14 if ly > cy + r * 0.9 else 5)
            g.append(f'<text x="{lx:.1f}" y="{ly+dy:.1f}" text-anchor="{anchor}" font-size="{label_size}" '
                     f'font-weight="500" fill="var(--ink)">{STEPS[i]}</text>')
    return "".join(g)


def wrap(w, h, t, body, extra_css, title, desc):
    return f'''<svg xmlns="http://www.w3.org/2000/svg" width="{w}" height="{h}" viewBox="0 0 {w} {h}" role="img" aria-labelledby="t d">
<title id="t">{title}</title><desc id="d">{desc}</desc>
<style>
svg{{{vars_css(t)}}}
text{{font-family:{FONT};font-variant-numeric:tabular-nums}}
{extra_css}
@media (prefers-reduced-motion: reduce){{*{{animation:none!important}}.stroke{{stroke-dashoffset:0!important}}}}
</style>
<rect width="{w}" height="{h}" rx="20" fill="var(--bg)"/>
{body}
</svg>
'''


def hero(theme):
    t = THEMES[theme]
    W, H = 1280, 440
    dur = 16
    css = marker_css("travel", dur) + f".marker{{animation:travel {dur}s cubic-bezier(.65,0,.35,1) infinite}}"
    css += (".stroke{stroke-dasharray:360;stroke-dashoffset:360;animation:draw 1.4s .4s cubic-bezier(.65,0,.35,1) forwards}"
            "@keyframes draw{to{stroke-dashoffset:0}}")
    body = [
        f'<rect x="1" y="1" width="{W-2}" height="{H-2}" rx="19" fill="none" stroke="var(--line)"/>',
        f'<circle cx="1010" cy="220" r="120" fill="{t["glow"]}" fill-opacity=".6"/>',
        # logo mark + word
        f'<g transform="translate(72 70) scale(.42)" fill="none" stroke="var(--accent)" stroke-width="9" stroke-linecap="round">{LOGO}</g>',
        f'<text x="108" y="100" font-size="20" font-weight="600" fill="var(--ink)" letter-spacing="-.2">Built for Brush</text>',
        f'<text x="72" y="210" font-size="92" font-weight="600" fill="var(--ink)" letter-spacing="-3">Brush Frame</text>',
        f'<text x="74" y="262" font-size="25" font-weight="500" fill="var(--muted)">A human-led way to build software with AI.</text>',
        f'<text x="74" y="336" font-size="30" font-weight="600" fill="var(--ink)" letter-spacing="-.5">You build the frame; the AI holds the '
        f'<tspan fill="var(--accent)">brush.</tspan></text>',
        # brush stroke under "brush." (x positions tuned for the system sans at 30px)
        f'<path class="stroke" d="M 560 352 C 585 345, 615 343, 640 347 S 668 353, 676 349" fill="none" '
        f'stroke="var(--amber)" stroke-width="6" stroke-linecap="round" stroke-opacity=".75"/>',
        f'<text x="74" y="392" font-size="17" font-weight="500" fill="var(--muted)">Eight steps · two gates · one decider · '
        f'<tspan fill="var(--accent)">people decide, AI makes them faster</tspan></text>',
        ring(1010, 220, 150, 20, False, t),
    ]
    return wrap(W, H, t, "".join(body), css, "Brush Frame",
                "Brush Frame: a human-led way to build software with AI. You build the frame; the AI holds the brush. "
                "A ring of eight steps with a marker moving from step to step.")


def steps(theme):
    t = THEMES[theme]
    W, H = 1280, 640
    dur = 20
    css = marker_css("travel", dur) + f".marker{{animation:travel {dur}s cubic-bezier(.65,0,.35,1) infinite}}"
    cx, cy, r = 300, 320, 190
    rows = [
        ("1", "Idea check", "Is it worth building?", True),
        ("2", "Design", "Screens, model facts, promises.", True),
        ("3", "Planning", "Small tickets, one goal each.", False),
        ("4", "Setup", "Guardrails before the first feature.", False),
        ("5", "Build loop", "One ticket, one branch, one reviewed PR.", False),
        ("6", "Field test", "Real people, real devices.", False),
        ("7", "Learn", "Every correction becomes a rule.", False),
        ("8", "Release", "A tagged version with notes.", False),
    ]
    body = [f'<rect x="1" y="1" width="{W-2}" height="{H-2}" rx="19" fill="none" stroke="var(--line)"/>',
            f'<circle cx="{cx}" cy="{cy}" r="150" fill="{t["glow"]}" fill-opacity=".5"/>',
            ring(cx, cy, r, 24, False, t),
            f'<text x="{cx}" y="{cy-8}" text-anchor="middle" font-size="34" font-weight="600" fill="var(--ink)" letter-spacing="-.6">Eight steps</text>',
            f'<text x="{cx}" y="{cy+24}" text-anchor="middle" font-size="18" font-weight="500" fill="var(--muted)">A person decides at each gate</text>',
            f'<text x="{cx}" y="{cy+50}" text-anchor="middle" font-size="18" font-weight="500" fill="var(--accent)">and merges every change</text>']
    x0, y0, rh = 610, 110, 64
    body.append(f'<text x="{x0}" y="70" font-size="19" font-weight="600" fill="var(--accent)">From idea to release</text>')
    for i, (n, name, what, gate) in enumerate(rows):
        y = y0 + i * rh
        if i:
            body.append(f'<line x1="{x0}" x2="{W-72}" y1="{y-26}" y2="{y-26}" stroke="var(--line)"/>')
        body.append(f'<text x="{x0}" y="{y+12}" font-size="22" font-weight="600" fill="var(--accent)">{n}</text>')
        body.append(f'<text x="{x0+36}" y="{y+12}" font-size="26" font-weight="600" fill="var(--ink)" letter-spacing="-.3">{name}</text>')
        body.append(f'<text x="{x0+214}" y="{y+12}" font-size="21" fill="var(--muted)">{what}</text>')
        if gate:
            body.append(f'<rect x="{W-120}" y="{y-10}" width="52" height="30" rx="15" fill="none" stroke="var(--accent)"/>'
                        f'<text x="{W-94}" y="{y+11}" text-anchor="middle" font-size="15" font-weight="600" fill="var(--accent)">Gate</text>')
    return wrap(W, H, t, "".join(body), css, "The eight steps of Brush Frame",
                "Idea check, Design, Planning, Setup, Build loop, Field test, Learn, Release. "
                "Gates after Idea check and Design, where a person decides. Learn feeds back into the build loop.")


for th in THEMES:
    (OUT / f"hero-{th}.svg").write_text(hero(th))
    (OUT / f"steps-{th}.svg").write_text(steps(th))
print("ok")
