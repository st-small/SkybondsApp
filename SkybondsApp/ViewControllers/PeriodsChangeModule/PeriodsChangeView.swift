//
//  PeriodsChangeView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class PeriodsChangeView: SKBModalController {
    
    // UI elements
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Choose period"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Select start date:"
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        return label
    }()
    
    private var startPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "Close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    // Data
    public var viewModel: PeriodsChangeModelProtocol! {
        didSet {
//            viewModel.isUIBlocked.bind { [weak self] isBlocked in
//                DispatchQueue.main.async {
//                    isBlocked ? self?.lockUI() : self?.unlockUI()
//                }
//            }
//
//            viewModel.bonds.bind { [weak self] bonds in
//                guard let bond = bonds.first else { return }
//                DispatchQueue.main.async {
//                    self?.reportsView.update(bond)
//                }
//            }
        }
    }
    
    public override func loadView() {
        super.loadView()
        
        prepareContainerView()
        prepareTitle()
        prepareStartDateTitle()
        prepareStartDatePicker()
        prepareCloseButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func prepareContainerView() {
        self.view.addSubview(containerView)
        containerView.snp.remakeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.6)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.center.equalToSuperview()
        }
        
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = true
    }
    
    private func prepareTitle() {
        containerView.addSubview(titleLabel)
        
        titleLabel.snp.remakeConstraints { make in
            make.top.equalTo(containerView.snp.top).offset(40)
            make.leading.equalTo(containerView.snp.leading).offset(40)
            make.trailing.equalTo(containerView.snp.trailing).offset(-40)
        }
    }
    
    private func prepareStartDateTitle() {
        containerView.addSubview(startDateLabel)
        
        startDateLabel.snp.remakeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    private func prepareStartDatePicker() {
        containerView.addSubview(startPicker)
        startPicker.snp.remakeConstraints { make in
            make.top.equalTo(startDateLabel.snp.bottom).offset(-15)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(100)
        }
        startPicker.dataSource = self
        startPicker.delegate = self
    }
    
    private func prepareCloseButton() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        containerView.addSubview(closeButton)
        
        closeButton.snp.remakeConstraints { make in
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).offset(-30)
            make.width.height.equalTo(44)
        }
    }
    
    @objc
    private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension PeriodsChangeView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
}
extension PeriodsChangeView: UIPickerViewDelegate { }

extension PeriodsChangeView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != containerView
    }
}
