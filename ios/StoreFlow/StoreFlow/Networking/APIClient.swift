//
//  APIClient.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation
import StoreFlowShared

protocol IssueService {
    func listIssues() async throws -> [Issue]
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue
    func transition(issueId: String, to target: IssueStatus, assigneeId: String?) async throws -> Issue
}

struct APIClient: IssueService {
    var transport = URLSessionTransport()
    var token: String? = nil
    private var requestBuilder: StoreFlowRequests { .shared }
    private var responseBuilder: StoreFlowResponses { .shared }
    
    func listIssues() async throws -> [Issue] {
        let response = try await transport.execute(
            requestBuilder.listIssues(token: token)
        )
        return try responseBuilder.issues(response: response)
    }
    
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue {
        let response = try await transport.execute(
            requestBuilder.createIssue(token: token, body: request)
        )
        return try responseBuilder.issue(response: response)
    }
    
    func transition(issueId: String,
                    to target: IssueStatus,
                    assigneeId: String?
    ) async throws -> Issue {
        let body = TransitionRequest(
            to: target,
            assigneeId: assigneeId
        )
        let response = try await transport.execute(
            requestBuilder.transitionIssue(token: token,
                                     issueId: issueId,
                                     body: body)
        )
        return try responseBuilder.issue(response: response)
    }
}

