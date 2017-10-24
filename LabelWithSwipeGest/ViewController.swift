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
    private var view: UIView? = nil
    private var slidingLabel: UILabel? = nil
    
    fileprivate func showSlidingLabel(_ view: UIView, navigationController: UINavigationController?) {
        initializeSlidingLabel("This is a test label", view: view, backgroundColor: .red, navigationController: navigationController)
        animateLabel()
    }
    
    private func initializeSlidingLabel(_ message: String, view: UIView, backgroundColor: UIColor, navigationController: UINavigationController?) {
        // width
        let width = view.bounds.width
        
        // Height (equivalent to searchBar height)
        let height = CGFloat(44)
        
        // x
        let x = view.bounds.minX
        
        // y
        var y = UIApplication.shared.statusBarFrame.height
        if let navigationController = navigationController {
            y += navigationController.navigationBar.bounds.size.height
        }
        
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
        navigationController?.view.addSubview(slidingLabel)
        
        self.view = view
        self.slidingLabel = slidingLabel
        slidingLabel.isUserInteractionEnabled = true
        addSwipeRecognizer(slidingLabel)
        addTapRecognizer(slidingLabel)
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
        guard let slidingLabel = slidingLabel else { return }
        guard  let view = view else { return }
        UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y -= view.bounds.height })
    }
    
    @objc private func handleSwipe(sender: UISwipeGestureRecognizer) {
        guard let slidingLabel = slidingLabel else { return }
        guard  let view = view else { return }
        if sender.direction == .up {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y -= view.bounds.height })
        } else if sender.direction == .right {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.frame.origin.x += view.bounds.width })
        } else if sender.direction == .left {
            UIView.animate(withDuration: 1.0, animations: { slidingLabel.frame.origin.x -= view.bounds.width })
        }
    }
    
    private func animateLabel() {
        guard let slidingLabel = slidingLabel else { return }
        guard  let view = view else { return }
        UIView.animate(withDuration: 1.0, animations: { slidingLabel.center.y += view.bounds.height })
    }
}
