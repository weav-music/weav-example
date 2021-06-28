package io.weav.example.ui.run
import android.os.Handler
import android.os.HandlerThread
import android.os.Looper
import java.util.concurrent.CountDownLatch

internal class Background : Runnable {
    private val latch: CountDownLatch = CountDownLatch(1)
    var handler: Handler? = null

    override fun run() {
        Looper.prepare()
        val handlerThread = HandlerThread("BackgroundThread")
        handlerThread.start()
        handler = Handler(handlerThread.looper)
        latch.countDown()
        Looper.loop()
    }

    init {
        val thread = Thread(this)
        thread.start()
        try {
            latch.await()
        } catch (e: InterruptedException) {
            /// e.printStackTrace();
        }
    }
}