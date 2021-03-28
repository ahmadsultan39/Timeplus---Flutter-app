import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class DBHelper {
  static final keyApplicationId = 'U210LBiGPhL2QdrR8fehohtrooI37mj4CGuafpJQ';
  static final keyClientKey = '78W4ezRyLD8Mkacjb1AjNSI4ON9taRAKFLUeQzFI';
  // static final keyRESTapikey = 'Ilw2Bh3IyR15FL6xlScb8z1INtK1gh5XOD4uxSiI';
  static final keyParseServerUrl = 'https://parseapi.back4app.com';
  static Future<void> init() async {
    await Parse().initialize(keyApplicationId, keyParseServerUrl,
        clientKey: keyClientKey, autoSendSessionId: true);
  }
}
