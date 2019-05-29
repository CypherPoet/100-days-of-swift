//
//  ViewController.swift
//  Guess the Flag
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    @IBOutlet var flagButtons: [UIButton]!
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
    
    lazy var notificationCenter = UNUserNotificationCenter.current()
    
    lazy var notificationCategories: Set<UNNotificationCategory> = {
        return [
            LocalNotification.Category.playReminder.notificationCategory
        ]
    }()
    
    var canScheduleNotifications = false {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.notificationPermissionsChanged()
            }
        }
    }
}


// MARK: - Lifecycle

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScore = 0
        highestScore = UserDefaults.standard.integer(forKey: "High Score")
        
        loadFlagData()
        setupButtonStyles()
        askQuestion()
        setupNotifications()
    }
}


// MARK: - Private Helper Methods

private extension HomeViewController {
    
    func askQuestion() {
        flagChoices = Array(flags.shuffled()[..<3])
        correctFlagTag = Int.random(in: 0..<3)
        correctFlag = flagChoices[correctFlagTag]

        title = "Which flag belongs to \(correctFlag.displayName)?"
        
        for (index, button) in flagButtons.enumerated() {
            button.setImage(UIImage(named: flagChoices[index].assetName), for: .normal)
        }
    }
    
    
    func setupButtonStyles() {
        for button in flagButtons {
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor(red: 1.00, green: 0.28, blue: 0.38, alpha: 1.00).cgColor
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
    
    
    func setupNotifications() {
        notificationCenter.getNotificationSettings { [weak self] (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                DispatchQueue.main.async {
                    self?.promptForNotificationPermission()
                }
            case .authorized:
                self?.canScheduleNotifications = true
            case .denied, .provisional:
                self?.canScheduleNotifications = false
            @unknown default:
                break
            }
        }
    }
    
    
    func promptForNotificationPermission() {
        notificationCenter.requestAuthorization(
            options: [.alert, .badge, .criticalAlert, .sound]) {
            [weak self] (wasGranted, error) in
            
            guard error == nil else {
                return print("Error while attempting to authorize local notifications:\n\n\(error!)")
            }
            
            if wasGranted {
                print("🙂 Notification permission was granted!")
                self?.canScheduleNotifications = true
            } else {
                print("😞 Notification permission was not granted.")
            }
        }
    }
    
    
    func scheduleLocalNotifications() {
        notificationCenter.add(LocalNotification.remindPlayer)
    }
    
    
    func registerNoticiationCategories() {
        print("registerNoticiationCategories")
        notificationCenter.setNotificationCategories(notificationCategories)
    }
    
    
    func notificationPermissionsChanged() {
        notificationCenter.removeAllPendingNotificationRequests()
        
        if canScheduleNotifications {
            registerNoticiationCategories()
            scheduleLocalNotifications()
        }
    }
}


// MARK: - Event handling

extension HomeViewController {
    
    @IBAction func flagButtonTouchedDown(_ button: UIButton) {
        button.animateFlagTouchDown()
    }
    
    
    @IBAction func buttonTouchedUpOutside(_ button: UIButton) {
        button.animateFlagTouchUp()
    }

    
    @IBAction func buttonTapped(_ button: UIButton) {
        button.animateFlagTouchUp()
        
        let chosenFlag = flagChoices[button.tag]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            
            if chosenFlag.displayName == self.correctFlag.displayName {
                self.handleChoice(chosenFlag, wasCorrect: true)
            } else {
                self.handleChoice(chosenFlag, wasCorrect: false)
            }
        }
    }
}


