package com.storeflow.mobile.network

data class ApiRequest(
    val method: String,
    val path: String,
    val headers: Map<String, String>,
    val body: String?
)

data class ApiResponse(
    val status: Int,
    val body: String
)

class ApiException(
    val status: Int,
    val code: String,
    message: String,
    val requestId: String?,
) : Exception(message)

interface HttpTransport {
    suspend fun execute(request: ApiRequest): ApiResponse
}