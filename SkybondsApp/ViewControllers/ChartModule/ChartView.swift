//
//  ChartView.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class ChartView: UIViewController {

    public var viewModel: ChartModelProtocol!
    
    public override func loadView() {
        super.loadView()
        
        loadData()
    }
    
    @objc private func loadData() {
        viewModel?.getBonds()
        
        view.backgroundColor = .cyan
    }
}
