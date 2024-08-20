//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by karine pankova on 17.08.2024.
//

import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    private var correctAnswers = 0
    
    private enum BestGameKeys: String{
        case date
        case correct
        case total
    }
    private enum Keys: String {
        case correct
        case gamesCount
    }
}

extension StatisticService: StatisticServiceProtocol {
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
           // let date = storage.object(forKey:"gameResult.date") as? Date ?? Date()
           // let correct = storage.integer(forKey: "gameResult.correct")
        //let total = storage.integer(forKey: "gameResult.total")
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
    
    var totalAccuracy: Double {
        get{
            Double(correctAnswers/10*self.gamesCount*100)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        let date = Date()
        self.gamesCount += 1
        let gameResult = GameResult(correct: count, total: amount, date: date)
        if gameResult.isBetterThan(bestGame){
            bestGame = gameResult
        }
    }
    
    
}
