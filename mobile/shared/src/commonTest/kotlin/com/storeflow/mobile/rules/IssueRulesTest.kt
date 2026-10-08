package com.storeflow.mobile.rules

import com.storeflow.mobile.model.IssueStatus.RESOLVED
import com.storeflow.mobile.model.IssueStatus.IN_PROGRESS
import com.storeflow.mobile.model.IssueStatus.ASSIGNED
import com.storeflow.mobile.model.IssueStatus.OPEN
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertNull
import kotlin.test.assertTrue

class IssueRulesTest {
    @Test
    fun allowsTheFourMoves() {
        listOf(
            OPEN to ASSIGNED,
            ASSIGNED to IN_PROGRESS,
            ASSIGNED to OPEN,
            IN_PROGRESS to RESOLVED,
        ).forEach { (from, to) -> assertTrue(
    IssueStateMachine.canTransition(from, to),
    "$from -> $to should be allowed")
        }
    }
    @Test
    fun resolvedIsFinal() = assertEquals(
    emptyList(),
    IssueStateMachine.allowedNext(RESOLVED),
    )
    @Test
    fun titleRuleMatchesTheServer() {
        assertEquals(
        "Title must be at least 3 characters",
        IssueValidator.titleError(" no ")
        )
        assertNull(IssueValidator.titleError("Scanner broken"))
        assertEquals(
            "Title must be at most 120 characters",
            IssueValidator.titleError("x".repeat(121))
        )
    }
}