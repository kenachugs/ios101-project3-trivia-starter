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
    private let triviaGame = TriviaGame()
    private var answerButtons: [UIButton] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupAnswerButtons()
        displayCurrentQuestion()
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
    
    // MARK: - Display Methods
    private func displayCurrentQuestion() {
        guard let question = triviaGame.currentQuestion else {
            showGameComplete()
            return
        }
        
        // Update question and answers
        questionLabel.text = question.question
        
        for (index, button) in answerButtons.enumerated() {
            button.setTitle(question.answers[index], for: .normal)
            button.isEnabled = true
            button.backgroundColor = UIColor.systemGray6
        }
        
        // Update progress
        progressLabel.text = "Question \(triviaGame.currentQuestionNumber) of \(triviaGame.totalQuestions)"
    }
    
    private func showGameComplete() {
        questionLabel.text = "Quiz Complete!"
        progressLabel.text = "Final Score:"
        scoreLabel.text = "\(triviaGame.currentScore) out of \(triviaGame.totalQuestions)"
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
        if !isCorrect, let correctQuestion = triviaGame.currentQuestion {
            let correctButton = answerButtons[correctQuestion.correctAnswerIndex]
            correctButton.backgroundColor = UIColor.systemGreen
        }
        
        // Move to next question after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.displayCurrentQuestion()
        }
    }
    
    // MARK: - IBActions
    @IBAction func answerButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        let isCorrect = triviaGame.answerCurrentQuestion(selectedIndex: selectedIndex)
        highlightAnswer(selectedIndex: selectedIndex, isCorrect: isCorrect)
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        triviaGame.resetGame()
        restartButton.isHidden = true
        scoreLabel.isHidden = true
        answerButtons.forEach { $0.isHidden = false }
        displayCurrentQuestion()
    }
}
