package com.storeflow.mobile

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.compose.ui.tooling.preview.Preview
import com.storeflow.mobile.network.AndroidHttpTransport
import com.storeflow.mobile.network.StoreFlowClient

private const val API_BASE_URL = "http://10.0.2.2:8787"

class MainActivity : ComponentActivity() {
    private val client = StoreFlowClient(AndroidHttpTransport(API_BASE_URL))
    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)

        setContent { App(client) }
    }
}