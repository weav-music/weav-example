package io.weav.example
import android.os.Looper
import androidx.core.os.HandlerCompat
import java.util.concurrent.Executor
import java.util.concurrent.Executors

internal object Dispatch {

    private val executor: Executor
    private val mainHandler = HandlerCompat.createAsync(Looper.getMainLooper())

    init {
        executor = Executors.newSingleThreadExecutor()
    }

    fun background(runnable: () -> Unit) {
        executor.execute(runnable)
    }

    fun ui(runnable: () -> Unit) {
        mainHandler.post(runnable)
    }
}