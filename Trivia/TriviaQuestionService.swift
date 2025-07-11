//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Kennedy Achugamonu on 7/10/25.
//

import Foundation

// Decodable structs matching the API's JSON
struct TriviaAPIResponse: Decodable {
    let response_code: Int
    let results: [TriviaAPIQuestion]
}

struct TriviaAPIQuestion: Decodable {
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
}

class TriviaQuestionService {
    func fetchQuestions(amount: Int = 5, completion: @escaping ([TriviaQuestion]?) -> Void) {
        let urlString = "https://opentdb.com/api.php?amount=\(amount)&type=multiple"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let apiResponse = try? JSONDecoder().decode(TriviaAPIResponse.self, from: data) else {
                completion(nil)
                return
            }

            let questions: [TriviaQuestion] = apiResponse.results.compactMap { apiQuestion in
                let allAnswers = ([apiQuestion.correct_answer] + apiQuestion.incorrect_answers).shuffled()
                guard let correctIndex = allAnswers.firstIndex(of: apiQuestion.correct_answer) else { return nil }
                return TriviaQuestion(
                    question: htmlUnescape(apiQuestion.question),
                    answers: allAnswers.map { htmlUnescape($0) },
                    correctAnswerIndex: correctIndex
                )
            }
            completion(questions)
        }.resume()
    }
}

// Helper to decode HTML entities in API questions/answers
func htmlUnescape(_ string: String) -> String {
    guard let data = string.data(using: .utf8) else { return string }
    let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
        .documentType: NSAttributedString.DocumentType.html
    ]
    let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    return attributedString?.string ?? string
}
