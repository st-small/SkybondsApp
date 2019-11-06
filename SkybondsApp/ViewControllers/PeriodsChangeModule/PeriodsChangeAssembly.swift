//
//  PeriodsChangeAssembly.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public typealias ActionTrigger = (() -> ())

public class PeriodsChangeAssembly {
    
    public var handler: ActionTrigger?
    
    private var viewController: PeriodsChangeView?
    
    public var view: PeriodsChangeView {
        guard let view = viewController else {
            self.viewController = PeriodsChangeView()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    private func configureModule(_ view: PeriodsChangeView) {
        view.viewModel = PeriodsChangeModel()
    }
}
