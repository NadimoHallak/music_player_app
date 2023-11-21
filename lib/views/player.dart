import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/color.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MyPlayer extends StatelessWidget {
  MyPlayer({super.key, required this.data});
  final List<SongModel> data;
  final ctrl = Get.find<PlayerController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(),
      body: Column(children: [
        Expanded(
          flex: 5,
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            width: 250,
            height: 250,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: QueryArtworkWidget(
              id: data[ctrl.palyIndex.value].id,
              type: ArtworkType.AUDIO,
              artworkHeight: double.infinity,
              artworkWidth: double.infinity,
              nullArtworkWidget: const Icon(
                Icons.music_off,
                color: whiteColor,
                size: 50,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => Text(
                      data[ctrl.palyIndex.value].displayNameWOExt,
                      style: ourStyle(size: 22, color: Colors.black),
                    ),
                  ),
                  Obx(
                    () => Text(
                      data[ctrl.palyIndex.value].artist!,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Obx(
                    () => Row(
                      children: [
                        Text(
                          ctrl.position.value,
                          style: ourStyle(color: bgColor),
                        ),
                        Expanded(
                          child: Slider(
                            value: ctrl.value.value,
                            min:
                                const Duration(seconds: 0).inSeconds.toDouble(),
                            max: ctrl.max.value,
                            onChanged: (newvalue) {
                              ctrl.changeDurationToSecondes(newvalue.toInt());
                              newvalue = newvalue;
                            },
                            thumbColor: slideColor,
                            inactiveColor: bgColor,
                            activeColor: slideColor,
                          ),
                        ),
                        Text(
                          ctrl.duration.value,
                          style: ourStyle(color: bgColor),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (ctrl.palyIndex.value - 1 < data.length) {
                            ctrl.palyIndex.value = data.length - 1;
                            ctrl.playSong(data[ctrl.palyIndex.value].uri,
                                ctrl.palyIndex.value);
                          } else {
                            ctrl.playSong(data[ctrl.palyIndex.value - 1].uri,
                                ctrl.palyIndex.value - 1);
                          }
                        },
                        icon: const Icon(
                          Icons.skip_previous_rounded,
                          size: 40,
                        ),
                      ),
                      Obx(
                        () => CircleAvatar(
                          backgroundColor: bgColor,
                          radius: 35,
                          child: Transform.scale(
                            scale: 2.5,
                            child: IconButton(
                              onPressed: () {
                                if (ctrl.isPlaying.value) {
                                  ctrl.audioPlayer.pause();
                                  ctrl.isPlaying(false);
                                } else {
                                  ctrl.audioPlayer.play();
                                  ctrl.isPlaying(true);
                                }
                              },
                              icon: Icon(
                                ctrl.isPlaying.value
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (ctrl.palyIndex.value + 1 > data.length) {
                            ctrl.palyIndex.value = 0;
                            ctrl.playSong(data[ctrl.palyIndex.value].uri,
                                ctrl.palyIndex.value);
                          } else {
                            ctrl.playSong(data[ctrl.palyIndex.value + 1].uri,
                                ctrl.palyIndex.value + 1);
                          }
                        },
                        icon: const Icon(
                          Icons.skip_next_rounded,
                          size: 40,
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ]),
    );
  }
}
