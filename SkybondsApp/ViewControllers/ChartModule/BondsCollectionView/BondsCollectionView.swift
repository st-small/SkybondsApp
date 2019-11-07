//
//  BondsCollectionView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public protocol BondsCollectionViewDelegate: class {
    func didSelectItem(isin: String)
}

public class BondsCollectionView: UICollectionView {
    
    // Data
    public var bondDelegate: BondsCollectionViewDelegate?
    private var bonds = [Bond]()
    
    private var selected: IndexPath
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        
        selected = IndexPath(item: 0, section: 0)
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .clear
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        register(BondsCollectionViewCell.self, forCellWithReuseIdentifier: BondsCollectionViewCell.reuseId)
    }
    
    public func set(bonds: [Bond]) {
        self.bonds = bonds
        contentOffset = .zero
        reloadData()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        selected = IndexPath(item: 0, section: 0)
        super.init(coder: aDecoder)
    }
}

extension BondsCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bonds.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: BondsCollectionViewCell.reuseId, for: indexPath) as! BondsCollectionViewCell
        cell.set(bond: bonds[indexPath.row], isSelected: indexPath == selected)
        return cell
    }
}

extension BondsCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bond = bonds[indexPath.row]
        selected = indexPath
        bondDelegate?.didSelectItem(isin: bond.isin)
        collectionView.reloadData()
    }
}

extension BondsCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 32 - 30)/3
        return CGSize(width: width, height: width)
    }
}
