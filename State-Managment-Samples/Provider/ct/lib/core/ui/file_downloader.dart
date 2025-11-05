import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:snowchat_ios/core/misc/logger.dart';



class FileDownloader {
  final _class='FileDownloader';
  Future<void> downloadFileWithDialog(BuildContext context, String url) async {

    ValueNotifier<double> progressNotifier = ValueNotifier(0.0);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Downloading...'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: progressNotifier,
              builder: (context, progress, _) => Column(
                children: [
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 16),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );


    final filePath = await _downloadFile(
      url, (updatedProgress) {
      progressNotifier.value = updatedProgress;
    },
    );

    if(context.mounted){
      Navigator.of(context).pop();
    }
    if (filePath != null&&context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Download Complete'),
          content: Text('File saved at:\n$filePath'),
          actions: [
            TextButton(
              onPressed: ()async {
                Navigator.of(context).pop();
                Logger.temp(_class, 'file path:$filePath');
                openFile(filePath);
              },
              child: const Text('Open'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } else {
      if(context.mounted){
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to download the file.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }

    }


  }

  void openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
      if (result.type != ResultType.done) {
        Logger.temp(_class, 'Error opening file: ${result.message}');
      }
    } catch (e) {
      Logger.temp(_class, 'Error opening file: $e');
    }
  }
  Future<String?> _downloadFile(String url, Function(double) onProgressUpdate) async {
    try {
      final fileName = _extractFileName(url);
      final directory =await pickDirectoryName();
      final filePath = '$directory/$fileName';
      final response = await http.Client().send(http.Request('GET', Uri.parse(url)));

      if (response.statusCode == 200) {
        final file = File(filePath);
        final totalBytes = response.contentLength ?? 0;
        var downloadedBytes = 0;

        final stream = response.stream.listen(
              (chunk) {
            file.writeAsBytesSync(chunk, mode: FileMode.append);
            downloadedBytes += chunk.length;
            onProgressUpdate(totalBytes > 0 ? downloadedBytes / totalBytes : 0.0);
          },
        );

        await stream.asFuture();

        return filePath;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }


  Future<String?> pickDirectoryName() async {
    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
      return selectedDirectory; // Return the full path
    } catch (e) {
      return null;
    }
  }
  String _extractFileName(String url) {
    return url.split('/').last;
  }
}