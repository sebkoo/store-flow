package com.storeflow.mobile

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.lifecycle.viewmodel.compose.viewModel
import com.storeflow.mobile.network.StoreFlowClient
import com.storeflow.mobile.ui.IssueListScreen
import com.storeflow.mobile.ui.IssueListViewModel

const val DEMO_ASSIGNEE_ID = "7d2f5a0e-3c11-4b6a-9e43-2b8f0c6a1d55"
@Composable
fun App(client: StoreFlowClient) {
    MaterialTheme {
        val viewModel = viewModel { IssueListViewModel(client) }
        var creating by remember { mutableStateOf(false) }
        IssueListScreen(viewModel,
        { creating = true },
        DEMO_ASSIGNEE_ID
        )
    }
}