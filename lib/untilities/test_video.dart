// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// An example of using the plugin, controlling lifecycle and playback of the
/// video.
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'theme.dart';

class test_video extends StatefulWidget {
  @override
  test_videoState createState() => test_videoState();
}

class test_videoState extends State<test_video> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String videoId = YoutubePlayer.convertUrlToId(
      "https://www.youtube.com/watch?v=c4xjJtfTXl0")!;
  // print(videoId); // BBAyRBTfsOU

  @override
  Widget build(BuildContext context) {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );

    return MaterialApp(
      color: whiteColor,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                // thumbnail: Image.network(
                //   "https://loremflickr.com/640/480",
                //   width: MediaQuery.of(context).size.width,
                //   height: MediaQuery.of(context).size.height,
                //   fit: BoxFit.fill,
                // ),
                showVideoProgressIndicator: true,
              ),
              builder: (context, player) {
                return Column(
                  children: [
                    // some widgets
                    player,
                    //some other widgets
                  ],
                );
              }),
        ),
      ),
    );
  }
}
