//
//  ChartModel.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol ChartModelProtocol: class {
    var isUIBlocked: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
    var bonds: Dynamic<[Bond]> { get }
    var filteredItems: Dynamic<[BondValue]> { get }
    
    var chartType: ChartType { get }
    var selectedPeriod: Period? { get }
    var currentBond: Dynamic<Bond?> { get }
    
    func getBonds()
    func updateChartType(_ type: ChartType)
    func updatePeriod(_ period: Period)
    func updateCurrentBond(_ isin: String)
}

public class ChartModel: ChartModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let bonds: Dynamic<[Bond]>
    public let filteredItems: Dynamic<[BondValue]>
    public var chartType: ChartType = .price
    public var currentBond: Dynamic<Bond?>
    public var selectedPeriod: Period?
    
    // Services
    private var fetcher: MockDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        bonds = Dynamic([])
        filteredItems = Dynamic([])
        currentBond = Dynamic(nil)
        
        fetcher = MockDataSourceService()
    }
    
    public func getBonds() {
        isUIBlocked.value = true
        fetcher.getBonds { [weak self] (response, error) in
            self?.isUIBlocked.value = false
            guard let activities = response?.activities else { return }
            
            var updatedBonds = [Bond]()
            
            for bond in activities {
                var items = [BondValue]()
                for item in bond.items {
                    guard let date = item.date.date() else { continue }
                    let newItem = BondValue(date: item.date, price: item.price, dateValue: date)
                    items.append(newItem)
                }
                let newItems = items.sorted(by: { $0.date < $1.date })
                let newBond = Bond(title: bond.title,
                                        currency: bond.currency,
                                        isin: bond.isin,
                                        items: newItems)
                updatedBonds.append(newBond)
            }
            
            if self?.currentBond.value == nil {
                self?.currentBond.value = updatedBonds.first
            } else {
                let currentIsin = self?.currentBond.value?.isin ?? ""
                let selected = updatedBonds.filter({ $0.isin == currentIsin }).first
                self?.currentBond.value = selected
            }
            
            self?.filteredItems.value = self?.currentBond.value?.items ?? []
            self?.bonds.value = updatedBonds
        }
    }
    
    public func updateChartType(_ type: ChartType) {
        chartType = type
    }
    
    public func updatePeriod(_ period: Period) {
        selectedPeriod = period

        guard let bond = currentBond.value else { return }
        let items = bond.items.filter({ $0.dateValue! >= period.start.date && $0.dateValue! <= period.end.date })
        filteredItems.value = items
    }
    
    public func updateCurrentBond(_ isin: String) {
        guard let bond = bonds.value.filter({ $0.isin == isin }).first else { return }
        currentBond.value = bond
        
        let period = selectedPeriod ?? preparePeriod(bond.items.first?.dateValue, end: bond.items.last?.dateValue)
        updatePeriod(period)
    }
    
    private func preparePeriod(_ start: Date?, end: Date?) -> Period {
        let startDate = start ?? Date()
        let startString = startDate.stringDateWithFormatUTC(format: "HH:mm/dd.MM.yy")
        let startItem = PeriodItem(date: startDate, dateString: startString)
        
        let endDate = end ?? Date()
        let endString = endDate.stringDateWithFormatUTC(format: "HH:mm/dd.MM.yy")
        let endItem = PeriodItem(date: endDate, dateString: endString)
        
        return Period(start: startItem, end: endItem)
    }
}
