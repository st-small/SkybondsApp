//
//  PeriodsChangeModel.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public enum PickerType {
    case start
    case end
}

public protocol PeriodsChangeModelProtocol: class {
    var isUIBlocked: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
    
    var periods: Dynamic<[PeriodItem]> { get }
    var startDate: PeriodItem? { get }
    var endDate: PeriodItem? { get }
    
    func getIndexForPicker(_ value: PeriodItem) -> Int?
    func updateValue(_ date: PeriodItem, type: PickerType)
    func datesValid() -> Bool
    func periodUpdated()
}

public class PeriodsChangeModel: PeriodsChangeModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let periods: Dynamic<[PeriodItem]>
    
    public var startDate: PeriodItem?
    public var endDate: PeriodItem?
    
    private var action: ActionTrigger?
    
    // Services
    
    public init(_ dates: [Date], period: Period?, handler: ActionTrigger?) {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        periods = Dynamic([])
        action = handler
        
        startDate = period?.start
        endDate = period?.end
        
        periods.value = dates.map({ PeriodItem(date: $0, dateString: $0.stringDateWithFormatUTC(format: "HH:mm/dd.MM.yy") )})
    }
    
    public func getIndexForPicker(_ value: PeriodItem) -> Int? {
        return periods.value.firstIndex { $0.date == value.date }
    }
    
    public func updateValue(_ date: PeriodItem, type: PickerType) {
        switch type {
        case .start:
            startDate = date
        case .end:
            endDate = date
        }
    }
    
    public func datesValid() -> Bool {
        guard let start = startDate, let end = endDate else {
            error.value = "Please select both dates values..."
            return false
        }
        guard start.date < end.date else {
            error.value = "Period start and end shouldn't be the same date or Period start date cannot be later than the date of the end of the period..."
            return false
        }
        
        return true
    }
    
    public func periodUpdated() {
        guard let start = startDate, let end = endDate else { return }
        action?(start, end)
    }
}
