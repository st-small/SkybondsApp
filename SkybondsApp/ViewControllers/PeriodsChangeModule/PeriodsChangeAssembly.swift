//
//  PeriodsChangeAssembly.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public typealias ActionTrigger = ((_ start: PeriodItem, _ end: PeriodItem) -> ())

public class PeriodsChangeAssembly {
    
    public var handler: ActionTrigger?
    
    private var viewController: PeriodsChangeView?
    private var dates: [Date]
    private var selectedPeriod: Period?
    
    public var view: PeriodsChangeView {
        guard let view = viewController else {
            self.viewController = PeriodsChangeView()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    public init(_ dates: [Date], period: Period? = nil) {
        self.dates = dates
        self.selectedPeriod = period
    }
    
    private func configureModule(_ view: PeriodsChangeView) {
        view.viewModel = PeriodsChangeModel(dates, period: selectedPeriod, handler: handler)
    }
}
