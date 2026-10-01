//
//  IssueListViewModelTests.swift
//  IssueListViewModelTests
//
//  Created by Ben Koo on 9/30/26.
//

import Testing
@testable import StoreFlow

typealias Issue = StoreFlow.Issue

@MainActor
final class FakeIssueService: IssueService {
    var result: Result<[Issue], any Error>
    private(set) var created: [CreateIssueRequest] = []

    init(result: Result<[Issue], any Error>) {
        self.result = result
    }
    
    func listIssues() async throws -> [Issue] {
        try result.get()
    }
    
    func createIssue(_ request: CreateIssueRequest) async throws -> Issue {
        created.append(request)
        return Issue.samples[0]
    }
}

@MainActor
struct IssueListViewModelTests {
    @Test("Load shows issues")
    func loadShowsIssues() async {
        let fake = FakeIssueService(result: .success(Issue.samples))
        let model = IssueListViewModel(service: fake)
        await model.load()
        #expect(model.issues.count == 2)
        #expect(model.state == .loaded)
    }
    @Test("Load failure shows a message")
    func loadFailureShowsMessage() async {
        let fake = FakeIssueService(result: .failure(APIClientError.unreadableResponse(status: 502)))
        let model = IssueListViewModel(service: fake)
        await model.load()
        #expect(model.issues.isEmpty)
        #expect(model.state == .failed("The server answered 502 in an unexpected format."))
    }
    @Test("Create puts the new issue first")
    func createPutsNewIssueFirst() async throws {
        let fake = FakeIssueService(result: .success([]))
        let model = IssueListViewModel(service: fake)
        try await model.create(CreateIssueRequest(
            title: "Printer out of paper",
            type: "PRINTER_FAILURE",
            priority: "NORMAL")
        )
        #expect(fake.created.count == 1)
        #expect(model.issues.first?.id == Issue.samples[0].id)
    }
    @Test("A retry after failure recovers")
    func retryRecovers() async throws {
        let fake = FakeIssueService(result: .failure(APIClientError.unreadableResponse(status: 502)))
        let model = IssueListViewModel(service: fake)
        await model.load()
        fake.result = .success(Issue.samples)
        await model.load()
        #expect(model.state == .loaded)
    }
}
