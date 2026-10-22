# Audio Timeline (iOS prototype)

An iOS SwiftUI app that maps a timeline onto physical distance. For example, 100 years can equal 100 meters. As the user walks, runs, bikes, or drives, the app reads aloud the next timeline event once they have covered the matching distance.

## Working rules
- Build **one feature at a time**. Each feature gets its own commit and a line in the Feature log below.
- **Never remove or break existing features** without explicit instruction from Tim.
- `legacy/` holds the earlier Python exploration. It is reference only, so don't build on it or edit it.
- Keep the Swift models in `AudioTimeline/Model/Timeline.swift` in sync with the schema docs in `docs/schema/`. The current schema is `timeline_schema_doc_v1.1.md`.
- Add Info.plist privacy keys (location, background audio, etc.) through `project.yml` `INFOPLIST_KEY_*` settings when the feature needing them lands.

## Project layout
- `project.yml` is the XcodeGen spec and the source of truth. `AudioTimeline.xcodeproj` is generated and gitignored.
- `AudioTimeline/` holds the app: `App/` (entry point), `Views/`, `Model/`, `Resources/Timelines/` (bundled timeline JSON).
- `AudioTimelineTests/` holds the Swift Testing unit tests.
- `Config/` holds the xcconfigs. `Local.xcconfig` (gitignored) holds `DEVELOPMENT_TEAM`, and you copy it from `Local.xcconfig.example`.

## Commands
`xcode-select` on this Mac points at CommandLineTools, so prefix xcodebuild commands with `DEVELOPER_DIR` or run `sudo xcode-select -s /Applications/Xcode.app` once.

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodegen generate                                   # after adding/removing files or editing project.yml
xcodebuild build-for-testing -scheme AudioTimeline -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO   # compile check
xcodebuild test -scheme AudioTimeline -destination 'platform=iOS Simulator,name=iPhone 17'                        # needs an iOS simulator runtime
xcodebuild test -scheme AudioTimeline -destination 'platform=iOS,name=<Tim's iPhone>'                              # on device
```

## Deploying to an iPhone
1. Copy `Config/Local.xcconfig.example` to `Config/Local.xcconfig` and set `DEVELOPMENT_TEAM` (paid Developer Program team ID).
2. Run `xcodegen generate`, then `open AudioTimeline.xcodeproj`.
3. Connect the iPhone and trust the Mac. Turn on Developer Mode on the phone (Settings → Privacy & Security), then restart it.
4. In Xcode, pick the iPhone as the run destination and press Run (⌘R).

## Timeline data
- Bundled files live in `AudioTimeline/Resources/Timelines/*.json`, and any `.json` added there is picked up by `TimelineLoader.loadBundled()`.
- Time units in use: `year` (negative values mean BCE) and `million_years_ago`.
- `metadata` is required by schema v1.1, but the current sample files lack it, so the model treats it as optional.

## Feature log
- **0. Project init:** XcodeGen project, Codable timeline models, bundled sample timelines, and a list/detail browser UI with decoding tests.
