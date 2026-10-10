package com.storeflow.mobile.network

import com.storeflow.mobile.model.CreateIssueRequest
import com.storeflow.mobile.model.IssuePriority
import com.storeflow.mobile.model.IssueType
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertNull

class StoreFlowApiTest {
    @Test
    fun buildsTheListRequestWithoutAToken() {
        val request = StoreFlowRequests.listIssues(token = null)
        assertEquals("GET", request.method)
        assertEquals("/v1/issues", request.path)
        assertNull(request.headers["Authorization"])
    }
    @Test
    fun buildsTheCreateRequestWithJsonBody() {
        val request = StoreFlowRequests.createIssue(
            null,
            CreateIssueRequest(
                "Printer jam",
                IssueType.PRINTER_FAILURE,
                IssuePriority.NORMAL
            )
        )
        assertEquals("POST", request.method)
        assertEquals("/v1/issues", request.path)
        assertEquals(
            "application/json",
            request.headers["Content-Type"]
        )
        assertEquals(
            """{"title":"Printer jam","type":"PRINTER_FAILURE","priority":"NORMAL"}""",
            request.body
        )
    }
    @Test
    fun buildsTheGetRequest() {
        val request = StoreFlowRequests.getIssue(token = null,"abc")
        assertEquals("/v1/issues/abc",request.path)
    }
    @Test
    fun turnsTheErrorEnvelopeIntoAnApiException() {
        val body = """{"error":{"code":"INVALID_TRANSITION","message":"Cannot move an issue from OPEN to RESOLVED","requestId":"r-1"}}"""
        val error = assertFailsWith<ApiException> {
            StoreFlowResponses.issues(ApiResponse(409, body))
        }
        assertEquals(
            "INVALID_TRANSITION",
            error.code
        )
        assertEquals(
            "Cannot move an issue from OPEN to RESOLVED",
            error.message
        )
        assertEquals(
            "r-1",
            error.requestId
        )
    }
    @Test
    fun explainsResponsesThatAreNotOurEnvelope() {
        val error = assertFailsWith<ApiException> {
            StoreFlowResponses.issues(
                ApiResponse(502,
                    "<html>Bad Gateway</html>")
            )
        }
        assertEquals(
            "UNREADABLE_RESPONSE",
            error.code
        )
    }
}