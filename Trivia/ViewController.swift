//
//  ViewController.swift
//  Trivia
//
//  Created by Kennedy Achugamonu on 6/25/25.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restartButton: UIButton!
    
    // MARK: - Properties
    private var triviaGame: TriviaGame?
    private let triviaService = TriviaQuestionService()
    private var answerButtons: [UIButton] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnswerButtons()
        fetchTriviaQuestions()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Style the question label
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Initially hide restart button and score
        restartButton.isHidden = true
        scoreLabel.isHidden = true
        
        // Style restart button
        restartButton.backgroundColor = UIColor.systemBlue
        restartButton.setTitleColor(.white, for: .normal)
        restartButton.layer.cornerRadius = 8
    }
    
    private func setupAnswerButtons() {
        answerButtons = [answerButton1, answerButton2, answerButton3, answerButton4]
        
        for (index, button) in answerButtons.enumerated() {
            button.tag = index
            button.backgroundColor = UIColor.systemGray6
            button.setTitleColor(.label, for: .normal)
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
        }
    }
    
    // MARK: - Fetching & Display Methods
    private func fetchTriviaQuestions() {
        // Optionally, show a loading state here
        questionLabel.text = "Loading..."
        answerButtons.forEach { $0.isHidden = true }
        progressLabel.text = ""
        scoreLabel.isHidden = true
        restartButton.isHidden = true
        
        triviaService.fetchQuestions(amount: 5) { [weak self] questions in
            guard let self = self, let questions = questions, !questions.isEmpty else {
                DispatchQueue.main.async {
                    self?.questionLabel.text = "Failed to load questions. Please try again."
                    self?.restartButton.isHidden = false
                }
                return
            }
            DispatchQueue.main.async {
                self.triviaGame = TriviaGame(questions: questions)
                self.answerButtons.forEach { $0.isHidden = false }
                self.displayCurrentQuestion()
            }
        }
    }
    
    private func displayCurrentQuestion() {
        guard let game = triviaGame, let question = game.currentQuestion else {
            showGameComplete()
            return
        }
        
        // Update question and answers
        questionLabel.text = question.question
        
        for (index, button) in answerButtons.enumerated() {
            if index < question.answers.count {
                button.setTitle(question.answers[index], for: .normal)
                button.isHidden = false
                button.isEnabled = true
                button.backgroundColor = UIColor.systemGray6
            } else {
                button.isHidden = true
            }
        }
        
        // Update progress
        progressLabel.text = "Question \(game.currentQuestionNumber) of \(game.totalQuestions)"
    }
    
    private func showGameComplete() {
        guard let game = triviaGame else { return }
        questionLabel.text = "Quiz Complete!"
        progressLabel.text = "Final Score:"
        scoreLabel.text = "\(game.currentScore) out of \(game.totalQuestions)"
        scoreLabel.isHidden = false
        restartButton.isHidden = false
        
        // Hide answer buttons
        answerButtons.forEach { $0.isHidden = true }
    }
    
    private func highlightAnswer(selectedIndex: Int, isCorrect: Bool) {
        // Disable all buttons temporarily
        answerButtons.forEach { $0.isEnabled = false }
        
        // Highlight selected answer
        let selectedButton = answerButtons[selectedIndex]
        selectedButton.backgroundColor = isCorrect ? UIColor.systemGreen : UIColor.systemRed
        
        // Show correct answer if wrong was selected
        if let game = triviaGame, !isCorrect, let currentQuestion = game.currentQuestion {
            let correctButton = answerButtons[currentQuestion.correctAnswerIndex]
            correctButton.backgroundColor = UIColor.systemGreen
        }
        
        // Move to next question after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.displayCurrentQuestion()
        }
    }
    
    // MARK: - IBActions
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        guard let game = triviaGame else { return }
        let selectedIndex = sender.tag
        let isCorrect = game.answerCurrentQuestion(selectedIndex: selectedIndex)
        highlightAnswer(selectedIndex: selectedIndex, isCorrect: isCorrect)
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        fetchTriviaQuestions()
    }
}
