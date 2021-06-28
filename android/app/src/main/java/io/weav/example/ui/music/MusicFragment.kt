package io.weav.example.ui.music

import android.graphics.BitmapFactory
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import io.weav.example.Dispatch
import io.weav.example.R
import io.weav.example.ui.run.SupportingFileInfo
import io.weav.weavkit.*
import java.io.BufferedInputStream
import java.net.URL
import android.widget.SeekBar
import android.widget.SeekBar.OnSeekBarChangeListener
import io.weav.example.databinding.FragmentMusicBinding

class MusicFragment : Fragment() {

    private lateinit var musicViewModel: MusicViewModel
    
    private var session: WeavMusicSession? = null

    override fun onCreateView(
            inflater: LayoutInflater,
            container: ViewGroup?,
            savedInstanceState: Bundle?
    ): View? {
        musicViewModel = ViewModelProvider(this).get(MusicViewModel::class.java)

        val binding = FragmentMusicBinding.inflate(layoutInflater)

        binding.nextSongButton.setOnClickListener {
            Dispatch.background {
                getSession().nextSong()
            }
        }
        
        binding.previousSongButton.setOnClickListener {
            Dispatch.background {
                getSession().prevSong()
            }
        }

        binding.playPauseToggleButton.setOnClickListener {
            Dispatch.background {
                val session = getSession()
                if (session.isMusicPlaying) {
                    session.pauseMusic()
                } else {
                    session.resumeMusic()
                }
            }
        }

        musicViewModel.musicSessionListener.playerIsPlaying.observe(viewLifecycleOwner, Observer {
            if (it) {
                binding.playPauseToggleButton.setBackgroundResource(R.drawable.ic_baseline_pause_24)
                binding.bpmTextView.text = "${session?.currentBpm()?.toInt()} BPM"
            } else {
                binding.playPauseToggleButton.setBackgroundResource(R.drawable.ic_baseline_play_arrow_24dp)
            }
        })

        musicViewModel.musicSessionListener.song.observe(viewLifecycleOwner, Observer {
            binding.songTitleTextView.text = it.name
            binding.songArtistTextView.text = it.artist
            Dispatch.background {
                val connection = URL(it.coverArtImageUrl).openConnection()
                connection.connect()
                val inputStream = connection.getInputStream()
                val bufferedInputStream = BufferedInputStream(inputStream)
                val bmp = BitmapFactory.decodeStream(inputStream)
                Dispatch.ui {
                    binding.coverArtImageView.setImageBitmap(bmp)
                }
                bufferedInputStream.close()
                inputStream.close()
            }
        })

        binding.bpmTextView.text = "--- BPM"
        musicViewModel.musicSessionListener.playerBpm.observe(viewLifecycleOwner, Observer {
            binding.bpmTextView.text = "${it.toInt()} BPM"
        })

        binding.bpmSeekBar.setOnSeekBarChangeListener (object : OnSeekBarChangeListener {
            override fun onProgressChanged(seekBar: SeekBar, i: Int, b: Boolean) {

                // transition to bpm supports continuous bpm - however, seek bar is ints so for simplicity we keep it like this
                session?.transitionToBpm(i.toDouble(), 0, false)
            }

            override fun onStartTrackingTouch(seekBar: SeekBar?) {}
            override fun onStopTrackingTouch(seekBar: SeekBar?) {}
        })

        musicViewModel.musicSessionListener.song

        binding.coverArtImageView

        return binding.root
    }

    private fun getSession(): WeavMusicSession {
        if (session != null) {
            return session!!
        }
        session = WeavKit.sessionManager().activateMusicSession()
        session?.addMusicSessionListener(musicViewModel.musicSessionListener)
        session?.setPlaylistWithId(SupportingFileInfo.playlistId)
        return session!!
    }
}