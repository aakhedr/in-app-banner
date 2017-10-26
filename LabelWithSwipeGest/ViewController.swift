//
//  ViewController.swift
//  LabelWithSwipeGest
//
//  Created by Ahmed Khedr on 10/24/17.
//  Copyright © 2017 Ahmed Khedr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showSlidingLabel(_ sender: UIButton) {
        Helpers.sharedInstance.showSlidingLabel(view, navigationController: navigationController)
    }
}

class Helpers {
    static let sharedInstance = Helpers()
    
    fileprivate func showSlidingLabel(_ view: UIView, navigationController: UINavigationController?) {
        guard let slidingLabel = initializeSlidingLabel("This is a test label", view: view, backgroundColor: .red, navigationController: navigationController) else { return }
        animateLabel(slidingLabel: slidingLabel, view: view)
    }
    
    private func initializeSlidingLabel(_ message: String, view: UIView, backgroundColor: UIColor, navigationController: UINavigationController?) -> UILabel? {
        guard let navController = navigationController else { return nil }
        
        // width
        let width = view.bounds.width
        
        // Height (equivalent to searchBar height)
        let height = CGFloat(44)
        
        // x
        let x = view.bounds.minX
        
        // y
        let y = UIApplication.shared.statusBarFrame.height + navController.navigationBar.bounds.height
        
        let slidingLabel = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        slidingLabel.layer.cornerRadius = 5.0
        slidingLabel.layer.masksToBounds = true
        slidingLabel.numberOfLines = 0
        slidingLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        slidingLabel.adjustsFontSizeToFitWidth = true
        slidingLabel.minimumScaleFactor = 0.7
        slidingLabel.textAlignment = .center
        slidingLabel.text = message
        slidingLabel.backgroundColor = backgroundColor
        slidingLabel.textColor = .white
        
        // Make it disappear from the view
        slidingLabel.center.y -= view.bounds.height
        navController.view.addSubview(slidingLabel)
        
        slidingLabel.isUserInteractionEnabled = true
        addSwipeRecognizer(slidingLabel)
        addTapRecognizer(slidingLabel)
        
        return slidingLabel
    }
    
    private func addSwipeRecognizer(_ slidingLabel: UILabel) {
        let gestureDirections: [UISwipeGestureRecognizerDirection] = [.up, .left, .right]
        for direction in gestureDirections {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
            gesture.direction = direction
            slidingLabel.addGestureRecognizer(gesture)
        }
    }
    
    private func addTapRecognizer(_ slidingLabel: UILabel) {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        slidingLabel.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer) {
        guard let slidingLabel = sender.view as? UILabel else { return }
        guard let view = slidingLabel.superview else { return }
        UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y -= view.bounds.height }, completion: nil)
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        guard let slidingLabel = sender.view as? UILabel else { return }
        guard let view = slidingLabel.superview else { return }
        if sender.direction == .up {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y -= view.bounds.height })
        } else if sender.direction == .right {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.frame.origin.x += view.bounds.width })
        } else if sender.direction == .left {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.frame.origin.x -= view.bounds.width })
        }
    }
    
    private func animateLabel(slidingLabel: UILabel, view: UIView) {
        UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y += view.bounds.height })
    }
}
