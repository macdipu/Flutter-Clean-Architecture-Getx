// Windows implementation stub — win32 API removed for cross-version compatibility.
// This app targets Android/iOS; the Windows picker is never invoked at runtime.

import 'dart:typed_data';

import 'package:file_picker/src/api/file_picker_types.dart';
import 'package:file_picker/src/api/file_picker_result.dart';
import 'package:file_picker/src/platform/file_picker_platform_interface.dart';

class FilePickerWindows extends FilePickerPlatform {
  static void registerWith() {}

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
    bool cancelUploadOnWindowBlur = true,
  }) async =>
      null;

  @override
  Future<String?> saveFile({
    String? dialogTitle,
    String? fileName,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Uint8List? bytes,
    bool lockParentWindow = false,
  }) async =>
      null;

  @override
  Future<String?> getDirectoryPath({
    String? dialogTitle,
    bool lockParentWindow = false,
    String? initialDirectory,
  }) async =>
      null;

  @override
  Future<bool?> clearTemporaryFiles() async => true;
}
