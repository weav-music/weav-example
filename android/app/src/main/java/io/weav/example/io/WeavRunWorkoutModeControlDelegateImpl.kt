package io.weav.example.io

import android.os.Handler
import android.os.Looper
import android.widget.TextView
import io.weav.example.R
import io.weav.example.ui.run.WorkoutNoMusicSessionFragment
import io.weav.weavkit.WeavRunWorkoutModeControlDelegate
import io.weav.weavkit.WeavWorkoutPlan

class WeavRunWorkoutModeControlDelegateImpl : WeavRunWorkoutModeControlDelegate {
    var currentIntervalText: TextView
    var workoutPlan: WeavWorkoutPlan
    var currentInterval = 0

    private fun postToUIThread(workToDo: () -> Unit){
        Handler(Looper.getMainLooper()).post(workToDo)
    }

    constructor(currentIntervalTextView: TextView, workoutPlan: WeavWorkoutPlan){
        this.workoutPlan = workoutPlan
        currentIntervalText = currentIntervalTextView
        currentIntervalText.text = workoutPlan.intervals[currentInterval].title
    }

    override fun executorCompleted() {
    }

    override fun executorIntervalLengthRemaining(length: Double, time: Boolean) {
    }

    override fun executorIntervalChanged() {
        currentInterval++
        currentIntervalText.text = workoutPlan.intervals[currentInterval].title
    }

    override fun executorScoreCardRowAdded() {
    }

    override fun scheduleLegoLiteTransition(): Double {
        return 3.0
    }}