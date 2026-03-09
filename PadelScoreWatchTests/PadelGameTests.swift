import XCTest
@testable import PadelScoreWatch

final class PadelGameTests: XCTestCase {
    
    var game: PadelGame!
    
    override func setUp() {
        super.setUp()
        game = PadelGame()
    }
    
    override func tearDown() {
        game = nil
        super.tearDown()
    }
    
    // MARK: - Basic Scoring
    
    func testInitialScore() {
        XCTAssertEqual(game.team1Score, 0)
        XCTAssertEqual(game.team2Score, 0)
        XCTAssertEqual(game.team1Games, 0)
        XCTAssertEqual(game.team2Games, 0)
        XCTAssertEqual(game.team1Sets, 0)
        XCTAssertEqual(game.team2Sets, 0)
        XCTAssertFalse(game.isDeuce)
        XCTAssertNil(game.advantage)
        XCTAssertNil(game.matchWinner)
    }
    
    func testPointWon() {
        game.pointWon(by: 1)
        XCTAssertEqual(game.team1Score, 1)
        XCTAssertEqual(game.team2Score, 0)
        
        game.pointWon(by: 2)
        XCTAssertEqual(game.team1Score, 1)
        XCTAssertEqual(game.team2Score, 1)
    }
    
    func testScoreDisplay() {
        XCTAssertEqual(game.scoreDisplay(for: 1), "0")
        
        game.pointWon(by: 1)
        XCTAssertEqual(game.scoreDisplay(for: 1), "15")
        
        game.pointWon(by: 1)
        XCTAssertEqual(game.scoreDisplay(for: 1), "30")
        
        game.pointWon(by: 1)
        XCTAssertEqual(game.scoreDisplay(for: 1), "40")
    }
    
    // MARK: - Game Wins
    
    func testGameWin() {
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.team1Games, 1)
        XCTAssertEqual(game.team1Score, 0)
        XCTAssertEqual(game.team2Score, 0)
    }
    
    func testGameWinWithOpponentPoints() {
        game.pointWon(by: 2)
        game.pointWon(by: 2)
        
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.team1Games, 1)
        XCTAssertEqual(game.team1Score, 0)
        XCTAssertEqual(game.team2Score, 0)
    }
    
    // MARK: - Deuce and Advantage
    
    func testDeuce() {
        for _ in 0..<3 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        XCTAssertTrue(game.isDeuce)
        XCTAssertNil(game.advantage)
        XCTAssertEqual(game.scoreDisplay(for: 1), "40")
        XCTAssertEqual(game.scoreDisplay(for: 2), "40")
    }
    
    func testAdvantage() {
        for _ in 0..<3 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        game.pointWon(by: 1)
        
        XCTAssertFalse(game.isDeuce)
        XCTAssertEqual(game.advantage, 1)
        XCTAssertEqual(game.scoreDisplay(for: 1), "AD")
        XCTAssertEqual(game.scoreDisplay(for: 2), "40")
    }
    
    func testAdvantageBackToDeuce() {
        for _ in 0..<3 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        game.pointWon(by: 1)
        game.pointWon(by: 2)
        
        XCTAssertTrue(game.isDeuce)
        XCTAssertNil(game.advantage)
    }
    
    func testGameWinFromAdvantage() {
        for _ in 0..<3 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        game.pointWon(by: 1)
        game.pointWon(by: 1)
        
        XCTAssertEqual(game.team1Games, 1)
    }
    
    // MARK: - Set Wins
    
    func testSetWin() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
        }
        
        XCTAssertEqual(game.team1Sets, 1)
        XCTAssertEqual(game.team1Games, 0)
        XCTAssertEqual(game.team2Games, 0)
    }
    
    func testSetWinWithWinByTwo() {
        for _ in 0..<5 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.team1Sets, 1)
    }
    
    // MARK: - Tiebreak
    
    func testTiebreakStartsAtSixSix() {
        for _ in 0..<5 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        for _ in 0..<4 {
            game.pointWon(by: 2)
        }
        
        XCTAssertTrue(game.isTiebreak)
    }
    
    func testTiebreakScoring() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        XCTAssertTrue(game.isTiebreak)
        
        game.pointWon(by: 1)
        XCTAssertEqual(game.scoreDisplay(for: 1), "1")
        XCTAssertEqual(game.scoreDisplay(for: 2), "0")
    }
    
    func testTiebreakWin() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        for _ in 0..<7 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.team1Sets, 1)
        XCTAssertFalse(game.isTiebreak)
    }
    
    func testTiebreakWinByTwo() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        for _ in 0..<6 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        game.pointWon(by: 1)
        game.pointWon(by: 1)
        
        XCTAssertEqual(game.team1Sets, 1)
    }
    
    // MARK: - Match Win
    
    func testMatchWin() {
        for _ in 0..<2 {
            for _ in 0..<6 {
                for _ in 0..<4 {
                    game.pointWon(by: 1)
                }
            }
        }
        
        XCTAssertEqual(game.matchWinner, 1)
    }
    
    func testPointsDontCountAfterMatchWon() {
        for _ in 0..<2 {
            for _ in 0..<6 {
                for _ in 0..<4 {
                    game.pointWon(by: 1)
                }
            }
        }
        
        XCTAssertEqual(game.matchWinner, 1)
        
        game.pointWon(by: 2)
        XCTAssertEqual(game.team2Score, 0)
    }
    
    // MARK: - Remove Point
    
    func testRemovePoint() {
        game.pointWon(by: 1)
        game.pointWon(by: 1)
        XCTAssertEqual(game.team1Score, 2)
        
        game.removePoint(from: 1)
        XCTAssertEqual(game.team1Score, 1)
    }
    
    func testRemovePointNotBelowZero() {
        game.removePoint(from: 1)
        XCTAssertEqual(game.team1Score, 0)
    }
    
    func testRemovePointClearsDeuce() {
        for _ in 0..<3 {
            game.pointWon(by: 1)
            game.pointWon(by: 2)
        }
        
        XCTAssertTrue(game.isDeuce)
        
        game.removePoint(from: 1)
        XCTAssertFalse(game.isDeuce)
    }
    
    // MARK: - Reset
    
    func testReset() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
        }
        
        XCTAssertEqual(game.team1Sets, 1)
        
        game.reset()
        
        XCTAssertEqual(game.team1Score, 0)
        XCTAssertEqual(game.team2Score, 0)
        XCTAssertEqual(game.team1Games, 0)
        XCTAssertEqual(game.team2Games, 0)
        XCTAssertEqual(game.team1Sets, 0)
        XCTAssertEqual(game.team2Sets, 0)
        XCTAssertFalse(game.isDeuce)
        XCTAssertNil(game.advantage)
        XCTAssertNil(game.matchWinner)
    }
    
    // MARK: - Serve Indicator
    
    func testServeStartsWithTeam1() {
        XCTAssertEqual(game.servingTeam, 1)
        XCTAssertEqual(game.currentServer, 1)
    }
    
    func testServeChangesAfterGame() {
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.servingTeam, 2)
        XCTAssertEqual(game.currentServer, 2)
    }
    
    func testServeResetsOnReset() {
        for _ in 0..<4 {
            game.pointWon(by: 1)
        }
        
        XCTAssertEqual(game.servingTeam, 2)
        
        game.reset()
        
        XCTAssertEqual(game.servingTeam, 1)
    }
    
    func testTiebreakServePattern() {
        for _ in 0..<6 {
            for _ in 0..<4 {
                game.pointWon(by: 1)
            }
            for _ in 0..<4 {
                game.pointWon(by: 2)
            }
        }
        
        let lastServer = game.servingTeam
        
        XCTAssertTrue(game.isTiebreak)
        XCTAssertEqual(game.currentServer, lastServer)
        
        game.pointWon(by: 1)
        let firstPointServer = game.currentServer
        XCTAssertNotEqual(firstPointServer, lastServer)
        
        game.pointWon(by: 1)
        game.pointWon(by: 1)
        XCTAssertEqual(game.currentServer, lastServer)
        
        game.pointWon(by: 1)
        game.pointWon(by: 1)
        XCTAssertEqual(game.currentServer, firstPointServer)
    }
    
    // MARK: - Timer
    
    func testTimerNotStartedInitially() {
        XCTAssertFalse(game.isMatchStarted)
        XCTAssertEqual(game.elapsedTime, 0)
    }
    
    func testStartMatchStartsTimer() {
        game.startMatch()
        XCTAssertTrue(game.isMatchStarted)
    }
    
    func testResetStopsTimer() {
        game.startMatch()
        XCTAssertTrue(game.isMatchStarted)
        
        game.reset()
        XCTAssertFalse(game.isMatchStarted)
        XCTAssertEqual(game.elapsedTime, 0)
    }
}
