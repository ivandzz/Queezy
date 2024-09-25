//
//  NetworkManager.swift
//  Queezy
//
//  Created by Іван Джулинський on 17/09/24.
//

import Foundation

final class NetworkManager {

    static let shared = NetworkManager()

    private let baseURL = "https://opentdb.com/api.php?amount=10&category=18&type=boolean"

    private init() {}

    func getQuestions(completion: @escaping (Result<[Question], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(QError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(QError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(QuestionResponse.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
