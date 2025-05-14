import 'package:champion_footballer/Utils/appextensions.dart';

import '../Utils/packages.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obsecure;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final Color? backgroundColor;
  final Color? bordercolor;
  final int? maxLength;
  final double? height;
  final double? hintfontSize;

  final int? maxLines;
  final bool enablestate;

  const PrimaryTextField({
    super.key,
    this.controller,
    this.obsecure = false,
    this.labelText,
    required this.hintText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffix,
    this.focusNode,
    this.onChanged,
    this.backgroundColor,
    this.bordercolor,
    this.maxLength,
    this.height,
    this.hintfontSize,
    this.maxLines = 1, // Default to 1
    this.enablestate = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null && labelText!.isNotEmpty) ...[
          Text(
            labelText!,
            style: TextStyle(
              color: ktextColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          5.0.heightbox,
        ],
        Container(
          height: height ?? 35,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: bordercolor ?? ktextColor.withValues(alpha: .4),
              // width: 2,
            ),
            color: backgroundColor ?? kdefwhiteColor,
            borderRadius: defaultBorderRadious,
          ),
          child: TextFormField(
            enabled: enablestate,
            maxLines: maxLines,
            focusNode: focusNode,
            onChanged: onChanged,
            obscureText: obsecure,
            cursorColor: kdefgreyColor,
            cursorHeight: 14,
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: ktextColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            inputFormatters: [
              if (maxLength != null) LengthLimitingTextInputFormatter(maxLength)
            ],
            decoration: InputDecoration(
              suffix: suffix,
              hintText: hintText,
              hintStyle: TextStyle(
                  color: ktexthintColor.withValues(alpha: .6),
                  fontSize: hintfontSize ?? 12,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
        if (maxLength != null)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "Maximum $maxLength Characters",
              style: TextStyle(
                color: ktextColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
