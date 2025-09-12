import '../Utils/packages.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? titleText;
  final Widget? titleWidget;
  final Widget? action;
  final Color? backgroundColor;
  final bool showLeading;
  final VoidCallback? tapaction;
  final double? appBarElevation;
  final Color? shadowColor;
  final Color? foregroundColor;
  final Color? surfaceTintColor;
  final Gradient? gradient;
  const CustomAppBar({
    super.key,
    this.titleText,
    this.action,
    this.showLeading = true,
    this.backgroundColor,
    this.tapaction,
    this.titleWidget,
    this.appBarElevation,
    this.shadowColor,
    this.foregroundColor,
    this.surfaceTintColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? (backgroundColor ?? kPrimaryColor) : null,
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        leading: showLeading
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Image.asset(
                    "assets/images/backarrow.png",
                    width: 15,
                    height: 15,
                  ),
                ),
              )
            : null,
        centerTitle: true,
        actions: [
          if (action != null)
            Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 20),
              child: GestureDetector(
                onTap: tapaction,
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: action,
                ),
              ),
            ),
        ],
        elevation: appBarElevation ?? 0,
        backgroundColor: Colors.transparent,
        shadowColor: shadowColor ?? Colors.transparent,
        foregroundColor: foregroundColor ?? kdefwhiteColor,
        surfaceTintColor: surfaceTintColor ?? kPrimaryColor,
        title: titleWidget ??
            Text(
              titleText ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
