//
//  CreateIssueView.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import SwiftUI
import StoreFlowShared

struct CreateIssueView: View {
    let onCreate: (CreateIssueRequest) async throws -> Void
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var type: IssueType = IssueOptions.shared.types[0]
    @State private var priority: IssuePriority = IssueOptions.shared.defaultPriority
    @State private var errorMessage: String?
    @State private var isSaving = false

    private var titleError: String? {
        IssueValidator.shared.titleError(title: title)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("What is wrong?") {
                    TextField("Title", text: $title)
                    if let titleError,
                       !title.isEmpty {
                        Text(titleError)
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                }
                Section("Details") {
                    Picker("Type", selection: $type) {
                        ForEach(IssueOptions.shared.types, id: \.self) {
                            Text($0.name).tag($0)
                        }
                    }
                    Picker("Priority", selection: $priority) {
                        ForEach(IssueOptions.shared.priorities, id: \.self) {
                            Text($0.name).tag($0)
                        }
                    }
                }
                if let errorMessage {
                    Section { Text(errorMessage).foregroundStyle(.red) }
                }
            }
            .navigationTitle("New issue")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { Task { await save() } }
                        .disabled(titleError != nil || isSaving)
                }
            }
        }
    }
    
    private func save() async {
        isSaving = true
        defer { isSaving = false }
        do {
            let request = CreateIssueRequest(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                type: type,
                priority: priority)
            try await onCreate(request)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    CreateIssueView(onCreate: { _ in })
}
