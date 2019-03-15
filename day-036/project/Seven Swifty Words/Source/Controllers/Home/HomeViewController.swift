//
//  ViewController.swift
//  Seven Swifty Words
//
//  Created by Brian Sipple on 1/21/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet var cluesLabel: UILabel!
    @IBOutlet var answersLabel: UILabel!
    @IBOutlet var currentAnswerField: UITextField!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var letterGroupButtonContainer: UIView!
    
    enum LetterGroupButton {
        static let width = 150
        static let height = 80
    }
    
    // MARK: - Instance Properties
    
    var activatedButtons: [UIButton] = []
    var letterGroupButtons: [UIButton] = []
    var solutionWords: [String] = []
    var currentLevel = 1
    
    var currentScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(self.currentScore)"
        }
    }
    
    var currentAnswer = "" {
        didSet {
            if currentAnswer.isEmpty {
                currentAnswerField.text = "Tap Lettters To Guess"
                currentAnswerField.textColor = Style.Color.answerTextPlaceholder
            } else {
                currentAnswerField.text = currentAnswer
                currentAnswerField.textColor = Style.Color.answerText
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        currentAnswer = ""
        
        setStyles()
        createLetterGroupButtons()
        positionLabels()
        positionAnswerText()
        positionButtons()
        
        setupLevel(number: currentLevel)
    }
}


// MARK: - Level Data Loading

private extension HomeViewController {
    func setupLevel(number: Int) {
        let (cluesText, solutionLengthsText, solutionLetterGroups, solutionWords) = loadLevel(number: number)

        self.solutionWords = solutionWords
        cluesLabel.text = cluesText.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionLengthsText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        setLetterGroupButtonTitles(from: solutionLetterGroups)
    }

    
    func loadLevel(number levelNumber: Int) ->
        (cluesText: String, solutionLengthsText: String, solutionLetterGroups: [String], solutionWords: [String])
    {
        guard let filePath = Bundle.main.path(forResource: "level\(levelNumber)", ofType: "txt") else {
            fatalError("Could not find file \"level\(levelNumber).txt\"")
        }
        
        do {
            let contents = try String(contentsOfFile: filePath)
            var cluesText = ""
            var solutionLengthsText = ""
            var solutionLetterGroups: [String] = []
            var solutionWords: [String] = []
            
            var lines = contents.components(separatedBy: "\n")
            lines.shuffle()
            
            for (index, line) in lines.enumerated() {
                let lineParts = line.components(separatedBy: ": ")
                let solutionPart = lineParts[0]
                let solutionWord = solutionPart.replacingOccurrences(of: "|", with: "")
                
                solutionLengthsText += "\(solutionWord.count) letters\n"
                cluesText += "\(index + 1). \(lineParts[1])\n"
                
                solutionWords.append(solutionWord)
                solutionLetterGroups += solutionPart.components(separatedBy: "|")
            }
            
            solutionLetterGroups.shuffle()
            
            return (cluesText, solutionLengthsText, solutionLetterGroups, solutionWords)
            
        } catch {
            fatalError("Error while parsing \"level\(levelNumber).txt\":\n\n\(error.localizedDescription)")
        }
    }
    
    
    func setLetterGroupButtonTitles(from solutionLetterGroups: [String]) {
        guard solutionLetterGroups.count == letterGroupButtons.count else {
            fatalError("Count of solution letter groups should match the number of letter group buttons")
        }
        
        for index in 0 ..< solutionLetterGroups.count {
            letterGroupButtons[index].setTitle(solutionLetterGroups[index], for: .normal)
        }
    }
}


// MARK: - UI Setup

extension HomeViewController {
    func setStyles() {
        view.backgroundColor = Style.Color.background
        answersLabel.textColor = Style.Color.labelText
        cluesLabel.textColor = Style.Color.labelText
        scoreLabel.textColor = Style.Color.labelText
        
        letterGroupButtonContainer.layer.cornerRadius = 3
        letterGroupButtonContainer.layer.shadowColor = Style.Color.letterGroupButtonShadow.cgColor
        letterGroupButtonContainer.layer.shadowOpacity = 0.7
        letterGroupButtonContainer.layer.shadowRadius = 2
    }
    
    func createLetterGroupButtons() {
        let xSpacing = 0
        let ySpacing = 0
        
        for row in 0...3 {
            for column in 0...4 {
                let button = UIButton(type: .system)
                let xPos = (column * LetterGroupButton.width) + (column * xSpacing)
                let yPos = (row * LetterGroupButton.height) + (row * ySpacing)
                
                button.frame = CGRect(x: xPos, y: yPos, width: LetterGroupButton.width, height: LetterGroupButton.height)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.tintColor = Style.Color.letterGroupButton
                button.addTarget(self, action: #selector(letterGroupTapped), for: .touchUpInside)
                
                letterGroupButtons.append(button)
                letterGroupButtonContainer.addSubview(button)
            }
        }
    }
    
    func positionLabels() {
        [scoreLabel, cluesLabel, answersLabel].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -16),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 0),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor)
        ])
     
        // Lower the content hugging priority -- making these the first views to be stretched if needed
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    }
    
    func positionAnswerText() {
        currentAnswerField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentAnswerField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswerField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswerField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 14),
        ])
    }
    
    func positionButtons() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        letterGroupButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor, constant: 12),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            letterGroupButtonContainer.widthAnchor.constraint(equalToConstant: CGFloat(LetterGroupButton.width * 5)),
            letterGroupButtonContainer.heightAnchor.constraint(equalToConstant: CGFloat(LetterGroupButton.height * 4)),
            letterGroupButtonContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 12),
            letterGroupButtonContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -32),
        ])
    }
}


// MARK: - Helper functions

private extension HomeViewController {
    func addCorrectAnswer(indexOfMatch: Int) {
        var answerStrings = answersLabel.text!.components(separatedBy: "\n")
        
        answerStrings[indexOfMatch] = currentAnswer
        answersLabel.text = answerStrings.joined(separator: "\n")
        
        currentAnswer = ""
    }
    
    
    func bumpScore() {
        currentScore += 1
        
        if currentScore % 7 == 0 {
            // advance level
            promptForNextLevel()
        }
    }
    
    
    func promptForNextLevel() {
        let alertController = UIAlertController(
            title: "Well Done!",
            message: "Are you ready for the next level?",
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
        present(alertController, animated: true)
    }
    
    
    func promptAfterIncorrect() {
        let alertController = UIAlertController(
            title: "Incorrect",
            message: "No solutions were found for that answer.",
            preferredStyle: .alert
        )
        
        alertController.addAction(
            UIAlertAction(title: "Try again", style: .default) { [unowned self] (action: UIAlertAction) in
                self.clearAnswer()
            }
        )
                
        present(alertController, animated: true)
    }
    
    
    func levelUp(action: UIAlertAction) {
        currentLevel += 1
        solutionWords.removeAll(keepingCapacity: true)
        
        for button in letterGroupButtons {
            button.isHidden = false
        }
        
        setupLevel(number: currentLevel)
    }


    func clearAnswer() {
        currentAnswer = ""
        
        activatedButtons.forEach { $0.isHidden = false }
        activatedButtons.removeAll()
    }
}


// MARK: - Event handling

extension HomeViewController {
    @IBAction func clearTapped(_ sender: Any) {
        clearAnswer()
    }
    
    
    /*
     If the user guesses a correct answer, we'll change
     the answer's corresponding label (in the upper text area)
     to display the answer itself, rather than its letter count
     */
    @IBAction func submitTapped(_ sender: Any) {
        guard !currentAnswer.isEmpty else { return }
        
        if let indexOfMatch = solutionWords.firstIndex(of: currentAnswer) {
            activatedButtons.removeAll()  // remove all from our array -- but keep them "hidden" on the UI
            addCorrectAnswer(indexOfMatch: indexOfMatch)
            bumpScore()
        } else {
            promptAfterIncorrect()
        }
    }
    
    
    @objc func letterGroupTapped(_ sender: UIButton) {
        guard let buttontext = sender.titleLabel?.text else { return }

        currentAnswer += buttontext
        activatedButtons.append(sender)
        sender.isHidden = true
    }
}
