import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';

class DynamicLinkService {
  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        debugPrint("Open Deep Link: $deepLink");
        String invitedId = deepLink.queryParameters["id"];
        prefs.setString(inviteKey, invitedId);
      }

      FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
        debugPrint("Open Dynamic Link: ${dynamicLink.link}");
        if (dynamicLink.link.toString().isNotEmpty) {
          final String invitedId = Uri.parse(dynamicLink.link.toString()).queryParameters["id"];
          prefs.setString(inviteKey, invitedId);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Uri> createInviteDynamicLink({String inviteId = ""}) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://reasobi.page.link',
      link: Uri.parse('https://reasobi.page.link.com/invite?id=$inviteId'),
      androidParameters: AndroidParameters(
        packageName: 'com.monapk.d_2008',
        minimumVersion: 1,
        // TODO: アプリDLサイトへ変更
        fallbackUrl: Uri.parse('https://twitter.com/home'),
      ),
      // TODO: iOS
      iosParameters: IosParameters(
        bundleId: 'your_ios_bundle_identifier',
        minimumVersion: '1',
        appStoreId: 'your_app_store_id',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }
}
