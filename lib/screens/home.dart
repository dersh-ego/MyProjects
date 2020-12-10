import 'package:bubu_playlist/bloc/videos_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'video_player_screen.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController;
  VideosBloc videosBloc;
  @override
  void initState() {
    scrollController = ScrollController();
    videosBloc = BlocProvider.of(context);
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          // you are at top position
          videosBloc.add(VideosFetched());
          print('good');
        }
      }
    });
    super.initState();
  }

  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Упражнения для домашней работы – Логопеды Онлайн Bubulearn",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [searchBar.getSearchAction(context)]);
  }

  _HomeState() {
    searchBar = new SearchBar(
        hintText: 'Поиск',
        inBar: false,
        setState: setState,
        onSubmitted: (query) {
          videosBloc.add(VideosFetched(query: query, search: true));
        },
        buildDefaultAppBar: buildAppBar);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Scaffold(
      appBar: searchBar.build(context),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: BlocBuilder<VideosBloc, VideosState>(
                    builder: (context, state) {
                  if (state is VideosInitial) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is VideosFailure) {
                    return Center(
                      child: Text('Error'),
                    );
                  }
                  if (state is VideosSuccess) {
                    if (state.videos.length == 0) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.videos.length < 20) {
                      videosBloc.add(VideosFetched());
                    }
                    return Container(
                        child: GridView.count(
                      controller: scrollController,
                      crossAxisCount: 3,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 1,
                      children: [
                        ...state.videos.map((item) {
                          return Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)),
                            child: InkWell(
                              onTap: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return VideoPlayerScreen(
                                    videoItem: item,
                                  );
                                }));
                              },
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: item.video.thumbnails.medium.url,
                                  ),
                                  Flexible(
                                      child: Text(
                                    item.video.title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20),
                                  )),
                                ],
                              ),
                            ),
                          );
                        }).toList()
                      ],
                    ));
                  }
                  return Container();
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
