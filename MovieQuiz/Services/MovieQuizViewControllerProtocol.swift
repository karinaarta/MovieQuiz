//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by karine pankova on 14.09.2024.
//

import Foundation
protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrect: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showAnswerResult(isCorrect: Bool) 
    func showNetworkError(message: String)
    func changeStateButton(isEnabled: Bool)
}
