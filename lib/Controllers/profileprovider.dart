import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Added for WidgetRef
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';
import '../Utils/appextensions.dart';
import '../Utils/packages.dart';
import '../Services/RiverPord Provider/ref_provider.dart'; // For uploadProfilePicture
import '../Model/Api Models/usermodel.dart';


class ProfileSelectionUpdateState {
  final File? selectedFile;
  final bool isAutoUploading;

  ProfileSelectionUpdateState({
    this.selectedFile,
    this.isAutoUploading = false,
  });

  ProfileSelectionUpdateState copyWith({
    File? selectedFile,
    bool? isAutoUploading,
    bool clearSelectedFile = false,
  }) {
    return ProfileSelectionUpdateState(
      selectedFile: clearSelectedFile ? null : (selectedFile ?? this.selectedFile),
      isAutoUploading: isAutoUploading ?? this.isAutoUploading,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileSelectionUpdateState> {
  final ImagePicker _picker = ImagePicker();

  @override
  ProfileSelectionUpdateState build() => ProfileSelectionUpdateState();

  Future<File?> getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final newFile = File(pickedFile.path);
      state = state.copyWith(selectedFile: newFile, isAutoUploading: false); 
      return newFile;
    }
    return null;
  }

  Future<File?> getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final newFile = File(pickedFile.path);
      state = state.copyWith(selectedFile: newFile, isAutoUploading: false); 
      return newFile;
    }
    return null;
  }

  void clearSelectionState() {
    state = ProfileSelectionUpdateState();
  }

  void clearSelectedFileOnly() {
    state = state.copyWith(clearSelectedFile: true);
  }

  void _changePhoto(BuildContext sheetContext, WidgetRef ref, {required BuildContext originalContext, bool autoUpload = false}) {
    showCupertinoModalPopup(
      context: sheetContext, 
      builder: (context) => CupertinoActionSheet(
        actions: [
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text(
                'Photo Gallery',
                style: TextStyle(color: kdefwhiteColor, fontSize: 14),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); 
                File? newFile = await getImageFromGallery(); 
                if (newFile != null) {
                  if (autoUpload) {
                    await _initiateAutoUpload(newFile, ref, originalContext); 
                  }
                }
              },
            ),
          ),
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text(
                'Camera',
                style: TextStyle(color: kdefwhiteColor, fontSize: 14),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); 
                File? newFile = await getImageFromCamera(); 
                 if (newFile != null) {
                  if (autoUpload) {
                    await _initiateAutoUpload(newFile, ref, originalContext); 
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initiateAutoUpload(File imageFile, WidgetRef ref, BuildContext originalContext) async {
    state = state.copyWith(isAutoUploading: true); 
    try {
      await uploadProfilePicture(ref: ref, profileImageFile: imageFile); 
      
       if (originalContext.mounted) {
        toastification.show(
          context: originalContext,
          type: ToastificationType.success,
          style: ToastificationStyle.fillColored,
          title: Text('Picture Updated'),
          description: Text('Profile picture updated successfully!'),
          autoCloseDuration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print("Error auto-uploading profile picture: $e");
      if (originalContext.mounted) {
        toastification.show(
          context: originalContext,
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          title: Text('Upload Failed'),
          description: Text('Failed to upload picture: ${e.toString()}'),
          autoCloseDuration: const Duration(seconds: 5),
        );
      }
    } finally {
      state = ProfileSelectionUpdateState(); 
    }
  }

  void showOptions(BuildContext screenContext, WidgetRef ref, {bool autoUpload = false}) async {
    await showCupertinoModalPopup(
      context: screenContext, 
      builder: (sheetBuilderContext) => CupertinoActionSheet( 
        actions: [
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text(
                'View Picture',
                style: TextStyle(color: kdefwhiteColor, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(sheetBuilderContext).pop(); 
                _viewPhoto(screenContext, ref); 
              },
            ),
          ),
          3.0.heightbox,
          const Divider(color: kdefgreyColor, height: 0),
          3.0.heightbox,
          Container(
            color: kPrimaryColor,
            child: CupertinoActionSheetAction(
              child: const Text(
                'Change Picture',
                style: TextStyle(color: kdefwhiteColor, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(sheetBuilderContext).pop();
                _changePhoto(screenContext, ref, originalContext: screenContext, autoUpload: autoUpload);
              },
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.of(sheetBuilderContext).pop();
          },
          child: const Text('Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
                fontSize: 14,
              )),
        ),
      ),
    );
  }

  void _viewPhoto(BuildContext screenContext, WidgetRef ref) {
    final File? localFile = state.selectedFile;
    final String? networkImageUrl = ref.read(userDataProvider).asData?.value?.pictureKey;

    ImageProvider? imageProviderToShow;

    if (localFile != null) {
      imageProviderToShow = FileImage(localFile);
    } else if (networkImageUrl != null && networkImageUrl.isNotEmpty) {
      imageProviderToShow = NetworkImage(networkImageUrl);
    }

    showDialog(
      context: screenContext,
      builder: (dialogContext) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: [
              if (imageProviderToShow != null)
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                  child: Image(
                    image: imageProviderToShow,
                    width: 300, 
                    height: 350,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox( 
                        height: 350,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      print("Error loading image in _viewPhoto: $error");
                      return const SizedBox( 
                        height: 350,
                        child: Center(child: Text('Error displaying image.')),
                      );
                    },
                  ),
                )
              else
                Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: const Text('No picture available for preview.', textAlign: TextAlign.center),
                ),
              Padding( 
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileSelectionUpdateState>(
  () => ProfileNotifier(),
);
