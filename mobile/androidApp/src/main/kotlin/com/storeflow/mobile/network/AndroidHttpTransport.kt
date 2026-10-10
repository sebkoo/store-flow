package com.storeflow.mobile.network


import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.util.concurrent.TimeUnit

internal val storeFlowHttp: OkHttpClient = OkHttpClient.Builder()
    .connectTimeout(10, TimeUnit.SECONDS)
    .readTimeout(15, TimeUnit.SECONDS)
    .build()

class AndroidHttpTransport(private val baseUrl: String): HttpTransport {
    override suspend fun execute(request: ApiRequest): ApiResponse = withContext(Dispatchers.IO) {
        val body = request.body?.toRequestBody()
            ?: if (request.method == "GET") null
            else "".toRequestBody()
        val builder = Request.Builder().url(baseUrl + request.path).method(request.method, body)
        request.headers.forEach { name, value ->
            builder.header(name, value)
        }
        storeFlowHttp.newCall(builder.build()).execute().use { response ->
            ApiResponse(response.code, response.body.string())
        }
    }
}