//
//  Issue.swift
//  StoreFlow
//
//  Created by Ben Koo on 9/30/26.
//

import Foundation

struct Issue: Codable, Identifiable, Hashable {
    let id: String
    let storeId: String
    let title: String
    let type: String
    let priority: String
    let status: String
    let assigneeId: String?
    let createdAt: String
    let updatedAt: String
}

struct IssueList: Codable {
    let items: [Issue]
}

struct CreateIssueRequest: Codable {
    let title: String
    let type: String
    let priority: String
}

struct APIErrorBody: Codable {
    struct Detail: Codable {
        let code: String
        let message: String
        let requestId: String?
    }
    let erorr: Detail
}

extension Issue {
    static let samples: [Issue] = [
        Issue(id: "0b8f6a4e-0000-4000-8000-000000000001",
              storeId: "store-001",
              title: "Scanner broken at register 2",
              type: "SCANNER_BROKEN",
              priority: "HIGH",
              status: "OPEN",
              assigneeId: nil,
              createdAt: "2026-09-25T09:00:00Z",
              updatedAt: "2026-09-25T09:00:00Z"
        ),
        Issue(id: "0b8f6a4e-0000-4000-8000-000000000002",
              storeId: "store-001",
              title: "Pickup shelf full",
              type: "SHELF_FULL",
              priority: "NORMAL",
              status: "ASSIGNED",
              assigneeId: "7d2f5a0e-3c11-4b6a-9e43-2b8f0c6a1d55",
              createdAt: "2026-09-25T09:05:00Z",
              updatedAt: "2026-09-25T09:20:00Z"
        ),
    ]
}
