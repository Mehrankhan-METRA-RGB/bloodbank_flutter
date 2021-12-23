

import 'package:get/get.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController{
  final _googleSignIn=GoogleSignIn();
  var googleAccount=Rx<GoogleSignInAccount?>(null);
void login()async {
  googleAccount.value=await _googleSignIn.signIn();
}
  void logout()async {
  await _googleSignIn.signOut();
  }
Future<bool?> isSignedIn()async{
 return await _googleSignIn.isSignedIn() ;
}

void signInOptions()async {
  googleAccount.value=( _googleSignIn.signInOption) as GoogleSignInAccount?;
}

}


