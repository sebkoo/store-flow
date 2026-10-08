//
//  PreviewIssueService.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation
import StoreFlowShared

struct PreviewIssueService: IssueService {
    func listIssues() async throws -> [Issue] { PreviewData.issues }
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue {
        PreviewData.issues[0]
    }
    func transition(issueId: String, to target: IssueStatus, assigneeId: String?) async throws -> Issue {
        PreviewData.issues[1]
    }
}
