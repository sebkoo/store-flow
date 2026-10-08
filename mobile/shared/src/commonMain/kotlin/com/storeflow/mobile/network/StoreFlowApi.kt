package com.storeflow.mobile.network

import com.storeflow.mobile.model.CreateIssueRequest
import com.storeflow.mobile.model.Issue
import com.storeflow.mobile.model.IssueList
import com.storeflow.mobile.model.TransitionRequest
import kotlinx.serialization.KSerializer
import kotlinx.serialization.Serializable

object StoreFlowRequests {
    fun listIssues(token: String?): ApiRequest = request(
        "GET",
        "/v1/issues",
        token
    )
    fun createIssue(token: String?, body: CreateIssueRequest): ApiRequest = request(
        "POST",
        "/v1/issue",
        token,
        storeFlowJson.encodeToString(
            CreateIssueRequest.serializer(),
            body
        )
    )
    fun getIssue(token: String?, issueId: String): ApiRequest = request(
        "GET",
        "/v1/issues/$issueId",
        token
    )
    fun transitionIssue(token: String?, issueId: String, body: TransitionRequest): ApiRequest = request(
        "POST",
        "/v1/issues/$issueId/transition",
        token,
        storeFlowJson.encodeToString(
            TransitionRequest.serializer(),
            body
        )
    )
    internal fun request(method: String,
                         path: String,
                         token: String?,
                         body: String? = null
    ): ApiRequest {
        val headers = buildMap {
            put("Accept", "application/json")
            if (body  != null) put("Content-Type", "application/json")
            if (token != null) put("Authorization", "Bearer $token")
        }
        return ApiRequest(method, path, headers, body)
    }
}
object StoreFlowResponses {
    @Throws(Exception::class)
    fun issues(response: ApiResponse): List<Issue> =
        decode(response, IssueList.serializer()).items

    @Throws(Exception::class)
    fun issue(response: ApiResponse): Issue = decode(response, Issue.serializer())

    internal fun <T> decode(response: ApiResponse, serializer: KSerializer<T>): T {
        if (response.status !in 200..299) throw toException(response)
        return storeFlowJson.decodeFromString(
        serializer,
        response.body
        )
    }
    fun toException(response: ApiResponse): ApiException {
        val envelope = runCatching {
            storeFlowJson.decodeFromString(
            ErrorEnvelope.serializer(),
            response.body)
        }.getOrNull()
        return if (envelope != null) {
            ApiException(response.status,
                envelope.error.code,
                envelope.error.message,
                envelope.error.requestId
            )
        } else {
            ApiException(response.status,
                "UNREADABLE_RESPONSE",
                "The server answered ${response.status} in an unexpected format.", null
            )
        }
    }
}
@Serializable
internal data class ErrorEnvelope(val error: ErrorBody)
@Serializable
internal data class ErrorBody(
    val code: String,
    val message: String,
    val requestId: String? = null
)