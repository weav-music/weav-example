package io.weav.example.ui.music

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import io.weav.weavkit.WeavMusicSessionListener
import io.weav.weavkit.WeavPlaylist
import io.weav.weavkit.WeavSong

class MusicSessionListenerImpl: WeavMusicSessionListener {
    val song = MutableLiveData<WeavSong>()
    val playerIsPlaying = MutableLiveData<Boolean>()
    val playerBpm = MutableLiveData<Double>()
    val songProgress = MutableLiveData<Int>()

    override fun nowPlayingSong(song: WeavSong?, playlist: WeavPlaylist?) {
        if (song != null) {
            this.song.postValue(song!!)
        }
    }

    override fun playerStateChanged(isPlaying: Boolean) {
        playerIsPlaying.postValue(isPlaying)
    }

    override fun playerBpmChanged(bpm: Double) {
        playerBpm.postValue(bpm)
    }

    override fun nowPlayingSongProgress(elapsed: Double, total: Double) {
        songProgress.postValue((Math.round((elapsed*100.0)/total)).toInt())
    }

    override fun currentSongTimeElapsed(timeElapsed: Double) {

    }
}

class MusicViewModel : ViewModel() {
    val musicSessionListener = MusicSessionListenerImpl()
}