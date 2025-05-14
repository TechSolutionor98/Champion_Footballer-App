// import 'dart:io';
// import 'package:champion_footballer/Utils/appextensions.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:image_picker/image_picker.dart';

// import '../Utils/packages.dart';

// class ProfileProvider with ChangeNotifier {


//   File? _selectedImage;


//   File? get getselectedImage => _selectedImage;

//   final ImagePicker _picker = ImagePicker();


//   // Pick image from gallery
//   Future<void> getImageFromGallery() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _selectedImage = File(pickedFile.path);
//       notifyListeners();
//     }
//   }

//   // Pick image from camera
//   Future<void> getImageFromCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       _selectedImage = File(pickedFile.path);
//       notifyListeners();
//     }
//   }

//   // Change the photo
//   void _changePhoto(BuildContext context) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         actions: [
//           Container(
//             color: kPrimaryColor,
//             child: CupertinoActionSheetAction(
//               child: const Text(
//                 'Photo Gallery',
//                 style: TextStyle(color: kdefwhiteColor, fontSize: 14),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 getImageFromGallery();
//               },
//             ),
//           ),
//           Container(
//             color: kPrimaryColor,
//             child: CupertinoActionSheetAction(
//               child: const Text(
//                 'Camera',
//                 style: TextStyle(color: kdefwhiteColor, fontSize: 14),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 getImageFromCamera();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Show image options
//   Future<void> showOptions(BuildContext context) async {
//     await showCupertinoModalPopup(
//       context: context,
//       builder: (context) => CupertinoActionSheet(
//         actions: [
//           Container(
//             color: kPrimaryColor,
//             child: CupertinoActionSheetAction(
//               child: const Text(
//                 'View Picture',
//                 style: TextStyle(color: kdefwhiteColor, fontSize: 14),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _viewPhoto(context);
//               },
//             ),
//           ),
//           3.0.heightbox,
//           const Divider(color: kdefgreyColor, height: 0),
//           3.0.heightbox,
//           Container(
//             color: kPrimaryColor,
//             child: CupertinoActionSheetAction(
//               child: const Text(
//                 'Change Picture',
//                 style: TextStyle(color: kdefwhiteColor, fontSize: 14),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _changePhoto(context);
//               },
//             ),
//           ),
//         ],
//         cancelButton: CupertinoActionSheetAction(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text('Cancel',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: kPrimaryColor,
//                 fontSize: 14,
//               )),
//         ),
//       ),
//     );
//   }

//   // View the current photo
//   void _viewPhoto(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(6),
//             color: Colors.white,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _selectedImage != null
//                   ? ClipRRect(
//                       borderRadius: BorderRadius.circular(4),
//                       child: Image.file(_selectedImage!,
//                           width: 300, height: 350, fit: BoxFit.cover),
//                     )
//                   : const Text('No picture available'),
//               10.0.heightbox,
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Close'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../Utils/appextensions.dart';
import '../Utils/packages.dart';

class ProfileNotifier extends Notifier<File?> {
  final ImagePicker _picker = ImagePicker();

  @override
  File? build() => null;

  File? get selectedImage => state;

  Future<void> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state = File(pickedFile.path);
    }
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      state = File(pickedFile.path);
    }
  }

  void showOptions(BuildContext context, WidgetRef ref) async {
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text('View Picture',
                  style: TextStyle(color: kdefwhiteColor, fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
                _viewPhoto(context, ref);
              },
            ),
          ),
          3.0.heightbox,
          const Divider(color: kdefgreyColor, height: 0),
          3.0.heightbox,
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text('Change Picture',
                  style: TextStyle(color: kdefwhiteColor, fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
                _changePhoto(context, ref);
              },
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                  fontSize: 14)),
        ),
      ),
    );
  }

  void _changePhoto(BuildContext context, WidgetRef ref) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text('Photo Gallery',
                  style: TextStyle(color: kdefwhiteColor, fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(profileProvider.notifier).getImageFromGallery();
              },
            ),
          ),
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text('Camera',
                  style: TextStyle(color: kdefwhiteColor, fontSize: 14)),
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(profileProvider.notifier).getImageFromCamera();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _viewPhoto(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.file(state!,
                          width: 300, height: 350, fit: BoxFit.cover),
                    )
                  : const Text('No picture available'),
              10.0.heightbox,
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, File?>(
  () => ProfileNotifier(),
);
