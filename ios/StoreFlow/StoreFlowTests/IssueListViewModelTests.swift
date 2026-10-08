//
//  IssueListViewModelTests.swift
//  IssueListViewModelTests
//
//  Created by Ben Koo on 9/30/26.
//

import Testing
import StoreFlowShared
@testable import StoreFlow

typealias Issue = StoreFlowShared.Issue

struct FakeFailure: LocalizedError {
    var errorDescription: String? {
        "The server answered 502 in an unexpected format."
    }
}

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
        return PreviewData.issues[0]
    }
    func transition(issueId: String,
                    to target: IssueStatus,
                    assigneeId: String?
    ) async throws -> Issue {
        PreviewData.issues[1]
    }
}

@MainActor
struct IssueListViewModelTests {
    @Test("Load shows issues")
    func loadShowsIssues() async {
        let fake = FakeIssueService(result: .success(PreviewData.issues))
        let model = IssueListViewModel(service: fake)
        await model.load()
        #expect(model.issues.count == 2)
        #expect(model.state == .loaded)
    }
    @Test("Load failure shows a message")
    func loadFailureShowsMessage() async {
        let fake = FakeIssueService(result: .failure(FakeFailure()))
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
            type: IssueType.printerFailure,
            priority: IssueOptions.shared.defaultPriority)
        )
        #expect(fake.created.count == 1)
        #expect(model.issues.first?.id == PreviewData.issues[0].id)
    }
    @Test("A retry after failure recovers")
    func retryRecovers() async throws {
        let fake = FakeIssueService(result: .failure(FakeFailure()))
        let model = IssueListViewModel(service: fake)
        await model.load()
        fake.result = .success(PreviewData.issues)
        await model.load()
        #expect(model.state == .loaded)
    }
}

struct KotlinBridgeTests {
    @Test("A Kotlin error message reaches Swift with its messsage")
    func kotlinErrorKeepsItsMessage() {
        let body = #"{"error":{"code":"INVALID_TRANSITION","message":"Cannot move an issue from OPEN to RESOLVED","requestId":"r-1"}}"#
        let conflictResponse = ApiResponse(status: 409, body: body)
        let error = #expect(throws: (any Error).self) {
            _ = try StoreFlowResponses.shared.issue(response: conflictResponse)
        }
        #expect(error?.localizedDescription == "Cannot move an issue from OPEN to RESOLVED")
    }
}
