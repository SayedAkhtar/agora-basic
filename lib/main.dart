import 'package:agora_voice_video/voice_call.dart';
import 'package:agora_voice_video/video_call.dart';
import 'package:flutter/material.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "Main Page",
      ),
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
  late TextEditingController _controller;
  late TextEditingController _tokenController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _tokenController = TextEditingController(
        text:
            "007eJxTYNjpfD7Jw4CjVsOM/dwCsYbl6ulH63S6Lic66K+/PdOqeYoCg7GJpYFhampairGZsUliUlJiYnKacZKlhUWSmYFlmoHBQ41fqQ2BjAwpU/YzMTJAIIjPyZBb6ZyRmJeXmsPAAABz4CCk");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Enter Channel Name',
            ),
            TextFormField(
              controller: _controller,
            ),
            const Text(
              'Enter Token',
            ),
            TextFormField(
              controller: _tokenController,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => VoiceCall(
                                channelName: _controller.text,
                                token: _tokenController.text,
                              )));
                },
                child: const Text("Audio Call")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => VideoCall(
                                channelName: _controller.text,
                                token: _tokenController.text,
                              )));
                },
                child: const Text("Video Call"))
          ],
        ),
      ),
    );
  }
}
