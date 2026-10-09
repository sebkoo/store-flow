//
//  IssueListView.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import SwiftUI
import StoreFlowShared

struct IssueListView: View {
    @State private var model: IssueListViewModel
    @State private var isCreating = false
    
    init(model: IssueListViewModel? = nil) {
        _model = State(initialValue: model ?? IssueListViewModel())
    }
    
    var body: some View {
        NavigationStack {
            List(model.issues, id: \.id) { issue in
                NavigationLink {
                    IssueDetailView(issue: issue) { target in
                        try await model.transition(issue,
                                                   to: target,
                                                   assigneeId: assignee(for: target))
                    }
                } label: {
                    IssueRow(issue: issue)
                }
            }
            .overlay {
                switch model.state {
                case .loaded where model.issues.isEmpty:
                    ProgressView("Loading issues...")
                case .failed(let message):
                    ContentUnavailableView(
                        "Could not load issues",
                        systemImage: "wifi.exclamationmark",
                        description: Text(message)
                    )
                case .loaded where model.issues.isEmpty:
                    ContentUnavailableView(
                        "No issues",
                        systemImage: "checkmark.seal"
                    )
                default:
                    EmptyView()
                }
            }
            .navigationTitle("Store issues")
            .toolbar {
                Button("New issue", systemImage: "plus") {
                    isCreating = true
                }
            }
            .sheet(isPresented: $isCreating) {
                CreateIssueView(onCreate: model.create)
            }
            .task { await model.load() }
            .refreshable { await model.load() }
        }
    }
    
    private func assignee(for target: IssueStatus) -> String? {
        target == .assigned ? AppConfig.demoAssigneeId : nil
    }
}

struct IssueRow: View {
    let issue: Issue
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(issue.title)
                .font(.headline)
            HStack(spacing: 8) {
                Text(issue.status.name)
                    .font(.caption.bold())
                    .padding(.horizontal, 6)
                    .background(.blue.opacity(0.15), in: Capsule())
                Text(issue.priority.name)
                    .font(.caption)
                Text(issue.type.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    IssueListView(model: IssueListViewModel(
        service: PreviewIssueService())
    )
}
