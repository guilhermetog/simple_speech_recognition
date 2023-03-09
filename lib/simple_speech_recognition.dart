import 'dart:async';

import 'package:flutter/services.dart';

class SimpleSpeechRecognition {
  final MethodChannel _channel =
      const MethodChannel('simple_speech_recognition');

  void Function()? onReadyForSpeech;
  void Function()? onBeginningOfSpeech;
  void Function(double)? onVolumeChange;
  void Function()? onEndOfSpeech;

  Completer<String>? completer;

  SimpleSpeechRecognition({
    this.onReadyForSpeech,
    this.onBeginningOfSpeech,
    this.onVolumeChange,
    this.onEndOfSpeech,
  }) {
    _channel.setMethodCallHandler(_callbackHandler);
  }

  Future<String> recognize(String language) async {
    completer = Completer();
    _channel.invokeMethod('recognizeSpeech', {"language": language});
    return completer!.future;
  }

  Future<void> _callbackHandler(MethodCall call) async {
    switch (call.method) {
      case "onReadyForSpeech":
        if (onReadyForSpeech != null) {
          onReadyForSpeech!();
        }
        break;
      case "onBeginningOfSpeech":
        if (onBeginningOfSpeech != null) {
          onBeginningOfSpeech!();
        }
        break;
      case "onVolumeChange":
        if (onVolumeChange != null) {
          final double volume = call.arguments;
          onVolumeChange!(volume);
        }
        break;
      case "onEndOfSpeech":
        if (onEndOfSpeech != null) {
          onEndOfSpeech!();
        }
        break;
      case "onResult":
        if (completer != null) {
          final String text = call.arguments;
          completer!.complete(text);
        }
        break;
      case "onAudioError":
        completer!.completeError(SpeechRecognitionAudioException());
        break;
      case "onNotPermitted":
        completer!.completeError(SpeechRecognitionNoPermissionException());
        break;
      case "onNetworkError":
        completer!.completeError(SpeechRecognitionNetworkException());
        break;
      case "onNetworkTimeout":
        completer!.completeError(SpeechRecognitionNetworkTimoutException());
        break;
      case "onClientError":
        completer!.completeError(SpeechRecognitionClientException());
        break;
      case "onServerError":
        completer!.completeError(SpeechRecognitionServerExcpetion());
        break;
      case "onBusy":
        completer!.completeError(SpeechRecognitionBusyException());
        break;
      case "onNotMatchAny":
        completer!.completeError(SpeechRecognitionNotMatchException());
        break;
      case "onSpeechTimeout":
        completer!.completeError(SpeechRecognitionSpeechTimeoutException());
        break;
      case "onUnknownError":
        completer!.completeError(SpeechRecognitionUnknownException());
        break;
      default:
        completer!.completeError(SpeechRecognitionUnknownException());
        break;
    }
  }
}

class SpeechRecognitionAudioException implements Exception {}

class SpeechRecognitionNoPermissionException implements Exception {}

class SpeechRecognitionNetworkException implements Exception {}

class SpeechRecognitionNetworkTimoutException implements Exception {}

class SpeechRecognitionClientException implements Exception {}

class SpeechRecognitionServerExcpetion implements Exception {}

class SpeechRecognitionBusyException implements Exception {}

class SpeechRecognitionNotMatchException implements Exception {}

class SpeechRecognitionSpeechTimeoutException implements Exception {}

class SpeechRecognitionUnknownException implements Exception {}
