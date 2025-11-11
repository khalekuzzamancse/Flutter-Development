import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../_core/generic_screen.dart';
import '../_core/time_formatter.dart';
import 'app_color.dart';

class ImageViewer extends StatelessWidget {
  final String url;
  final Widget? timeAndStatus;

  const ImageViewer({super.key, required this.url, this.timeAndStatus});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        //await Navigation.push(context, PhotoViewer(url: url));
        // openLinkInDevice(url);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Image.network(
              url,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
            ),
          ),
          if (timeAndStatus != null)
            Positioned(bottom: 4, right: 4, child: timeAndStatus!),
        ],
      ),
    );
  }
}

class FileViewer extends StatelessWidget {
  final String url;
  final Widget? timeAndStatus;

  const FileViewer({super.key, required this.url, this.timeAndStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    openLinkInDevice(url);
                  },
                  icon: const Icon(Icons.file_open_outlined)),
              const SizedBox(width: 4),
              Flexible(child: Text(extractFileName(url)))
            ],
          ),
          if (timeAndStatus != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  timeAndStatus!,
                ],
              ),
            )

        ],
      ),
    );
  }
}

class TimeAndStatus extends StatelessWidget {
  final String time;
  final int status;

  const TimeAndStatus({super.key, required this.time, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.only(left: 8.0, top: 1, bottom: 1, right: 2),
      child: Row(
        children: [
          Text(
            time,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13.0,
            ),
          ),
          if (status != 0) //Assuming value are 0,1,2
            Row(
              children: [
                const SizedBox(width: 4),
                Icon(
                  status == 1 ? Icons.done : Icons.done_all_outlined,
                  //status=2==seen
                  size: 10.0,
                  color: status == 2 ? Colors.blue : Colors.grey,
                )
              ],
            )
        ],
      ),
    );
  }
}

//@formatter:off

class VideoViewer extends StatefulWidget {
  final String url;
  final Widget? timeAndStatus;

  const VideoViewer({super.key, required this.url, this.timeAndStatus});

  @override
  VideoViewerState createState() => VideoViewerState();
}

class VideoViewerState extends State<VideoViewer> {
  late VideoPlayerController _controller;
  bool _isVideoSupported = true;  // Track whether the video is supported or not

  @override
  void initState() {
    super.initState();
    try{

      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {});
          _controller.addListener(() {
            if (_controller.value.position == _controller.value.duration) {
              setState(() {}); // Trigger re-build when the video finishes
            }
          });
        }).catchError((error) {
          setState(() {
            _isVideoSupported = false;  // Video is not supported
          });
        });
    }
    catch(_){}

  }

//@formatter:off
  @override
  Widget build(BuildContext context) {
    return Container(width: 200, height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _isVideoSupported ? _controller.value.isInitialized ?
          AspectRatio(aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : const CircularProgressIndicator()
              : _VideoPreviewNotSupportProxy(url: widget.url),
          // Centering the action buttons (play/pause and external link)
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Ensure centering
              mainAxisSize: MainAxisSize.min, // Minimize the size of the row
              children: [
                if (_isVideoSupported  && _controller.value.isInitialized)
                  IconButton(onPressed: (){
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  }, icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  )),
                if (_isVideoSupported)
                  Row(
                    children: [
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: () {
                          openLinkInDevice(widget.url); // Open the video externally
                        },
                        icon: const Icon(Icons.open_in_new, color: AppColor.primary),
                      ),
                    ],
                  ), // Add spacing between the buttons

              ],
            ),
          ),
          if(widget.timeAndStatus!=null)
            Positioned(
                bottom: 4,
                right: 4,
                child: widget.timeAndStatus!),
        ],
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _VideoPreviewNotSupportProxy extends StatelessWidget {
  final String url;
  const _VideoPreviewNotSupportProxy({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/image/video_file_symbol.png',
          fit: BoxFit.cover,
          height: 200,
          width: 200,
        ),
        Positioned(
          top: 80,
          child: IconButton(
            onPressed: () {
              openLinkInDevice(url);
            },
            icon: const Icon(Icons.open_in_new, color:Colors.white),
          ),
        ),
      ],
    );
  }
}

class PhotoViewer extends StatelessWidget {
  final String url;
  const PhotoViewer({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return GenericScreen(
      title: 'Image Viewer',
      content: PhotoView(
        imageProvider: NetworkImage(url),
      ),
    );
  }
}


///open video to the device player
void openLinkInDevice(String videoUrl) async {
  try{
    if (await canLaunchUrl(Uri.parse(videoUrl))) {
      await launchUrl(Uri.parse(videoUrl));
    } else {

    }
  }
  catch(e){

  }

}