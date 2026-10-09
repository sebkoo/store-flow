//
//  IssueDetailView.swift
//  StoreFlow
//
//  Created by Ben Koo on 10/8/26.
//

import SwiftUI
import StoreFlowShared

struct IssueDetailView: View {
    let issue: Issue
    let onTransition: (IssueStatus) async throws -> Void
    
    @State private var errorMessage: String?
    @State private var isWorking = false
    
    var body: some View {
        List {
            Section("Issue") {
                LabeledContent("Title", value: issue.title)
                LabeledContent("Status", value: issue.status.name)
                LabeledContent("Priority", value: issue.priority.name)
                LabeledContent("Type", value: issue.type.name)
            }
            Section("Actions") {
                let next = IssueStateMachine.shared.allowedNext(from: issue.status)
                if next.isEmpty {
                    Text("No further actions - this issue is resolved.")
                        .foregroundStyle(.secondary)
                }
                ForEach(next, id: \.self) { target in
                    Button(IssueStateMachine.shared.actionLabel(to: target)) {
                        Task { await run(target) }
                    }
                    .disabled(isWorking)
                }
            }
            if let errorMessage {
                Section { Text(errorMessage).foregroundStyle(.red) }
            }
        }
        .navigationTitle("Issue")
    }
    
    private func run(_ target: IssueStatus) async {
        isWorking = true
        defer { isWorking = false }
        do {
            try await onTransition(target)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview("Assigned issue") {
    NavigationStack {
        IssueDetailView(issue: PreviewData.issues[1],
                        onTransition: { _ in })
    }
}
