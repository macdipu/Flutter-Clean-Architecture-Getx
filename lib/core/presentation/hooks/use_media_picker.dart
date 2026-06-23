import 'dart:io';

import 'package:customer/core/presentation/hooks/use_permission.dart';
import 'package:customer/core/presentation/widgets/snackbar/custom_snackbar.dart';
import 'package:customer/services/others/media_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickOptions {
  final ImageSource source;
  final double? maxWidth;
  final double? maxHeight;
  final int? imageQuality;

  const ImagePickOptions({
    this.source = ImageSource.gallery,
    this.maxWidth,
    this.maxHeight,
    this.imageQuality,
  });
}

class FilePickOptions {
  final FileType type;
  final List<String>? allowedExtensions;
  final bool allowMultiple;

  const FilePickOptions({
    this.type = FileType.any,
    this.allowedExtensions,
    this.allowMultiple = false,
  });
}

typedef ImagePickerResult = (File?, Future<void> Function(BuildContext));
typedef FilePickerResult = (List<File>?, bool, Future<void> Function());


ImagePickerResult useImagePicker({double? maxWidth, double? maxHeight, int? imageQuality}) {
  final pickedFile = useState<File?>(null);

  Future<File?> _crop(BuildContext context, File raw) async {
    final cropped = await ImageCropper().cropImage(
      sourcePath: raw.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Theme.of(context).colorScheme.primary,
          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          lockAspectRatio: true,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true, resetAspectRatioEnabled: false),
      ],
    );
    if (cropped == null) return null;
    return File(cropped.path);
  }

  Future<void> _pickFromSource(BuildContext context, ImageSource source) async {
    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final current = await permission.request();
    if (!current.isGranted && !current.isLimited) {
      final msg = source == ImageSource.camera
          ? 'Camera access is required. Please grant permission in Settings.'
          : 'Photo library access is required. Please grant permission in Settings.';
      CustomSnackbar.error(msg);
      return;
    }
    final result = await MediaService.instance.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    await result.fold(
      (failure) async => CustomSnackbar.error(failure.message),
      (file) async {
        if (file == null) return;
        final cropped = await _crop(context, file);
        pickedFile.value = cropped ?? file;
      },
    );
  }

  Future<void> pick(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.camera),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromSource(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.image),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromSource(context, ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  return (pickedFile.value, pick);
}

FilePickerResult useFilePicker({FilePickOptions options = const FilePickOptions()}) {
  final (status, isChecking, requestPermission) = usePermission(Permission.storage);
  final pickedFiles = useState<List<File>?>(null);

  Future<void> pick() async {
    if (!status.isGranted) {
      await requestPermission();
    }

    final current = await Permission.storage.status;
    if (!current.isGranted) {
      CustomSnackbar.error(
        'Storage access is required to pick files. Please grant permission in Settings.',
      );
      return;
    }

    final result = await MediaService.instance.pickFiles(
      type: options.type,
      allowedExtensions: options.allowedExtensions,
      allowMultiple: options.allowMultiple,
    );
    result.fold(
      (failure) => CustomSnackbar.error(failure.message),
      (files) {
        if (files.isNotEmpty) pickedFiles.value = files;
      },
    );
  }

  return (pickedFiles.value, isChecking, pick);
}
