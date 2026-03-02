# Padel Score Watch App

A minimal Apple Watch app for keeping score during padel matches.

## Features
- Standard padel scoring (0, 15, 30, 40, deuce, advantage)
- Game tracking
- Set tracking (best of 3)
- Match winner detection
- Reset button

## How to Run

1. Open `PadelScoreWatch.xcodeproj` in Xcode
2. Select a Watch simulator (e.g., Apple Watch Series 9 - 45mm)
3. Press Cmd+R to build and run

## Usage

- Tap **Team 1** or **Team 2** buttons to award points
- Score follows standard tennis/padel rules
- Watch displays current point score, games, and sets
- "DEUCE" and "ADV" indicators show when applicable
- Match ends when one team wins 2 sets
- Tap **Reset** to start a new match

## Project Structure

- `PadelScoreWatchApp.swift` - App entry point
- `ContentView.swift` - Main UI
- `PadelGame.swift` - Game logic and scoring rules

## Notes

- Built for watchOS 9.0+
- Uses SwiftUI
- No companion iOS app needed
- Tiebreak at 6-6 not implemented (simplified for prototype)

Built by lz13(https://github.com/lz13), 2026. Enjoy keeping score on the court!
