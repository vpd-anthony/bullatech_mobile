import 'dart:convert';
import 'package:bullatech/common/constants/auth_keys.dart';
import 'package:bullatech/core/models/auth_user.dart';
import 'package:bullatech/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:flutter/material.dart';

extension AuthUserStorage on AuthLocalDataSource {
  /// Save employee/user data
  Future<void> saveEmployeeUser(final AuthUser user) async {
    final jsonString = jsonEncode(user.toJson());
    await storage.write(key: AuthKeys.employeeUser, value: jsonString);
  }

  /// Read employee/user data
  Future<AuthUser?> getEmployeeUser() async {
    final jsonString = await storage.read(key: AuthKeys.employeeUser);
    if (jsonString == null) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return AuthUser.fromJson(jsonMap);
  }

  /// Update employee/user data
  Future<void> updateEmployeeUser(final AuthUser user) async {
    await saveEmployeeUser(user);
  }

  /// Debug log full employee/user data
  Future<void> logDetailedEmployeeUserData() async {
    final user = await getEmployeeUser();
    if (user == null) {
      debugPrint('No employee user data found.');
      return;
    }
    final json = const JsonEncoder.withIndent('  ').convert(user.toJson());
    debugPrint('================ EMPLOYEE USER DATA ================');
    debugPrint(json);
    debugPrint('====================================================');
  }
}
