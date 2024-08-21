//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by karine pankova on 17.08.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    private enum BestGameKeys: String {
        case date
        case correct
        case total
    }
    
    private enum Keys: String {
        case gamesCount
        case highestCorrect
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let date = storage.object(forKey: BestGameKeys.date.rawValue) as? Date ?? Date()
            let correct = storage.integer(forKey: BestGameKeys.correct.rawValue)
            let total = storage.integer(forKey: BestGameKeys.total.rawValue)
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.date, forKey: BestGameKeys.date.rawValue)
            storage.set(newValue.correct, forKey: BestGameKeys.correct.rawValue)
            storage.set(newValue.total, forKey: BestGameKeys.total.rawValue)
        }
    }
    
    var highestCorrect: Int {
        get {
            return storage.integer(forKey: Keys.highestCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.highestCorrect.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        get {
            let highestCorrect = self.highestCorrect
            let totalQuestions = gamesCount * 10
            return totalQuestions > 0 ? Double(highestCorrect) / Double(totalQuestions) * 100 : 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let date = Date()
        
        self.gamesCount += 1
        
        if count > highestCorrect {
            highestCorrect = count
        }
        
        let gameResult = GameResult(correct: count, total: amount, date: date)
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}
