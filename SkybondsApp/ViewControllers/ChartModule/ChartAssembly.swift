//
//  ChartAssembly.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public class ChartAssembly {
    
    private var viewController: ChartViewController?
    
    public var view: ChartViewController {
        guard let view = viewController else {
            self.viewController = ChartViewController()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    private func configureModule(_ view: ChartViewController) {
        view.viewModel = ChartModel()
    }
}
