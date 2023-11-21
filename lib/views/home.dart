import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/const/color.dart';
import 'package:music_player/const/text_style.dart';
import 'package:music_player/controller/player_controller.dart';
import 'package:music_player/views/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    PlayerController Ctrl = Get.put(PlayerController());

    return Scaffold(
        backgroundColor: bgDarkColor,
        appBar: AppBar(
          backgroundColor: bgDarkColor,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: whiteColor,
                ))
          ],
          leading: const Icon(
            Icons.sort_rounded,
            color: whiteColor,
          ),
          title: Text(
            "Beat",
            style: ourStyle(),
          ),
        ),
        body: FutureBuilder<List<SongModel>>(
          future: Ctrl.audioQuery.querySongs(
              ignoreCase: true,
              orderType: OrderType.ASC_OR_SMALLER,
              sortType: null,
              uriType: UriType.EXTERNAL),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No song found',
                  strutStyle: ourStyle(),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: bgColor,
                          title: Text(
                            '${snapshot.data?[index].displayNameWOExt}',
                            style: ourStyle(size: 15),
                          ),
                          subtitle: Text(
                            'atist name',
                            style: ourStyle(size: 12),
                          ),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(
                              Icons.music_note,
                              color: whiteColor,
                            ),
                          ),
                          trailing: Ctrl.palyIndex.value == index &&
                                  Ctrl.isPlaying.value
                              ? const Icon(
                                  Icons.play_arrow,
                                  color: whiteColor,
                                )
                              : null,
                          onTap: () {
                            Ctrl.playSong(snapshot.data![index].uri, index);

                            Get.to(
                              () => MyPlayer(
                                data: snapshot.data!,
                              ),
                              transition: Transition.leftToRight,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}
