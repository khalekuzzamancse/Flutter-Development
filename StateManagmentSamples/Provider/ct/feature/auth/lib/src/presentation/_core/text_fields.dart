import 'package:flutter/material.dart';

import 'resource_factory.dart';

class PasswordField extends StatefulWidget {
  final Function(String) onInputChanged;
  final String? hints;

  const PasswordField({Key? key, required this.onInputChanged, this.hints})
      : super(key: key);

  @override
  PasswordFieldState createState() => PasswordFieldState();
}

class PasswordFieldState extends State<PasswordField> {
  final TextEditingController _controller = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password",
          style: TextStyle(fontSize: 16, color: AppColor.primary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          obscureText: _isObscured,
          onChanged: widget.onInputChanged,
          decoration: InputDecoration(
            hintText: widget.hints,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.5)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: AppColor.primary), // Set border color to black
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: AppColor.primary), // Black border for enabled state
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                  color: AppColor.primary,
                  width: 2), // Thicker black border for focused state
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isObscured ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isObscured = !_isObscured;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class CustomOutlinedTextField extends StatefulWidget {
  final Function(String) onChange;
  final String label;
  final String? hint;
  final bool readOnly;
  final String value;

  const CustomOutlinedTextField({
    Key? key,
    required this.onChange,
    required this.label,
    this.hint,
    this.readOnly = false,
    this.value = '',
  }) : super(key: key);

  @override
  CustomOutlinedTextFieldState createState() => CustomOutlinedTextFieldState();
}

class CustomOutlinedTextFieldState extends State<CustomOutlinedTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, color: AppColor.primary),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          readOnly: widget.readOnly,
          onChanged: widget.onChange,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColor.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: AppColor.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? leadingIcon;
  final String? error;
  final bool obscureText;
  final Widget? trailingIcon;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.label,
    this.error,
    this.leadingIcon,
    this.obscureText = false,
    this.trailingIcon,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            isDense: true,
            hintText: "  $label",
            //TODO:Proxy padding by trailing space, fix it later
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Colors.blue,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            prefixIcon: leadingIcon == null
                ? null
                : Icon(
                    leadingIcon,
                    color: AppColor.primary,
                    size: 20,
                  ),
            suffixIcon: trailingIcon,
          ),
        ),
        if (error != null)
          _Error(
            text: error!,
            color: Colors.red,
            padding: const EdgeInsets.only(left: 10, right: 2),
          )
      ],
    );
  }
}

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPasswordField;
  final IconData? leadingIcon;
  final String? errorText;
  final TextInputType? keyboardType;
  final VoidCallback? onDone;

  const AuthTextField({
    Key? key,
    required this.controller,
    required this.keyboardType,
    this.isPasswordField = false,
    this.errorText,
    this.onDone,
    required this.label,
    this.leadingIcon,
  }) : super(key: key);

  @override
  AuthTextFieldState createState() => AuthTextFieldState();
}

class AuthTextFieldState extends State<AuthTextField> {
  late bool _obscureText = widget.isPasswordField ? true : false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BasicTextField(
          property: const BasicTextFieldProperty(
            leadingIconColor: AppColor.primary,
          ),
          hints: widget.label,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          leadingIcon: widget.leadingIcon,
          error: widget.errorText,
          obscureText: _obscureText,
          controller: widget.controller,
          trailingIcon: widget.isPasswordField
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle visibility
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColor.primary,
                  ),
                )
              : const Icon(
                  //Just to keep the height same when there nis no trailing icon
                  Icons.visibility,
                  color: Colors.transparent,
                )),
    );
  }
}

class BasicTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hints;
  final String? error;
  final TextInputType keyboardType;
  final IconData? leadingIcon;
  final Widget? trailingIcon;
  final bool obscureText;
  final BasicTextFieldProperty property;

  const BasicTextField({
    super.key,
    required this.controller,
    required this.hints,
    this.keyboardType = TextInputType.text,
    this.property = const BasicTextFieldProperty(),
    this.leadingIcon,
    required this.obscureText,
    this.error,
    this.trailingIcon,
  });

  @override
  BasicTextFieldState createState() => BasicTextFieldState();
}

class BasicTextFieldState extends State<BasicTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = widget.error;
    final property = widget.property;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
                  color: property.borderColor, width: property.borderWidth),
              borderRadius: property.borderRadius),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(
                widget.leadingIcon,
                color: property.leadingIconColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    isDense: true,
                    //removing default internal padding
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    hintText: widget.hints,
                    border: InputBorder.none,
                    suffixIcon: widget.trailingIcon,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          _Error(
            text: error,
            color: property.errorColor,
            padding: const EdgeInsets.only(left: 10, right: 2),
          )
      ],
    );
  }
}

class _Error extends StatelessWidget {
  final String text;
  final Color color;
  final EdgeInsets padding;

  const _Error(
      {required this.text, required this.padding, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // take full width of parent
      padding: padding,
      child: Text(
        text,
        style: TextStyle(color: color),
      ),
    );
  }
}

class BasicTextFieldProperty {
  final Color borderColor;
  final double borderWidth;
  final BorderRadiusGeometry? borderRadius;
  final Color leadingIconColor;
  final Color errorColor;

  const BasicTextFieldProperty({
    this.borderColor =
        const Color(0xFFB3B3B3), // approx Colors.grey.withOpacity(0.8)
    this.borderWidth = 2.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    Color? leadingIconColor,
    this.errorColor = Colors.redAccent,
  }) : leadingIconColor = leadingIconColor ?? borderColor;

  BasicTextFieldProperty copyWith({
    Color? borderColor,
    double? borderWidth,
    BorderRadiusGeometry? borderRadius,
    Color? leadingIconColor,
    Color? errorColor,
  }) {
    final effectiveBorderColor = borderColor ?? this.borderColor;

    return BasicTextFieldProperty(
      borderColor: effectiveBorderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      leadingIconColor: leadingIconColor ?? this.leadingIconColor,
      errorColor: errorColor ?? this.errorColor,
    );
  }
}
