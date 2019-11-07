//
//  BondsCollectionViewCell.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class BondsCollectionViewCell: UICollectionViewCell {
    
    public static let reuseId = "BondsCollectionViewCell"
    
    // UI elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.MainGradient.start
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.Colors.MainGradient.start
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.numberOfLines = 3
        label.textAlignment = .center
        return label
    }()
    
    // Data
    private let customColor = Constants.Colors.MainGradient.start
    private var isItemSelected: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        
        prepareTileLabel()
        prepareCurrencyLabel()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func prepareTileLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    private func prepareCurrencyLabel() {
        self.addSubview(currencyLabel)
        currencyLabel.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    public override func prepareForReuse() {
        
    }
    
    public func set(bond: Bond, isSelected: Bool) {
        titleLabel.text = bond.title
        currencyLabel.text = bond.currency
        
        isItemSelected = isSelected
        backgroundColor = isSelected ? customColor : .white
        titleLabel.textColor = isSelected ? .white : customColor
        currencyLabel.textColor = isSelected ? .white : customColor
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.width/2
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2.5, height: 4.0)
        
        layer.borderColor = isItemSelected ? UIColor.white.cgColor : customColor.cgColor
        layer.borderWidth = 1.0
        
        clipsToBounds = false
    }

}
