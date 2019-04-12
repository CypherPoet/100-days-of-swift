//
//  ViewController.swift
//  Guess the Flag
//

import UIKit


class HomeViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet weak var scoreButton: UIBarButtonItem!
    @IBOutlet weak var highestScoreLabel: UILabel!
    
    var flags: [Flag] = []
    var flagChoices: [Flag] = []
    var correctFlag: Flag!
    var correctFlagTag: Int!
    
    var questionsAsked = 0
    
    var currentScore = 0 {
        didSet {
            scoreButton.title = String(currentScore)
        }
    }
    
    var highestScore = 0 {
        didSet {
            UserDefaults.standard.set(highestScore, forKey: "High Score")
            highestScoreLabel.text = "Highset Score: \(highestScore)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        currentScore = 0
        highestScore = UserDefaults.standard.integer(forKey: "High Score")
        
        loadFlagData()
        setupButtonStyles()
        askQuestion()
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {
    
    func askQuestion() {
        flagChoices = Array(flags.shuffled()[..<3])
        correctFlagTag = Int.random(in: 0..<3)
        correctFlag = flagChoices[correctFlagTag]

        title = "Which flag belongs to \(correctFlag.displayName)?"
        
        for (index, button) in [button1, button2, button3].enumerated() {
            button?.setImage(UIImage(named: flagChoices[index].assetName), for: .normal)
        }
    }
    
    
    func setupButtonStyles() {
        for button in [button1, button2, button3] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor(red: 1.00, green: 0.28, blue: 0.38, alpha: 1.00).cgColor
        }
    }
    
    
    func handleChoice(_ chosenFlag: Flag, wasCorrect: Bool) {
        var responseMessage: String
        
        if wasCorrect {
            title = "Correct!"
            responseMessage = "You just gained 1 point!"
            currentScore += 1
        } else {
            title = "Incorrect!"
            responseMessage = "That's the flag of \(chosenFlag.displayName), not \(correctFlag.displayName). You just lost 3 points."
            currentScore = max(0, currentScore - 3)
        }
        
        let alertController = UIAlertController(title: title, message: responseMessage, preferredStyle: .alert)
        
        alertController.addAction(
            UIAlertAction(title: "Continue", style: .default) { [unowned self] _ in
                self.questionsAsked += 1
                self.questionsAsked == 10 ? self.endGame() : self.askQuestion()
            }
        )
        
        present(alertController, animated: true)
    }

    
    func loadFlagData() {
        if let jsonData = loadFlagJSON() {
            let decoder = JSONDecoder()
            
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                flags = try decoder.decode([Flag].self, from: jsonData)
            } catch {
                print("Error decoding flag JSON data:\n\(error.localizedDescription)")
            }
            
        } else {
            print("Unable to find flag JSON data")
        }
    }
    
    
    func loadFlagJSON() -> Data? {
        if let dataPath = Bundle.main.path(forResource: "flag-data", ofType: "json") {
            
            do {
                let flagDataURL = URL(fileURLWithPath: dataPath)
                return try Data(contentsOf: flagDataURL)
            } catch {
                print("Error while loading flag json data: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
    
    
    func endGame() {
        if currentScore > highestScore {
            highestScore = currentScore
        }
        
        let alertController = UIAlertController(title: "Game Over", message: "Your final score is \(currentScore)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Play Again", style: .default) { [unowned self] _ in
            self.currentScore = 0
            self.questionsAsked = 0
            self.askQuestion()
        })
        
        present(alertController, animated: true)
    }
}


// MARK: - Event handling

extension HomeViewController {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let chosenFlag = flagChoices[sender.tag]
        
        if chosenFlag.displayName == correctFlag.displayName {
            handleChoice(chosenFlag, wasCorrect: true)
        } else {
            handleChoice(chosenFlag, wasCorrect: false)
        }
    }
}
