//
//  URLSessionTransport.swift
//  StoreFlow
//
//  Created by Ben Koo on 10/7/26.
//

import Foundation
import StoreFlowShared

struct URLSessionTransport {
    var baseURL: URL = AppConfig.apiBaseURL
    var session: URLSession = .shared
    
    func execute(_ request: ApiRequest) async throws -> ApiResponse {
        let base = baseURL.absoluteString.hasSuffix("/")
            ? String(baseURL.absoluteString.dropLast())
            : baseURL.absoluteString
        
        guard let url = URL(string: base + request.path)
        else { throw URLError(.badURL) }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method
        
        for (name, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: name)
        }
        
        urlRequest.httpBody = request.body?.data(using: .utf8)
        
        let (data, response) = try await session.data(for: urlRequest)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        
        return ApiResponse(status: Int32(status), body: String(decoding: data, as: UTF8.self))
    }
}
