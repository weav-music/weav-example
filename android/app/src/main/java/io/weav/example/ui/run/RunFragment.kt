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
    private var session: SessionFragment? = null

    private lateinit var weavPromptSettings: WeavRunningPromptSettings
    private var workoutPlan: WeavWorkoutPlan? = null

    private var background = Background()

    fun loadWorkoutPlan() {
        background.handler?.post{
            try {
                Handler(Looper.getMainLooper()).post {
                    thisView?.findViewById<TextView>(R.id.text_load_workout_plan)?.visibility = View.GONE
                }
                workoutPlan = WeavWorkoutPlan.createWithPath("${fileDir}/${SupportingFileInfo.workoutPath}", SupportingFileInfo.workoutIdentifier);
                val aURL = URL(workoutPlan?.headerImageUrl)
                val conn: URLConnection = aURL.openConnection()
                conn.connect()
                val `is`: InputStream = conn.getInputStream()
                val bis = BufferedInputStream(`is`)
                val bmp = BitmapFactory.decodeStream(bis)
                bis.close()
                `is`.close()
                Handler(Looper.getMainLooper()).post {
                    thisView?.findViewById<ImageView>(R.id.instructor_image)?.setImageBitmap(bmp)
                }
            } catch (e: IOException) {
                Log.e("LOG-WK", "Error getting instructor bitmap", e)
            }
        }
    }

    private fun startSession(weavSession: WeavRunningSession, hasWorkout: Boolean){
        // Delete old session fragment if it exists
        if (session != null){
            val d = parentFragmentManager.beginTransaction()
            d.remove(session!!)
            d.commit()
        }

        session = SessionFragment()
        val t = parentFragmentManager.beginTransaction()
        session?.setArgs(weavSession, background, fileDir!!, if (hasWorkout) workoutPlan else null)
        t.hide(this)
        t.add(container!!.id, session!!)
        t.show(session!!)
        t.addToBackStack("Run-Stack")
        t.commit()
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

        fileDir = activity?.getExternalFilesDir(null)

        val context = requireContext()
        Log.i("LOG-WK", "weavkit setup initialized")
        WeavSDK.initializeSDK(context)
        WeavKit.setupWithApiKey("weav-example-license-key")
        Log.i("LOG-WK", "weavkit setup completed")
        WeavKit.loadLocalContentFromPath("${fileDir}/${SupportingFileInfo.songBundle}")

        // Init session
        val config = WeavRunningSessionConfig(
            "${fileDir}/${SupportingFileInfo.instructorBundlePath}",
            SupportingFileInfo.instructorBundleIdentifier,
            WeavDistanceUpdateSource.kDistanceUpdateSourceDefault,
            WeavCadenceUpdateSource.kCadenceUpdateSourceCustom,
            WeavHeartRateUpdateSource.kHeartRateUpdateSourceNone,
            WeavRpeMap.initWithDefaults(),
            WeavRunningPromptSettings.initWithDefaults(),
            WeavDistanceUnit.WeavDistanceUnitKilometer
        )

        weavPromptSettings = WeavRunningPromptSettings.initWithDefaults()
        if (fileDir != null) {
            thisView?.findViewById<TextView>(R.id.text_load_workout_plan)?.setOnClickListener { loadWorkoutPlan() }
            thisView?.findViewById<TextView>(R.id.text_start_workout_without_music)?.setOnClickListener { startSession(WeavKit.sessionManager().activateRunningSessionWithConfig(config), true) }
            thisView?.findViewById<TextView>(R.id.text_start_workout_with_music)?.setOnClickListener { startSession(WeavKit.sessionManager().activateRunningWithMusicSessionWithConfig(config), true) }
            thisView?.findViewById<TextView>(R.id.text_start_run_without_music)?.setOnClickListener { startSession(WeavKit.sessionManager().activateRunningSessionWithConfig(config), false) }
            thisView?.findViewById<TextView>(R.id.text_start_run_with_music)?.setOnClickListener { startSession(WeavKit.sessionManager().activateRunningWithMusicSessionWithConfig(config), false) }
        }
        return thisView
    }
}
