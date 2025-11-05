
import 'package:features/core/ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ClassificationScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const ClassificationScreen({Key? key, required this.imageBytes})
    : super(key: key);

  @override
  _ClassificationScreenState createState() => _ClassificationScreenState();
}

class _ClassificationScreenState extends State<ClassificationScreen> {
  late Uint8List resizedImage = Uint8List(
    0,
  ); // Initialize with empty byte array
  bool isLoading = false;
  String? result;


  @override
  void initState() {
    super.initState();
    _classifyImage();
  }

  Future<void> _classifyImage() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Classification Result")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (resizedImage.isNotEmpty) ...[
                ImageWithProgress(
                  imageBytes: resizedImage,
                  isLoading: isLoading,
                  isSuccess: result != null,
                ),
                const SizedBox(height: 24),
              ],
              DisplayResult(result: result, isLoading: isLoading),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageWithProgress extends StatelessWidget {
  final Uint8List imageBytes;
  final bool isLoading;
  final bool isSuccess;

  const ImageWithProgress({
    Key? key,
    required this.imageBytes,
    required this.isLoading,
    required this.isSuccess,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = isLoading
        ? Colors.grey
        : isSuccess
        ? Colors.green
        : Colors.red;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Stack(
        children: [
          Image.memory(
            imageBytes,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          if (isLoading)
            Positioned.fill(child: RandomWaveDotGridLoader()),
        ],
      ),
    );



  }
}

class DisplayResult extends StatelessWidget {
  final String? result;
  final bool isLoading;

  const DisplayResult({Key? key, required this.result, required this.isLoading})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Text(
        "Classifying the image...",
        style: TextStyle(fontSize: 18, color: Colors.blue),
        textAlign: TextAlign.center,
      );
    }

    if (result == null) {
      return Text(
        "Prediction Failed",
        style: TextStyle(
          fontSize: 20,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      );
    }

    return Text(
      result!,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.green,
      ),
      textAlign: TextAlign.center,
    );
  }
}
