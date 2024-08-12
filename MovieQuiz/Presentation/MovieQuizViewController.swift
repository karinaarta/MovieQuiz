import UIKit

final class MovieQuizViewController: UIViewController {
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
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    private let questionsAmount: Int = 10
    private let questionFactory: QuestionFactoryProtocol = QuestionFactory()
    private var currentQuestion: QuizQuestion?
    
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
           let result = QuizResultsViewModel(
               title: "Этот раунд окончен",
               text: text,
               buttonText: "Сыграть еще раз"
           )
           return result
       }
       
       private func show(quiz step: QuizStepViewModel) {
           imageView.image = step.image
           textLabel.text = step.question
           counterLabel.text = step.questionNumber
           imageView.layer.borderColor = UIColor.clear.cgColor
           imageView.layer.cornerRadius = 20
       }
       
       private func showCurrentQuestion() {
           if let firstQuestion = questionFactory.requestNextQuestion() {
               currentQuestion = firstQuestion
               let viewModel = convert(model: firstQuestion)
               show(quiz: viewModel)
           }
       }
       private func showAnswerResult(isCorrect: Bool) {
           if isCorrect == true{
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
               let result =  createResultModel()
               showResult(model: result)
           } else {
               currentQuestionIndex += 1
               showCurrentQuestion()
           }
       }
       
       private  func showResult(model: QuizResultsViewModel) {
           let alert = UIAlertController(
               title: model.title,
               message: model.text,
               preferredStyle: .alert)
           
           let action = UIAlertAction(title: model.buttonText, style: .default) { [weak self] _ in
               guard let self = self else { return }
               
               self.currentQuestionIndex = 0
               self.correctAnswers = 0
               
               if let firstQuestion = self.questionFactory.requestNextQuestion() {
                   self.currentQuestion = firstQuestion
                   let viewModel = self.convert(model: firstQuestion)
                   
                   self.show(quiz: viewModel)
               }
           }
           
           alert.addAction(action)
           
           self.present(alert, animated: true, completion: nil)
       }
   override func viewDidLoad() {
               super.viewDidLoad()
               showCurrentQuestion()
           }
       }
