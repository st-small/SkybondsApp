//
//  MockDataSourceService.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol MockDataFetcher {
    func getBonds(response: @escaping (_ data: BondsResponse?, _ error: Error?) -> ())
}

public struct MockDataSourceService: MockDataFetcher {
    
    public func getBonds(response: @escaping (BondsResponse?, Error?) -> ()) {
        
        guard let path = Bundle.main.path(forResource: "bonds", ofType: "json") else { return }
        let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .uncached)
        
        let decoded = self.decodeJSON(type: BondsResponse.self, from: data)
        response(decoded, nil)
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard
            let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
