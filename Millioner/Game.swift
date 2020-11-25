//
//  Game.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 14.11.2020.
//

import Foundation

class Game {
    static let game = Game()
    var gameSessions:  [GameSession]
    var gameSession: GameSession!
    var gameSettings: GameSettings
    
    private let recordsCaretaker = RecordsCaretaker()
    private let settingsCaretaker = SettingsCaretaker()
    
    private init() {
        self.gameSessions = self.recordsCaretaker.retrieveRecords()
        self.gameSettings = self.settingsCaretaker.retrieveSettings()
    }
    
    func newGameSession()  {
        gameSession = GameSession()
    }
    
    func save() {
        gameSessions.append(gameSession)
        self.recordsCaretaker.save(records: gameSessions)
    }
    
    func saveSettings() {
        self.settingsCaretaker.save(settings: gameSettings)
    }
    
    func getGameSettings() -> GameSettings {
        return gameSettings
    }
}

class GameSession: Codable {
    var score: String = "0"
    var data: String = ""
    
    func newResult(_ data: String, _ score: String) {
        self.score = score
        self.data = data
    }
    
}

class GameSettings: Codable {
    var isRandomly = false
}

final class RecordsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "records"
    
    func save(records: [GameSession]) {
        do {
            let data = try self.encoder.encode(records)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveRecords() -> [GameSession] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        do {
            return try self.decoder.decode([GameSession].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
}

final class SettingsCaretaker {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let key = "settings"
    
    func save(settings: GameSettings) {
        do {
            let data = try self.encoder.encode(settings)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieveSettings() -> GameSettings {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return GameSettings()
        }
        do {
            return try self.decoder.decode(GameSettings.self, from: data)
        } catch {
            print(error)
            return GameSettings()
        }
    }
}

protocol NextQuestionStrategy {
    func nextQuestion(questions: [Question], lastQuestionNumber: Int) -> Question?
}
