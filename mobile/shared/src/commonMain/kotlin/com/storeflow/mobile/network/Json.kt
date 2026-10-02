package com.storeflow.mobile.network

import kotlinx.serialization.json.Json

internal val storeFlowJson: Json = Json {
    ignoreUnknownKeys = true
    explicitNulls = false
}