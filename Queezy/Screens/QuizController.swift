//
//  QuizManager.swift
//  Queezy
//
//  Created by Іван Джулинський on 17/09/24.
//

import Foundation

class QuizController {
    
    private var questions = [Question]()
    private var questionNumber = 0
    public var score = 0
    
    func getQuestions(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.getQuestions { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let questions):
                self.questions = questions
                self.questionNumber = 0
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func getQuestionLabel() -> String {
        guard questionNumber < questions.count else { return "Error: Invalid question" }
        
        return questions[questionNumber].question.decodeHTMLEntities()
    }
    
    func checkAnswer(_ answer: String) -> Bool {
        guard questionNumber < questions.count else { return false }
        
        let isCorrect = questions[questionNumber].correct_answer == answer
        
        if isCorrect {
            score += 1
        }
        
        return isCorrect

    }
    
    func nextQuestion() {
        questionNumber += 1
    }
    
    func getProgress() -> Float {
        let totalQuestions = Float(questions.count)
        let progress = totalQuestions > 0 ? Float(questionNumber) / totalQuestions : 0.0
        return progress
    }
    
    func isEnd() -> Bool {
        return questionNumber >= questions.count
    }
}
