package com.storeflow.mobile

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform