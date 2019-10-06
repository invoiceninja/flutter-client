import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:invoiceninja_flutter/data/models/serializers.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/data/web_client.dart';

class SettingsRepository {
  const SettingsRepository({
    this.webClient = const WebClient(),
  });

  final WebClient webClient;

  Future<CompanyEntity> saveCompany(
      Credentials credentials, CompanyEntity company,
      [EntityAction action]) async {
    final data = serializers.serializeWith(CompanyEntity.serializer, company);
    dynamic response;

    final url = credentials.url + '/companies/${company.id}';
    response =
        await webClient.put(url, credentials.token, data: json.encode(data));

    final CompanyItemResponse companyResponse =
        serializers.deserializeWith(CompanyItemResponse.serializer, response);

    return companyResponse.data;
  }

  Future<UserEntity> saveUser(Credentials credentials, UserEntity user) async {
    final data = serializers.serializeWith(UserEntity.serializer, user);
    dynamic response;

    final url = credentials.url + '/users/${user.id}';
    response =
        await webClient.put(url, credentials.token, data: json.encode(data));

    final UserItemResponse userResponse =
        serializers.deserializeWith(UserItemResponse.serializer, response);

    return userResponse.data;
  }

  Future<CompanyEntity> uploadLogo(
      Credentials credentials, String companyId, String path) async {
    final url = '${credentials.url}/companies/$companyId';

    final dynamic response = await webClient.post(url, credentials.token,
        data: {'_method': 'PUT'}, filePath: path, fileIndex: 'logo');

    final CompanyItemResponse companyResponse =
        serializers.deserializeWith(CompanyItemResponse.serializer, response);

    return companyResponse.data;
  }
}
