//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by karine pankova on 17.08.2024.
//

import Foundation

final class StatisticService: StatisticServiceProtocol{
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        
        public enum BestGame: String {
            case date
            case correct
            case total
        }
        
        case gamesCount
        case highestCorrect
        case totalCorrect
    }
    
    var gamesCount: Int {
        get {
            return storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    var totalCorrect: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrect.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrect.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let date = storage.object(forKey: Keys.BestGame.date.rawValue) as? Date ?? Date()
            let correct = storage.integer(forKey: Keys.BestGame.correct.rawValue)
            let total = storage.integer(forKey: Keys.BestGame.total.rawValue)
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.date, forKey: Keys.BestGame.date.rawValue)
            storage.set(newValue.correct, forKey: Keys.BestGame.correct.rawValue)
            storage.set(newValue.total, forKey: Keys.BestGame.total.rawValue)
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
            let totalCorrect = self.totalCorrect
            let totalQuestions = gamesCount * 10
            print (totalCorrect)
            print (totalQuestions)
            return totalQuestions != 0 ? 100 * Double(totalCorrect)/Double(totalQuestions): 0
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let date = Date()
        
        self.gamesCount += 1
        self.totalCorrect += count
        if count > highestCorrect {
            highestCorrect = count
        }
        
        let gameResult = GameResult(correct: count, total: amount, date: date)
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}
