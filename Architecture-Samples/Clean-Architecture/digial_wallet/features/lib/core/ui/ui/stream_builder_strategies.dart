import 'package:flutter/material.dart';
import 'core_ui.dart';
import '../presentation_logic/message_to_ui.dart';

class StreamBuilderStrategyWithSnackBar<T> extends StatelessWidget {
  final Stream<MessageToUi?> messageStream; // Nullable MessageToUi stream
  final Stream<bool>? isLoadingStream;
  final Stream<T> dataStream;
  final AsyncWidgetBuilder<T> builder;

  const StreamBuilderStrategyWithSnackBar({
    Key? key,
    required this.messageStream,
    this.isLoadingStream,
    required this.dataStream,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MessageToUi?>(
      stream: messageStream,
      builder: (context, messageSnapshot) {
        // Check if there's a new non-null message to display
        if (messageSnapshot.hasData && messageSnapshot.data != null) {
          _showSnackBar(context, messageSnapshot.data!);
        }
        // Wrap the StreamBuilderStrategy to handle loading and data streams
        return StreamBuilderStrategy<T>(
          isLoadingStream: isLoadingStream,
          dataStream: dataStream,
          builder: builder,
        );
      },
    );
  }

  // Helper method to display a SnackBar
  void _showSnackBar(BuildContext context, MessageToUi message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          width: 300,
          // Set fixed width directly on the SnackBar
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Text(
            message.message,
            textAlign: TextAlign.center,
          ),
          backgroundColor: _getSnackBarColor(message.type,isDarkTheme(context)),
        ),
      );
    });
  }


  // Determines the color of the SnackBar based on message type and theme type
  Color _getSnackBarColor(MessageType type, bool isDarkTheme) {
    switch (type) {
      case MessageType.success:
        return isDarkTheme ? Color(0xFF80E1A1) : Color(0xFF008A4B); // Adjust green for dark mode
      case MessageType.error:
        return isDarkTheme ? Color(0xFFFF6B6B) : Color(0xFFE12F2B); // Adjust red for dark mode
      case MessageType.neutral:
      default:
        return isDarkTheme ? Colors.grey[600]! : Colors.blueGrey; // Default neutral color adjustment for dark mode
    }
  }

  bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }



}

/// `StreamBuilderStrategy` is inspired by the Strategy design pattern, offering
/// a flexible and reusable approach to managing stream states in the UI.
///
/// This widget wraps a `StreamBuilder` and provides additional, user-friendly
/// functionality for handling asynchronous data streams.
///
/// `StreamBuilderStrategy` is designed to make handling streams in the UI more
/// streamlined by:
///  - Displaying a loading progress indicator when data is loading.
///  - Showing an error message automatically if any error occurs in the stream.
///  - Providing a clear "no data" message if the stream completes without data.
///
/// ## Usage
/// `StreamBuilderStrategy` simplifies your `StreamBuilder` usage by managing
/// common stream states. You need only provide the main data stream and an
/// optional loading stream to handle loading conditions independently:
///
/// ```dart
/// StreamBuilderStrategy<List<MyModel>>(
///   isLoadingStream: controller.isLoading, // Optional loading stream
///   dataStream: controller.myDataStream,   // Required data stream
///   builder: (context, snapshot) {
///     // Widget to display when data is successfully loaded.
///     return MyDataWidget(data: snapshot.data!); //Guaranteed that data is available so need not extra checking
///   },
/// )
/// ```
///
/// ### Parameters
/// - `isLoadingStream` (optional): A stream of boolean values indicating
///   whether loading is in progress. If provided and loading is true,
///   a loading indicator is displayed until loading completes.
/// - `dataStream` (required): The primary data stream to display.
/// - `builder`: A function that builds the widget for successfully loaded data.
///
/// `StreamBuilderStrategy` handles loading, error, and no-data states
/// internally, making it ideal for simplifying asynchronous stream handling
/// in a user-friendly way.

class StreamBuilderStrategy<T> extends StatelessWidget {
  final Stream<bool>? isLoadingStream;
  final Stream<T> dataStream;
  final AsyncWidgetBuilder<T> builder;

  const StreamBuilderStrategy({
    Key? key,
    this.isLoadingStream,
    required this.dataStream,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no loading stream is provided, directly use DataStreamBuilder
    if (isLoadingStream == null) {
      return DataStreamBuilder<T>(
        stream: dataStream,
        builder: builder,
      );
    } else {
      return StreamBuilder<bool>(
        stream: isLoadingStream,
        builder: (context, isLoadingSnapshot) {
          final isLoading = isLoadingSnapshot.data == true;
          if (isLoading)
            return LoadingUi();
          //Need not handle the Error for isLoading,if any error then progressbar will not show/start
          // } else if (isLoadingSnapshot.hasError) {
          //   return Text("An error occurred: ${isLoadingSnapshot.error}");
          else {
            return DataStreamBuilder<T>(
              stream: dataStream,
              builder: builder,
            );
          }
        },
      );
    }
  }
}

/// `DataStreamBuilder` is a streamlined widget that only calls the builder
/// function when data is available, allowing you to safely use `snapshot.data!`
/// directly without additional null or loading state checks.
class DataStreamBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncWidgetBuilder<T> builder;

  const DataStreamBuilder({
    Key? key,
    required this.stream,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          // Show loading if waiting on data
          return LoadingUi();

// Occurrences of snapshot.hasError and !snapshot.hasData are rare if the Stream API is managed carefully.
// If they do occur, it may be due to framework bugs or incorrect Stream API usage.
        else if (snapshot.hasError)
          // SBE = StreamBuilder Error. This message is intended for developers to aid in debugging.
          return EmptyContentScreen(text: "Something is went wrong, Error code : SBE");
        else if (!snapshot.hasData)
          //SBHNDE=SteamBuilder has not data Error
          return EmptyContentScreen(text: "Something is went wrong, Error code : SBHNDE");
        else {
          return builder(context, snapshot);
        }
      },
    );
  }
}
