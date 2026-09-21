import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';

class FullyScreenGalleryWidget extends StatefulWidget {
  const FullyScreenGalleryWidget({
    super.key,
    required this.galleryImages,
    this.initialIndex = 0,
  });

  final List<String> galleryImages;
  final int initialIndex;

  @override
  State<FullyScreenGalleryWidget> createState() =>
      _FullyScreenGalleryWidgetState();
}

class _FullyScreenGalleryWidgetState extends State<FullyScreenGalleryWidget> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.galleryImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: InteractiveViewer(
                  child: Image.network(
                    widget.galleryImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: Text(
              '${_currentIndex + 1} / ${widget.galleryImages.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
