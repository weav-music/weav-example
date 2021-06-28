package io.weav.example.ui.run

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import io.weav.example.Dispatch
import io.weav.example.R
import io.weav.example.databinding.FragmentRunSessionBinding
import io.weav.example.io.WeavMusicSessionListenerImpl
import io.weav.weavkit.*
import java.io.File

class RunSessionFragment : Fragment() {
    private lateinit var fileDir: File
    private lateinit var session: WeavRunningSession

    private var workoutPlan: WeavWorkoutPlan? = null
    private var weavMusicSessionListener: WeavMusicSessionListener? = null

    companion object {
        fun newInstance() = RunSessionFragment()
    }

    lateinit var viewModel: RunSessionViewModel
        private set

    private fun toggleWorkout() {
        val isWorkoutRunning = (session as WeavRunningSession).isWorkoutRunning
        val hasWorkoutStarted = (session as WeavRunningSession).hasWorkoutStarted()

        if (!hasWorkoutStarted) {
            session?.startWorkout()
        } else if (!isWorkoutRunning) {
            session?.resumeWorkout()
        } else {
            session?.pauseWorkout()
        }

        Dispatch.ui {
            view?.findViewById<TextView>(R.id.startWorkoutButton)?.text  = if (isWorkoutRunning)  "Resume workout" else "Pause workout"
        }

    }

    private fun toggleMusic() {
        val session = this.session as? WeavRunningWithMusicSession
        if (session == null) {
            return
        }

        if (session!!.isMusicPlaying) {
            session.pauseMusic()
        } else {
            session.resumeMusic()
        }
    }

    internal fun setArgs(session: WeavRunningSession, fileDir: File, workoutPlan: WeavWorkoutPlan?) {
        this.session = session
        this.fileDir = fileDir
        this.workoutPlan = workoutPlan
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        if (session is WeavRunningWithMusicSession){
            (session as WeavRunningWithMusicSession).addMusicSessionListener(weavMusicSessionListener)
            (session as WeavRunningWithMusicSession).setPlaylistWithId(SupportingFileInfo.playlistId)
        }

        if (workoutPlan != null){
            (session as WeavRunningSession).activateWorkoutPlanModeWithWorkoutPlan(workoutPlan,
                "${fileDir}/${SupportingFileInfo.workoutBundlePath}",
                viewModel.workoutModeControlListener
            )
        } else {
            (session as WeavRunningSession).activateCadenceModeWithInitialCadence(120.0, false)
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val binding = FragmentRunSessionBinding.inflate(inflater, container, false)

        binding.musicControlsLayout.visibility = if (session is WeavRunningWithMusicSession) View.VISIBLE else View.INVISIBLE
        binding.textCurrentInterval.visibility = if (workoutPlan != null) View.VISIBLE else View.INVISIBLE

        binding.startWorkoutButton.setOnClickListener {
            Dispatch.background {
                toggleWorkout()
            }
        }

        binding.playPauseToggleButton.setOnClickListener {
            Dispatch.background {
                toggleMusic()
            }
        }

        binding.nextSongButton.setOnClickListener {
            Dispatch.background {
                (session as? WeavRunningWithMusicSession)?.nextSong()
            }
        }

        binding.previousSongButton.setOnClickListener {
            Dispatch.background {
                (session as? WeavRunningWithMusicSession)?.prevSong()
            }
        }
        
        // TODO (mani) - use view model
        weavMusicSessionListener = WeavMusicSessionListenerImpl(
            binding.bpmSeekBar,
            binding.coverArtImageView,
            binding.songTitleTextView,
            binding.songArtistTextView,
            binding.playPauseToggleButton
        )
        viewModel = ViewModelProvider(this).get(RunSessionViewModel::class.java)
        viewModel.workoutModeControlListener.currentIntervalTitle.observe(viewLifecycleOwner, Observer {
            binding.textCurrentInterval.text = it
        })

        return binding.root
    }

    override fun onDestroyView() {
        super.onDestroyView()
        session?.stop()
        session?.terminate()
        WeavKit.sessionManager().deactivateSession()
    }
}