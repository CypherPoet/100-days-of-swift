//
//  ViewController.swift
//  Animation
//
//  Created by Brian Sipple on 1/29/19.
//  Copyright © 2019 Brian Sipple. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {
    @IBOutlet var triggerButton: UIButton!
    
    var currentAnimationIndex = 0
    let animationDuration = 1.0
    let animationDelay = 0.0
    
    lazy var imageView = makeAnimatingImage()
}


// MARK: - Lifecycle

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)

        triggerButton.layer.zPosition = 1
    }
}


// MARK: - Event handling
extension MainViewController {

    @IBAction func triggerAnimation(_ sender: Any) {
        triggerButton.alpha = 0.0
        
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 5,
            options: [],
            animations: { [weak self] in
                self?.runCurrentAnimation()
            },
            completion: { [weak self] _ in
                self?.triggerButton.alpha = 1.0
            }
        )
    
        currentAnimationIndex = (currentAnimationIndex + 1) % 8
    }
    
}


// MARK: - Private Helper Methods

private extension MainViewController {
    func runCurrentAnimation() {
        switch currentAnimationIndex {
        case 1, 3, 5:
            self.imageView.transform = CGAffineTransform.identity
        case 0:
            self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
        case 2:
            self.imageView.transform = CGAffineTransform(translationX: -(view.center.x / 2), y: -(view.center.y / 2))
        case 4:
            self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        case 6:
            self.imageView.alpha = 0.1
            self.imageView.backgroundColor = UIColor.purple
        case 7:
            self.imageView.alpha = 1.0
            self.imageView.backgroundColor = UIColor.clear
        default:
            break
        }
    }
    
    
    func makeAnimatingImage() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "penguin"))
        
        imageView.center = view.center
        imageView.layer.zPosition = 0
        
        return imageView
    }
}

