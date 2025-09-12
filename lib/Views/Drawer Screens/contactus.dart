import 'package:champion_footballer/Utils/appextensions.dart';
import 'package:champion_footballer/Utils/packages.dart';
import 'package:toastification/toastification.dart';

import '../../Model/Api Models/contact_model.dart';
import '../../Services/RiverPord Provider/ref_provider.dart';

class ContactUsScreen extends ConsumerStatefulWidget {
  const ContactUsScreen({super.key});

  @override
  ConsumerState<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends ConsumerState<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  String? nameError;
  String? emailError;
  String? messageError;

  bool isSubmitting = false;

  void _submitForm() async {
    setState(() {
      nameError =
          nameController.text.trim().isEmpty ? "Name is required" : null;
      emailError = emailController.text.trim().isEmpty
          ? "Email is required"
          : (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                  .hasMatch(emailController.text.trim())
              ? "Invalid email format"
              : null);
      messageError =
          messageController.text.trim().isEmpty ? "Message is required" : null;
    });

    if (nameError != null || emailError != null || messageError != null) return;

    setState(() => isSubmitting = true);

    final request = ContactRequest(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      message: messageController.text.trim(),
    );

    try {
      final success = await ref.read(contactUsProvider(request).future);
      if (success) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: const Text("Message sent successfully"),
        );
        nameController.clear();
        emailController.clear();
        messageController.clear();
        setState(() {
          nameError = null;
          emailError = null;
          messageError = null;
        });
      }
    } catch (e) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text("Failed: ${e.toString()}"),
      );
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      // appBar: CustomAppBar(titleText: "Contact Us"),
      appBar: CustomAppBar(
        titleText: "Contact Us",
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(229, 106, 22, 1),
            Color.fromRGBO(207, 35, 38, 1),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: SingleChildScrollView(
          padding: defaultPadding(vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryTextField(
                  bordercolor: kPrimaryColor.withValues(alpha: .5),
                  hintText: 'write your name',
                  labelText: "Your Name",
                  controller: nameController,
                ),
                if (nameError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4),
                    child: Text(nameError!,
                        style: TextStyle(color: Colors.red, fontSize: 11)),
                  ),
                15.0.heightbox,
                PrimaryTextField(
                  bordercolor: kPrimaryColor.withValues(alpha: .5),
                  hintText: 'write your email',
                  labelText: "Email Address",
                  controller: emailController,
                ),
                if (emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4),
                    child: Text(emailError!,
                        style: TextStyle(color: Colors.red, fontSize: 11)),
                  ),
                15.0.heightbox,
                PrimaryTextField(
                  bordercolor: kPrimaryColor.withValues(alpha: .5),
                  hintText: 'write your messegae here..',
                  labelText: "Your Message",
                  controller: messageController,
                  // maxLines: 5,
                ),
                if (messageError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4),
                    child: Text(messageError!,
                        style: TextStyle(color: Colors.red, fontSize: 11)),
                  ),
                40.0.heightbox,
                isSubmitting
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(
                        buttonText: "Submit",
                        width: context.width / 4,
                        onPressFunction: _submitForm,
                      ),
                20.0.heightbox,
                StyledContainer(
                  boxShadow: [],
                  borderColor: kPrimaryColor.withValues(alpha: .5),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In order to resolve a complaint regarding the Site or to receive further information regarding use of the Site, please contact us at:\n\nChampion Footballer\nFirst Floor\n85 Great Portland St,\nLondon, England,\nW1W 7LL\nEmail: championfootballer@outlook.com',
                        style: TextStyle(
                          fontSize: 12,
                          color: ktextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
