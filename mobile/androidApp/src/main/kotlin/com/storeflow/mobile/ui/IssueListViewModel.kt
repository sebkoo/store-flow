package com.storeflow.mobile.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.storeflow.mobile.model.CreateIssueRequest
import com.storeflow.mobile.model.Issue
import com.storeflow.mobile.model.IssueStatus
import com.storeflow.mobile.model.TransitionRequest
import com.storeflow.mobile.network.StoreFlowClient
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import kotlin.coroutines.cancellation.CancellationException

data class IssueListUiState(
    val issues: List<Issue> = emptyList(),
    val isLoading: Boolean = false,
    val errorMessage: String? = null
)

class IssueListViewModel(private val client: StoreFlowClient): ViewModel() {
    private val _state = MutableStateFlow(IssueListUiState())
    val state: StateFlow<IssueListUiState> = _state.asStateFlow()

    fun load() {
        viewModelScope.launch {
            _state.update { it.copy(
                isLoading = true,
                errorMessage = null)
            }
            try {
                val issues = client.listIssues()
                _state.update { it.copy(
                    issues = issues,
                    isLoading = false)
                }
            } catch (e: CancellationException) {
                throw e
            } catch (e: Exception) {
                _state.update { it.copy(
                    isLoading = false,
                    errorMessage = e.message ?: "Something went wrong")
                }
            }
        }
    }
    suspend fun create(request: CreateIssueRequest) {
        val issue = client.createIssue(request)
        _state.update { it.copy(
            issues = listOf(issue) + it.issues)
        }
    }
    fun transition(issue: Issue,
                   to: IssueStatus,
                   assigneeId: String?
    ) {
        viewModelScope.launch {
            try {
                val updated = client.transition(
                issue.id,
                TransitionRequest(to, assigneeId)
                )
                _state.update { state -> state.copy(
                    issues = state.issues.map {
                        if (it.id == updated.id) updated else it }
                )}
            } catch (e: CancellationException) {
                throw e
            } catch (e: Exception) {
                _state.update { it.copy(
                    errorMessage = e.message)
                }
            }
        }
    }
}