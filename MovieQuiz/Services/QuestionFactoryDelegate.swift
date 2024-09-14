//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by karine pankova on 12.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
