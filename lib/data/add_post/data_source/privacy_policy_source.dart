import 'package:flutter/services.dart';

class PrivacyPolicySource {
  Future<String> getPrivacyPolicy() async {
    return await rootBundle.loadString(
      'assets/privacy_policy/0d029ddc-be7f-4095-8c22-44034674390a_en.md',
    );
  }

  Future<String> getTeramsAndConditions() async {
    return await rootBundle.loadString(
      'assets/tearms_and_conditions/0152eb70-a9db-418d-b6ab-9552a2f96828_en.md',
    );
  }
}