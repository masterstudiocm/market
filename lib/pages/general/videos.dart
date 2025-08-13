import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/image.dart';
import 'package:market/widgets/indicator.dart';
import 'package:market/widgets/notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/lightbox.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideosPage extends StatefulWidget {
  const VideosPage({super.key});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List videos = <dynamic>[];
  bool noVideos = false;
  String token = '';
  bool loadMore = false;

  Future<void> get() async {
    String url = '${App.domain}/api/video.php?action=get';
    if (token != '') {
      url = '$url&token=$token';
    }

    Map result = await httpRequest(url);
    final payload = result['payload'];

    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      loadMore = false;
      if (payload['status'] == 'success') {
        videos = videos + payload['result']['items'];
        if (payload['result']['nextPageToken'] != null) {
          token = payload['result']['nextPageToken'];
        } else {
          noVideos = true;
        }
      } else {
        noVideos = true;
      }
    });
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      token = '';
      videos = [];
    });
    get();
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: const Text('Videolar')),
      body: MsContainer(
        loading: loading,
        serverError: serverError,
        connectError: connectError,
        action: _refreshPage,
        child: (videos.isEmpty)
            ? MsNotify(heading: 'Heç bir məlumat tapılmadı.', action: _refreshPage)
            : ListView(
                children: <Widget>[
                  OrientationBuilder(
                    builder: (BuildContext context, Orientation orientation) {
                      return ListView.separated(
                        padding: const EdgeInsets.all(15.0).r,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: videos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              showDialog(
                                barrierColor: Colors.black.withValues(alpha: .9),
                                useSafeArea: (orientation == Orientation.portrait) ? true : false,
                                context: context,
                                builder: (BuildContext context) {
                                  return YoutubeVideoPlayer(id: videos[index]['id']['videoId']);
                                },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: MsImage(url: videos[index]['snippet']['thumbnails']['high']['url']),
                                  ),
                                ),
                                SizedBox(height: 15.0.r),
                                Text(
                                  videos[index]['snippet']['title'],
                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0.sp),
                                ),
                                SizedBox(height: 5.0.r),
                                Text(videos[index]['snippet']['publishTime'], style: TextStyle(color: Theme.of(context).colorScheme.grey4)),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 30.0.r);
                        },
                      );
                    },
                  ),
                  if (noVideos) ...<Widget>[const Text('Göstəriəcək başqa video yoxdur.', textAlign: TextAlign.center)] else ...<Widget>[
                    VisibilityDetector(
                      key: Key('visibility_detector_${videos.length}'),
                      child: const MsIndicator(),
                      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                        double visiblePercentage = visibilityInfo.visibleFraction * 100;
                        if (visiblePercentage == 100 && !loadMore) {
                          setState(() => loadMore = true);
                          get();
                        }
                      },
                    ),
                  ],
                  const SizedBox(height: 30.0),
                ],
              ),
      ),
    );
  }
}

class YoutubeVideoPlayer extends StatefulWidget {
  const YoutubeVideoPlayer({super.key, required this.id});

  final String id;

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.id,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MsLightbox(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[YoutubePlayer(backgroundColor: Colors.black, controller: _controller, aspectRatio: 16 / 9)],
        ),
      ),
    );
  }
}
