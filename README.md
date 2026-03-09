# Padel Score Watch App

A minimal Apple Watch app for keeping score during padel matches.

## Features

- Standard padel scoring (0, 15, 30, 40, deuce, advantage)
- Game tracking
- Set tracking (best of 3)
- Match winner detection
- Tiebreak support at 6-6 (first to 7, win by 2)
- Match timer with start button
- Serve indicator (alternates correctly during tiebreak)
- Haptic feedback on scoring, game/set/match wins
- Long press to remove points
- Reset confirmation dialog

## How to Run

1. Open `PadelScoreWatch.xcodeproj` in Xcode
2. Select a Watch simulator (e.g., Apple Watch Series 9 - 45mm)
3. Press Cmd+R to build and run

## Usage

- Tap **Start Match** to begin the timer
- Tap **Team 1** or **Team 2** buttons to award points
- Long press a team button to remove a point (in case of mistake)
- Green dot indicates which team is serving
- Score follows standard tennis/padel rules
- At 6-6 games, tiebreak begins (points shown as 1, 2, 3... instead of 15, 30, 40)
- Match ends when one team wins 2 sets
- Tap **Reset** to start a new match (confirmation required)

## Project Structure

- `PadelScoreWatchApp.swift` - App entry point
- `ContentView.swift` - Main UI
- `PadelGame.swift` - Game logic and scoring rules

## Notes

- Built for watchOS 9.0+
- Uses SwiftUI
- No companion iOS app needed

Built by lz13(https://github.com/lz13), 2026. Enjoy keeping score on the court!
