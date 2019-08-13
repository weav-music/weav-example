package io.weav.example;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Context;
import android.content.Intent;
import android.media.AudioManager;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.io.File;
import java.io.IOException;
import java.util.Locale;

import io.weav.PlayerConfig;
import io.weav.SongPlayer;
import io.weav.SystemConfig;

import static android.os.Environment.DIRECTORY_MUSIC;

public class MainActivity extends AppCompatActivity {
    private static final String TAG = "Weav: MainActivity";
    private TextView bpmTextView;

    static {
        System.loadLibrary("WeavAudioJNI");
    }

    private SongPlayer player;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        String samplerateString = null, buffersizeString = null;
        AudioManager audioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);
        if (audioManager != null) {
            samplerateString = audioManager.getProperty(AudioManager.PROPERTY_OUTPUT_SAMPLE_RATE);
            buffersizeString = audioManager.getProperty(AudioManager.PROPERTY_OUTPUT_FRAMES_PER_BUFFER);
        }
        if (samplerateString == null) samplerateString = "48000";
        if (buffersizeString == null) buffersizeString = "480";
        long samplerate = Long.parseLong(samplerateString);
        int buffersize = Integer.parseInt(buffersizeString);

        long queuedFramesHighWatermark = 16 * 1024;
        PlayerConfig playerConfig = new PlayerConfig(queuedFramesHighWatermark, buffersize);
        SystemConfig systemConfig = new SystemConfig(samplerate, 16);

        // NOTE - ensure song folder exists
        String songFolder = "io.weav.tracks.RunIt";
        player = new SongPlayer(systemConfig, playerConfig);
        player.open(MainActivity.getExternalStorageDirectory(this) + File.separator + songFolder);
        player.play();

        bpmTextView = (TextView)findViewById(R.id.bpmTextView);

        updateBpmTextView(player.getBpm());

        Button playPauseButton = (Button)findViewById(R.id.playPauseButton);
        Button increaseBpmButton = (Button)findViewById(R.id.increaseBpmButton);
        Button decreaseBpmButton = (Button)findViewById(R.id.decreaseBpmButton);

        playPauseButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (player.isPlaying()) {
                    player.pause();
                } else {
                    player.play();
                }
            }
        });

        increaseBpmButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                player.setBpm(player.getBpm() + 1);
                updateBpmTextView(player.getBpm());
            }
        });

        decreaseBpmButton.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v) {
                player.setBpm(player.getBpm() - 1);
                updateBpmTextView(player.getBpm());
            }
        });
    }

    void updateBpmTextView(double bpm) {
        int bpmi = (int) bpm;
        bpmTextView.setText(String.format(Locale.getDefault(), "%dbpm", bpmi));
    }

    static String getExternalStorageDirectory(Context context) {
        try {
            if (System.getenv().containsKey("EXTERNAL_STORAGE")) {
                return new File(System.getenv("EXTERNAL_STORAGE")).getCanonicalPath() + "/Android/data/io.weav.example/music";
            } else {
                return context.getExternalFilesDir(DIRECTORY_MUSIC).getCanonicalPath();
            }
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
}
