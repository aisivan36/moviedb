import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_db/models/movies/image_backdrop_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPhotos extends StatefulWidget {
  const ViewPhotos({
    Key? key,
    required this.color,
    required this.imageIndex,
    required this.imageList,
  }) : super(key: key);

  final int imageIndex;
  final Color color;
  final List<ImageBackdrop> imageList;

  @override
  State<ViewPhotos> createState() => _ViewPhotosState();
}

class _ViewPhotosState extends State<ViewPhotos> {
  late PageController pageController;

  PhotoViewController photoViewController = PhotoViewController();

  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    photoViewController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.arrow_left_circle)),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: IconButton(
              onPressed: () => launch(widget.imageList[currentIndex].image),
              icon: const Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: pageController,
        itemCount: widget.imageList.length,
        builder: (contex, index) {
          return PhotoViewGalleryPageOptions(
            controller: photoViewController,
            imageProvider:
                CachedNetworkImageProvider(widget.imageList[index].image),
            minScale: PhotoViewComputedScale.contained,
          );
        },
        onPageChanged: onPageChanged,

        /// Loading progress circle indicator
        loadingBuilder: (context, progress) => Center(
          child: CircularProgressIndicator(
            color: Colors.cyanAccent,
            strokeWidth: 2,
            backgroundColor: Colors.grey[800],
            value: progress == null
                ? null
                : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
          ),
        ),
      ),
    );
  }
}
