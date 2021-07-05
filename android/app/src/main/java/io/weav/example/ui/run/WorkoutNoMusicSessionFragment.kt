package io.weav.example.ui.run

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import io.weav.example.R
import io.weav.example.io.WeavRunWorkoutModeControlDelegateImpl
import io.weav.weavkit.*
import java.io.File


/**
 * A simple [Fragment] subclass.
 * Use the [WorkoutNoMusicSessionFragment.newInstance] factory method to
 * create an instance of this fragment.
 */
class WorkoutNoMusicSessionFragment : Fragment() {
    private var workoutPlan: WeavWorkoutPlan? = null
    private var fileDir: File? = null
    private var weavRunWorkoutModeControlDelgate: WeavRunWorkoutModeControlDelegateImpl? = null
    private var currentIntervalTextView: TextView? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    fun startWorkout() {
        val config = WeavRunningSessionConfig(
            "${fileDir}/KellyRoberts_embedded.bundle",
            "KellyRoberts",
            WeavDistanceUpdateSource.kDistanceUpdateSourceDefault,
            WeavCadenceUpdateSource.kCadenceUpdateSourceDefault,
            WeavHeartRateUpdateSource.kHeartRateUpdateSourceNone,
            WeavRpeMap.initWithDefaults(),
            WeavRunningPromptSettings.initWithDefaults(),
            WeavDistanceUnit.WeavDistanceUnitKilometer)
        val session = WeavKit.sessionManager().activateRunningSessionWithConfig(config)
        weavRunWorkoutModeControlDelgate = WeavRunWorkoutModeControlDelegateImpl(currentIntervalTextView!!, workoutPlan!!)
        session.activateWorkoutPlanModeWithWorkoutPlan(workoutPlan, "${fileDir}/KellyRoberts_embedded.bundle", weavRunWorkoutModeControlDelgate!!)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val thisView = inflater.inflate(R.layout.fragment_session, container, false)

        thisView?.findViewById<TextView>(R.id.text_start_workout)?.setOnClickListener { startWorkout() }
        currentIntervalTextView = thisView?.findViewById<TextView>(R.id.text_current_interval)
        return thisView
    }

    public fun setArgs(workoutPlan: WeavWorkoutPlan, fileDir: File?) {
        this.workoutPlan = workoutPlan
        this.fileDir = fileDir
    }
}