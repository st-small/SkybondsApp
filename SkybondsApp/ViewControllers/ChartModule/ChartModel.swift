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
    
    func getBonds()
}

public class ChartModel: ChartModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    
    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    private var dataFetcher: MockDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
        dataFetcher = MockDataSourceService()
    }
    
    public func getBonds() {
        isUIBlocked.value = true
//        fetcher.getBonds { [weak self] (response, error) in
//            self?.isUIBlocked.value = false
//
//            if let error = error {
//                self?.error.value = error.localizedDescription
//            }
//
//        }
        dataFetcher.getBonds { [weak self] (response, error) in
            
        }
    }
}
