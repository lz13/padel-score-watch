import SwiftUI
import WatchKit

struct ContentView: View {
    @StateObject private var game = PadelGame()
    @State private var showResetConfirmation = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Match status
            if let winner = game.matchWinner {
                Text("Team \(winner) Wins!")
                    .font(.headline)
                    .foregroundColor(.green)
                    .padding(.bottom, 4)
            }
            
            // Timer or Start button
            if game.isMatchStarted {
                Text(game.timeDisplay)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.bottom, 2)
            } else {
                Button(action: {
                    game.startMatch()
                }) {
                    Text("Start Match")
                        .font(.caption2)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(6)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)
                .padding(.bottom, 2)
            }
            
            // Sets score
            HStack {
                Text("Sets: \(game.team1Sets)")
                    .font(.caption2)
                Spacer()
                Text("\(game.team2Sets)")
                    .font(.caption2)
            }
            .padding(.horizontal)
            .padding(.bottom, 2)
            
            // Games score
            HStack {
                Text("Games: \(game.team1Games)")
                    .font(.caption2)
                Spacer()
                Text("\(game.team2Games)")
                    .font(.caption2)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            // Point score
            HStack(spacing: 4) {
                // Team 1
                VStack(spacing: 2) {
                    Text("Team 1")
                        .font(.caption2)
                    Text(game.scoreDisplay(for: 1))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(8)
                .contentShape(Rectangle())
                .onTapGesture {
                    if game.matchWinner == nil {
                        WKInterfaceDevice.current().play(.click)
                        game.pointWon(by: 1)
                    }
                }
                .onLongPressGesture(minimumDuration: 0.5) {
                    WKInterfaceDevice.current().play(.stop)
                    game.removePoint(from: 1)
                }
                
                // Team 2
                VStack(spacing: 2) {
                    Text("Team 2")
                        .font(.caption2)
                    Text(game.scoreDisplay(for: 2))
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.orange.opacity(0.3))
                .cornerRadius(8)
                .contentShape(Rectangle())
                .onTapGesture {
                    if game.matchWinner == nil {
                        WKInterfaceDevice.current().play(.click)
                        game.pointWon(by: 2)
                    }
                }
                .onLongPressGesture(minimumDuration: 0.5) {
                    WKInterfaceDevice.current().play(.stop)
                    game.removePoint(from: 2)
                }
            }
            .padding(.horizontal, 4)
            
            // Deuce indicator
            if game.isDeuce {
                Text("DEUCE")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                    .padding(.top, 4)
            } else if let adv = game.advantage {
                Text("ADV Team \(adv)")
                    .font(.caption2)
                    .foregroundColor(.yellow)
                    .padding(.top, 4)
            }
            
            // Reset button
            Button(action: {
                showResetConfirmation = true
            }) {
                Text("Reset")
                    .font(.caption)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 4)
            .padding(.top, 8)
            .confirmationDialog("Reset Game?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("Reset", role: .destructive) {
                    game.reset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will reset all scores. Are you sure?")
            }
        }
        .padding(4)
        .onChange(of: game.team1Games + game.team2Games) { _ in
            WKInterfaceDevice.current().play(.success)
        }
        .onChange(of: game.team1Sets + game.team2Sets) { _ in
            WKInterfaceDevice.current().play(.notification)
        }
        .onChange(of: game.matchWinner) { winner in
            if winner != nil {
                WKInterfaceDevice.current().play(.success)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
