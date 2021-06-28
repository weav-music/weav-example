package io.weav.example.io

import android.graphics.BitmapFactory
import android.os.Handler
import android.os.Looper
import android.widget.Button
import android.widget.ImageView
import android.widget.SeekBar
import android.widget.TextView
import io.weav.example.R
import io.weav.weavkit.WeavMusicSessionListener
import io.weav.weavkit.WeavPlaylist
import io.weav.weavkit.WeavSong
import java.io.BufferedInputStream
import java.io.InputStream
import java.net.URL
import java.net.URLConnection

class WeavMusicSessionListenerImpl : WeavMusicSessionListener{
    private var seekBar: SeekBar
    private var songImage: ImageView
    private var songTitle: TextView
    private var songArtist: TextView
    private var playPauseButton: Button
    var playing: Boolean = false

    constructor(seekBar: SeekBar, songImage: ImageView, songTitle: TextView, songArtist: TextView, playPauseButton: Button) {
        this.seekBar = seekBar
        this.songImage = songImage
        this.songTitle = songTitle
        this.songArtist = songArtist
        this.playPauseButton = playPauseButton
    }

    private fun postToUIThread(workToDo: () -> Unit){
        Handler(Looper.getMainLooper()).post(workToDo)
    }

    override fun nowPlayingSong(song: WeavSong?, playlist: WeavPlaylist?) {
        val aURL = URL(song?.coverArtImageUrl)
        val conn: URLConnection = aURL.openConnection()
        conn.connect()
        val `is`: InputStream = conn.getInputStream()
        val bis = BufferedInputStream(`is`)
        val bmp = BitmapFactory.decodeStream(bis)
        bis.close()
        `is`.close()
        postToUIThread {
            songTitle.text = song?.name
            songArtist.text = song?.artist
            songImage.setImageBitmap(bmp)
        }
    }

    override fun playerStateChanged(isPlaying: Boolean) {
        this.playing = isPlaying
        if (isPlaying) {
            playPauseButton.setBackgroundResource(R.drawable.ic_baseline_pause_24)
        } else {
            playPauseButton.setBackgroundResource(R.drawable.ic_baseline_play_arrow_24dp)
        }
    }

    override fun playerBpmChanged(bpm: Double) {
    }

    override fun currentSongTimeElapsed(timeElapsed: Double) {
    }

    override fun nowPlayingSongProgress(elapsed: Double, total: Double) {
        postToUIThread {
            seekBar.progress = (Math.round((elapsed*100.0)/total)).toInt()
        }
    }
}