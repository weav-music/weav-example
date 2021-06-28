package io.weav.example.ui.run

import androidx.appcompat.widget.LinearLayoutCompat

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import io.weav.example.R
import io.weav.example.io.WeavMusicSessionListenerImpl
import io.weav.example.io.WeavRunWorkoutModeControlListenerImpl
import io.weav.example.io.WeavRunningSessionListenerImpl
import io.weav.weavkit.*
import java.io.File

class SessionFragment : Fragment() {
    private var workoutPlan: WeavWorkoutPlan? = null
    private var fileDir: File? = null
    private var weavRunWorkoutModeControlListener: WeavRunWorkoutModeControlListenerImpl? = null
    private var weavRunningSessionListener: WeavRunningSessionListener? = null
    private var weavMusicSessionListener: WeavMusicSessionListener? = null
    private var currentIntervalTextView: TextView? = null
    private var workoutRunning = false
    private var workoutPaused = false
    private var session: WeavRunningSession? = null
    private var background: Background? = null

    private fun startStopWorkout() {
        if (!workoutRunning){
            background?.handler?.post {
                (session as WeavRunningSession).startWorkout()
            }
            workoutRunning = true
            view?.findViewById<TextView>(R.id.text_start_workout)?.text = "Pause Workout"
        } else if (!workoutPaused) {
            background?.handler?.post {
                (session as WeavRunningSession).pauseWorkout()
            }
            workoutPaused = true
            view?.findViewById<TextView>(R.id.text_start_workout)?.text = "Resume Workout"
        } else {
            background?.handler?.post {
                (session as WeavRunningSession).resumeWorkout()
            }
            workoutPaused = false
            view?.findViewById<TextView>(R.id.text_start_workout)?.text = "Pause Workout"
        }

    }

    private fun toggleMusic() {
        if ((weavMusicSessionListener as WeavMusicSessionListenerImpl).playing){
            (session as WeavRunningWithMusicSession).pauseMusic()
        } else {
            (session as WeavRunningWithMusicSession).resumeMusic()
        }
    }

    internal fun setArgs(session: WeavRunningSession, background: Background, fileDir: File, workoutPlan: WeavWorkoutPlan?) {
        this.session = session
        this.background = background
        this.fileDir = fileDir
        this.workoutPlan = workoutPlan
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        background?.handler?.post{
            // Connect up all the UI stuff
            view.findViewById<TextView>(R.id.text_start_workout)?.setOnClickListener { startStopWorkout() }
            view.findViewById<ImageView>(R.id.button_play_pause)?.setOnClickListener { toggleMusic() }
            view.findViewById<ImageView>(R.id.button_skip_next)?.setOnClickListener {
                background?.handler?.post {
                    (session as WeavRunningWithMusicSession).nextSong()
                }
            }
            view.findViewById<ImageView>(R.id.button_skip_previous)?.setOnClickListener {
                background?.handler?.post {
                    (session as WeavRunningWithMusicSession).prevSong()
                }
            }
            weavMusicSessionListener = WeavMusicSessionListenerImpl(
                view.findViewById(R.id.seek_bar)!!,
                view.findViewById(R.id.song_image)!!,
                view.findViewById(R.id.song_title)!!,
                view.findViewById(R.id.song_artist)!!,
                view.findViewById(R.id.button_play_pause)!!
            )
            weavRunningSessionListener = WeavRunningSessionListenerImpl()

            if (session is WeavRunningWithMusicSession){
                (session as WeavRunningWithMusicSession).addMusicSessionListener(weavMusicSessionListener)
                (session as WeavRunningWithMusicSession).setPlaylistWithId(SupportingFileInfo.playlistId)
            }

            if (workoutPlan != null){
                weavRunWorkoutModeControlListener =
                    WeavRunWorkoutModeControlListenerImpl(currentIntervalTextView, workoutPlan)
                (session as WeavRunningSession).activateWorkoutPlanModeWithWorkoutPlan(
                    workoutPlan,
                    "${fileDir}/${SupportingFileInfo.workoutBundlePath}",
                    weavRunWorkoutModeControlListener!!
                )
            } else {
                (session as WeavRunningSession).activateCadenceModeWithInitialCadence(120.0, false)
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        // Inflate the layout for this fragment
        val thisView = inflater.inflate(R.layout.fragment_session, container, false)

        // Only display relevant UI components
        thisView?.findViewById<LinearLayoutCompat>(R.id.music_controls)?.visibility = if (session is WeavRunningWithMusicSession) View.VISIBLE else View.INVISIBLE
        currentIntervalTextView = thisView?.findViewById(R.id.text_current_interval)
        currentIntervalTextView?.visibility = if (workoutPlan != null) View.VISIBLE else View.INVISIBLE

        return thisView
    }

    override fun onDestroyView() {
        super.onDestroyView()
        (session as WeavRunningSession).stop()
        (session as WeavRunningSession).terminate()
        WeavKit.sessionManager().deactivateSession()
    }
}