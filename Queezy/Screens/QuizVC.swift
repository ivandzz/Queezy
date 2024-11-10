//
//  ViewController.swift
//  Queezy
//
//  Created by Іван Джулинський on 16/09/24.
//

import UIKit

class QuizVC: UIViewController {
    
    //MARK: - Variables
    let foreground = UIView()
    let quizLabel = UILabel()
    let trueButton = QButton(title: "True")
    let falseButton = QButton(title: "False")
    let progressBar = UIProgressView()
    
    var controller = QuizController()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchQuestions()
    }
    
    //MARK: - UI Setup
    private func configureUI() {
        view.backgroundColor = .systemGray6
        configureForeground()
        configureQuizLabel()
        configureFalseButton()
        configureTrueButton()
        configureProgressBar()
    }
    
    private func configureForeground() {
        foreground.backgroundColor = .systemBackground
        foreground.translatesAutoresizingMaskIntoConstraints = false
        foreground.layer.cornerRadius = 8
        foreground.layer.shadowColor = UIColor.black.cgColor
        foreground.layer.shadowOffset = CGSize(width: 2, height: 2)
        foreground.layer.shadowRadius = 8
        foreground.layer.shadowOpacity = 0.5
        foreground.layer.masksToBounds = false
        view.addSubview(foreground)
        
        NSLayoutConstraint.activate([
            foreground.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            foreground.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            foreground.widthAnchor.constraint(equalToConstant: 280),
            foreground.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureQuizLabel() {
        quizLabel.text = "Question Text"
        quizLabel.font = .systemFont(ofSize: 19, weight: .semibold)
        quizLabel.textAlignment = .center
        quizLabel.lineBreakMode = .byWordWrapping
        quizLabel.numberOfLines = 0
        quizLabel.translatesAutoresizingMaskIntoConstraints = false
        
        foreground.addSubview(quizLabel)
        
        NSLayoutConstraint.activate([
            quizLabel.centerXAnchor.constraint(equalTo: foreground.centerXAnchor),
            quizLabel.centerYAnchor.constraint(equalTo: foreground.centerYAnchor),
            quizLabel.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureFalseButton() {
        falseButton.translatesAutoresizingMaskIntoConstraints = false
        falseButton.addTarget(self, action: #selector(answerButtonPressed), for: .touchUpInside)
        view.addSubview(falseButton)
        
        NSLayoutConstraint.activate([
            falseButton.widthAnchor.constraint(equalToConstant: 280),
            falseButton.heightAnchor.constraint(equalToConstant: 50),
            falseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            falseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTrueButton() {
        trueButton.translatesAutoresizingMaskIntoConstraints = false
        trueButton.addTarget(self, action: #selector(answerButtonPressed), for: .touchUpInside)
        view.addSubview(trueButton)
        
        NSLayoutConstraint.activate([
            trueButton.widthAnchor.constraint(equalToConstant: 280),
            trueButton.heightAnchor.constraint(equalToConstant: 50),
            trueButton.bottomAnchor.constraint(equalTo: falseButton.topAnchor, constant: -30),
            trueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureProgressBar() {
        progressBar.progressTintColor = .systemBlue
        progressBar.trackTintColor = .lightGray
        progressBar.layer.cornerRadius = 8
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            progressBar.widthAnchor.constraint(equalToConstant: 280),
            progressBar.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    //MARK: - Selectors
    @objc private func answerButtonPressed(_ sender: UIButton) {
        guard let answer = sender.title(for: .normal) else { return }
        
        let isCorrect = controller.checkAnswer(answer)
        sender.backgroundColor = isCorrect ? .green : .red
        
        controller.nextQuestion()
        updateUI()
    }
    
    //MARK: - Helpers
    private func fetchQuestions() {
        controller.getQuestions { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    self.updateUI()
                } else {
                    self.quizLabel.text = "Failed to load questions"
                }
            }
        }
    }
    
    private func updateUI() {
        if controller.isEnd() {
            quizLabel.text = "You've completed another quiz!"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.fetchQuestions()
            }
        } else {
            quizLabel.text = controller.getQuestionLabel()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.trueButton.backgroundColor = .systemBackground
                self.falseButton.backgroundColor = .systemBackground
            }
            
            progressBar.setProgress(controller.getProgress(), animated: true)
        }
    }
}


#if DEBUG
import SwiftUI

@available(iOS 13, *)
struct QuizVC_Preview: PreviewProvider {
    static var previews: some View {
        QuizVC().showPreview()
    }
}
#endif
