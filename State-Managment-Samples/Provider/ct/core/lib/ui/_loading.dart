part of core_ui;


class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent background
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
class NoDataView extends StatelessWidget {
  final Color fontColor;
  const NoDataView({super.key,this.fontColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return  Center(child: Text('No data found',style: TextStyle(color: fontColor,fontSize: 20),));
  }
}
class LoadingUI extends StatelessWidget {
  final double size;
  final  Color? color;
  const LoadingUI({super.key,this.size=64, this.color});

  @override
  Widget build(BuildContext context) {
    return   Center(child: SizedBox(width:size,height:size,child:  CircularProgressIndicator(color: color,)));
  }
}


class Utils {
  late BuildContext context;

  Utils(this.context);

  // this is where you would do your fullscreen loading
  Future<void> startLoading() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const SimpleDialog(
          elevation: 0.0,
          backgroundColor:
              Colors.transparent, // can change this to your prefered color
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(),
            )
          ],
        );
      },
    );
  }

  Future<void> stopLoading() async {
    Navigator.of(context).pop();
  }

  Future<void> showError(Object? error) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        backgroundColor: Colors.red,
        content: const Text('Error Found'),
      ),
    );
  }
}
