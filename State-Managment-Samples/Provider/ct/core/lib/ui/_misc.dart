part of core_ui;
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  bool isLoading = false;

  void startLoading() => _setLoading(true);

  void stopLoading() => _setLoading(false);

  void _setLoading(bool value) {
    //avoid unnecessary rebuild
    if(value==isLoading){
      return;

    }
    if (mounted) {
      safeSetState(() {
        isLoading = value;
      });
    }
  }
}

/// A reusable widget that supports both vertical and horizontal scrolling.
///
/// ### Features
/// - Provides both vertical and horizontal scrolling for its content
/// - Uses `SingleChildScrollView` with `ClampingScrollPhysics` to support nested scrolling
/// - Allows content to vary independently of its layout, supporting flexible designs
///
/// ### Caution
/// - This widget contains nested scrolling in both directions (vertical and horizontal).
/// - If used within another scrollable parent, it can result in complex nested scrolling behavior.
/// - Ensure that the parent scrollable container does not conflict with this widget to avoid unexpected behavior.
/// ### Usage Example
/// ```dart
/// NestedScrollContainer(
///   content: Container(
///     padding: const EdgeInsets.all(20),
///     child: Column(
///       children: List.generate(
///         20,
///         (index) => Row(
///           children: List.generate(
///             10,
///             (i) => Container(
///               margin: const EdgeInsets.all(5),
///               width: 100,
///               height: 50,
///               color: Colors.blue[(i + 1) * 100],
///               child: Center(child: Text('Item $index-$i')),
///             ),
///           ),
///         ),
///       ),
///     ),
///   ),
/// )
/// ```
///
/// ### Parameters
/// - [content]: The widget to be displayed inside the scrollable container.
///

class NestedScrollContainer extends StatelessWidget {
  final Widget content;

  const NestedScrollContainer({Key? key, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: content,
      ),
    );
  }
}

ScrollbarThemeData getCustomScrollbarTheme() {
  return ScrollbarThemeData(
    thumbVisibility: WidgetStateProperty.all(true),
    trackVisibility: WidgetStateProperty.all(true),
    trackColor: WidgetStateProperty.all(Colors.grey),
    thumbColor: WidgetStateProperty.all(Colors.white),
  );
}

///TODO: The names sound 'Verb' , rename with a better name that sound 'Noun'
class FillMaxWidth extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  ///Occupy the full width and wrap the container
  const FillMaxWidth({super.key, this.padding, required this.child});

  @override
  Widget build(BuildContext context) => padding == null
      ? SizedBox(width: double.infinity, child: child)
      : Padding(
          padding: padding!,
          child: SizedBox(width: double.infinity, child: child));
}

class WrapWithSpaceBetween extends StatelessWidget {
  final Widget left, right;

  const WrapWithSpaceBetween(
      {super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return FillMaxWidth(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Wrap(
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            children: [left, right]));
  }
}

class FormRow2 extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final double labelWidth;
  final String? error, hints;
  final void Function(String) onChange;

  FormRow2(
      {Key? key,
      required this.label,
      this.keyboardType = TextInputType.text,
      required this.labelWidth,
      this.error,
      this.hints,
      required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material( //Wrap to avoid theme problem
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Label
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          // Text Field
          Expanded(
            child: TextField(
              style: ThemeInfo.textFieldStyle,
              keyboardType: keyboardType,
              onChanged: onChange,
              decoration: InputDecoration(
                hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w400),
                hintText: hints,
                errorStyle: const TextStyle(color: Colors.yellow),
                errorText: error,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class CustomTextFieldXX extends StatefulWidget {
  final String? text; // Injected text
  final TextInputType keyboardType;
  final String? hints;
  final String? error;
  final ValueChanged<String>? onChange;

  const CustomTextFieldXX({
    Key? key,
     this.text,
     this.keyboardType=TextInputType.text,
    this.hints,
    this.error,
    this.onChange,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextFieldXX> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  void didUpdateWidget(covariant CustomTextFieldXX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.text = widget.text??''; // Update text when prop changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: Theme.of(context).textTheme.bodyMedium,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChange,
      decoration: InputDecoration(
        hintStyle: const TextStyle(
            color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w400),
        hintText: widget.hints,
        errorStyle: const TextStyle(color: Colors.yellow),
        errorText: widget.error,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FormRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final double labelWidth;
  final bool readOnly;
  final String? error, hints;
  final void Function(String)? onChange;

  const FormRow(
      {Key? key,
      required this.label,
       required this.controller,
      this.keyboardType = TextInputType.text,
      required this.labelWidth,
      this.error,
      this.hints,
      this.onChange,
        this.readOnly=false
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        // Text Field
        Expanded(
          child: TextField(
            style: ThemeInfo.textFieldStyle,
            controller: controller,  // Use local controller here
            keyboardType: keyboardType,
            onChanged: onChange,
            readOnly: readOnly,
            decoration: InputDecoration(
              hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
              hintText: hints,
              errorStyle: const TextStyle(color: Colors.yellow),
              errorText: error,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class FormRowBase extends StatelessWidget {
  final String label;
  final double labelWidth;
  final Widget input;

  const FormRowBase({
    Key? key,
    required this.label,
    this.labelWidth = 150,
    required this.input,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
        // Text Field
        Expanded(
          child: input,
        ),
      ],
    );
  }
}
void hideKeyboardOrSkip(){
  try{
    FocusManager.instance.primaryFocus?.unfocus();
  }
      catch(_){}
}