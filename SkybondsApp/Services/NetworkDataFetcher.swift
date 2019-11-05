//
//  NetworkDataFetcher.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol DataFetcher {
    func getBonds(response: @escaping (_ data: [Bond]?, _ error: Error?) -> ())
}

public struct NetworkDataFetcher: DataFetcher {
    
    private let networking: Networking
    
    public init(_ networking: Networking) {
        self.networking = networking
    }
    
    public func getBonds(response: @escaping ([Bond]?, Error?) -> ()) {
        
        networking.request(path: APIConstants.bonds, method: .get, body: nil) { (data, error, _) in
            if let error = error {
                print("Error recieved requesting data: \(error.localizedDescription)")
                response(nil, error)
            }
            
            let decoded = self.decodeJSON(type: [Bond].self, from: data)
            response(decoded, nil)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard
            let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
    private func encode<T>(_ value: T) -> Data? where T: Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        guard let response = try? encoder.encode(value) else { return nil }
        return response
    }
}
