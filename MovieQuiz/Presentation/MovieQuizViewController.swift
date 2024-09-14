import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, MovieQuizViewControllerProtocol{
    // MARK: - Lifecycle
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
                presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
                presenter.yesButtonClicked()
    }
    // MARK: - Properties
    
     var alertPresenter: AlertPresenter?
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        presenter.viewController = self
        
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
        presenter.showCurrentQuestion()
        imageView.layer.cornerRadius = 20
        textLabel.font = UIFont(name: "YSDisplay-Medium", size: 23)
        counterLabel.font = UIFont(name: "YSDisplay-Medium", size: 20) 

        presenter.questionFactory?.requestNextQuestion()
        
    }
   
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        presenter.questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    // MARK: - Private Methods
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func changeStateButton(isEnabled: Bool){
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
     func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self = self else { return }
            presenter.restartGame()

        }
        
        alertPresenter?.showAlert(model: model)
    }
    
    
     func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = 20
    }
    
    
     func showAnswerResult(isCorrect: Bool) {
         presenter.showAnswerResult(isCorrect: isCorrect)
    }
   func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
    }
    
     func showNextQuestionOrResults() {
        presenter.showNextQuestionOrResults()
      
    }
    
    // MARK: - QuestionFactoryDelegate
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
        }
}
