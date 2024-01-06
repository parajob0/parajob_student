import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  final ImagePicker _imagePicker;

  final ImageCropper _imageCropper;

  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) async {
    return _imagePicker.pickImage(source: source, imageQuality: 100);
  }

  Future<CroppedFile?> cropImage(
      {required XFile file, CropStyle cropStyle = CropStyle.circle}) async {
    return _imageCropper.cropImage(
      sourcePath: file.path,
      cropStyle: cropStyle,
      compressQuality: 100,
      uiSettings: [
        IOSUiSettings(),
        AndroidUiSettings(),
      ]
    );
  }
}
