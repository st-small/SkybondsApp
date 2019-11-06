//
//  ChartTypeSelector.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class ChartTypeSelector: UIView {
    
    // UI elements
    private var typeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PRICE"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    private var accessory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "⌄"
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        label.lineBreakMode = .byClipping
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        self.backgroundColor = .white
        
        prepareTypeTitle()
        prepareAccessory()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 15.0
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        
        clipsToBounds = false
    }
    
    private func prepareTypeTitle() {
        addSubview(typeTitle)
        typeTitle.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().offset(10)
            make.width.equalToSuperview().offset(-30)
        }
    }
    
    private func prepareAccessory() {
        addSubview(accessory)
        accessory.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview().offset(-5)
        }
    }
    
    
    public func updateTitle(_ text: String) {
        typeTitle.text = text
        layoutSubviews()
    }
}
