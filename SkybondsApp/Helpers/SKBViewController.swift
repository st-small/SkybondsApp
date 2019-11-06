//
//  SKBViewController.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class SKBViewController: UIViewController {
    
    // UI elements
    private var blurView = UIView(frame: UIScreen.main.bounds)
    private var gradient: GradientView = {
        let start = Constants.Colors.MainGradient.start
        let end = Constants.Colors.MainGradient.end
        let view = GradientView(startColor: start, endColor: end)
        return view
    }()
    
    public override func loadView() {
        super.loadView()
        
        prepareBackground()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func prepareBackground() {
        view.addSubview(gradient)
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    public func lockUI() {
        setupContainer()
        view.isUserInteractionEnabled = false
    }
    
    public func unlockUI() {
        view.isUserInteractionEnabled = true
        blurView.removeFromSuperview()
    }
    
    private func setupContainer() {
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.45)
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.setNeedsLayout()
        guard blurView.subviews.isEmpty else { return }
        
        let lockViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        lockViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        lockViewContainer.layer.cornerRadius = 10.0
        lockViewContainer.clipsToBounds = true
        blurView.addSubview(lockViewContainer)
        lockViewContainer.center = blurView.center
        
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.color = .gray
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        lockViewContainer.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: lockViewContainer.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: lockViewContainer.centerYAnchor).isActive = true
    }
    
    public func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title : "OK", style : .default, handler: { action in
            self.okErrorButtonTapped()
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func okErrorButtonTapped() { }
    
    public func showSuccessAlert(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title : "OK", style : .default, handler: { action in
            self.okSuccessButtonTapped()
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func okSuccessButtonTapped() { }
    
    public func presentViaCrossDissolve(_ viewControllerToPresent: UIViewController, on controller: UIViewController) {
        viewControllerToPresent.modalPresentationStyle = .overCurrentContext
        viewControllerToPresent.modalTransitionStyle = .crossDissolve
        controller.present(viewControllerToPresent, animated: true, completion: nil)
    }
}
