import 'package:get/get.dart';

class Pagethreecontroller extends GetxController{

  String? name;
@override
  void onInit(){
  name = Get.arguments['name'];
  super.onInit();
}
}