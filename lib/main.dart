import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  // late BetterPlayerController _betterPlayerController;
  //
  // @override
  // void initState() {
  //   BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
  //     BetterPlayerDataSourceType.network,
  //     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  //     subtitles: [
  //       BetterPlayerSubtitlesSource(
  //         type: BetterPlayerSubtitlesSourceType.network,
  //         name: "EN",
  //         urls: [
  //           "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt"
  //         ],
  //       ),
  //       BetterPlayerSubtitlesSource(
  //         type: BetterPlayerSubtitlesSourceType.network,
  //         name: "DE",
  //         urls: [
  //           "https://dl.dropboxusercontent.com/s/71nzjo2ux3evxqk/example_subtitles.srt"
  //         ],
  //       ),
  //     ],
  //   );
  //
  //   _betterPlayerController = BetterPlayerController(
  //       const BetterPlayerConfiguration(),
  //       betterPlayerDataSource: betterPlayerDataSource,
  //   );
  //   super.initState();
  // }
  //
  // @override
  // Widget build(BuildContext context) {
  //   return AspectRatio(
  //     aspectRatio: 9 / 9,
  //     child: BetterPlayer(
  //       controller: _betterPlayerController,
  //     ),
  //   );
  // }



  late BetterPlayerController _betterPlayerController;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final byteData = await rootBundle.load("assets/my_output_with2.mp4");

    final file = File("${(await getTemporaryDirectory()).path}/my_output_with2.mp4");
    await file.writeAsBytes(byteData.buffer.asUint8List());

    setState(() {
      _filePath = file.path;
      _setupVideoPlayer();
    });
  }

  void _setupVideoPlayer() {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      // _filePath!,
      // "https://d2jl6e4h8300i8.cloudfront.net/netflix_meridian/4k-18.5!9/keyos-logo/g180-avc_a2.0-vbr-aac-128k/r30/dash-wv-pr/video/avc1/9/seg-4.m4s",
      // "https://cdn.bitmovin.com/content/assets/art-of-motion-dash-hls-progressive/mpds/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.mpd",
      // "https://storage.googleapis.com/shaka-demo-assets/angel-one/dash.mpd",
      // 'https://dash.akamaized.net/dash264/TestCases/1c/1/manifest.mpd',
      // 'https://cdn.mozilla.net/media/marionette/test-video/video.mp4',
      // 'https://cdn.bitmovin.com/content/assets/big_buck_bunny/big_buck_bunny.mpd',
      // "https://cdn.bitmovin.com/content/assets/sintel/sintel.mpd",
      // "https://cdn.bitmovin.com/content/assets/sintel/hls/playlist.m3u8",
      "https://cdn.futurenation.gov.bd:5002/static/develop/2024-12-2/2f9b4cf2-9b10-4a98-a8c7-c812277ad608/master.m3u8",
      // "http://192.168.13.211:8001/static/ext2/master.m3u8",
      // "https://drive.google.com/uc?id=1WX-ZGQ0fJiYvphL4dhgD2PPB1FzQw0RR",
      useAsmsSubtitles: true,
      useAsmsTracks: true,
      useAsmsAudioTracks: true,
    );

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        autoPlay: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          enableSubtitles: true,
          enableAudioTracks: true,
        ),
      ),
      betterPlayerDataSource: dataSource,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Local Video Player")),
      body: Center(
        // Show loading indicator while the video file is being prepared
        child: _filePath == null
            ? const CircularProgressIndicator()
            : AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(controller: _betterPlayerController),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

}
