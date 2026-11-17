# Environment setup

How to get this project building and running on a new Mac, or on any machine you switch to. GitHub (`origin`, `main`) is the primary copy. Everything needed to continue should be committed and pushed there.

Project conventions, build commands, and device deploy steps are in [CLAUDE.md](CLAUDE.md). This file covers the machine setup that CLAUDE.md assumes.

## 1. Prerequisites

| Need | Why | Check |
|------|-----|-------|
| macOS with Xcode (currently 27.2 on the main Mac) | Builds and runs the iOS app. The project targets iOS 26.0. | `ls /Applications/Xcode.app` |
| An iOS 26 simulator runtime | Runs the app in the iPhone Simulator | Xcode → Settings → Platforms |
| Xcode signed in with your Apple ID | Automatic signing for device builds | Xcode → Settings → Accounts |
| Paid Apple Developer Program membership | Needed to run on a physical iPhone with a team ID | developer.apple.com/account |
| Git with GitHub access | Clone, pull, and push | `git remote -v` |
| Python 3 (optional) | Only for the scripts in `legacy/` | `python3 --version` |
| iPhone with Developer Mode on | Required to run on a device | Settings → Privacy & Security → Developer Mode |

## 2. One-time machine setup

```sh
# Command line tools must point at full Xcode, not CommandLineTools.
sudo xcode-select -s /Applications/Xcode.app
xcodebuild -version                    # should print Xcode 27.x
```

Open Xcode once and accept the license and any "install components" prompt.

## 3. Get the code

```sh
cd ~/Documents/Github                  # or wherever you keep repos
git clone https://github.com/tsmcgrath/timelinesandbox1.git
cd timelinesandbox1
```

If you already have a clone, pull instead:

```sh
git checkout main
git pull --ff-only
```

Use `--ff-only` so a pull never creates a surprise merge commit. If it refuses, something has diverged. Stop and check `git status` and `git log --oneline --graph --all` before going further.

`AudioTimeline.xcodeproj` is committed to git, so there is nothing to generate after cloning.

## 4. Per-machine config (not in git)

Signing identity is stored per machine so the team ID never reaches GitHub.

```sh
cp Config/Local.xcconfig.example Config/Local.xcconfig
```

Edit `Config/Local.xcconfig` and set `DEVELOPMENT_TEAM` to your Team ID. This file is gitignored, so you must create it on every new machine. The iPhone Simulator does not need a team ID.

## 5. Run in the iPhone Simulator (on the Mac)

In Xcode:

1. Open `AudioTimeline.xcodeproj`.
2. In the toolbar, choose the scheme `AudioTimeline` and an iPhone simulator running iOS 26.
3. Press ⌘R.

To see which simulators are installed:

```sh
xcrun simctl list devices available | grep iPhone
```

From the command line (compile, install, and launch, with no signing):

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
xcodebuild -scheme AudioTimeline -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
open -a Simulator
xcrun simctl boot "iPhone 17" || true
xcrun simctl install booted build/Build/Products/Debug-iphonesimulator/AudioTimeline.app
xcrun simctl launch booted com.wanderfeast.AudioTimeline
```

Replace `iPhone 17` with a name from the list above if it isn't installed. `build/` is gitignored.

Compile check, no signing needed:

```sh
xcodebuild build-for-testing -scheme AudioTimeline -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO
```

## 6. Run on an iPhone

1. Connect the iPhone with a cable and tap **Trust** on the phone.
2. Turn on **Developer Mode** (Settings → Privacy & Security), then restart the phone.
3. In Xcode, choose the iPhone as the run destination and press ⌘R.
4. First run only: on the phone, go to Settings → General → VPN & Device Management and trust your developer profile.

## 7. Daily workflow across machines

Start of a session (any machine):

```sh
git pull --ff-only
```

End of a session:

```sh
git status                             # check nothing is left behind
git add <files>
git commit -m "<what changed>"
git push
```

Commit each feature separately and add a line to the Feature log in CLAUDE.md.

### What does NOT travel between machines

| Item | Where it lives | What to do on a new machine |
|------|----------------|-----------------------------|
| `Config/Local.xcconfig` (team ID) | Each Mac, gitignored | Recreate from the example (step 4) |
| DerivedData, build output | Each Mac | Rebuilt automatically |
| Xcode user settings (`xcuserdata/`) | Each Mac, gitignored | Set up in Xcode |
| Claude Code memory notes | `~/.claude/projects/...` on each Mac | Not synced. Project progress lives in the repo (CLAUDE.md feature log, `docs/design.md`, this file), so it travels with git |

## 8. Troubleshooting

- **`xcodebuild` says it needs Xcode, not CommandLineTools:** run `sudo xcode-select -s /Applications/Xcode.app` (step 2).
- **No iPhone simulator in the toolbar:** Xcode → Settings → Platforms, and download an iOS 26 runtime (step 1).
- **Signing error about a team or provisioning profile:** check `Config/Local.xcconfig` has the right `DEVELOPMENT_TEAM`, and that Xcode → Settings → Accounts shows your team.
- **Phone not listed as a destination:** check the cable, unlock the phone, confirm Developer Mode is on, and confirm the phone is trusted.
- **Pull refused:** run `git status`. Don't force anything. Commit or stash local changes first.
