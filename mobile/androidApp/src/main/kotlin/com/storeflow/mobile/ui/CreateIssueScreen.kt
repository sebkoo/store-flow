package com.storeflow.mobile.ui

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.FlowRow
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Button
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.saveable.Saver
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.storeflow.mobile.model.CreateIssueRequest
import com.storeflow.mobile.rules.IssueOptions
import com.storeflow.mobile.rules.IssueValidator
import kotlinx.coroutines.launch

@OptIn(ExperimentalStdlibApi::class)
@Composable
fun CreateIssueScreen(onSave: suspend (CreateIssueRequest) -> Unit,
                      onClose: () -> Unit
) {
    var title by remember { mutableStateOf("") }
    var type by remember { mutableStateOf(IssueOptions.defaultType) }
    var priority by remember { mutableStateOf(IssueOptions.defaultPriority) }
    var errorMessage by remember { mutableStateOf<String?>(null) }
    var saving by remember { mutableStateOf(false) }
    val scope = rememberCoroutineScope()
    val titleError = IssueValidator.titleError(title)

    Column(Modifier.fillMaxWidth().padding(16.dp),
        verticalArrangement = Arrangement.spacedBy(12.dp)
    ) {
        Text("New issue",
            style = MaterialTheme.typography.headlineSmall
        )
        OutlinedTextField(
            value = title,
            onValueChange = { title = it },
            label = { Text("Title") },
            isError = title.isNotEmpty() && titleError != null,
            supportingText = { if (title.isNotEmpty() && titleError != null) Text(titleError) },
            modifier = Modifier.fillMaxWidth()
        )
        Text("Type")
        FlowRow(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            IssueOptions.types.forEach { option -> FilterChip(
                    selected = option == type,
                    onClick = { type = option },
                    label = { Text(option.name) }
            )}
        }
        Text("Priority")
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            IssueOptions.priorities.forEach { option -> FilterChip(
                    selected = option == priority,
                    onClick = { priority = option },
                    label = { Text(option.name) }
            )}
        }
        errorMessage?.let { Text(it, color =
            MaterialTheme.colorScheme.error)
        }
        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
            TextButton(onClose) { Text("Cancel") }
            Button(
                enabled = titleError == null && !saving,
                onClick = { scope.launch {
                        saving = true
                        try {
                            onSave(CreateIssueRequest(title.trim(), type, priority))
                            onClose()
                        } catch (e: Exception) { errorMessage = e.message
                        } finally { saving = false }
                }},
            ) { Text("Save") }
        }
    }
}

@Preview(showBackground = true)
@Composable
private fun CreateIssuePreview() {
    MaterialTheme { CreateIssueScreen(
            onSave = {},
            onClose = {}
    )}
}