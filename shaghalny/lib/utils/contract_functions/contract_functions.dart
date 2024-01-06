import 'dart:typed_data';

class ContractFunctions{

  static String fromImageToString(Uint8List image){
    String str = "";
    for (int i = 0; i < image.length; i++) {
      if (i < image.length - 1) {
        str += "${image[i]}" + ",";
      } else {
        str += "${image[i]}";
      }
    }
    return str;
  }


  static Uint8List fromStringToUint8List(String contract){
    List <int> list = contract.split(',').map(int.parse).toList();
    Uint8List bytes = Uint8List.fromList(list);
    return bytes;
  }
}