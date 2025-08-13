import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:market/components/app/app_heading.dart';
import 'package:market/components/posts/single_post_item.dart';
import 'package:market/pages/general/posts.dart';
import 'package:market/widgets_extra/navigator.dart';

class HomePosts extends StatelessWidget {
  final List posts;
  const HomePosts({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return (posts.isNotEmpty)
        ? Column(
            children: [
              AppHeading(
                title: 'Ən son paylaşılan yenilik və kampaniyalar',
                onTap: () {
                  navigatePage(context, const PostsPage(), root: true);
                },
              ),
              SizedBox(
                height: 250.0.r,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: [
                        if (index == 0) ...[SizedBox(width: 20.0.r)],
                        SizedBox(
                          width: 200.0.r,
                          child: SinglePostItem(data: posts[index]),
                        ),
                        if (index == posts.length - 1) ...[SizedBox(width: 20.0.r)],
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 15.0.r);
                  },
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
