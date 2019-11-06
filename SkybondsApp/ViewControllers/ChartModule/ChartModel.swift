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
    var bonds: Dynamic<[BondModel]> { get }
    var filteredItems: Dynamic<[BondModelValue]> { get }
    
    var chartType: ChartType { get }
    var selectedPeriod: Period? { get }
    
    func getBonds()
    func updateChartType(_ type: ChartType)
    func updatePeriod(_ period: Period)
}

public class ChartModel: ChartModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let bonds: Dynamic<[BondModel]>
    public let filteredItems: Dynamic<[BondModelValue]>
    public var chartType: ChartType = .price
    public var selectedPeriod: Period?
    
    // Services
    private var fetcher: MockDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        bonds = Dynamic([])
        filteredItems = Dynamic([])
        
        fetcher = MockDataSourceService()
    }
    
    public func getBonds() {
        isUIBlocked.value = true
        fetcher.getBonds { [weak self] (response, error) in
            self?.isUIBlocked.value = false
            guard let activities = response?.activities else { return }
            
            var updatedBonds = [BondModel]()
            
            for bond in activities {
                var items = [BondModelValue]()
                for item in bond.items {
                    guard let date = item.date.date() else { continue }
                    let newItem = BondModelValue(date: date, price: item.price)
                    items.append(newItem)
                }
                let newItems = items.sorted(by: { $0.date < $1.date })
                let newBond = BondModel(title: bond.title,
                                        currency: bond.currency,
                                        isin: bond.currency,
                                        items: newItems)
                updatedBonds.append(newBond)
            }
            
            self?.bonds.value = updatedBonds
        }
    }
    
    public func updateChartType(_ type: ChartType) {
        chartType = type
    }
    
    public func updatePeriod(_ period: Period) {
        selectedPeriod = period
        
        // current
        guard let first = bonds.value.first else { return }
        let items = first.items.filter({ $0.date >= period.start.date && $0.date <= period.end.date })
        filteredItems.value = items
    }
}
