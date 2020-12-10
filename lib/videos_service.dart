import 'package:dio/dio.dart';
import 'models/video_list.dart';

class VideosService {
  static const CHANNEL_ID = 'UCL0kSPpZX5UsVx90v-oCCIw';
  static const _baseUrl = 'youtube.googleapis.com';
  static const String API_KEY = 'AIzaSyBGj_Duj__ivCxJ2ya3ilkVfEzX1ZSRlpE';

  Future<VideosList> getVideoList(
      {String playListId, String pageToken = ''}) async {
    var dio = Dio();
    var parameters = {
      'part': 'snippet',
      'playlistId': playListId,
      'maxResults': '20',
      'pageToken': pageToken,
      'key': API_KEY,
    };

    dio.options.contentType = 'application/json';
    var uri = Uri.https(
      _baseUrl,
      '/youtube/v3/playlistItems',
      parameters,
    );
    var response = await dio.get(uri.toString());
    if (response.statusCode == 200) {
      print(response.data);
      return VideosList.fromJson(response.data);
    } else {
      print('error');
    }
    return null;
  }
}
