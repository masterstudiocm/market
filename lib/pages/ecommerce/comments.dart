import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/comments/stats.dart';
import 'package:market/pages/ecommerce/add_comment.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/button.dart';
import 'package:market/widgets/container.dart';
import 'package:market/widgets/rating.dart';
import 'package:market/widgets/simple_notify.dart';
import 'package:market/widgets_extra/appbar.dart';
import 'package:market/widgets_extra/navigator.dart';

class Comments extends StatefulWidget {
  final Map data;
  const Comments({super.key, required this.data});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool loading = true;
  bool connectError = false;
  bool serverError = false;
  Map data = {};
  List comments = [];

  Future<void> get() async {
    if (!loading) setState(() => loading = true);

    Map result = await httpRequest('${App.domain}/api/comments.php?action=get&post_id=${widget.data['post_id']}');
    final payload = result['payload'];

    setStateSafe(() {
      loading = false;
      serverError = result['serverError'];
      connectError = result['connectError'];
      if (payload['status'] == 'success') {
        data = payload['result'];
        comments = payload['result']['comments'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MsAppBar(title: Text('Şərhlər')),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0).r,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Theme.of(context).colorScheme.grey1)),
          ),
          child: MsButton(
            onTap: () {
              navigatePage(context, AddCommentPage(data: widget.data));
            },
            title: 'Şərh bildir',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (comments.isNotEmpty) ...[CommentsStats(data: data)],
            MsContainer(
              loading: loading,
              serverError: serverError,
              connectError: connectError,
              action: get,
              child: (comments.isEmpty)
                  ? SimpleNotify(text: 'Heç bir şərh bildirilməyib.')
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20.0).r,
                      itemCount: comments.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15.0).r,
                              width: double.infinity,
                              decoration: BoxDecoration(color: Theme.of(context).colorScheme.grey1, borderRadius: BorderRadius.circular(5.0).r),
                              child: Text(comments[index]['comment_content'], style: TextStyle(fontSize: 13.0.sp, height: 1.4)),
                            ),
                            SizedBox(height: 10.0.r),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${comments[index]['comment_author']}',
                                        style: TextStyle(fontSize: 12.0.sp, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 5.0.r),
                                      MsRating(value: double.parse(comments[index]['comment_rating'].toString())),
                                    ],
                                  ),
                                ),
                                Text(
                                  comments[index]['comment_date'],
                                  style: TextStyle(color: Theme.of(context).colorScheme.grey5, fontSize: 12.0.sp),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 25.0.r);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
