import 'package:bubu_playlist/models/video_list.dart';
import 'package:bubu_playlist/screens/video_player_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoItemWidget extends StatelessWidget {
  const VideoItemWidget(VideoItem e, {Key key, this.videoItem})
      : super(key: key);
  final VideoItem videoItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return VideoPlayerScreen(
              videoItem: videoItem,
            );
          }));
        },
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: videoItem.video.thumbnails.thumbnailsDefault.url,
            ),
            SizedBox(
              height: 5,
            ),
            Flexible(child: Text(videoItem.video.title)),
          ],
        ),
      ),
    );
  }
}
