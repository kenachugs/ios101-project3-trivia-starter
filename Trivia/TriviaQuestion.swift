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
    private var questions: [TriviaQuestion]
    private var currentQuestionIndex = 0
    private var score = 0

    init(questions: [TriviaQuestion]) {
        self.questions = questions
    }

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
        if isCorrect { score += 1 }
        currentQuestionIndex += 1
        return isCorrect
    }

    func resetGame(with newQuestions: [TriviaQuestion]) {
        self.questions = newQuestions
        currentQuestionIndex = 0
        score = 0
    }
}
