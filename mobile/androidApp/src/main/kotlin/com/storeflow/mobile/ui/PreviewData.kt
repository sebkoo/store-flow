package com.storeflow.mobile.ui

import com.storeflow.mobile.model.Issue
import com.storeflow.mobile.model.IssuePriority
import com.storeflow.mobile.model.IssueStatus
import com.storeflow.mobile.model.IssueType

object PreviewData {
    val issues = listOf(
        Issue(
            id = "0b8f6a4e-0000-4000-8000-000000000001",
            storeId = "store-001",
            title = "Scanner broken at register 2",
            type = IssueType.SCANNER_BROKEN,
            priority = IssuePriority.HIGH,
            status = IssueStatus.OPEN,
            createdAt = "2026-09-25T09:00:00Z",
            updatedAt = "2026-09-25T09:00:00Z",
        ),
        Issue(
            id = "0b8f6a4e-0000-4000-8000-000000000002",
            storeId = "store-001",
            title = "Pickup shelf full",
            type = IssueType.SHELF_FULL,
            priority = IssuePriority.NORMAL,
            status = IssueStatus.ASSIGNED,
            assigneeId = "7d2f5a0e-3c11-4b6a-9e43-2b8f0c6a1d55",
            createdAt = "2026-09-25T09:05:00Z",
            updatedAt = "2026-09-25T09:20:00Z",
        ),
    )
}