import 'package:d_2008/di/get_it.dart';
import 'package:dart_twitter_api/api/twitter_client.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../../env_constants.dart';

class TwitterRequest {
  SharedPreferences prefs;
  TwitterApi twitterApi;

  TwitterRequest() {
    this.prefs = getItInstance.get<SharedPreferences>();
    this.twitterApi = TwitterApi(
      client: TwitterClient(
        consumerKey: twitterConsumerKey,
        consumerSecret: twitterSecretConsumerKey,
        token: prefs.getString(twitterAccessToken),
        secret: prefs.getString(twitterSecret),
      ),
    );
  }

  Future<void> postTweet(String tweet) async {
    try {
      twitterApi.tweetService.update(status: tweet);
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
