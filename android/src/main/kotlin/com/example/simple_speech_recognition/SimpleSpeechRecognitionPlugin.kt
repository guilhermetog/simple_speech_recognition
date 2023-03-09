package com.example.simple_speech_recognition

import android.content.Context
import android.content.Intent
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.annotation.NonNull
import com.example.speech_recognition.SpeechRecognitionListener

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class SimpleSpeechRecognitionPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var speechRecognizer: SpeechRecognizer
  private lateinit var speechRecognitionListener: SpeechRecognitionListener
  private lateinit var speechIntent: Intent

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "simple_speech_recognition")
    channel.setMethodCallHandler(this)
    configRecognizer(flutterPluginBinding.applicationContext)
    configRecognitionListener()
  }


  private fun configRecognizer(context: Context){
      speechRecognizer = SpeechRecognizer.createSpeechRecognizer(context)
  } 

  private fun configRecognitionListener(){
      speechRecognitionListener = SpeechRecognitionListener()
      speechRecognizer.setRecognitionListener(speechRecognitionListener)

      speechRecognitionListener.onCalledReadyForSpeech = {
          channel.invokeMethod("onReadyForSpeech", "")
      }

      speechRecognitionListener.onCalledResult = { result ->
          channel.invokeMethod("onResult", result)
      }

      speechRecognitionListener.onCalledNotPermitted = {
          channel.invokeMethod("onNotPermitted", "")
      }
      
      speechRecognitionListener.onCalledNotMatchAny = {
          channel.invokeMethod("onNotMatchAny", "")
      }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if(call.method == "recognizeSpeech") {
        val language:String? = call.argument("language")
        startRecognition(language ?: "en_US")
    }
  }

    private fun startRecognition(language:String){
        speechIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH)
        speechIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        speechIntent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, language)

        speechRecognizer.startListening(speechIntent)
    }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
