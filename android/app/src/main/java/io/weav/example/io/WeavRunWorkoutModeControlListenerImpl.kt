package io.weav.example.io

import android.os.Handler
import android.os.Looper
import android.widget.TextView
import io.weav.weavkit.*


class WeavRunWorkoutModeControlListenerImpl : WeavRunWorkoutModeControlListener {
    var currentIntervalText: TextView? = null
    var workoutPlan: WeavWorkoutPlan? = null
    var currentInterval = 0

    private fun postToUIThread(workToDo: () -> Unit){
        Handler(Looper.getMainLooper()).post(workToDo)
    }

    constructor(currentIntervalTextView: TextView?, workoutPlan: WeavWorkoutPlan?){
        postToUIThread {
            this.workoutPlan = workoutPlan
            currentIntervalText = currentIntervalTextView
            currentIntervalText?.text = this.workoutPlan?.intervals?.get(currentInterval)?.title
        }
    }

    override fun executorCompleted() {

    }

    override fun executorIntervalChanged(
        fromInterval: WeavWorkoutInterval?,
        stats: RunningStageStats?,
        toInterval: WeavWorkoutInterval?
    ) {
        postToUIThread {
            currentInterval++
            currentIntervalText?.text = toInterval?.title
        }
    }

    override fun executorIntervalLengthRemaining(lengthRemaining: Double, time: Boolean) {
    }

    override fun executorScoreCardRowAdded(
        info: WeavWorkoutScoreCardInfo?,
        scoreRow: WeavWorkoutScoreCardRow?
    ) {

    }

    override fun scheduleLegoLiteTransition(
        afterSeconds: Double,
        nextIntervalBpm: Double,
        rampDurationBeats: Double
    ): Double {
        return 3.0

    }
}