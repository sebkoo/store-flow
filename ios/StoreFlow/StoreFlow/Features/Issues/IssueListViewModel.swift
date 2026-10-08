//
//  IssueListViewModel.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation
import Observation
import StoreFlowShared

@MainActor
@Observable
final class IssueListViewModel {
    enum State: Equatable {
        case idle, loading, loaded
        case failed(String)
    }
    
    private(set) var issues: [Issue] = []
    private(set) var state: State = .idle
    private let service: any IssueService
    
    init(service: (any IssueService)? = nil) {
        self.service = service ?? APIClient()
    }
    
    func load() async {
        state = .loading
        do {
            issues = try await service.listIssues()
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
    
    func create(_ request: CreateIssueRequest) async throws {
        let issue = try await service.createIssue(request)
        issues.insert(issue, at: 0)
    }
    
    func transition(_ issue: Issue,
                    to target: IssueStatus,
                    assigneeId: String?
    ) async throws {
        let updated = try await service.transition(issueId: issue.id,
                                                   to: target,
                                                   assigneeId: assigneeId)
        if let index = issues.firstIndex(where: { $0.id == updated.id }) {
            issues[index] = updated
        }
    }
}
