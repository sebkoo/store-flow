package com.storeflow.mobile.model

import kotlinx.serialization.Serializable

@Serializable
enum class IssueStatus {
    OPEN,
    ASSIGNED,
    IN_PROGRESS,
    RESOLVED,
}
@Serializable
enum class IssuePriority {
    LOW,
    NORMAL,
    HIGH
}
@Serializable
enum class IssueType {
    SCANNER_BROKEN,
    POS_OFFLINE,
    SHELF_FULL,
    LOW_INVENTORY,
    PRINTER_FAILURE,
    OTHER
}
@Serializable
data class Issue(
    val id: String,
    val storeId: String,
    val title: String,
    val type: IssueType,
    val priority: IssuePriority,
    val status: IssueStatus,
    val assigneeId: String? = null,
    val createdAt: String,
    val updatedAt: String,
)
@Serializable
data class IssueList(
    val items: List<Issue>
)
@Serializable
data class CreateIssueRequest(
    val title: String,
    val type: IssueType,
    val priority: IssuePriority
)
@Serializable
data class TransitionRequest(
    val to: IssueStatus,
    val assigneeId: String? = null
)