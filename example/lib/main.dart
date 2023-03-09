import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_speech_recognition/simple_speech_recognition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SimpleSpeechRecognition? speechRecognition;
  String _text = '';

  @override
  void initState() {
    super.initState();
    speechRecognition = SimpleSpeechRecognition();
    speechRecognition!.onBeginningOfSpeech =
        () => _updateText("comecou a falar");
    speechRecognition!.onVolumeChange =
        (volume) => _updateText("volume $volume");
    speechRecognition!.onEndOfSpeech = () => _updateText("terminou de falar");
  }

  void recognize() async {
    if (!(await Permission.speech.isGranted)) {
      await Permission.speech.request();
      recognize();
    } else {
      initRecognition();
    }
  }

  void initRecognition() async {
    try {
      String result = await speechRecognition!.recognize("pt_BR");
      _updateText(result);
    } on SpeechRecognitionNotMatchException {
      _updateText("Não reconheci");
    } on SpeechRecognitionAudioException {
      _updateText("Sem audio");
    } on SpeechRecognitionBusyException {
      _updateText("estou ocupado");
    } on SpeechRecognitionClientException {
      _updateText("falha no client");
    } on SpeechRecognitionNetworkException {
      _updateText("falha na rede");
    } on SpeechRecognitionNetworkTimoutException {
      _updateText("tempo de rede expirou");
    } on SpeechRecognitionNoPermissionException {
      _updateText("sem permissão");
    } on SpeechRecognitionServerExcpetion {
      _updateText("falha no servidor");
    } on SpeechRecognitionSpeechTimeoutException {
      _updateText("tempo de fala expirou");
    } on SpeechRecognitionUnknownException {
      _updateText("falha desconhecida");
    }
  }

  _updateText(String text) {
    setState(() {
      _text = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Texto:'),
            Text(
              _text,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: recognize,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
