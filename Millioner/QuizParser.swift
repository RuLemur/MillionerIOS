//
//  Question.swift
//  Millioner
//
//  Created by Aleksandr Pavlov on 09.11.2020.
//

import UIKit

struct ResponseData: Codable {
    let data: [Question]
}

struct Question: Codable{
    let questionId: String
    let categoryName: String
    let question: String
    let answer: String
    let wrongAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case categoryName = "category_name"
        case wrongAnswers = "wrong_answers"
        case question = "question"
        case answer = "answer"
    }
}
class QuizParser{
    public func readLocalFile(_ name: String) -> ResponseData? {
        if let url = Bundle.main.url(forResource: name, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let questions = try JSONDecoder().decode(ResponseData.self, from: data)
                return questions
            } catch {
                print(error)
            }
        }
        return nil
    }
}

