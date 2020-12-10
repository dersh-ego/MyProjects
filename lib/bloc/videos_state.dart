part of 'videos_bloc.dart';

abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object> get props => [];
}

class VideosInitial extends VideosState {}

class VideosFailure extends VideosState {}

class VideosSuccess extends VideosState {
  final VideosList videosList;
  final List<VideoItem> videos;

  VideosSuccess({this.videos, this.videosList});

  @override
  List<Object> get props => [videosList, videos];
}
