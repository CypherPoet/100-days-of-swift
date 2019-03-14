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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        if let (clueString, answerString, solutionLetterGroups, solutionWords) = loadLevel(number: number) {
            self.solutionWords = solutionWords
            cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
            answersLabel.text = answerString.trimmingCharacters(in: .whitespacesAndNewlines)
            
            setLetterGroupButtonTitles(from: solutionLetterGroups)
        }
    }

    
    func loadLevel(number levelNumber: Int) ->
        (clueString: String, answerString: String, solutionLetterGroups: [String], solutionWords: [String])?
    {
        if let filePath = Bundle.main.path(forResource: "level\(levelNumber)", ofType: "txt") {
            if let contents = try? String(contentsOfFile: filePath) {
                var clueString = ""
                var answerString = ""
                var solutionLetterGroups = [String]()
                var solutionWords = [String]()
                
                var lines = contents.components(separatedBy: "\n")
                lines.shuffle()
                
                for (index, line) in lines.enumerated() {
                    let lineParts = line.components(separatedBy: ": ")
                    let solutionPart = lineParts[0]
                    let solutionWord = solutionPart.replacingOccurrences(of: "|", with: "")
                    
                    answerString += "\(solutionWord.count) letters\n"
                    clueString += "\(index + 1). \(lineParts[1])\n"
                    
                    solutionWords.append(solutionWord)
                    solutionLetterGroups += solutionPart.components(separatedBy: "|")
                }
                
                solutionLetterGroups.shuffle()
                return (clueString, answerString, solutionLetterGroups, solutionWords)
            }
        }
        return nil
    }
    
    
    func setLetterGroupButtonTitles(from solutionLetterGroups: [String]) {
        if solutionLetterGroups.count == letterGroupButtons.count {
            for index in 0 ..< solutionLetterGroups.count {
                letterGroupButtons[index].setTitle(solutionLetterGroups[index], for: .normal)
            }
        }
    }
}


// MARK: - UI Setup

extension HomeViewController {
    func createLetterGroupButtons() {
        let xSpacing = 10
        let ySpacing = 10
        
        for row in 0...3 {
            for column in 0...4 {
                let button = UIButton(type: .system)
                let xPos = (column * LetterGroupButton.width) + (column * xSpacing)
                let yPos = (row * LetterGroupButton.height) + (row * ySpacing)
                
                button.frame = CGRect(x: xPos, y: yPos, width: LetterGroupButton.width, height: LetterGroupButton.height)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                button.addTarget(self, action: #selector(letterGroupTapped), for: .touchUpInside)
                
                letterGroupButtons.append(button)
                letterGroupButtonContainer.addSubview(button)
            }
        }
    }
    
    func positionLabels() {
        [scoreLabel, cluesLabel, answersLabel].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 12),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 12),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 12),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answersLabel.topAnchor.constraint(equalTo: cluesLabel.topAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor)
        ])
     
        // Make these the first views to be stretched if needed
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    }
    
    func positionAnswerText() {
        currentAnswerField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            currentAnswerField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswerField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswerField.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
        ])
    }
    
    func positionButtons() {
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        letterGroupButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: currentAnswerField.bottomAnchor),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.topAnchor.constraint(equalTo: submitButton.topAnchor),
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            
            letterGroupButtonContainer.widthAnchor.constraint(equalToConstant: 750),
            letterGroupButtonContainer.heightAnchor.constraint(equalToConstant: 320),
            letterGroupButtonContainer.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            letterGroupButtonContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -32),
        ])
    }
}


// MARK: - Helper functions

private extension HomeViewController {
    func addCorrectAnswer(indexOfMatch: Int) {
        var answerStrings = answersLabel.text!.components(separatedBy: "\n")
        
        answerStrings[indexOfMatch] = currentAnswerField.text!
        answersLabel.text = answerStrings.joined(separator: "\n")
        
        currentAnswerField.text = ""
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
        currentAnswerField.text = ""
        
        for button in activatedButtons {
            button.isHidden = false
        }
        
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
        if let indexOfMatch = solutionWords.index(of: currentAnswerField.text!) {
            activatedButtons.removeAll()  // remove all from our array -- but keep them "hidden" on the UI
            addCorrectAnswer(indexOfMatch: indexOfMatch)
            bumpScore()
        } else {
            promptAfterIncorrect()
        }
    }
    
    
    @objc func letterGroupTapped(btn: UIButton) {
        currentAnswerField.text! += btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }
}
