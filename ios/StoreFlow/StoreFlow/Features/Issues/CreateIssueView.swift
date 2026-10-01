//
//  CreateIssueView.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import SwiftUI

struct CreateIssueView: View {
    let onCreate: (CreateIssueRequest) async throws -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var type = "SCANNER_BROKEN"
    @State private var priority = "NORMAL"
    @State private var errorMessage: String?
    @State private var isSaving = false
    
    private let types = ["SCANNER_BROKEN",
                         "POS_OFFLINE",
                         "SHELF_FULL",
                         "LOW_INVENTORY",
                         "PRINTER_FAILURE",
                         "OTHER"]
    private let priorities = ["LOW",
                              "NORMAL",
                              "HIGH"]
    private var titleError: String? {
        let count = title.trimmingCharacters(in: .whitespacesAndNewlines).count
        if count < 3 { return "Title must be at least 3 characters" }
        if count > 120 { return "Title must be at most 120 characters" }
        return nil
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
                        ForEach(types, id: \.self) { Text($0) }
                    }
                    Picker("Priority", selection: $priority) {
                        ForEach(priorities, id: \.self) { Text($0) }
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
