import 'dart:io';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:just_audio/just_audio.dart' as just_audio;
import 'package:flutter_sound/flutter_sound.dart' as flutter_sound;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class WebSocketChatPage extends StatefulWidget {
  const WebSocketChatPage({Key? key}) : super(key: key);

  @override
  State<WebSocketChatPage> createState() => _WebSocketChatPageState();
}

class _WebSocketChatPageState extends State<WebSocketChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final flutter_sound.FlutterSoundRecorder _recorder =
      flutter_sound.FlutterSoundRecorder();
  late WebSocketChannel _channel;
  late just_audio.AudioPlayer _audioPlayer;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _audioPlayer = just_audio.AudioPlayer();
    _initRecorder();

    _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.10:8765'));
    _channel.stream.listen((message) {
      if (message.contains('[AUDIO_BASE64]')) {
        final regex = RegExp(r'\[AUDIO_BASE64\](.+\.mp3)');
        final match = regex.firstMatch(message);
        if (match != null) {
          final audioUrl = 'http://192.168.1.10:8080/media/${match.group(1)}';
          _playAudio(audioUrl);
        }
      } else {
        setState(() {
          _messages.add({'sender': 'IA', 'message': message});
        });
      }
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add({'sender': 'Você', 'message': _controller.text});
      });
      _channel.sink.add(_controller.text);
      _controller.clear();
    }
  }

  void _playAudio(String url) async {
    print('Tentando tocar: $url');
    try {
      await _audioPlayer.stop();
      await _audioPlayer
          .setAudioSource(just_audio.AudioSource.uri(Uri.parse(url)));
      await _audioPlayer.play();
    } on just_audio.PlayerException catch (e) {
      print("Error code: ${e.code}");
      print("Error message: ${e.message}");
    } on just_audio.PlayerInterruptedException catch (e) {
      print("Connection aborted: ${e.message}");
    } catch (e) {
      print('An error occured: $e');
    }
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/audio_temp.aac';
    _recordedFilePath = filePath;
    await _recorder.startRecorder(
        toFile: filePath, codec: flutter_sound.Codec.aacMP4);
    setState(() => _isRecording = true);
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => _isRecording = false);
    if (_recordedFilePath != null) {
      _sendAudioFile(File(_recordedFilePath!));
    }
  }

  Future<void> _sendAudioFile(File audioFile) async {
    final uri = Uri.parse('http://192.168.1.10:8000/transcribe');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('file', audioFile.path));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      setState(() {
        _messages.add({'sender': 'Você', 'message': responseBody});
      });

      _channel.sink.add(responseBody);
    } else {
      print('Erro ao enviar o áudio: ${response.statusCode}');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _channel.sink.close(status.goingAway);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat com IA'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == 'Você';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message']!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Digite sua mensagem...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic,
                      color: Colors.red),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
