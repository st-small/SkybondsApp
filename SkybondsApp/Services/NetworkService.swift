//
//  NetworkService.swift
//  SkybondsApp
//
//  Created by Станислав Шияновский on 11/5/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
}

public typealias NetworkHandler = (Data?, Error?, Int?) -> ()

public protocol Networking: class {
    func request(path: String, method: NetworkMethod, body: Data?, completion: @escaping NetworkHandler)
}

public final class NetworkService: Networking {
    
    public func request(path: String, method: NetworkMethod, body: Data?, completion: @escaping NetworkHandler) {
        let url = self.url(from: path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping NetworkHandler) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            let httpResponse = response as? HTTPURLResponse
            DispatchQueue.main.async {
                completion(data, error, httpResponse?.statusCode)
            }
        })
    }
    
    private func url(from path: String) -> URL {
        var components = URLComponents()
        components.scheme = APIConstants.scheme
        components.host = APIConstants.host
        components.path = path
        return components.url!
    }
}
