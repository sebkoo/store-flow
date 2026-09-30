//
//  APIClient.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation

enum APIClientError: LocalizedError {
    case server(status: Int,
                code: String,
                message: String,
                requestId: String?
    )
    case unreadableResponse(status: Int)
    
    var errorDescription: String? {
        switch self {
        case let .server(_, _, message, _): message
        case let .unreadableResponse(status):
            "The server answered \(status) in an unexpected format."
        }
    }
}

protocol IssueService {
    func listIssues() async throws -> [Issue]
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue
}

struct APIClient: IssueService {
    var baseURL: URL = AppConfig.apiBaseURL
    var session: URLSession = .shared
    
    func listIssues() async throws -> [Issue] {
        let list: IssueList = try await send("GET", "/v1/issues")
        return list.items
    }
    
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue {
        try await send("POST",
                       "/v1/issues",
                       body: request)
    }
    
    private func send<Response: Decodable>(
        _ method: String,
        _ path: String,
        body: (any Encodable)? = nil
    ) async throws -> Response {
        var request = URLRequest(url: baseURL.appending(path: path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        let (data, response) = try await session.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard (200..<300).contains(status) else {
            if let error = try? JSONDecoder().decode(APIErrorBody.self, from: data) {
                throw APIClientError.server(
                    status: status,
                    code: error.erorr.code,
                    message: error.erorr.message,
                    requestId: error.erorr.requestId)
            }
            throw APIClientError.unreadableResponse(status: status)
        }
        return try JSONDecoder().decode(Response.self, from: data)
    }
}

