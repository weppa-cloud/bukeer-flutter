import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../config/app_config.dart';
import 'api_manager.dart';
export 'api_manager.dart' show ApiCallResponse;

class GetContactSearchCall {
  static Future<ApiCallResponse> call({
    String? search = '',
    String? authToken = '',
    int? pageNumber,
    int? pageSize,
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${search}",
  "type": "${type}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getContactSearch',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_contacts_search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<bool>? isCompany(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_company''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
  static List<bool>? isClient(dynamic response) => (getJsonField(
        response,
        r'''$[:].is_client''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class GetContactIdCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getContactId',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts?id=eq.${id}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? dataAll(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      ) as List?;
  static bool? isProvider(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].is_provider''',
      ));
  static bool? isClient(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].is_client''',
      ));
  static String? name(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].name''',
      ));
  static String? email(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].email''',
      ));
  static String? phone(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].phone''',
      ));
  static String? address(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].address''',
      ));
  static bool? isCompany(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].is_company''',
      ));
  static String? phone2(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].phone2''',
      ));
  static String? website(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].website''',
      ));
  static String? typeID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].type_id''',
      ));
  static String? numberID(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].number_id''',
      ));
  static String? lastName(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].last_name''',
      ));
}

class UpdateContactCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? name = '',
    String? lastName = '',
    String? phone = '',
    String? phone2 = '',
    bool? isCompany = false,
    String? email = '',
    String? typeId = '',
    String? numberId = '',
    String? userRol = '',
    String? address = '',
    String? nationality = '',
    String? birthDate = '',
    bool? isProvider,
    bool? isClient,
    String? authToken = '',
    String? location = '',
    String? userImage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "last_name": "${lastName}",
  "type_id": "${typeId}",
  "number_id": "${numberId}",
  "is_company": "${isCompany}",
  "user_rol": "${userRol}",
  "phone": "${phone}",
  "phone2": "${phone2}",
  "email": "${email}",
  "nationality": "${nationality}",
  "birth_date": "${birthDate}",
  "is_client": ${isClient},
  "is_provider": ${isProvider},
  "user_image": "${userImage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateContact',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserRolesCall {
  static Future<ApiCallResponse> call({
    String? userId = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'GetUserRoles',
      apiUrl: '${AppConfig.apiBaseUrl}/user_roles_view',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {
        'user_id': userId,
        'select': "*",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateUserContactCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? name = '',
    String? lastName = '',
    String? userRol = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "last_name": "${lastName}",
  "user_rol": "${userRol}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateUserContact',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertContactCall {
  static Future<ApiCallResponse> call({
    String? lastName = '',
    String? phone = '',
    String? nationality = '',
    String? name = '',
    String? email = '',
    String? typeId = '',
    String? numberId = '',
    String? address = '',
    bool? isCompany,
    String? phone2 = '',
    String? userImage = '',
    String? birthDate = '',
    bool? isProvider,
    bool? isClient,
    String? authToken = '',
    String? location = '',
    String? accountId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "last_name": "${lastName}",
  "phone": "${phone}",
  "nationality": "${nationality}",
  "name": "${name}",
  "type_id": "${typeId}",
  "number_id": "${numberId}",
  "is_company": ${isCompany},
  "phone2": "${phone2}",
  "user_image": "${userImage}",
  "birth_date": "${birthDate}",
  "is_client": ${isClient},
  "is_provider": ${isProvider},
  "email": "${email}",
  "location": "${location}",
  "account_id": "${accountId}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertContact',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic all(dynamic response) => getJsonField(
        response,
        r'''$[:]''',
      );
}

class AddUserCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? password = '',
  }) async {
    final ffApiRequestBody = '''
{
  "email": "${email}",
  "password": "${password}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'AddUser',
      apiUrl: 'https://wzlxbpicdcdvxvdcvgas.supabase.co/auth/v1/signup',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddUserContactCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? lastName = '',
    String? email = '',
    String? userRole = '',
    String? idUserAuth = '',
    String? authToken = '',
    String? accountId = '',
    String? userImage =
        'https://wzlxbpicdcdvxvdcvgas.supabase.co/storage/v1/object/public/images/assets/profile_default.png',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "last_name": "${lastName}",
  "email": "${email}",
  "user_rol": "${userRole}",
  "user_id": "${idUserAuth}",
  "account_id": "${accountId}",
  "user_image": "${userImage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addUserContact',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUsersCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getUsers',
      apiUrl:
          '${AppConfig.apiBaseUrl}/user_contact_info?select=*&or=(name.ilike.*${searchTerm}*,email.ilike.*${searchTerm}*)',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetActivitiesCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getActivities',
      apiUrl:
          '${AppConfig.apiBaseUrl}/activities_view?id_contact=eq.${id}&select=*&order=updated_at.desc',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetHotelsByIdProviderCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getHotelsByIdProvider',
      apiUrl:
          '${AppConfig.apiBaseUrl}/hotels_view?id_contact=eq.${id}&select=*&order=updated_at.desc',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTransfersByIdProviderCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getTransfersByIdProvider',
      apiUrl:
          '${AppConfig.apiBaseUrl}/transfers_view?id_contact=eq.${id}&select=*&order=updated_at.desc',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetItinerariesByContactCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getItinerariesByContact',
      apiUrl:
          '${AppConfig.apiBaseUrl}/itineraries?id_contact=eq.${id}&select=*&order=updated_at.desc',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetItinerariesCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getItineraries',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProductsByTypeCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? location = '',
    String? type = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "location_param": "${location}",
  "searchterm": "${searchTerm}",
  "typeproduct": "${type}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsByType',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_products',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProductsByTypePaginatedTestCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? location = '',
    String? type = '',
    int? pageNumber,
    int? pageSize,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "location_param": "${location}",
  "searchterm": "${searchTerm}",
  "typeproduct": "${type}",
  "page_number": ${pageNumber},
  "page_size": ${pageSize}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsByTypePaginatedTest',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/get_products_paginated_test',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProductsByTypePaginatedCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? location = '',
    String? type = '',
    int? pageSize,
    int? pageNumber,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "location_param": "${location}",
  "searchterm": "${searchTerm}",
  "typeproduct": "${type}",
  "page_size": ${pageSize},
  "page_number": ${pageNumber}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsByTypePaginated',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_products_paginated',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProductsFromViewsCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? type = '',
    int? pageSize,
    int? pageNumber,
    String? authToken = '',
    String? location = '',
  }) async {
    final ffApiRequestBody = '''
{
  "search": "${searchTerm}",
  "type": "${type}",
  "page_size": ${pageSize},
  "page_number": ${pageNumber},
  "location": "${location}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsFromViews',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_products_from_views',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List? data(dynamic response) => getJsonField(
        response,
        r'''$''',
        true,
      ) as List?;
  static List? payload(dynamic response) => getJsonField(
        response,
        r'''$.payload''',
        true,
      ) as List?;
  static List<String>? id(dynamic response) => (getJsonField(
        response,
        r'''$.payload[:].id''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? name(dynamic response) => (getJsonField(
        response,
        r'''$.payload[:].name''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? description(dynamic response) => (getJsonField(
        response,
        r'''$.payload[:].description''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? descriptionShort(dynamic response) => (getJsonField(
        response,
        r'''$.payload[:].description_short''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
  static List<String>? mainImage(dynamic response) => (getJsonField(
        response,
        r'''$.payload[:].main_image''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class GetRelatedContactCall {
  static Future<ApiCallResponse> call({
    String? contactId = '',
    String? authToken = '',
    int? pageNumber,
    int? pageSize,
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "contact_id": "${contactId}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getRelatedContact',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_contacts_related',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetLocationsByProductCall {
  static Future<ApiCallResponse> call({
    String? typeproduct = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_type": "${typeproduct}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getLocationsByProduct',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_locations_products',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddActivityCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? description = '',
    String? type = '',
    String? inclutions = '',
    String? exclutions = '',
    String? recomendations = '',
    String? instructions = '',
    String? idContact = '',
    String? authToken = '',
    String? accountId = '',
    String? location = '',
    String? descriptionShort = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "description": "${description}",
  "type": "${type}",
  "inclutions": "${inclutions}",
  "exclutions": "${exclutions}",
  "recomendations": "${recomendations}",
  "instructions": "${instructions}",
  "id_contact": "${idContact}",
  "account_id": "${accountId}",
  "location": "${location}",
  "description_short": "${descriptionShort}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addActivity',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_add_activity_test',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateActivityCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? description = '',
    String? type = '',
    String? location = '',
    String? inclutions = '',
    String? exclutions = '',
    String? recomendations = '',
    String? instructions = '',
    String? id = '',
    String? authToken = '',
    String? descriptionShort = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "description": "${description}",
  "experience_type": "${type}",
  "inclutions": "${inclutions}",
  "exclutions": "${exclutions}",
  "recomendations": "${recomendations}",
  "instructions": "${instructions}",
  "description_short": "${descriptionShort}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateActivity',
      apiUrl: '${AppConfig.apiBaseUrl}/activities?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetHotelsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    int? offset,
    int? limit,
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getHotels',
      apiUrl: '${AppConfig.apiBaseUrl}/hotels',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {
        'offset': offset,
        'limit': limit,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetRatesByIdProviderCall {
  static Future<ApiCallResponse> call({
    String? idProduct = '',
    String? authToken = '',
    String? typeproduct = '',
  }) async {
    final ffApiRequestBody = '''
{
  "product_id": "${idProduct}",
  "typeproduct": "${typeproduct}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getRatesByIdProvider',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_product_rates',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddOrEditRateProductCall {
  static Future<ApiCallResponse> call({
    String? idProduct = '',
    String? name = '',
    double? price,
    double? unitCost,
    String? authToken = '',
    String? accountId = '',
    String? idRate = '',
    double? profit,
    String? typeaction = '',
    String? typeproduct = '',
  }) async {
    final ffApiRequestBody = '''
{
  "id_product": "${idProduct}",
  "p_name": "${name}",
  "p_price": ${price},
  "p_unit_cost": ${unitCost},
  "account_id": "${accountId}",
  "id_rate": "${idRate}",
  "p_profit": ${profit},
  "typeaction": "${typeaction}",
  "typeproduct": "${typeproduct}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addOrEditRateProduct',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_add_edit_product_rates',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateItineraryForContactCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? startDate = '',
    int? passengerCount,
    String? endDate = '',
    String? validUntil = '',
    String? currencyType = '',
    String? agent = '',
    String? idContact = '',
    String? language = '',
    String? authToken = '',
    String? idCreatedBy = '',
    String? requestType = '',
    String? idFm = '',
    String? accountId = '',
    dynamic currencyJson,
    String? status = '',
    dynamic typesIncreaseJson,
    String? personalizedMessage = '',
    String? mainImage = '',
  }) async {
    final currency = _serializeJson(currencyJson, true);
    final typesIncrease = _serializeJson(typesIncreaseJson, true);
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "itinerary_start_date": "${startDate}",
  "itinerary_passenger_count": ${passengerCount},
  "itinerary_end_date": "${endDate}",
  "itinerary_currency_type": "${currencyType}",
  "itinerary_valid_until": "${validUntil}",
  "itinerary_agent": "${agent}",
  "contact_id": "${idContact}",
  "itinerary_language": "${language}",
  "creator_id": "${idCreatedBy}",
  "itinerary_request_type": "${requestType}",
  "itinerary_id_fm": "${idFm}",
  "account_id": "${accountId}",
  "input_currency": ${currency},
  "itinerary_status": "${status}",
  "input_types_increase": ${typesIncrease},
  "itinerary_personalized_message": "${personalizedMessage}",
"itinerary_main_image":"${mainImage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createItineraryForContact',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_create_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic all(dynamic response) => getJsonField(
        response,
        r'''$[:]''',
      );
}

class GetHotelRatesCall {
  static Future<ApiCallResponse> call({
    String? hotelId = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getHotelRates',
      apiUrl: '${AppConfig.apiBaseUrl}/hotel_rates?hotel_id=eq.${hotelId}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetTransfersRatesCall {
  static Future<ApiCallResponse> call({
    String? transferId = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getTransfersRates',
      apiUrl:
          '${AppConfig.apiBaseUrl}/transfer_rates?id_transfer=eq.${transferId}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetActivitiesRatesCall {
  static Future<ApiCallResponse> call({
    String? idProduct = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getActivitiesRates',
      apiUrl:
          '${AppConfig.apiBaseUrl}/activities_rates?id_product=eq.${idProduct}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddItineraryItemsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? idItinerary = '',
    double? unitCost,
    int? quantity,
    double? totalCost,
    String? date = '',
    int? hotelNights,
    double? profitPercentage,
    double? totalPrice,
    int? unitPrice,
    String? idProduct = '',
    String? productType = '',
    String? destination = '',
    String? productName = '',
    String? rateName = '',
    String? flightDeparture = '',
    String? flightArrival = '',
    String? departureTime = '',
    String? arrivalTime = '',
    String? accountId = '',
    String? personalizedMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "id_itinerary": "${idItinerary}",
  "unit_cost": ${unitCost},
  "quantity": ${quantity},
  "total_cost": ${totalCost},
  "date": "${date}",
  "hotel_nights": ${hotelNights},
  "profit_percentage": ${profitPercentage},
  "id_product": "${idProduct}",
  "product_type": "${productType}",
  "destination": "${destination}",
  "product_name": "${productName}",
  "rate_name": "${rateName}",
  "total_price": ${totalPrice},
"account_id":"${accountId}",
"personalized_message":"${personalizedMessage}",
  "flight_departure": "${flightDeparture}",
  "flight_arrival": "${flightArrival}",
  "departure_time": "${departureTime}",
  "arrival_time": "${arrivalTime}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addItineraryItems',
      apiUrl: '${AppConfig.apiBaseUrl}/itinerary_items',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddItineraryItemsFlightsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? idItinerary = '',
    double? unitCost,
    int? quantity,
    double? totalCost,
    String? date = '',
    int? hotelNights,
    double? profitPercentage,
    double? totalPrice,
    int? unitPrice,
    String? idProduct = '',
    String? productType = '',
    String? destination = '',
    String? productName = '',
    String? rateName = '',
    String? flightDeparture = '',
    String? flightArrival = '',
    String? departureTime = '',
    String? arrivalTime = '',
    String? airline = '',
    String? accountId = '',
    String? personalizedMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "id_itinerary": "${idItinerary}",
  "unit_cost": ${unitCost},
  "quantity": ${quantity},
  "total_cost": ${totalCost},
  "date": "${date}",
  "hotel_nights": ${hotelNights},
  "profit_percentage": ${profitPercentage},
  "id_product": "${idProduct}",
  "product_type": "${productType}",
  "destination": "${destination}",
  "product_name": "${productName}",
  "rate_name": "${rateName}",
  "total_price": ${totalPrice},
  "airline": "${airline}",
  "flight_departure": "${flightDeparture}",
  "flight_arrival": "${flightArrival}",
  "departure_time": "${departureTime}",
  "arrival_time": "${arrivalTime}",
  "account_id": "${accountId}",
"personalized_message":"${personalizedMessage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addItineraryItemsFlights',
      apiUrl: '${AppConfig.apiBaseUrl}/itinerary_items',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryItemsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    double? unitCost,
    int? quantity,
    double? totalCost,
    String? date = '',
    int? hotelNights,
    double? profitPercentage,
    double? totalPrice,
    int? unitPrice,
    String? idProduct = '',
    String? productType = '',
    String? destination = '',
    String? productName = '',
    String? rateName = '',
    String? id = '',
    String? personalizedMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "unit_cost": ${unitCost},
  "quantity": ${quantity},
  "total_cost": ${totalCost},
  "date": "${date}",
  "hotel_nights": ${hotelNights},
  "profit_percentage": ${profitPercentage},
  "id_product": "${idProduct}",
  "product_type": "${productType}",
  "destination": "${destination}",
  "product_name": "${productName}",
  "rate_name": "${rateName}",
  "total_price": ${totalPrice},
"personalized_message":"${personalizedMessage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItineraryItems',
      apiUrl: '${AppConfig.apiBaseUrl}/itinerary_items?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryItemsFlightsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    double? unitCost,
    int? quantity,
    double? totalCost,
    String? date = '',
    double? profitPercentage,
    double? totalPrice,
    int? unitPrice,
    String? idProduct = '',
    String? productType = '',
    String? id = '',
    String? airline = '',
    String? flightDeparture = '',
    String? flightArrival = '',
    String? departureTime = '',
    String? arrivalTime = '',
    String? productName = '',
    String? personalizedMessage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "quantity": ${quantity},
  "id_product": "${idProduct}",
  "product_type": "${productType}",
  "profit_percentage": ${profitPercentage},
  "unit_cost": ${unitCost},
  "date": "${date}",
  "total_price": ${totalPrice},
  "flight_departure": "${flightDeparture}",
  "flight_arrival": "${flightArrival}",
  "departure_time": "${departureTime}",
  "arrival_time": "${arrivalTime}",
  "airline": "${airline}",
  "product_name": "${productName}",
  "personalized_message": "${personalizedMessage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItineraryItemsFlights',
      apiUrl: '${AppConfig.apiBaseUrl}/itinerary_items?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetMediaCall {
  static Future<ApiCallResponse> call({
    String? entityId = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getMedia',
      apiUrl:
          '${AppConfig.apiBaseUrl}/images?entity_id=eq.${entityId}&select=url',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetItinerariesWithDataContactCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getItinerariesWithDataContact',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_itineraries_with_contact_names',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetItinerariesWithDataContactSearchCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? search = '',
    int? pageNumber,
    int? pageSize,
    bool? confirmados,
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${search}",
  "confirmados": ${confirmados}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getItinerariesWithDataContactSearch',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_itineraries_with_contact_names_search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetItinerariesWithDataContactByIdCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itinerary_id": "${itineraryId}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getItinerariesWithDataContactById',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_itineraries_with_id',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProductsItineraryItemsCall {
  static Future<ApiCallResponse> call({
    String? pIdItinerary = '',
    String? pProductType = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_id_itinerary": "${pIdItinerary}",
"p_product_type":"${pProductType}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsItineraryItems',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_products_itinerary_items',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CreateActivityCall {
  static Future<ApiCallResponse> call({
    String? description = '',
    String? exclutions = '',
    String? idContact = '',
    String? inclutions = '',
    String? instructions = '',
    String? location = '',
    String? media = '',
    String? name = '',
    String? recomendations = '',
    String? type = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "description": "${description}",
  "exlutions": "${exclutions}",
  "id_contact": "${idContact}",
  "inclutions": "${inclutions}",
  "instructions": "${instructions}",
  "location": "${location}",
  "media": ${media},
  "name": "${name}",
  "recomendations": "${recomendations}",
  "type": "${type}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'createActivity',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/add_activity5',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class EditRateActivityCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? name = '',
    int? unitCost,
    int? price,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_name": "${name}",
  "p_unit_cost": ${unitCost},
  "p_price": ${price},
  "p_id": "${id}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'editRateActivity',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_update_activity_rate',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateHotelsCall {
  static Future<ApiCallResponse> call({
    String? name = '',
    String? description = '',
    String? inclutions = '',
    String? exclutions = '',
    String? recomendations = '',
    String? instructions = '',
    String? id = '',
    String? authToken = '',
    String? descriptionShort = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "description": "${description}",
  "inclutions": "${inclutions}",
  "exclutions": "${exclutions}",
  "recomendations": "${recomendations}",
  "instructions": "${instructions}",
  "description_short": "${descriptionShort}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateHotels',
      apiUrl: '${AppConfig.apiBaseUrl}/hotels?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateTransfersCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? name = '',
    String? description = '',
    String? location = '',
    String? inclutions = '',
    String? exclutions = '',
    String? recomendations = '',
    String? instructions = '',
    String? authToken = '',
    String? descriptionShort = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "description": "${description}",
  "inclutions": "${inclutions}",
  "exclutions": "${exclutions}",
  "recomendations": "${recomendations}",
  "instructions": "${instructions}",
  "description_short": "${descriptionShort}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateTransfers',
      apiUrl: '${AppConfig.apiBaseUrl}/transfers?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? name = '',
    String? startDate = '',
    int? passengerCount,
    String? endDate = '',
    String? validUntil = '',
    String? currencyType = '',
    String? agent = '',
    String? idContact = '',
    String? language = '',
    String? idCreatedBy = '',
    String? requestType = '',
    String? id = '',
    String? status = '',
    String? personalizedMessage = '',
    String? mainImage = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${name}",
  "start_date": "${startDate}",
  "passenger_count": ${passengerCount},
  "end_date": "${endDate}",
  "currency_type": "${currencyType}",
  "valid_until": "${validUntil}",
  "agent": "${agent}",
  "id_contact": "${idContact}",
  "language": "${language}",
  "id_created_by": "${idCreatedBy}",
  "request_type": "${requestType}",
  "personalized_message": "${personalizedMessage}",
"main_image":"${mainImage}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryStatusCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
    String? status = '',
  }) async {
    final ffApiRequestBody = '''
{
  "status": "${status}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItineraryStatus',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetImagesAndMainImageCall {
  static Future<ApiCallResponse> call({
    String? entityId = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_id": "${escapeStringForJson(entityId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getImagesAndMainImage',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_images_and_main_image',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryVisibilityCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
    String? visibility = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itinerary_visibility": "${visibility}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItineraryVisibility',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetHotelsPaginatedCall {
  static Future<ApiCallResponse> call({
    int? pageNumber,
    int? pageSize,
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getHotelsPaginated',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/get_hotels_paginated',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateItineraryRatesVisibilityCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
    String? visibility = '',
  }) async {
    final ffApiRequestBody = '''
{
  "rates_visibility": "${visibility}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateItineraryRatesVisibility',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAirlinesCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? search = '',
    int? pageSize,
    int? pageNumber,
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAirlines',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_airlines',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetDataItineraryItemsByIdCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getDataItineraryItemsById',
      apiUrl: '${AppConfig.apiBaseUrl}/itineraries?id=eq.${id}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetNationalitiesCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getNationalities',
      apiUrl: '${AppConfig.apiBaseUrl}/nationalities?select=name',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetDocumentTypeCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getDocumentType',
      apiUrl: '${AppConfig.apiBaseUrl}/document_type?select=name',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddPassengerItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? name = '',
    String? lastName = '',
    String? typeId = '',
    String? numberId = '',
    String? nationality = '',
    String? birthDate = '',
    String? itineraryId = '',
    String? accountId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}",
  "last_name": "${escapeStringForJson(lastName)}",
  "type_id": "${escapeStringForJson(typeId)}",
  "number_id": "${escapeStringForJson(numberId)}",
  "nationality": "${escapeStringForJson(nationality)}",
  "birth_date": "${escapeStringForJson(birthDate)}",
  "itinerary_id": "${escapeStringForJson(itineraryId)}",
  "account_id": "${escapeStringForJson(accountId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addPassengerItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/passenger',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPassengersByItineraryIdCall {
  static Future<ApiCallResponse> call({
    String? itineraryId = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getPassengersByItineraryId',
      apiUrl:
          '${AppConfig.apiBaseUrl}/passenger?itinerary_id=eq.${itineraryId}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertLocationsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? latlng = '',
    String? name = '',
    String? address = '',
    String? city = '',
    String? state = '',
    String? country = '',
    String? zipCode = '',
    String? accountId = '',
    String? typeEntity = '',
  }) async {
    final ffApiRequestBody = '''
{
  "latlng": "${escapeStringForJson(latlng)}",
  "name": "${escapeStringForJson(name)}",
  "address": "${escapeStringForJson(address)}",
  "city": "${escapeStringForJson(city)}",
  "state": "${escapeStringForJson(state)}",
  "country": "${escapeStringForJson(country)}",
  "zip_code": "${escapeStringForJson(zipCode)}",
  "account_id": "${escapeStringForJson(accountId)}",
  "type_entity": "${escapeStringForJson(typeEntity)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertLocations',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_insert_location',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TestUsersCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'testUsers',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_user_roles_for_authenticated_user',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatePassengerItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? name = '',
    String? lastName = '',
    String? typeId = '',
    String? numberId = '',
    String? nationality = '',
    String? birthDate = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}",
  "last_name": "${escapeStringForJson(lastName)}",
  "type_id": "${escapeStringForJson(typeId)}",
  "number_id": "${escapeStringForJson(numberId)}",
  "nationality": "${escapeStringForJson(nationality)}",
  "birth_date": "${escapeStringForJson(birthDate)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updatePassengerItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/passenger?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TestPaginatedContactsCall {
  static Future<ApiCallResponse> call({
    int? offset,
    int? limit,
    String? authToken = '',
    String? search = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'testPaginatedContacts',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts?name.eq=${search}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {
        'offset': offset,
        'limit': limit,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SearchProductsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "search": "${escapeStringForJson(search)}",
  "type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'searchProducts',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_search_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetContactWithLocationCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? inputContactId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "input_contact_id": "${escapeStringForJson(inputContactId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getContactWithLocation',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_contact_with_location',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static bool? isClient(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].contact_is_client''',
      ));
  static bool? isCompany(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].contact_is_company''',
      ));
  static bool? isProvider(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$[:].contact_is_provider''',
      ));
}

class GetProductsByTypeLocationSearchCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? location = '',
    int? pageNumber,
    int? pageSize,
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "location_param": "${escapeStringForJson(location)}",
  "page_number": ${pageNumber},
  "page_size": "${pageSize}",
  "search": "${escapeStringForJson(search)}",
  "type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProductsByTypeLocationSearch',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_products_by_type_location_search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TESTGetProductsByTypeSearchCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    int? pageNumber,
    int? pageSize,
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": "${pageSize}",
  "search": "${escapeStringForJson(search)}",
  "type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'TEST getProductsByTypeSearch',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_products_by_type_search',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateLocationsCall {
  static Future<ApiCallResponse> call({
    String? latlng = '',
    String? name = '',
    String? address = '',
    String? city = '',
    String? state = '',
    String? country = '',
    String? zipCode = '',
    String? id = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "latlng": "${escapeStringForJson(latlng)}",
  "name": "${escapeStringForJson(name)}",
  "address": "${escapeStringForJson(address)}",
  "city": "${escapeStringForJson(city)}",
  "state": "${escapeStringForJson(state)}",
  "country": "${escapeStringForJson(country)}",
  "zip_code": "${escapeStringForJson(zipCode)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateLocations',
      apiUrl: '${AppConfig.apiBaseUrl}/locations?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetDataByIdProductsCall {
  static Future<ApiCallResponse> call({
    String? recordId = '',
    String? tableName = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "record_id": "${escapeStringForJson(recordId)}",
  "table_name": "${escapeStringForJson(tableName)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getDataByIdProducts',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/get_data_by_id_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TestProductsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    int? pageSize,
    int? pageNumber,
    String? search = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${escapeStringForJson(search)}",
  "type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'testProducts',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_test_products',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TestProductsTresCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    int? pageSize,
    int? pageNumber,
    String? locationParam = '',
  }) async {
    final ffApiRequestBody = '''
{
  "location_param": "${escapeStringForJson(locationParam)}",
  "page_number": ${pageNumber},
  "page_size": ${pageSize}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'testProductsTres',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_test_productstres',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class TestProductsDosCall {
  static Future<ApiCallResponse> call({
    String? searchTerm = '',
    String? locationParam = '',
    String? authToken = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'testProductsDos',
      apiUrl:
          '${AppConfig.apiBaseUrl}/activities_view?select=*&or=(name.ilike.*${searchTerm}*,description.ilike.*${searchTerm}*,city.ilike.*${searchTerm}*)&city=ilike.*${locationParam}*&limit=10&offset=0',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {
        'searchTerm': searchTerm,
        'locationParam': locationParam,
        'auth_token': authToken,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetLocationsItinerariesCall {
  static Future<ApiCallResponse> call({
    String? type = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_type": "${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getLocationsItineraries',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_locations_itineraries',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAirportsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? search = '',
    int? pageNumber,
    int? pageSize,
  }) async {
    final ffApiRequestBody = '''
{
  "search": "${escapeStringForJson(search)}",
  "page_number": ${pageNumber},
  "page_size": ${pageSize}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAirports',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_airports',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InsertLocationByTypeCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? locationId = '',
    String? searchId = '',
    String? type = '',
  }) async {
    final ffApiRequestBody = '''
{
"location_id":"${escapeStringForJson(locationId)}",
"search_id":"${escapeStringForJson(searchId)}",
"type":"${escapeStringForJson(type)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertLocationByType',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_update_location_by_type',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAgentCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
    String? accountIdParam = '',
  }) async {
    final ffApiRequestBody = '''
{
  "user_id_input": "${escapeStringForJson(id)}",
  "account_id_param": "${escapeStringForJson(accountIdParam)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAgent',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_agent_data',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetClientItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_id": "${escapeStringForJson(id)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getClientItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_client_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAllDataAccountCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'getAllDataAccount',
      apiUrl: '${AppConfig.apiBaseUrl}/accounts?id=eq.${id}',
      callType: ApiCallType.GET,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdateAllDataAccountCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
    String? logoImage = '',
    String? name = '',
    String? typeId = '',
    String? numberId = '',
    String? phone = '',
    String? phone2 = '',
    String? mail = '',
    String? website = '',
    String? cancellationPolicy = '',
    String? privacyPolicy = '',
    String? termsConditions = '',
    dynamic currencyJson,
    dynamic typesIncreaseJson,
    dynamic paymentMethodsJson,
  }) async {
    final currency = _serializeJson(currencyJson, true);
    final typesIncrease = _serializeJson(typesIncreaseJson, true);
    final paymentMethods = _serializeJson(paymentMethodsJson, true);
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}",
  "logo_image": "${escapeStringForJson(logoImage)}",
  "type_id": "${escapeStringForJson(typeId)}",
  "number_id": "${escapeStringForJson(numberId)}",
  "phone": "${escapeStringForJson(phone)}",
  "phone2": "${escapeStringForJson(phone2)}",
  "mail": "${escapeStringForJson(mail)}",
  "website": "${escapeStringForJson(website)}",
  "cancellation_policy": "${escapeStringForJson(cancellationPolicy)}",
  "privacy_policy": "${escapeStringForJson(privacyPolicy)}",
  "terms_conditions": "${escapeStringForJson(termsConditions)}",
  "currency": ${currency},
  "types_increase": ${typesIncrease},
  "payment_methods": ${paymentMethods}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updateAllDataAccount',
      apiUrl: '${AppConfig.apiBaseUrl}/accounts?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAllItemsItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? search = '',
    int? pageNumber,
    int? pageSize,
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_id_itinerary": "${escapeStringForJson(id)}",
  "p_page_number": ${pageNumber},
  "p_page_size": ${pageSize},
  "p_search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAllItemsItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_all_items_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static List<bool>? reservationStatus(dynamic response) => (getJsonField(
        response,
        r'''$[:].reservation_status''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<bool>(x))
          .withoutNulls
          .toList();
}

class SendPDFnonCall {
  static Future<ApiCallResponse> call({
    dynamic dataItineraryJson,
  }) async {
    final dataItinerary = _serializeJson(dataItineraryJson);
    final ffApiRequestBody = '''
{
  "dataItinerary": ${dataItinerary}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendPDFnon',
      apiUrl: 'https://n8n.weppa.co/webhook-test/create-pdf',
      callType: ApiCallType.POST,
      headers: {
        'content-type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SendEmailReservaCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? agentMessage = '',
    String? providerName = '',
    String? passengers = '',
    String? agentName = '',
    String? agentEmail = '',
    String? fecha = '',
    String? producto = '',
    String? tarifa = '',
    int? cantidad,
    String? tipoEmail = '',
    String? idItinerario = '',
    String? accountName = '',
    String? accountLogo = '',
  }) async {
    final ffApiRequestBody = '''
{
  "provider_name": "${escapeStringForJson(providerName)}",
  "email": "${escapeStringForJson(email)}",
  "agent_message": "${escapeStringForJson(agentMessage)}",
  "passengers": "${escapeStringForJson(passengers)}",
  "agent_name": "${escapeStringForJson(agentName)}",
  "agent_email": "${escapeStringForJson(agentEmail)}",
  "fecha": "${escapeStringForJson(fecha)}",
  "producto": "${escapeStringForJson(producto)}",
  "tarifa": "${escapeStringForJson(tarifa)}",
  "cantidad": ${cantidad},
  "tipoEmail": "${escapeStringForJson(tipoEmail)}",
  "id": "${escapeStringForJson(idItinerario)}",
  "account_name": "${escapeStringForJson(accountName)}",
  "account_logo": "${escapeStringForJson(accountLogo)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendEmailReserva',
      apiUrl: 'https://n8n.weppa.co/webhook/email-bukeer',
      callType: ApiCallType.POST,
      headers: {
        'content-type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAllDataAccountWithLocationCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? accountId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "input_account_id": "${escapeStringForJson(accountId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAllDataAccountWithLocation',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_accounts_with_location',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class SendEmailPagoCall {
  static Future<ApiCallResponse> call({
    String? email = '',
    String? providerName = '',
    String? passengers = '',
    String? agentName = '',
    String? agentEmail = '',
    String? fecha = '',
    String? producto = '',
    String? tarifa = '',
    int? cantidad,
    String? tipoEmail = '',
    String? fechaPago = '',
    String? valorPago = '',
    String? medioDePago = '',
    double? saldoPendiente,
    String? voucher = '',
    String? idItinerary = '',
    String? accountName = '',
    String? accountLogo = '',
  }) async {
    final ffApiRequestBody = '''
{
  "provider_name": "${escapeStringForJson(providerName)}",
  "email": "${escapeStringForJson(email)}",
  "passengers": "${escapeStringForJson(passengers)}",
  "agent_name": "${escapeStringForJson(agentName)}",
  "agent_email": "${escapeStringForJson(agentEmail)}",
  "fecha": "${escapeStringForJson(fecha)}",
  "producto": "${escapeStringForJson(producto)}",
  "tarifa": "${escapeStringForJson(tarifa)}",
  "cantidad": ${cantidad},
  "tipoEmail": "${escapeStringForJson(tipoEmail)}",
  "fecha_pago": "${escapeStringForJson(fechaPago)}",
  "valorPago": "${escapeStringForJson(valorPago)}",
  "medioDePago": "${escapeStringForJson(medioDePago)}",
  "saldoPendiente": ${saldoPendiente},
  "voucher": "${escapeStringForJson(voucher)}",
  "id": "${escapeStringForJson(idItinerary)}",
  "account_name": "${escapeStringForJson(accountName)}",
  "account_logo": "${escapeStringForJson(accountLogo)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'sendEmailPago',
      apiUrl: 'https://n8n.weppa.co/webhook/email-bukeer',
      callType: ApiCallType.POST,
      headers: {
        'content-type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPassengersItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? idItinerary = '',
  }) async {
    final ffApiRequestBody = '''
{
  "id_itinerary": "${escapeStringForJson(idItinerary)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getPassengersItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_passengers_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAgendaCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? fechaInicial = '',
    String? fechaFinal = '',
    int? pageNumber,
    int? pageSize,
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "fecha_final": "${escapeStringForJson(fechaFinal)}",
  "fecha_inicial": "${escapeStringForJson(fechaInicial)}",
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAgenda',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_agenda',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAgendaByDateCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? fechaInicial = '',
    String? fechaFinal = '',
    int? pageNumber,
    int? pageSize,
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "fecha_final": "${escapeStringForJson(fechaFinal)}",
  "fecha_inicial": "${escapeStringForJson(fechaInicial)}",
  "page_number": ${pageNumber},
  "page_size": ${pageSize},
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAgendaByDate',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_agenda_by_date',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ValidateDeleteContactCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
    bool? isProvider,
    bool? isClient,
  }) async {
    final ffApiRequestBody = '''
{
  "contact_id": "${escapeStringForJson(id)}",
  "is_provider": ${isProvider},
  "is_client": ${isClient}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validateDeleteContact',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_validate_delete_contact',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ValidateDeleteProductCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? id = '',
  }) async {
    final ffApiRequestBody = '''
{
  "product_id": "${escapeStringForJson(id)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'validateDeleteProduct',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_validate_delete_product',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DeleteProductsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? recordId = '',
    String? recordType = '',
  }) async {
    final ffApiRequestBody = '''
{
  "record_id": "${escapeStringForJson(recordId)}",
  "record_type": "${escapeStringForJson(recordType)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'deleteProducts',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_delete_record',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class UpdatePersonalInformationCall {
  static Future<ApiCallResponse> call({
    String? id = '',
    String? authToken = '',
    String? userImage = '',
    String? name = '',
    String? lastName = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}",
  "last_name": "${escapeStringForJson(lastName)}",
  "user_image": "${escapeStringForJson(userImage)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'updatePersonalInformation',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts?id=eq.${id}',
      callType: ApiCallType.PATCH,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=minimal',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DuplicateItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? originalId = '',
    String? newIdFm = '',
  }) async {
    final ffApiRequestBody = '''
{
  "original_id": "${escapeStringForJson(originalId)}",
  "new_id_fm": "${escapeStringForJson(newIdFm)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'duplicateItinerary',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_duplicate_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CountPassengersByItineraryCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_itinerary_id": "${escapeStringForJson(itineraryId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'countPassengersByItinerary',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_count_passengers_by_itinerary',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AddAccountsCall {
  static Future<ApiCallResponse> call({
    String? name = '',
  }) async {
    final ffApiRequestBody = '''
{
  "name": "${escapeStringForJson(name)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'addAccounts',
      apiUrl: '${AppConfig.apiBaseUrl}/accounts',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Ind6bHhicGljZGNkdnh2ZGN2Z2FzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjU0NjQyODAsImV4cCI6MjA0MTA0MDI4MH0.dSh-yGzemDC7DL_rf7fwgWlMoEKv1SlBCxd8ElFs_d8',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetAccountSearchCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? pUserId = '',
    String? pAccountId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_user_id": "${escapeStringForJson(pUserId)}",
"p_account_id": "${escapeStringForJson(pAccountId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getAccountSearch',
      apiUrl:
          '${AppConfig.apiBaseUrl}/rpc/function_get_accounts_info_by_user_id_and_exclude_account',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DuplicateItineraryItemCall {
  static Future<ApiCallResponse> call({
    String? originalId = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "original_id": "${escapeStringForJson(originalId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'duplicateItineraryItem',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_copy_itinerary_item',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetProviderPaymentsCall {
  static Future<ApiCallResponse> call({
    String? idItem = '',
    String? authToken = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_id_item_itinerary": "${escapeStringForJson(idItem)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getProviderPayments',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_provider_payments',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetFlightsIACall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? pItineraryId = '',
    String? pAccountId = '',
    String? pTextToAnalyze = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_itinerary_id": "${escapeStringForJson(pItineraryId)}",
  "p_account_id": "${escapeStringForJson(pAccountId)}",
  "p_text_to_analyze": "${escapeStringForJson(pTextToAnalyze)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getFlightsIA',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/request_openai_extraction_edge',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetUserAuthCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? pEmail = '',
  }) async {
    final ffApiRequestBody = '''
{
  "p_email": "${escapeStringForJson(pEmail)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getUserAuth',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_user_by_email',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetReporteCuentasPorCobrarCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? fechaInicial = '',
    String? fechaFinal = '',
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "fecha_final": "${escapeStringForJson(fechaFinal)}",
  "fecha_inicial": "${escapeStringForJson(fechaInicial)}",
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getReporteCuentasPorCobrar',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_cuentas_por_cobrar',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetReporteVentasCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? fechaInicial = '',
    String? fechaFinal = '',
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "fecha_final": "${escapeStringForJson(fechaFinal)}",
  "fecha_inicial": "${escapeStringForJson(fechaInicial)}",
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getReporteVentas',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_reporte_ventas',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetReporteCuentasPorPagarCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? fechaInicial = '',
    String? fechaFinal = '',
    String? search = '',
  }) async {
    final ffApiRequestBody = '''
{
  "fecha_final": "${escapeStringForJson(fechaFinal)}",
  "fecha_inicial": "${escapeStringForJson(fechaInicial)}",
  "search": "${escapeStringForJson(search)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getReporteCuentasPorPagar',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_cuentas_por_pagar',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetitIneraryDetailsCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
  }) async {
    final ffApiRequestBody = '''
{
"itinerary_id":"${escapeStringForJson(itineraryId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'getitIneraryDetails',
      apiUrl: '${AppConfig.apiBaseUrl}/rpc/function_get_itinerary_details',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].status''',
      ));
  static String? language(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$[:].language''',
      ));
  static String? requestType(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].request_type''',
      ));
  static String? validUntil(dynamic response) =>
      castToType<String>(getJsonField(
        response,
        r'''$[:].valid_until''',
      ));
}

class ProcessFlightExtractionCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
    String? accountId = '',
    String? textToAnalyze = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itinerary_id": "${escapeStringForJson(itineraryId)}",
  "account_id": "${escapeStringForJson(accountId)}",
  "text_to_analyze": "${escapeStringForJson(textToAnalyze)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ProcessFlightExtraction',
      apiUrl:
          'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/process-flight-extraction',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static int? itemsAdded(dynamic response) => castToType<int>(getJsonField(
        response,
        r'''$.items_added''',
      ));
}

class InsertRelatedContactCall {
  static Future<ApiCallResponse> call({
    String? lastName = '',
    String? phone = '',
    String? nationality = '',
    String? name = '',
    String? email = '',
    String? typeId = '',
    String? numberId = '',
    String? address = '',
    bool? isCompany,
    String? phone2 = '',
    String? userImage = '',
    String? birthDate = '',
    bool? isProvider,
    bool? isClient,
    String? authToken = '',
    String? location = '',
    String? accountId = '',
    String? idRelatedContact = '',
    String? position = '',
    bool? notify,
  }) async {
    final ffApiRequestBody = '''
{
  "last_name": "${lastName}",
  "phone": "${phone}",
  "nationality": "${nationality}",
  "name": "${name}",
  "type_id": "${typeId}",
  "number_id": "${numberId}",
  "is_company": ${isCompany},
  "phone2": "${phone2}",
  "user_image": "${userImage}",
  "birth_date": "${birthDate}",
  "is_client": ${isClient},
  "is_provider": ${isProvider},
  "email": "${email}",
  "location": "${location}",
  "account_id": "${accountId}",
  "id_related_contact": "${idRelatedContact}",
  "position": "${position}",
  "notify": ${notify}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'insertRelatedContact',
      apiUrl: '${AppConfig.apiBaseUrl}/contacts',
      callType: ApiCallType.POST,
      headers: {
        'apikey': AppConfig.supabaseAnonKey,
        'Authorization': 'Bearer ${authToken}',
        'Content-Type': 'application/json',
        'Prefer': 'return=representation',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic all(dynamic response) => getJsonField(
        response,
        r'''$[:]''',
      );
}

class ItineraryProposalPdfCall {
  static Future<ApiCallResponse> call({
    String? authToken = '',
    String? itineraryId = '',
  }) async {
    final ffApiRequestBody = '''
{
  "itineraryId": "${escapeStringForJson(itineraryId)}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'itineraryProposalPdf',
      apiUrl:
          'https://wzlxbpicdcdvxvdcvgas.supabase.co/functions/v1/create-itinerary-proposal-pdf',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${authToken}',
        'apikey': AppConfig.supabaseAnonKey,
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static String? urlPDF(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.publicUrl''',
      ));
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;
  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });
  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  return input
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n')
      .replaceAll('\t', '\\t');
}
