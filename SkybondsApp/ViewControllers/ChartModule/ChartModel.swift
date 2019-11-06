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
    
    func getBonds()
}

public class ChartModel: ChartModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let bonds: Dynamic<[Bond]>
    
    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    private var dataFetcher: MockDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        bonds = Dynamic([])
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
        dataFetcher = MockDataSourceService()
    }
    
    public func getBonds() {
        isUIBlocked.value = true
        dataFetcher.getBonds { [weak self] (response, error) in
            self?.isUIBlocked.value = false
            guard let activities = response?.activities else { return }
            self?.bonds.value = activities
        }
    }
}
