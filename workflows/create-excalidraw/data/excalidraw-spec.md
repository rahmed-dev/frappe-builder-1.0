# Excalidraw Diagram Specification

---

## Visual Style

| Property | Value | Reason |
|----------|-------|--------|
| `roughness` | `1` | Hand-drawn feel |
| `fontFamily` | `1` (Virgil) | Excalidraw signature font |
| `strokeWidth` | `2` (shapes), `1` (annotations) | Visual weight hierarchy |
| `fillStyle` | `hachure` (sparingly) or `transparent` | Avoids heavy solid fills |
| `strokeStyle` | `solid` | Clean lines |

Colours — limit to 3–4 per diagram:
| Role | Stroke | Fill (if used) |
|------|--------|----------------|
| Primary / User actions | `#3b82f6` (blue) | `#dbeafe` |
| Secondary / System | `#6b7280` (grey) | `#f3f4f6` |
| Success / Completed | `#059669` (green) | `#d1fae5` |
| Warning / Error | `#ef4444` (red) | `#fee2e2` |
| Neutral / Notes | `#92400e` (amber) | `#fde68a` |

---

## Layout Patterns

| Pattern | Use When |
|---------|----------|
| Left-to-right flow | Sequential steps, pipelines, process flows |
| Top-to-bottom hierarchy | Approval chains, parent→child, org structures |
| Swim lanes (column frames) | Multiple roles acting in parallel |
| Cluster/group boxes | Related concepts that belong together visually |
| Matrix | Comparing options or mapping two dimensions |

Spacing guidelines:
- Boxes: 160×60px typical, 200×80px for larger labels
- Horizontal gap between boxes: ~60px
- Vertical gap between rows: ~80px
- Swim lane frame height: ~200px; gap between lanes: ~20px

---

## Shape Types

| Shape | `type` value | `roundness` | Use For |
|-------|-------------|-------------|---------|
| Rectangle | `rectangle` | `null` | Actions, steps, DocTypes |
| Rounded rectangle | `rectangle` | `{"type": 3}` | States, outcomes, results |
| Diamond | `diamond` | `null` | Decisions, branches |
| Ellipse | `ellipse` | `null` | Start/End points, events |
| Arrow | `arrow` | — | Connections, flow |
| Text | `text` | — | Labels, annotations |
| Frame | `frame` | — | Group containers, swim lanes |

---

## JSON File Format

```json
{
  "type": "excalidraw",
  "version": 2,
  "source": "frappe-builder-doc-writer",
  "elements": [],
  "appState": {
    "gridSize": null,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
```

### Element Base Structure

```json
{
  "id": "unique-alphanumeric-id",
  "type": "rectangle",
  "x": 0,
  "y": 0,
  "width": 160,
  "height": 60,
  "angle": 0,
  "strokeColor": "#1e1e1e",
  "backgroundColor": "transparent",
  "fillStyle": "hachure",
  "strokeWidth": 2,
  "strokeStyle": "solid",
  "roughness": 1,
  "opacity": 100,
  "roundness": null,
  "seed": 12345,
  "version": 1
}
```

Text labels are added as child `text` elements or as separate `text` type elements positioned over shapes.

### Arrow Bindings

Arrows that connect two shapes include:
```json
{
  "type": "arrow",
  "startBinding": {"elementId": "source-id", "gap": 4, "focus": 0},
  "endBinding": {"elementId": "target-id", "gap": 4, "focus": 0},
  "points": [[0, 0], [60, 0]]
}
```

### Frame Elements

```json
{
  "type": "frame",
  "name": "Frame Label",
  "x": 20,
  "y": 20,
  "width": 400,
  "height": 200
}
```
