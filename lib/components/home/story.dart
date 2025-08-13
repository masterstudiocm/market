import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/controllers/story_controller.dart';
import 'package:market/themes/functions.dart';
import 'package:market/themes/theme.dart';
import 'package:market/widgets/image.dart';

class Stories extends StatefulWidget {
  final List stories;
  const Stories({super.key, required this.stories});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();
  final storyController = Get.find<StoryController>();

  @override
  Widget build(BuildContext context) {
    return (widget.stories.isEmpty)
        ? const SizedBox()
        : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                height: 120.0,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.stories.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        (index == 0) ? const SizedBox(width: 15.0) : const SizedBox(),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              _currentIndex = index;
                            });
                            storyController.update();
                            storyController.updateProgress(0.0);
                            showDialog(
                              barrierColor: Colors.black,
                              useRootNavigator: true,
                              context: context,
                              builder: (context) {
                                return StoryDetails(
                                  storyController: storyController,
                                  carouselController: _carouselController,
                                  widget: widget,
                                  currentIndex: _currentIndex,
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: MsImage(url: widget.stories[index]['story_image']['media_url'], width: 70.0, height: 70.0),
                                ),
                              ),
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2.0, color: Theme.of(context).colorScheme.grey2),
                                    borderRadius: BorderRadius.circular(100.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        (index == widget.stories.length - 1) ? const SizedBox(width: 15.0) : const SizedBox(),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(width: 7.0);
                  },
                ),
              ),
            ],
          );
  }
}

class StoryDetails extends StatelessWidget {
  const StoryDetails({
    super.key,
    required this.storyController,
    required CarouselSliderController carouselController,
    required this.widget,
    required int currentIndex,
  }) : _carouselController = carouselController,
       _currentIndex = currentIndex;

  final StoryController storyController;
  final CarouselSliderController _carouselController;
  final Stories widget;
  final int _currentIndex;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => Positioned(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black.withValues(alpha: storyController.progress.value),
            ),
          ),
        ),
        Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.down,
          onUpdate: (data) {
            storyController.updateProgress(data.progress);
            if (data.progress >= 0.5) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(width: MediaQuery.of(context).size.width, height: 2.0, color: const Color(0xFF555555)),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Obx(
                          () => AnimatedContainer(
                            duration: Duration(milliseconds: storyController.duration.value),
                            width: storyController.width.value,
                            height: 2.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Expanded(
                    child: CarouselSlider.builder(
                      carouselController: _carouselController,
                      itemCount: widget.stories.length,
                      itemBuilder: (context, itemIndex, pageIndex) {
                        return Stack(
                          children: [
                            MsImage(url: widget.stories[itemIndex]['story_image']['media_url'], width: double.infinity, height: double.infinity),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _carouselController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: MediaQuery.of(context).size.height,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _carouselController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.linearToEaseOut);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  height: MediaQuery.of(context).size.height,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            if (widget.stories[itemIndex]['story_url'] != '' && widget.stories[itemIndex]['story_url'] != null) ...[
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    redirectUrl(widget.stories[itemIndex]['story_url']);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(15.0),
                                    color: Theme.of(context).colorScheme.grey5,
                                    child: Text(
                                      'Daha ətraflı',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                      options: CarouselOptions(
                        height: double.infinity,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1,
                        initialPage: _currentIndex,
                        enableInfiniteScroll: false,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        enlargeFactor: 0,
                        onPageChanged: (index, reason) {
                          storyController.update();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 7.0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.bg,
                    padding: const EdgeInsets.all(5.0),
                    child: const Icon(Icons.close, size: 30.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
