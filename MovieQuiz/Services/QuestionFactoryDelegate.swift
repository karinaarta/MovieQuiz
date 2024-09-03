//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by karine pankova on 12.08.2024.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               
    func didReceiveNextQuestion(question: QuizQuestion?)
}
