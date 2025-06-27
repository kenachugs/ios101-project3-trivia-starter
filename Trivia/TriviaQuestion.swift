//
//  TriviaQuestion.swift
//  Trivia
//
//  Created by Kennedy Achugamonu on 6/25/25.
//

import Foundation

struct TriviaQuestion {
    let question: String
    let answers: [String]
    let correctAnswerIndex: Int
}

class TriviaGame {
    private let questions = [
        TriviaQuestion(
            question: "When did Lebron James win a championship for the Cleveland Cavaliers?",
            answers: ["2008", "2010", "2016", "2020"],
            correctAnswerIndex: 2
        ),
        TriviaQuestion(
            question: "Who was the first U.S. President?",
            answers: ["Carter", "Nixon", "Reagan", "Washington"],
            correctAnswerIndex: 3
        ),
        TriviaQuestion(
            question: "Who launched Facebook?",
            answers: ["Steve Jobs", "Mark Zuckerberg", "Jeff Bezos", "Tim Cook"],
            correctAnswerIndex: 1
        ),
        TriviaQuestion(
            question: "How many kilometers are in 1 mile?",
            answers: ["1.6", "1.7", "1", "5208"],
            correctAnswerIndex: 0
        )
    ]
    
    private var currentQuestionIndex = 0
    private var score = 0
    
    var currentQuestion: TriviaQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    var isGameComplete: Bool {
        return currentQuestionIndex >= questions.count
    }
    
    var currentQuestionNumber: Int {
        return currentQuestionIndex + 1
    }
    
    var totalQuestions: Int {
        return questions.count
    }
    
    var currentScore: Int {
        return score
    }
    
    func answerCurrentQuestion(selectedIndex: Int) -> Bool {
        guard let question = currentQuestion else { return false }
        
        let isCorrect = selectedIndex == question.correctAnswerIndex
        if isCorrect {
            score += 1
        }
        
        currentQuestionIndex += 1
        return isCorrect
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        score = 0
    }
}
