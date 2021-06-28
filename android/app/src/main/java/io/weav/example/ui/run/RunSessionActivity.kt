package io.weav.example.ui.run

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import io.weav.weavkit.*
import android.view.Menu
import android.view.MenuItem
import io.weav.example.R

class RunSessionActivity : AppCompatActivity() {

    companion object {
        const val EnableMusicIntentExtra = "enableMusic"
        const val ExecuteWorkoutPlanIntentExtra = "executeWorkoutPlan"
    }

    private var session: WeavRunningSession? = null

    // keep a reference to prompt settings, as they can be modified during a session
    private var promptSettings = WeavRunningPromptSettings.initWithDefaults()
    private var workoutPlan: WeavWorkoutPlan? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_run_session)
        if (savedInstanceState == null) {
            val intent = getIntent()
            val fragment = RunSessionFragment.newInstance()

            val enableMusic = intent.getBooleanExtra(EnableMusicIntentExtra, true)

            session = if (enableMusic) {
                WeavKit.sessionManager().activateRunningWithMusicSessionWithConfig(makeConfig())
            } else {
                WeavKit.sessionManager().activateRunningSessionWithConfig(makeConfig())
            }

            val executeWorkoutPlan = intent.getBooleanExtra(ExecuteWorkoutPlanIntentExtra, false)
            val fileDir = getExternalFilesDir(null)
            if (executeWorkoutPlan) {
                workoutPlan = WeavWorkoutPlan.createWithPath("${fileDir}/${SupportingFileInfo.workoutPath}", SupportingFileInfo.workoutIdentifier)
            }
            
            fragment.setArgs(session!!, fileDir!!, workoutPlan)

            supportFragmentManager.beginTransaction()
                .replace(R.id.container, fragment)
                .commitNow()
        }
    }

    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
        menuInflater.inflate(R.menu.done_button_nav_menu, menu)
        return true
    }

    // handle button activities
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.doneButtonNavItem) {
            finish()
        }
        return super.onOptionsItemSelected(item)
    }

    override fun onDestroy() {
        super.onDestroy()
        session?.terminate()
        session = null
    }

    private fun makeConfig(): WeavRunningSessionConfig {
        val fileDir = getExternalFilesDir(null)
        return WeavRunningSessionConfig(
            "${fileDir}/${SupportingFileInfo.instructorBundlePath}",
            SupportingFileInfo.instructorBundleIdentifier,
            WeavDistanceUpdateSource.kDistanceUpdateSourceDefault,
            WeavCadenceUpdateSource.kCadenceUpdateSourceCustom,
            WeavHeartRateUpdateSource.kHeartRateUpdateSourceNone,
            WeavRpeMap.initWithDefaults(),
            promptSettings!!,
            WeavDistanceUnit.WeavDistanceUnitKilometer
        )
    }
}