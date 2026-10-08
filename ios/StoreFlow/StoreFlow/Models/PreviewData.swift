//
//  PreviewData.swift
//  StoreFlow
//
//  Created by Ben Koo on 10/7/26.
//

import StoreFlowShared

enum PreviewData {
    static let issuesJSON = """
        { "items":[
            {
                "id":"0b8f6a4e-0000-4000-8000-000000000001",
                "storeId":"store-001",
                "title":"Scanner broken at register 2",
                "type":"SCANNER_BROKEN",
                "priority":"HIGH",
                "status":"OPEN",
                "assigneeId":null,
                "createdAt":"2026-09-25T09:00:00Z",
                "updatedAt":"2026-09-25T09:00:00Z"
            },
            {
                "id":"0b8f6a4e-0000-4000-8000-000000000002",
                "storeId":"store-001",
                "title":"Pickup shelf full",
                "type":"SHELF_FULL",
                "priority":"NORMAL",
                "status":"ASSIGNED",
                "assigneeId":"7d2f5a0e-3c11-4b6a-9e43-2b8f0c6a1d55",
                "createdAt":"2026-09-25T09:05:00Z",
                "updatedAt":"2026-09-25T09:20:00Z"
            }
        ]}
        """
    static var issues: [Issue] {
        // A broken fixture should fail loudly, so we use try! here (previews and tests only).
        try! StoreFlowResponses.shared.issues(response: ApiResponse(status: 200, body: issuesJSON))
    }
}
