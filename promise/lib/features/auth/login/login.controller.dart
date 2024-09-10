import 'package:get/get.dart';
import 'package:promise/main.dart';
import 'package:promise/networks/getx_api.state.dart';
import 'package:promise/widgets/loading_overlay.dart';
class LoginState extends NetworkState {

}
class LoginController extends GetxController {
  late var loginState = LoginState().obs;

  login(String username, String password) async {
    await loadingOverlay.during(userManager.login(username, password));
  }
}