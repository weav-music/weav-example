package io.weav.example.ui.run

import android.graphics.BitmapFactory
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import io.weav.example.R
import io.weav.weavkit.*
import java.io.BufferedInputStream
import java.io.File
import java.io.IOException
import java.io.InputStream
import java.net.URL
import java.net.URLConnection


class RunFragment : Fragment() {

    private lateinit var runViewModel: RunViewModel

    private var fileDir: File? = null
    private var thisView: View? = null
    private var container: ViewGroup? = null
    private lateinit var bundlePath: String
    private lateinit var resourceBundlePath: String

    private lateinit var weavPromptSettings: WeavRunningPromptSettings
    private lateinit var workoutPlan: WeavWorkoutPlan
    private lateinit var config: WeavRunningSessionConfig

    fun loadWorkoutPlan() {
        val uri = "${fileDir}/KellyRoberts_400m_repeats.json"
        Log.i("LOG-WK", "workout plan path: ${uri}")
        Thread {
            try {
                workoutPlan = WeavWorkoutPlan.createWithPath(uri, "KellyRoberts");
                val aURL = URL(workoutPlan.headerImageUrl)
                val conn: URLConnection = aURL.openConnection()
                conn.connect()
                val `is`: InputStream = conn.getInputStream()
                val bis = BufferedInputStream(`is`)
                val bmp = BitmapFactory.decodeStream(bis)
                bis.close()
                `is`.close()
                Handler(Looper.getMainLooper()).post {
                    thisView?.findViewById<ImageView>(R.id.instructor_image)?.setImageBitmap(bmp)
                    thisView?.findViewById<TextView>(R.id.text_load_workout_plan)?.visibility = View.GONE
                }
            } catch (e: IOException) {
                Log.e("LOG-WK", "Error getting instructor bitmap", e)
            }
        }.start()
    }

    fun startWorkoutWithoutMusic () {
        Log.i("LOG-WK", "hiding run fragment")
        val newSession = WorkoutNoMusicSessionFragment()
        newSession.setArgs(workoutPlan, fileDir)
        val t = parentFragmentManager.beginTransaction()
        t.hide(this)
        t.add(container!!.id, newSession)
        t.show(newSession)
        t.addToBackStack("Run-Stack")
        t.commit()
    }

    fun startRunWithoutMusic() {
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
        session.activateCadenceModeWithInitialCadence(12.0, false)
        Log.i("LOG-WK", "Run without Music Session session started")
    }

    fun startRunWithMusic() {
        val config = WeavRunningSessionConfig(
                "${fileDir}/KellyRoberts_embedded.bundle",
                "KellyRoberts",
                WeavDistanceUpdateSource.kDistanceUpdateSourceDefault,
                WeavCadenceUpdateSource.kCadenceUpdateSourceDefault,
                WeavHeartRateUpdateSource.kHeartRateUpdateSourceNone,
                WeavRpeMap.initWithDefaults(),
                WeavRunningPromptSettings.initWithDefaults(),
                WeavDistanceUnit.WeavDistanceUnitKilometer)
        val session = WeavKit.sessionManager().activateRunningWithMusicSessionWithConfig(config)
        session.activateCadenceModeWithInitialCadence(12.0, false)
        Log.i("LOG-WK", "Run with Music Session session started")
    }

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        this.container = container
        runViewModel =
                ViewModelProvider(this).get(RunViewModel::class.java)

        thisView = inflater.inflate(R.layout.fragment_run, container, false)

        val context = requireContext()
        Thread{
            Log.i("LOG-WK", "weavkit setup initialized")
            WeavSDK.initializeSDK(context)
            WeavKit.setupWithApiKey("weav-example-license-key")
            Log.i("LOG-WK", "weavkit setup completed")
        }.start()

        fileDir = activity?.getExternalFilesDir(null)

        weavPromptSettings = WeavRunningPromptSettings.initWithDefaults()
        if (fileDir != null) {
            thisView?.findViewById<TextView>(R.id.text_load_workout_plan)?.setOnClickListener { loadWorkoutPlan() }
            thisView?.findViewById<TextView>(R.id.text_start_workout_without_music)?.setOnClickListener { startWorkoutWithoutMusic() }
            thisView?.findViewById<TextView>(R.id.text_start_run_without_music)?.setOnClickListener { startRunWithoutMusic() }
            thisView?.findViewById<TextView>(R.id.text_start_run_with_music)?.setOnClickListener { startRunWithMusic() }
        }

        return thisView
    }
}
