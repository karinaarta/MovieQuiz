//
//  MovieQuizPresenterProtocol.swift
//  MovieQuiz
//
//  Created by karine pankova on 15.09.2024.
//

import Foundation
protocol MovieQuizPresenterProtocol{
    
    func restartGame()
    func convert(model: QuizQuestion) -> QuizStepViewModel
    func isLastQuestion() -> Bool 
    func switchToNextQuestion() 
    func yesButtonClicked()
    func noButtonClicked()
    func showAnswerResult(isCorrect: Bool) 
    func showNextQuestionOrResults()
}
