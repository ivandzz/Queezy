//
//  Question.swift
//  Queezy
//
//  Created by Іван Джулинський on 17/09/24.
//

import Foundation

struct Question: Decodable {
    let question: String
    let correct_answer: String
}

struct QuestionResponse: Decodable {
    let results: [Question]
}
