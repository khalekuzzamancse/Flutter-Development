import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../core/ui/app_color.dart';


class PhoneNumberPicker extends StatelessWidget {
  final bool hintsAsLabel;
  final Function(String) onCountryCodeChanged,onNumberChanged,onFullNumberChanged;

  const PhoneNumberPicker({
    Key? key,
    required this.onCountryCodeChanged,  this.hintsAsLabel=false,  required this.onNumberChanged, required this.onFullNumberChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(!hintsAsLabel)
        const Text(
          "Phone Number",
          style: TextStyle(
            fontSize: 16,
            color: AppColor.primary,
          ),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          dropdownIconPosition:  IconPosition.trailing,
          flagsButtonPadding: const EdgeInsets.only(left: 8),
          showCountryFlag: false,
          disableLengthCheck: true,
          decoration: InputDecoration(
            hintText: hintsAsLabel?'Phone number':'Enter your phone number',
            hintStyle: TextStyle(
              fontWeight: FontWeight.w300,
              color: hintsAsLabel? Colors.blue : Colors.black.withOpacity(0.5),
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
          initialCountryCode: 'BD',
          onChanged: (phone) {
            onNumberChanged(phone.number);
            onCountryCodeChanged(phone.countryCode);
            onFullNumberChanged(phone.completeNumber);
          },
        ),
      ],
    );
  }
}

class PasswordField extends StatefulWidget {
  final Function(String) onInputChanged;
  final String? hints;

  const PasswordField({Key? key, required this.onInputChanged,  this.hints})
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
            hintText:widget.hints,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5)
            ),
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
            suffixIcon:
            IconButton(
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
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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


class CustomTextField extends StatefulWidget {
  final String label;
  final IconData? leadingIcon;
  final bool obscureText;
  final Widget? trailingIcon;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
     this.leadingIcon,
    this.obscureText = false,
    this.trailingIcon,
    required this.onChanged,
  }) : super(key: key);

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        isDense: true,
        hintText: "  ${widget.label}",//TODO:Proxy padding by trailing space, fix it later
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.blue,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
        prefixIcon: widget.leadingIcon==null?null:
        Container(
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            widget.leadingIcon,
            color: Colors.white,
            size: 20,
          ),
        ),
        suffixIcon: widget.trailingIcon,
      ),
    );
  }
}


///To change it size need to
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/image/logo.png',
    width: 150,
    height: 100,
  );
}