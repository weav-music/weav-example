package io.weav.example.ui.run

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.weav.weavkit.*

// TODO (mani) - convert listener to an interface instead of having to subclass
class WorkoutModeControlListener: WeavRunWorkoutModeControlListener() {
    val currentIntervalTitle = MutableLiveData<String>()

    override fun executorCompleted() {}

    override fun executorIntervalChanged(
        fromInterval: WeavWorkoutInterval?,
        stats: RunningStageStats?,
        toInterval: WeavWorkoutInterval?) {
        currentIntervalTitle.postValue(if (toInterval != null) toInterval!!.title else "")
    }

    override fun executorIntervalLengthRemaining(lengthRemaining: Double, time: Boolean) {}

    override fun executorScoreCardRowAdded(
        info: WeavWorkoutScoreCardInfo?,
        scoreRow: WeavWorkoutScoreCardRow?) {}
}

class RunSessionViewModel : ViewModel(), WeavRunningSessionListener {
    val workoutModeControlListener = WorkoutModeControlListener()

    // START: WeavRunningSessionListener

    override fun cadenceUpdated(cadence: Double) {

    }

    override fun heartRateUpdated(heartRateBpm: Double) {

    }

    override fun runSpeedUpdated(speedMps: Double) {

    }

    override fun updateDistance(meters: Double, latitude: Double, longitude: Double) {

    }

    override fun updateLatitude(latitude: Double, longitude: Double) {

    }

    override fun timerTicked(timeElapsed: Double) {

    }

    override fun workoutStateChanged(isRunning: Boolean) {

    }

    override fun intervalTrainingCurrentIntervalTriggerEventsWithTime(time: Double) {

    }

    override fun splitPaceUpdated(mps: Double) {

    }
}