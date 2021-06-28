package io.weav.example.ui.run

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

class RunSetupViewModel : ViewModel() {

    private val _text = MutableLiveData<String>().apply {
        value = "This is run Fragment"
    }
    val text: LiveData<String> = _text
}