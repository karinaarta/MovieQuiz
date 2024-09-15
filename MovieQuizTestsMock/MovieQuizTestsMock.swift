//
//  MovieQuizTestsMock.swift
//  MovieQuizTestsMock
//
//  Created by karine pankova on 14.09.2024.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAlert(model: MovieQuiz.AlertModel) {}
    
    func showAnswerResult(isCorrect: Bool) {}
    
    func changeStateButton(isEnabled: Bool) {}
    
    func show(quiz step: QuizStepViewModel) {}
    
    func highlightImageBorder(isCorrect: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showAnswerResult() {}
    
    func showNetworkError(message: String) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        _ = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter()
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
