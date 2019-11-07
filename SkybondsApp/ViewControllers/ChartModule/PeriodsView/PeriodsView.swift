//
//  PeriodsView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class PeriodsView: UIView {
    
    // UI elements
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.1
        return label
    }()
    
    // Data
    private let fromText = "From: "
    private let toText = "\tTo: "
    
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
        
        prepareDescriptionTitle()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 8.0
    }
    
    private func prepareDescriptionTitle() {
        self.addSubview(descriptionLabel)
        descriptionLabel.text = ""
        descriptionLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.center.equalToSuperview()
        }
    }
    
    public func update(_ startDate: Date, _ endDate: Date) {
        
        let startValue = startDate.stringDateWithFormatUTC(format: "dd.MMM.yy")
        let endValue = endDate.stringDateWithFormatUTC(format: "dd.MMM.yy")
        descriptionLabel.text = fromText + startValue + toText + endValue
        layoutSubviews()
    }
}
