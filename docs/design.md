# Audio Timeline: Design Decisions

This file records design decisions that affect more than one feature. Each entry gives the decision, the reason, and what it implies for the code. Update the entry rather than adding a duplicate when a decision changes.

---

## 1. Time normalization: canonical years

**Decision.** All time values are converted to one canonical axis: a `Double` count of **astronomical years**, where 0 = 1 BCE and negative values are earlier. The JSON files are not changed. Conversion happens in Swift when data is loaded.

**Why.** The bundled timelines mix units (`year` and `million_years_ago`). Two timelines active on one walk can only be placed on the same path after their times share a single axis. Canonical years keep historical and geologic data comparable without changing the source files.

**Conversion rules.**

| Source unit | Canonical years |
|---|---|
| `year`, value ≥ 1 (CE) | `value` |
| `year`, value < 0 (BCE) | `value + 1` (the data uses `-44` for 44 BCE, with no year zero) |
| `million_years_ago` | `presentYear − value × 1_000_000` |

- `presentYear` is a single named constant, **2026**. It has no practical effect at million-year scale.
- An unrecognized unit must fail visibly. It must not be converted silently.

**Implications.**
- Add `TimeUnit` (`.year`, `.millionYearsAgo`, `.unknown(String)`).
- Add `TimePoint.canonicalYears: Double?`, which returns `nil` for unknown units.
- Keep the existing Codable shapes so the decoding tests still pass.
- Record the unit list and these rules in `docs/schema/` when the feature lands.

---

## 2. Distance mapping: per-timeline scale

**Decision.** Each active timeline has its own scale and anchor:

```
distance_m = (canonicalYears − anchorYears) × metersPerYear
```

- `metersPerYear` is set **per timeline**, not globally. A historical timeline and a geologic timeline can use different scales.
- `anchorYears` is the point where the walk starts for that timeline. By default this is the present (2026), so timelines active together start at the same origin.
- **The user sets the distance units in the app.** Neither the scale nor the display unit is fixed in code or in the timeline JSON. The user chooses:
  - the **scale** for each timeline (how much distance represents one year, or one million years, for that timeline), and
  - the **display unit** for distances (for example metres, feet, kilometres, or miles).
- Internally, all distance math is done in metres. The display unit only affects how values are shown and entered, so conversions happen at the edges and the core logic stays in one unit.
- User settings are stored in the app, not in the timeline files. The bundled JSON stays unchanged.

**Why.** A single global scale cannot serve both a 2,000-year Roman timeline and a 4,600-million-year geologic one. Per-timeline scaling lets each be paced separately.

**Implications.**
- `metersPerYear` and `anchorYears` are parameters of a timeline's playback state, not fields in the JSON.
- The scale and anchor are the only inputs needed to turn an event into a distance. Units never reach the distance code.

---

## 3. Open decisions

These are not yet decided. They are listed here so they are not lost.

- **Deep-time compression.** A linear scale makes the geologic timeline impractical to walk (about 4.6 million km at 1 m per year). A logarithmic or piecewise scale would solve this, but it is a larger change. Decide before the geologic timeline is walked.
- **Importance cutoff.** Which events are narrated depends on `relative_importance`, which is still unexplained. This is tracked in `CLAUDE.md` under Open questions.
- **Uncertain dates.** Geologic dates are approximate. The schema has no field for uncertainty, so a point is treated as exact. Revisit if that causes problems.
