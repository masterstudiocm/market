import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/posts/single_post_item.dart';
import 'package:market/controllers/post_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/indicator.dart';
import 'package:flutter/material.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  bool loading = true;
  bool serverError = false;
  bool connectError = false;
  List posts = [];
  bool noPosts = false;
  int limit = 10;
  int offset = 0;
  bool loadMore = false;

  final PostController postController = PostController();

  void get() async {
    Map result = await postController.getPosts(limit: limit, offset: offset);
    setStateSafe(() {
      loading = false;
      loadMore = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      posts = posts + result['posts'];
      noPosts = result['noPosts'];
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  void _refreshPage() {
    setState(() {
      loading = true;
      offset = 0;
      posts = [];
    });
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MsAppBar(title: Text('Xəbər və yeniliklər')),
      body: SafeArea(
        bottom: true,
        child: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: _refreshPage,
          child: (posts.isEmpty)
              ? SimpleNotify(text: 'Heç bir xəbər və ya yenilik tapılmadı.')
              : GridView.builder(
                  padding: const EdgeInsets.all(20.0).r,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isTablet(context) ? 2 : 1, // tablet üçün 2 sütun, telefon üçün 1
                    crossAxisSpacing: 20.r,
                    mainAxisSpacing: 20.r,
                    childAspectRatio: 1, // istəyə görə dəyiş
                  ),
                  itemCount: posts.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == posts.length) {
                      if (noPosts) {
                        return const Center(child: Text('Göstəriləcək başqa xəbər yoxdur.'));
                      } else if (posts.length < limit) {
                        return const SizedBox();
                      } else {
                        return VisibilityDetector(
                          key: Key('visibility_detector_${posts.length}'),
                          onVisibilityChanged: (visibilityInfo) {
                            var visiblePercentage = visibilityInfo.visibleFraction * 100;
                            if (visiblePercentage == 100 && !loadMore) {
                              setState(() {
                                loadMore = true;
                                offset = offset + limit;
                              });
                              get();
                            }
                          },
                          child: const MsIndicator(),
                        );
                      }
                    } else {
                      return SinglePostItem(data: posts[index]);
                    }
                  },
                ),
        ),
      ),
    );
  }
}
