# Audio Timeline (iOS prototype)

An iOS SwiftUI app that maps a timeline onto physical distance. For example, 100 years can equal 100 meters. As the user walks, runs, bikes, or drives, the app reads aloud the next timeline event once they have covered the matching distance.

## Working rules
- Build **one feature at a time**. Each feature gets its own commit and a line in the Feature log below.
- **Never remove or break existing features** without explicit instruction from Tim.
- `legacy/` holds the earlier Python exploration. It is reference only, so don't build on it or edit it.
- Keep the Swift models in `AudioTimeline/Model/Timeline.swift` in sync with the schema docs in `docs/schema/`. The current schema is `timeline_schema_doc_v1.1.md`.
- Add Info.plist privacy keys (location, background audio, etc.) in Xcode under the `AudioTimeline` target's Build Settings as `INFOPLIST_KEY_*` values, and commit the project file with the change.
- Tim works in the Xcode IDE and does not use XcodeGen.

## Project layout
- `AudioTimeline.xcodeproj` is the project file and is committed to git. Edit it through Xcode. Its source of truth is the project file itself.
- `AudioTimeline/` holds the app: `App/` (entry point), `Views/`, `Model/`, `Resources/` (asset catalog and `Timelines/`, the bundled timeline JSON).
- `AudioTimelineTests/` holds the Swift Testing unit tests.
- `Config/` holds the xcconfigs. `Base.xcconfig` is shared and includes `Local.xcconfig`. `Local.xcconfig` (gitignored) holds `DEVELOPMENT_TEAM`, and you copy it from `Local.xcconfig.example`.
- `docs/` holds the schema docs and `design.md`, which records design decisions.

## Commands
`xcode-select` on this Mac points at CommandLineTools, so prefix xcodebuild commands with `DEVELOPER_DIR` or run `sudo xcode-select -s /Applications/Xcode.app` once.

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild build-for-testing -scheme AudioTimeline -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO   # compile check
xcodebuild test -scheme AudioTimeline -destination 'platform=iOS Simulator,name=iPhone 17'                        # needs an iOS simulator runtime
xcodebuild test -scheme AudioTimeline -destination 'platform=iOS,name=<Tim's iPhone>'                              # on device
```

## Running
- **iPhone Simulator (on the Mac):** open `AudioTimeline.xcodeproj`, choose the `AudioTimeline` scheme, pick an iPhone simulator running iOS 26 in the toolbar, and press Run (⌘R).
- **iPhone (device):** see Deploying below.

## Deploying to an iPhone
1. Copy `Config/Local.xcconfig.example` to `Config/Local.xcconfig` and set `DEVELOPMENT_TEAM` (paid Developer Program team ID).
2. Open `AudioTimeline.xcodeproj` in Xcode.
3. Connect the iPhone and trust the Mac. Turn on Developer Mode on the phone (Settings → Privacy & Security), then restart it.
4. In Xcode, pick the iPhone as the run destination and press Run (⌘R).

## Timeline data
- Bundled files live in `AudioTimeline/Resources/Timelines/*.json`, and any `.json` added there is picked up by `TimelineLoader.loadBundled()`.
- Time units in use: `year` (negative values mean BCE) and `million_years_ago`. Canonical time and distance rules are in `docs/design.md`.
- `metadata` is required by schema v1.1, and the model requires `title` and `author` within it. The sample files all include a metadata block.

## Open questions
- **Relative importance (`relative_importance`, 0.0–1.0):** How are scores produced: by hand, by AI, or by a formula? Only `roman_timeline_v3.json` has them (19 events, range 0.4–1.0, mean 0.74). Nothing documents the method. Decide this before the filtering feature. Also decide the cutoff that picks which events get narrated.

## Feature log
- **0. Project init:** Xcode project, Codable timeline models, bundled sample timelines, and a list/detail browser UI with decoding tests.
