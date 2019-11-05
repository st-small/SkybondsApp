//
//  ChartAssembly.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public class ChartAssembly {
    
    private var viewController: ChartView?
    
    public var view: ChartView {
        guard let view = viewController else {
            self.viewController = ChartView()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    private func configureModule(_ view: ChartView) {
        view.viewModel = ChartModel()
    }
}
