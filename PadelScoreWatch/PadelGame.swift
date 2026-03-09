import Foundation

class PadelGame: ObservableObject {
    @Published var team1Score: Int = 0
    @Published var team2Score: Int = 0
    @Published var team1Sets: Int = 0
    @Published var team2Sets: Int = 0
    @Published var team1Games: Int = 0
    @Published var team2Games: Int = 0
    @Published var isDeuce: Bool = false
    @Published var advantage: Int? = nil // 1 or 2
    @Published var matchWinner: Int? = nil
    
    func pointWon(by team: Int) {
        guard matchWinner == nil else { return }
        
        if team == 1 {
            team1Score += 1
        } else {
            team2Score += 1
        }
        
        checkGameEnd()
    }
    
    func removePoint(from team: Int) {
        matchWinner = nil
        if team == 1 && team1Score > 0 {
            team1Score -= 1
        } else if team == 2 && team2Score > 0 {
            team2Score -= 1
        }
        checkGameEnd()
    }
    
    private func checkGameEnd() {
        // Check for game win
        if team1Score >= 4 && team1Score >= team2Score + 2 {
            gameWon(by: 1)
        } else if team2Score >= 4 && team2Score >= team1Score + 2 {
            gameWon(by: 2)
        } else if team1Score >= 3 && team2Score >= 3 {
            // Deuce logic
            if team1Score == team2Score {
                isDeuce = true
                advantage = nil
            } else if team1Score > team2Score {
                isDeuce = false
                advantage = 1
            } else {
                isDeuce = false
                advantage = 2
            }
        } else {
            isDeuce = false
            advantage = nil
        }
    }
    
    private func gameWon(by team: Int) {
        if team == 1 {
            team1Games += 1
        } else {
            team2Games += 1
        }
        
        team1Score = 0
        team2Score = 0
        isDeuce = false
        advantage = nil
        
        checkSetEnd()
    }
    
    private func checkSetEnd() {
        // Standard padel: first to 6 games, win by 2, or tiebreak at 6-6
        if team1Games >= 6 && team1Games >= team2Games + 2 {
            setWon(by: 1)
        } else if team2Games >= 6 && team2Games >= team1Games + 2 {
            setWon(by: 2)
        }
        // In real padel you'd have tiebreak at 6-6, keeping it simple for now
    }
    
    private func setWon(by team: Int) {
        if team == 1 {
            team1Sets += 1
        } else {
            team2Sets += 1
        }
        
        team1Games = 0
        team2Games = 0
        
        checkMatchEnd()
    }
    
    private func checkMatchEnd() {
        // Best of 3 sets
        if team1Sets == 2 {
            matchWinner = 1
        } else if team2Sets == 2 {
            matchWinner = 2
        }
    }
    
    func reset() {
        team1Score = 0
        team2Score = 0
        team1Sets = 0
        team2Sets = 0
        team1Games = 0
        team2Games = 0
        isDeuce = false
        advantage = nil
        matchWinner = nil
    }
    
    func scoreDisplay(for team: Int) -> String {
        let score = team == 1 ? team1Score : team2Score
        let opponentScore = team == 1 ? team2Score : team1Score
        
        // Check for deuce/advantage
        if team1Score >= 3 && team2Score >= 3 {
            if isDeuce {
                return "40"
            } else if advantage == team {
                return "AD"
            } else {
                return "40"
            }
        }
        
        // Normal scoring
        switch score {
        case 0: return "0"
        case 1: return "15"
        case 2: return "30"
        case 3: return "40"
        default: return "W"
        }
    }
}
