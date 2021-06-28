package io.weav.example.ui.run

import android.graphics.BitmapFactory
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import io.weav.example.Dispatch
import io.weav.example.R
import io.weav.example.databinding.FragmentRunSetupBinding
import io.weav.weavkit.*
import java.io.BufferedInputStream
import java.io.File
import java.io.IOException
import java.net.URL
import java.net.URLConnection
import android.content.Intent

class RunSetupFragment : Fragment() {

    private lateinit var runSetupViewModel: RunSetupViewModel

    private var container: ViewGroup? = null

    private fun startSession(enableMusic: Boolean, executeWorkoutPlan: Boolean){
        val intent = Intent(activity, RunSessionActivity::class.java)
        intent.putExtra(RunSessionActivity.EnableMusicIntentExtra, enableMusic)
        intent.putExtra(RunSessionActivity.ExecuteWorkoutPlanIntentExtra, executeWorkoutPlan)
        startActivity(intent)
    }

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        this.container = container
        runSetupViewModel = ViewModelProvider(this).get(RunSetupViewModel::class.java)

        val binding = FragmentRunSetupBinding.inflate(inflater, container, false)

        binding.startRunWithMusicButton.setOnClickListener {
            startSession(true, false)
        }
        binding.startRunWithoutMusicButton.setOnClickListener {
            startSession(false, false)
        }
        binding.startWorkoutPlanWithMusicButton.setOnClickListener {
            startSession(true, true)
        }
        binding.startWorkoutPlanWithoutMusicButton.setOnClickListener {
            startSession(false, true)
        }
        return binding.root
    }
}
