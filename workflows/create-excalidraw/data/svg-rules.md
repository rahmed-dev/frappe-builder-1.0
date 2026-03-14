# SVG Generation Rules

SVG output must be fully self-contained and render correctly when embedded in a markdown file and converted to PDF.

---

## Required SVG Attributes

```svg
<svg xmlns="http://www.w3.org/2000/svg"
     viewBox="0 0 {width} {height}"
     width="{width}"
     height="{height}">
```

- `viewBox` set to encompass all elements with 40px padding on each side
- Both `width` and `height` attributes present
- No external image or resource references

---

## Font Embedding

Include this style block inside `<svg>`:

```svg
<defs>
  <style>
    @import url('https://fonts.googleapis.com/css2?family=Virgil');
    text { font-family: Virgil, 'Segoe UI Emoji', cursive; }
  </style>
</defs>
```

---

## Shape Rendering

**Rectangles:**
```svg
<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="4" ry="4"
      fill="transparent" stroke="#1e1e1e" stroke-width="2"
      stroke-linecap="round" stroke-linejoin="round"/>
```

**Rounded rectangles:** `rx="12" ry="12"`

**Diamonds:** Render as `<polygon>` with 4 points at mid-edges of bounding box.

**Ellipses:**
```svg
<ellipse cx="{cx}" cy="{cy}" rx="{rx}" ry="{ry}"
         fill="transparent" stroke="#1e1e1e" stroke-width="2"/>
```

---

## Text Labels

Centred inside their shape:
```svg
<text x="{cx}" y="{cy}"
      dominant-baseline="middle"
      text-anchor="middle"
      font-size="14"
      fill="#1e1e1e">Label text</text>
```

---

## Arrows

```svg
<defs>
  <marker id="arrowhead" markerWidth="8" markerHeight="6"
          refX="8" refY="3" orient="auto">
    <polygon points="0 0, 8 3, 0 6" fill="#1e1e1e"/>
  </marker>
</defs>
<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}"
      stroke="#1e1e1e" stroke-width="1.5"
      marker-end="url(#arrowhead)"/>
```

Arrow label (mid-point):
```svg
<text x="{mid_x}" y="{mid_y - 6}"
      text-anchor="middle" font-size="11" fill="#6b7280">label</text>
```

---

## Frame / Group Containers

```svg
<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="8" ry="8"
      fill="transparent" stroke="#d1d5db" stroke-width="1"
      stroke-dasharray="6,3"/>
<text x="{x + 8}" y="{y - 6}" font-size="11" fill="#6b7280"
      font-weight="bold">Frame Label</text>
```

---

## Self-Containment Checklist

- [ ] No `<image>` elements with external `href`
- [ ] No `url()` references that require network access (except Google Fonts import, which degrades gracefully)
- [ ] All colours defined inline (no CSS class references to external sheets)
- [ ] `viewBox` calculated correctly to include all elements + 40px padding
- [ ] Arrowhead marker defined in `<defs>` before first use
