//
//  Bond.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public struct BondsResponse: Decodable {
    public var activities: [Bond]
}

public struct Bond: Decodable {
    public var title: String
    public var currency: String
    public var isin: String
    public var items: [BondValue]
}

public struct BondValue: Decodable {
    public var date: String
    public var price: Double
    
    public var dateValue: Date?
}

public struct BondModel {
    public var title: String
    public var currency: String
    public var isin: String
    public var items: [BondModelValue]
}

public struct BondModelValue {
    public var date: Date
    public var price: Double
}
