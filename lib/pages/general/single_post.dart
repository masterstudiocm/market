import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/single_post/back.dart';
import 'package:market/components/single_post/header.dart';
import 'package:market/controllers/post_controller.dart';
import 'package:market/components/app/statusbar_overlay.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/annotated.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/html.dart';
import 'package:market/widgets/notify.dart';

class SinglePostPage extends StatefulWidget {
  const SinglePostPage({super.key, this.data, this.slug, this.id});

  final Map? data;
  final String? slug;
  final String? id;

  @override
  State<SinglePostPage> createState() => _SinglePostPageState();
}

class _SinglePostPageState extends State<SinglePostPage> {
  bool loading = false;
  bool serverError = false;
  bool connectError = false;
  Map data = <dynamic, dynamic>{};
  bool safearea = false;
  double height = 350.r;

  final ScrollController _scrollController = ScrollController();
  final PostController postController = PostController();

  Future<void> get() async {
    final slug = widget.slug ?? data['post_slug'] ?? '';
    final id = widget.id ?? data['post_id'] ?? '';

    setState(() => loading = true);
    Map result = await postController.get(slug: slug, id: id);
    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      data = result['data'];
    });
  }

  @override
  void initState() {
    super.initState();
    _scrollListener();
    if (widget.data == null) {
      get();
    } else {
      data = widget.data!;
    }
  }

  void _scrollListener() {
    _scrollController.addListener(() {
      if ((_scrollController.position.pixels > height && !safearea) || (_scrollController.position.pixels <= height && safearea)) {
        setState(() {
          safearea = _scrollController.position.pixels > height;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MsAnnotatedRegion(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.bg,
        body: MsContainer(
          loading: loading,
          serverError: serverError,
          connectError: connectError,
          action: get,
          child: (data.isEmpty)
              ? MsNotify(heading: 'Bu barədə heç bir məlumat tapılmadı.', action: get)
              : SafeArea(
                  top: safearea,
                  bottom: true,
                  child: Stack(
                    children: <Widget>[
                      CustomScrollView(
                        controller: _scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            iconTheme: const IconThemeData(color: Colors.white),
                            toolbarHeight: App.toolbarHeight,
                            expandedHeight: height,
                            leadingWidth: App.leadingWidth,
                            systemOverlayStyle: SystemUiOverlayStyle.light,
                            leading: const SinglePostBackButton(),
                            flexibleSpace: SinglePostHeader(data: data),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0).r,
                              child: MsHtml(data: data['post_content']),
                            ),
                          ),
                        ],
                      ),
                      if (!safearea) ...<Widget>[const StatusbarOverlay()],
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
