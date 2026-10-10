package com.storeflow.mobile.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.storeflow.mobile.model.Issue
import com.storeflow.mobile.model.IssueStatus
import com.storeflow.mobile.rules.IssueStateMachine

@Composable
fun IssueListScreen(
    viewModel: IssueListViewModel,
    onCreate: () -> Unit,
    demoAssigneeId: String
) {
    val state by viewModel.state.collectAsState()
    LaunchedEffect(Unit) { viewModel.load() }
    IssueListContent(
        state = state,
        onCreate = onCreate,
        onRetry = viewModel::load,
        onMove = { issue, target -> viewModel.transition(
            issue,
            target,
            if (target == IssueStatus.ASSIGNED)
                demoAssigneeId else null
            )
        }
    )
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun IssueListContent(
    state: IssueListUiState,
    onCreate: () -> Unit,
    onRetry: () -> Unit,
    onMove: (Issue, IssueStatus) -> Unit,
) {
    Scaffold(topBar = { TopAppBar(
        title = { Text("Store issues") },
        actions = { TextButton(onCreate) { Text("New") } }
    ) }) { padding ->
        Box(Modifier.padding(padding).fillMaxSize()) {
            when {
                state.isLoading && state.issues.isEmpty()
                    -> CircularProgressIndicator(Modifier.align(Alignment.Center))
                state.errorMessage != null && state.issues.isEmpty()
                    -> Column(Modifier.align(Alignment.Center).padding(24.dp)) {
                    Text("Could not load issues", style = MaterialTheme.typography.titleMedium)
                    Text(state.errorMessage ?: "")
                    Button(onRetry) { Text("Try again") }
                }
                else -> LazyColumn(Modifier.fillMaxSize()) {
                    items(state.issues, key = { it.id }) { issue ->
                        IssueRow(issue,{ target -> onMove(issue, target) })
                        HorizontalDivider()
                    }
                }
            }
        }
    }
}

@Composable
private fun IssueRow(issue: Issue, onMove: (IssueStatus) -> Unit) {
    Column(Modifier.fillMaxWidth().padding(16.dp)) {
        Text(issue.title, style = MaterialTheme.typography.titleMedium)
        Text("${issue.status.name} · ${issue.priority.name} · ${issue.type.name}",
            style = MaterialTheme.typography.bodySmall)
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            IssueStateMachine.allowedNext(issue.status).forEach { target ->
                TextButton({ onMove(target) }) {
                    Text(IssueStateMachine.actionLabel(target))
                }
            }
        }
    }
}

@Composable
private fun IssueListSample(state: IssueListUiState) {
    MaterialTheme { IssueListContent(state,
        onCreate = {},
        onRetry = {},
        onMove = { _, _ -> })
    }
}

@Preview
@Composable
private fun IssueListPreview() {
    IssueListSample(IssueListUiState(issues = PreviewData.issues))
}

@Preview
@Composable
private fun IssueListLoadingPreview() {
    IssueListSample(IssueListUiState(isLoading = true))
}

@Preview
@Composable
private fun IssueListErrorPreview() {
    IssueListSample(IssueListUiState(errorMessage = "Sample: the API did not answer"))
}