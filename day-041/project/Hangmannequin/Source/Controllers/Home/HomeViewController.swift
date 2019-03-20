//
//  ViewController.swift
//  Hangmannequin
//
//  Created by Brian Sipple on 3/18/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var mannequinImageView: UIImageView!
    @IBOutlet var currentScoreLabel: UILabel!
    @IBOutlet var currentLevelLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var keypadContainer: UIView!
    @IBOutlet var statsLabelsContainer: UIView!

    var lettersGuessed = [Character]()

    var levelAnswer = "" {
        didSet { levelAnswerChanged() }
    }

    var currentAnswer = "" {
        didSet {
            answerLabel.text = currentAnswer.uppercased()

            if currentAnswer == levelAnswer {
                levelCleared()
            }
        }
    }

    var currentLevel = 0 {
        didSet {
            currentLevelLabel.text = "Level: \(self.currentLevel)"
        }
    }

    var currentScore = 0 {
        didSet {
            currentScoreLabel.text = "Score: \(currentScore)"
        }
    }

    var remainingMistakes = 6 {
        didSet {
            updateMannequin()

            if remainingMistakes == 0 {
                levelLossed()
            }
        }
    }


    override func loadView() {
        super.loadView()
        setupUIAnchors()
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupKeypadButtons()
        startGame()
    }
}


// MARK: - Computed Properties

extension HomeViewController {
    var keypadButtons: [UIButton] {
        return keypadContainer.subviews.filter { $0.tag == 4000 && $0 is UIButton } as! [UIButton]
    }

    var currentMannequinImage: UIImage {
        return UIImage(named: "state-\(6 - remainingMistakes)")!
    }
}


// MARK: - UI Setup

extension HomeViewController {
    func setupUIAnchors() {
        [
            mannequinImageView,
            keypadContainer,
            answerLabel,
            statsLabelsContainer,
            currentScoreLabel,
            currentLevelLabel,
        ].forEach({ $0?.translatesAutoresizingMaskIntoConstraints = false })

        NSLayoutConstraint.activate([
            mannequinImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -140),
            mannequinImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mannequinImageView.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.5),
        ])

        NSLayoutConstraint.activate([
            keypadContainer.widthAnchor.constraint(equalToConstant: 644),
            keypadContainer.heightAnchor.constraint(equalToConstant: 316),
            keypadContainer.centerXAnchor.constraint(equalTo: mannequinImageView.trailingAnchor),
            keypadContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -50),
        ])

        NSLayoutConstraint.activate([
            answerLabel.bottomAnchor.constraint(equalTo: keypadContainer.topAnchor, constant: -12),
            answerLabel.leadingAnchor.constraint(equalTo: keypadContainer.leadingAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: keypadContainer.trailingAnchor),
        ])

        NSLayoutConstraint.activate([
            statsLabelsContainer.bottomAnchor.constraint(equalTo: answerLabel.topAnchor, constant: -140),
            statsLabelsContainer.leadingAnchor.constraint(equalTo: answerLabel.trailingAnchor, constant: -140),
            statsLabelsContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -12),
        ])

        NSLayoutConstraint.activate([
            currentScoreLabel.centerXAnchor.constraint(equalTo: statsLabelsContainer.centerXAnchor),
            currentScoreLabel.centerYAnchor.constraint(equalTo: statsLabelsContainer.centerYAnchor, constant: -24),

            currentLevelLabel.leadingAnchor.constraint(equalTo: currentScoreLabel.leadingAnchor),
            currentLevelLabel.topAnchor.constraint(equalTo: currentScoreLabel.bottomAnchor, constant: 12),
        ])
    }

    func setupKeypadButtons() {
        for button in keypadButtons {
            button.addTarget(self, action: #selector(keypadButtonTapped), for: .touchUpInside)
        }
    }
}


// MARK: - Event handling

extension HomeViewController {
    @objc func keypadButtonTapped(sender: UIButton) {
        guard let letterTapped = sender.titleLabel?.text?.lowercased() else { return }

        sender.isHidden = true

        if levelAnswer.contains(letterTapped.lowercased()) {
            updateCurrentAnswer(with: Character(letterTapped))
        } else {
            remainingMistakes -= 1
        }
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {

    func advanceLevel(to newLevel: Int) {
        guard let pathToLevel = Bundle.main.url(forResource: "level-\(newLevel)-words", withExtension: "txt") else {
            fatalError("Level data not found")
        }

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }

            do {
                let contents = try String(contentsOf: pathToLevel)
                let choices = contents.components(separatedBy: "\n")

                var answer = ""
                repeat {
                    answer = choices.randomElement()!
                } while answer == ""

                DispatchQueue.main.async {
                    self.levelAnswer = answer
                    self.remainingMistakes = 6
                    self.keypadButtons.forEach { $0.isHidden = false }
                    self.currentLevel = newLevel
                }
            } catch {
                self.showError(error, title: "Error while loading level data")
            }
        }
    }


    func levelLossed() {
        let alertController = UIAlertController(
            title: "Sorry",
            message: "You ran out of guesses. The correct answer was \"\(levelAnswer)\"",
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(title: "Restart", style: .default) { [weak self] _ in
                self?.startGame()
            }
        )

        present(alertController, animated: true)
    }


    func levelCleared() {
        let alertController = UIAlertController(
            title: "Well Done 👏",
            message: "Your mannequin has survived... for now.",
            preferredStyle: .alert
        )

        alertController.addAction(
            UIAlertAction(title: "Keep Going", style: .default) { [weak self] _ in
                guard let self = self else { return }

                self.currentScore += self.currentLevel * 10
                self.advanceLevel(to: self.currentLevel + 1)
            }
        )

        present(alertController, animated: true)
    }


    func updateMannequin() {
        mannequinImageView.image = currentMannequinImage
    }


    func levelAnswerChanged() {
        currentAnswer = levelAnswer.reduce("", { (accumulatedAnswer, current) -> String in
            if current == " " {
                return accumulatedAnswer + " "
            }
            return accumulatedAnswer + "*"
        })
    }

    func startGame() {
        currentScore = 0
        advanceLevel(to: 1)
    }

    func updateCurrentAnswer(with letter: Character) {
        currentAnswer = levelAnswer.indices.reduce("", { (accumulatedAnswer, currentIndex) -> String in
            let characterToMatch = levelAnswer[currentIndex]

            if characterToMatch == letter {
                return accumulatedAnswer.appending(String(characterToMatch))
            }
            return accumulatedAnswer.appending(String(currentAnswer[currentIndex]))
        })
    }
}
