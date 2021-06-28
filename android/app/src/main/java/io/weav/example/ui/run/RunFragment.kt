package io.weav.example.ui.run

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import io.weav.example.R
import io.weav.weavkit.*
import java.io.File

class RunFragment : Fragment() {

    private lateinit var runViewModel: RunViewModel

    private var fileDir: File? = null
    private lateinit var bundlePath: String
    private lateinit var workoutPlanPath: String
    private lateinit var resourceBundlePath: String

    private lateinit var weavPromptSettings: WeavRunningPromptSettings
    private lateinit var config: WeavRunningSessionConfig

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        runViewModel =
                ViewModelProvider(this).get(RunViewModel::class.java)

        val root = inflater.inflate(R.layout.fragment_run, container, false)

        val context = requireContext()
        Thread{
            WeavSDK.initializeSDK(context)
            WeavKit.setupWithApiKey("weav-example-license-key")
        }.start()

        fileDir = getActivity()?.getExternalFilesDir(null)
        bundlePath = "${fileDir}/KellyRoberts_embedded.bundle";
        workoutPlanPath = "${fileDir}/KellyRoberts_400m_repeats.json"
        resourceBundlePath = "${fileDir}/kelly_roberts_400m_repeats_13"

        weavPromptSettings = WeavRunningPromptSettings.initWithDefaults()

        return root
    }
}
