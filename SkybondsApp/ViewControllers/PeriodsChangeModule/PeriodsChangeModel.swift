//
//  PeriodsChangeModel.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/6/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol PeriodsChangeModelProtocol: class {
    var isUIBlocked: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
}

public class PeriodsChangeModel: PeriodsChangeModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    
    // Services
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        
    }
}
