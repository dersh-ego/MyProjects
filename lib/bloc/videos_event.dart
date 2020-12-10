part of 'videos_bloc.dart';

abstract class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object> get props => [];
}

class VideosFetched extends VideosEvent {
  final String query;
  final bool search;

  VideosFetched({this.search = false, this.query});

  List<Object> get props => [query, search];
}
