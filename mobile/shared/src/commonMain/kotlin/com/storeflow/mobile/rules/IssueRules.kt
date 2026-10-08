package com.storeflow.mobile.rules

import com.storeflow.mobile.model.IssuePriority
import com.storeflow.mobile.model.IssueStatus
import com.storeflow.mobile.model.IssueType

object IssueStateMachine {
    fun allowedNext(from: IssueStatus): List<IssueStatus> = when (from) {
        IssueStatus.OPEN        -> listOf(IssueStatus.ASSIGNED)
        IssueStatus.ASSIGNED    -> listOf(IssueStatus.IN_PROGRESS, IssueStatus.OPEN)
        IssueStatus.IN_PROGRESS -> listOf(IssueStatus.RESOLVED)
        IssueStatus.RESOLVED    -> emptyList()
    }
    fun canTransition(from: IssueStatus, to: IssueStatus): Boolean = to in allowedNext(from)
    fun actionLabel(to: IssueStatus): String = when (to) {
        IssueStatus.ASSIGNED    -> "Assign"
        IssueStatus.IN_PROGRESS -> "Start work"
        IssueStatus.RESOLVED    -> "Resolve"
        IssueStatus.OPEN        -> "Unassign"
    }
    fun canEdit(status: IssueStatus): Boolean = when (status) {
        IssueStatus.OPEN     -> true
        IssueStatus.ASSIGNED -> true
        else -> false
    }
}
object IssueValidator {
    const val TITLE_MIN = 3
    const val TITLE_MAX = 120

    fun titleError(title: String): String? {
        val length = title.trim().length
        return when {
            length < TITLE_MIN -> "Title must be at least $TITLE_MIN characters"
            length > TITLE_MAX -> "Title must be at most $TITLE_MAX characters"
            else -> null
        }
    }
}
object IssueOptions {
    val types: List<IssueType>          = IssueType.entries
    val priorities: List<IssuePriority> = IssuePriority.entries
    val defaultType: IssueType = IssueType.SCANNER_BROKEN
    val defaultPriority: IssuePriority  = IssuePriority.NORMAL
}