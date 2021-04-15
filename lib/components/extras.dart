import 'package:image_picker/image_picker.dart';

class Extra {
  //Si fromCamera es true abre la camara, sino abre la galeria
  static Future<PickedFile> pickImage(bool fromCamera) async {
    final ImagePicker picker = ImagePicker();
    final PickedFile file = await picker.getImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    return file;
  }
}
