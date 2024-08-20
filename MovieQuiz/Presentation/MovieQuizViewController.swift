import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate{
    // MARK: - Lifecycle
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = false
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        let givenAnswer = true
        showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    // MARK: - Properties
      
      private var currentQuestionIndex = 0
      private var correctAnswers = 0
      private let questionsAmount: Int = 10
      private var questionFactory: QuestionFactoryProtocol = QuestionFactory()
      private var currentQuestion: QuizQuestion?
      private var alertPresenter: AlertPresenter?
    
    // MARK: - Lifecycle
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let questionFactory = QuestionFactory()
            questionFactory.setup(delegate: self)
            self.questionFactory = questionFactory
            
            self.alertPresenter = AlertPresenter(viewController: self)
            
            questionFactory.requestNextQuestion()
            showCurrentQuestion()
        }
        
        // MARK: - Private Methods
        
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            let questionStep = QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
            return questionStep
        }
        
        private func createResultModel () -> QuizResultsViewModel {
            let text = correctAnswers == questionsAmount ?
            "Поздравляем, вы ответили на 10 из 10!" :
            "Вы ответили на \(correctAnswers) из 10, попробуйте ещё раз!"
            
            return QuizResultsViewModel(
                title: "Этот раунд окончен",
                text: text,
                buttonText: "Сыграть еще раз"
            )
        }
        
        private func show(quiz step: QuizStepViewModel) {
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.layer.cornerRadius = 20
        }
        
        private func showCurrentQuestion() {
            questionFactory.requestNextQuestion()
        }
        
        private func showAnswerResult(isCorrect: Bool) {
            if isCorrect {
                correctAnswers += 1
            }
            
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
            imageView.layer.cornerRadius = 20
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.showNextQuestionOrResults()
            }
        }
        
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questionsAmount - 1 {
                let resultModel = createResultModel()
                let alertModel = AlertModel(
                    title: resultModel.title,
                    message: resultModel.text,
                    buttonText: resultModel.buttonText
                ) { [weak self] in
                    guard let self = self else { return }
                    
                    self.currentQuestionIndex = 0
                    self.correctAnswers = 0
                    
                    self.questionFactory.requestNextQuestion()
                }
                
                alertPresenter?.showAlert(model: alertModel)
            } else {
                currentQuestionIndex += 1
                showCurrentQuestion()
            }
        }
        
        // MARK: - QuestionFactoryDelegate
        
        func didReceiveNextQuestion(question: QuizQuestion?) {
            guard let question = question else {
                return
            }
            
            currentQuestion = question
            let viewModel = convert(model: question)
            
            DispatchQueue.main.async { [weak self] in
                self?.show(quiz: viewModel)
            }
        }
    }
