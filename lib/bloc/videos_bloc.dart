import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bubu_playlist/models/video_list.dart';
import 'package:bubu_playlist/videos_service.dart'; //bubu_playlist - почему bubu? Разве здесь есть логика привязанная к проекту?
import 'package:equatable/equatable.dart';

part 'videos_event.dart';
part 'videos_state.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  VideosBloc({this.videosService}) : super(VideosInitial());
  final VideosService videosService;
  String query = '';

  @override
  Stream<VideosState> mapEventToState(
    VideosEvent event,
  ) async* {
    dynamic currentState = state;
    if (event is VideosFetched) {
      try {
        if (currentState is VideosInitial) {
          final videoList = await videosService.getVideoList(
              playListId: 'PLpv0AkznBN1frh6QzauYaVa9PL6P7UJK2'); //Почему не параметр или константа?
          yield VideosSuccess(videosList: videoList, videos: videoList.videos);
        }

        if ((currentState is VideosSuccess &&
                currentState.videosList.nextPageToken != null) ||
            (currentState is VideosSuccess && event.search)) {
          if (event.search) {
            currentState.videos.clear();
            currentState.videosList.nextPageToken = null;
            query = event.query;
          }
          final videosList = await videosService.getVideoList(
              playListId: 'PLpv0AkznBN1frh6QzauYaVa9PL6P7UJK2', //Почему не параметр или константа?
              pageToken: currentState.videosList.nextPageToken);
          yield VideosSuccess(
              videosList: videosList,
              videos: currentState.videos +
                  (query == '' //Очень громоздко. Почему не написать условие в разделе where? query == '' || element.video.title.contains(query)
                      ? videosList.videos
                      : videosList.videos
                          .where(
                              (element) => element.video.title.contains(query))
                          .toList()));
        }
      } catch (e) {
        yield VideosFailure();
      }
    }
  }
}
