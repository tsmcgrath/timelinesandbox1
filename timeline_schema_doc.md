# 📜 Timeline JSON Schema Documentation

Welcome! This repository defines a **generic JSON schema** for storing and sharing historical, geologic, or other timeline-based datasets. The format is designed to be flexible, filterable, and extensible — enabling consistent structure across diverse time-based narratives.

---

## 📦 Top-Level Structure

A timeline dataset is a single JSON file with a root-level `timeline` array:

```json
{
  "timeline": [ /* list of periods */ ]
}
```

Each period can represent an **era, age, dynasty, or large span of time** (e.g., *Precambrian*, *Roman Empire*, *Medieval China*).

---

## 🧱 JSON Field Reference

### `timeline[]`

| Field              | Type      | Required | Description |
|-------------------|-----------|----------|-------------|
| `category`         | `string`  | ✅       | Type of timeline (e.g. `"Geologic"`, `"Historical"`, `"Mythological"`) |
| `period`           | `string`  | ✅       | Name of the major period (e.g. `"Roman Empire"`, `"Precambrian"`) |
| `start_time`       | `object`  | ✅       | When the period begins. Format: `{ "unit": string, "value": number }` |
| `end_time`         | `object`  | ✅       | When the period ends. Format: `{ "unit": string, "value": number }` |
| `subdivisions`     | `array`   | ❌       | Sub-periods such as epochs, reigns, or dynasties |

---

### `start_time` / `end_time` / `event.time`

```json
{
  "unit": "million_years_ago" | "year" | "BCE" | "CE" | "other",
  "value": number
}
```

Use consistent units across the whole timeline.  
Examples:
- Geologic: `"unit": "million_years_ago"`
- Historical: `"unit": "year"` (use `-44` for 44 BCE)
- Custom: `"unit": "era_number"` if using a fictional calendar

---

### `subdivisions[]`

Each subdivision can include:

| Field              | Type      | Required | Description |
|-------------------|-----------|----------|-------------|
| `name`             | `string`  | ✅       | Name of the subdivision (e.g., `"Cambrian"`, `"Late Republic"`) |
| `start_time`       | `object`  | ✅       | Start of the subdivision |
| `end_time`         | `object`  | ✅       | End of the subdivision |
| `events`           | `array`   | ❌       | List of key events in this subdivision |

---

### `events[]`

| Field                 | Type      | Required | Description |
|----------------------|-----------|----------|-------------|
| `name`               | `string`  | ✅       | Short event title |
| `time`               | `object`  | ✅       | Time of the event (same format as above) |
| `description`        | `string`  | ✅       | Short narrative description |
| `relative_importance`| `number`  | ❌       | Float from `0.0` (least) to `1.0` (most important) — used for filtering |

---

## 🧠 Examples

### Event Example (Historical)
```json
{
  "name": "Battle of Hastings",
  "time": { "unit": "year", "value": 1066 },
  "description": "Norman conquest of England begins.",
  "relative_importance": 1.0
}
```

### Event Example (Geologic)
```json
{
  "name": "Cambrian Explosion",
  "time": { "unit": "million_years_ago", "value": 541 },
  "description": "Rapid diversification of animal life.",
  "relative_importance": 1.0
}
```

---

## 🧪 Validation & Tools

- You may use a linter or JSON schema validator to check formatting
- Future versions may include a full JSON Schema (`timeline.schema.json`)
- Contributions should be well-formatted and ideally sorted by time

---

## 📂 File Naming Conventions

Use clear and consistent filenames:
- `roman_empire.json`
- `geologic_timescale.json`
- `mayan_calendar.json`

---

## 🤝 Contributing

You’re encouraged to submit timelines from any domain — history, science, mythology, even fiction!

Please:
- Use consistent time units
- Keep descriptions short but educational
- Include `relative_importance` if your timeline might be filtered or narrated

Pull requests should include:
- One `.json` file under a `timelines/` folder
- Follow this schema
- Optionally: a README with citations or source notes

---

## 📬 Questions or Feedback?

Feel free to open an issue or suggest schema improvements.