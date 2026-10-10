package com.storeflow.mobile.network

import com.storeflow.mobile.model.CreateIssueRequest
import com.storeflow.mobile.model.Issue
import com.storeflow.mobile.model.TransitionRequest

class StoreFlowClient(
    private val transport: HttpTransport,
    var token: String? = null
) {
    suspend fun listIssues(): List<Issue> = StoreFlowResponses.issues(
    transport.execute(
    StoreFlowRequests.listIssues(token)
    ))
    suspend fun createIssue(body: CreateIssueRequest): Issue = StoreFlowResponses.issue(
    transport.execute(
    StoreFlowRequests.createIssue(token, body)
    ))
    suspend fun transition(issueId: String, body: TransitionRequest): Issue = StoreFlowResponses.issue(
    transport.execute(
    StoreFlowRequests.transitionIssue(token, issueId, body)
    ))
}