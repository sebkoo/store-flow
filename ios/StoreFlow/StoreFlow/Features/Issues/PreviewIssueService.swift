//
//  PreviewIssueService.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation

struct PreviewIssueService: IssueService {
    var issues: [Issue] = Issue.samples
    
    func listIssues() async throws -> [Issue] { issues }
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue {
        Issue(id: UUID().uuidString,
              storeId: "store-001",
              title: request.title,
              type: request.type,
              priority: request.priority,
              status: "OPEN",
              assigneeId: nil,
              createdAt: "2026-09-25T10:00:00Z",
              updatedAt: "2026-09-25T10:00:00Z")
    }
}
