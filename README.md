# Audio Timeline

iOS prototype that maps a timeline onto distance, so walking the distance moves you through history and each event is read aloud as you reach it.

Setup:
```sh
brew install xcodegen
cp Config/Local.xcconfig.example Config/Local.xcconfig   # set your DEVELOPMENT_TEAM
xcodegen generate && open AudioTimeline.xcodeproj
```

See [CLAUDE.md](CLAUDE.md) for project conventions, build commands, and device deploy steps.
The timeline JSON format is documented in [docs/schema/](docs/schema/).
