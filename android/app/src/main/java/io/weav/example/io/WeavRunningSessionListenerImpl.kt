package io.weav.example.io

import io.weav.weavkit.WeavRunningSessionListener

class WeavRunningSessionListenerImpl : WeavRunningSessionListener {
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