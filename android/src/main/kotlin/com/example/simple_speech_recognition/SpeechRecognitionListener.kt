package com.example.speech_recognition

import android.annotation.TargetApi
import android.os.Build
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.SpeechRecognizer

@TargetApi(Build.VERSION_CODES.FROYO)
class SpeechRecognitionListener: RecognitionListener{

    //Flow
    var onCalledReadyForSpeech:()->Unit = {}
    var onCalledBeginningOfSpeech:()->Unit = {}
    var onCalledVolumeChange:(volume:Float)->Unit = {}
    var onCalledEndOfSpeech:()->Unit = {}
    var onCalledResult:(result:String)->Unit = {}

    //Errors
    var onCalledAudioError:()->Unit = {}
    var onCalledNotPermitted:()->Unit = {}
    var onCalledNetworkError:()->Unit = {}
    var onCalledNetworkTimeout:()->Unit = {}
    var onCalledClientError:()->Unit = {}
    var onCalledServerError:()->Unit = {}
    var onCalledBusy:()->Unit = {}
    var onCalledNotMatchAny:()->Unit = {}
    var onCalledSpeechTimeout:()->Unit = {}
    var onCalledUnknownError:()->Unit = {}

    override fun onReadyForSpeech(p0: Bundle?) {
        onCalledReadyForSpeech()
    }

    override fun onBeginningOfSpeech() {
        onCalledBeginningOfSpeech()
    }

    override fun onRmsChanged(volume: Float) {
        onCalledVolumeChange(volume)
    }

    override fun onBufferReceived(p0: ByteArray?) {
        TODO("Not yet implemented")
    }

    override fun onEndOfSpeech() {
       onCalledEndOfSpeech()
    }

    override fun onError(error: Int) {
        when (error) {
            SpeechRecognizer.ERROR_AUDIO -> {
                onCalledAudioError()
            }
            SpeechRecognizer.ERROR_CLIENT -> {
                onCalledClientError()
            }
            SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> {
                onCalledNotPermitted()
            }
            SpeechRecognizer.ERROR_NETWORK -> {
                onCalledNetworkError()
            }
            SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> {
                onCalledNetworkTimeout()
            }
            SpeechRecognizer.ERROR_NO_MATCH -> {
                onCalledNotMatchAny()
            }
            SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> {
                onCalledBusy()
            }
            SpeechRecognizer.ERROR_SERVER -> {
                onCalledServerError()
            }
            SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> {
                onCalledSpeechTimeout()
            }
            else -> {
                onCalledUnknownError()
            }
        }
    }

    override fun onResults(bundle: Bundle?) {
        val matches = bundle?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)

        if(!matches.isNullOrEmpty()){
            onCalledResult(matches[0])
        }
    }

    override fun onPartialResults(p0: Bundle?) {
        TODO("Not yet implemented")
    }

    override fun onEvent(p0: Int, p1: Bundle?) {
        TODO("Not yet implemented")
    }

}