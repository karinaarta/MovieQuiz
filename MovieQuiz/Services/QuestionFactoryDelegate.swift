//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by karine pankova on 12.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
}
