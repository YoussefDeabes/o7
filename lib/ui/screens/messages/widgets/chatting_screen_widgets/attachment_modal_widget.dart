import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart' as mime;
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:path_provider/path_provider.dart';

class AttachmentModalWidget extends BaseStatelessWidget {
  final Function(File file, CustomMessageType type) sendFileMessage;

  AttachmentModalWidget({super.key, required this.sendFileMessage});
  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 96),
      child: Dialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.bottomCenter,
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 220,
          width: double.infinity,
          alignment: AlignmentDirectional.center,
          decoration: const BoxDecoration(
              color: ConstColors.appWhite,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            primary: true,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            padding: const EdgeInsets.all(4.0),
            children: <Widget>[
              _BottomSheetIconButtonWithLabel(
                assetPath: AssPath.galleryIcon,
                label: translate(LangKeys.gallery),
                onTap: () async {
                  final File? file =
                      await _showImagePicker(ImageSource.gallery);
                  if (file != null) {
                    sendFileMessage(file, CustomMessageType.image);
                    _popBottomSheet(context);
                  }
                },
              ),
              _BottomSheetIconButtonWithLabel(
                assetPath: AssPath.cameraIcon,
                label: translate(LangKeys.camera),
                onTap: () async {
                  final file = await _showImagePicker(ImageSource.camera);

                  if (file != null) {
                    sendFileMessage(file, CustomMessageType.image);
                    _popBottomSheet(context);
                  }
                },
              ),
              _BottomSheetIconButtonWithLabel(
                assetPath: AssPath.documentIcon,
                label: translate(LangKeys.document),
                onTap: () async {
                  final File? file = await _showDocumentPicker(context);
                  if (file != null) {
                    sendFileMessage(file, CustomMessageType.document);

                    _popBottomSheet(context);
                  }
                },
              ),
              _BottomSheetIconButtonWithLabel(
                assetPath: AssPath.headPhoneIcon,
                label: translate(LangKeys.audio),
                onTap: () async {
                  final File? file = await _showAudioPicker(FileType.audio);
                  if (file != null) {
                    sendFileMessage(file, CustomMessageType.audio);
                    _popBottomSheet(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _showImagePicker(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<File?> _showAudioPicker(FileType fileType) async {
    /// Lets the user pick one file; files with any file extension can be selected
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: false,
      withReadStream: true,
      allowCompression: true,
      withData: true,
    );

    /// The result will be null, if the user aborted the dialog
    if (result != null) {
      return await _convertPlatformFileToFile(result.files.first);
    }
    return null;
  }

  Future<File?> _showDocumentPicker(BuildContext context) async {
    /// Lets the user pick one file; files with any file extension can be selected
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      withReadStream: true,
      allowCompression: true,
      withData: true,
      allowedExtensions: [
        'svg',
        'pdf',
        'DOC',
        'doc',
        'docx',
        'html',
        'htm',
        'odt',
        'xls',
        'xlsx',
        'ods',
        'ppt',
        'pptx',
        'txt',
      ],
    );

    /// The result will be null, if the user aborted the dialog
    if (result != null) {
      return await _convertPlatformFileToFile(result.files.first);
    }
    return null;
  }

  void _popBottomSheet(BuildContext context) =>
      Navigator.canPop(context) ? Navigator.pop(context) : null;

  Future<File?> _convertPlatformFileToFile(PlatformFile platformFile) async {
    /// if the current platform is android
    /// - there will be an issue if I got the file from storage
    /// - sometime there is no extension in the end of the file name
    /// - so i need to get the extension using mime package
    /// - and get the file name
    /// - then create new file (with the name and extension )
    /// - also write data from picked file to the new file
    /// - > return the new file
    if (Platform.isAndroid) {
      final Directory tempDir = await getTemporaryDirectory();
      final String? mimeName = mime.lookupMimeType(
        platformFile.identifier!,
        headerBytes: platformFile.bytes!.toList(),
      );
      final String extension = mime.extensionFromMime(mimeName ?? "");
      final String fullPath = "${tempDir.path}/${platformFile.name}.$extension";
      debugPrint("fullPath: $fullPath");
      final File file = File(fullPath);
      final RandomAccessFile raf = file.openSync(mode: FileMode.write);
      await raf.writeFrom(platformFile.bytes!.toList());
      await raf.close();
      return file;
    } else if (Platform.isIOS) {
      return File(platformFile.path!);
    } else {
      return null;
    }
  }
}

class _BottomSheetIconButtonWithLabel extends StatelessWidget {
  const _BottomSheetIconButtonWithLabel({
    super.key,
    this.onTap,
    required this.label,
    required this.assetPath,
  });
  final void Function()? onTap;
  final String label;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: const Size(80, 80),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(assetPath),
                  const SizedBox(height: 8.0),
                  FittedBox(
                      child: Text(
                    label,
                    style: const TextStyle(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
