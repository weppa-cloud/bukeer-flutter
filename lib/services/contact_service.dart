import '../backend/api_requests/api_calls.dart';
import "package:bukeer/legacy/flutter_flow/flutter_flow_util.dart";
import 'base_service.dart';
import 'performance_optimized_service.dart';

class ContactService extends BaseService with PerformanceOptimizedService {
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  // Cached data
  List<dynamic> _contacts = [];
  List<dynamic> _accounts = [];
  Map<int, dynamic> _contactDetails = {};

  // Filtered lists
  List<dynamic> _clients = [];
  List<dynamic> _providers = [];

  // Selected contact data (replacement for allDataContact)
  dynamic _selectedContact;

  // Collection getters
  List<dynamic> get contacts => _contacts;
  List<dynamic> get accounts => _accounts;
  List<dynamic> get clients => _clients;
  List<dynamic> get providers => _providers;

  // Selected contact getters (replacement for allDataContact)
  dynamic get selectedContact => _selectedContact;

  // Backward compatibility getter for allDataContact pattern
  dynamic get allDataContact => _selectedContact;

  @override
  Future<void> initialize() async {
    await batchLoad([
      loadContacts(),
      loadAccounts(),
    ]);
  }

  // Load all contacts
  Future<void> loadContacts() async {
    if (isCacheValid && _contacts.isNotEmpty) return;

    await loadData(() async {
      final response = await GetContactSearchCall.call();
      if (response.succeeded) {
        _contacts = getJsonField(response.jsonBody, r'$[:]') ?? [];
        _filterContactsByType();
        batchNotify('contacts');
      }
    });
  }

  // Load all accounts
  Future<void> loadAccounts() async {
    if (isCacheValid && _accounts.isNotEmpty) return;

    await loadData(() async {
      final response = await GetAccountSearchCall.call();
      if (response.succeeded) {
        _accounts = getJsonField(response.jsonBody, r'$[:]') ?? [];
        batchNotify('accounts');
      }
    });
  }

  // Filter contacts by type
  void _filterContactsByType() {
    _clients = _contacts.where((contact) {
      final types =
          safeGet<List>(contact, r'$.contact_types', defaultValue: []);
      return types?.contains('client') ?? false;
    }).toList();

    _providers = _contacts.where((contact) {
      final types =
          safeGet<List>(contact, r'$.contact_types', defaultValue: []);
      return types?.contains('provider') ?? false;
    }).toList();
  }

  // Get contact details
  Future<dynamic> getContactDetails(int contactId) async {
    // Check cache first
    if (_contactDetails.containsKey(contactId)) {
      return _contactDetails[contactId];
    }

    return await loadData(() async {
      final response = await GetContactIdCall.call(id: contactId.toString());
      if (response.succeeded) {
        final details = getJsonField(response.jsonBody, r'$[0]');
        _contactDetails[contactId] = details;
        return details;
      }
      return null;
    });
  }

  // Create contact
  Future<int?> createContact({
    required String name,
    required String lastName,
    String? email,
    String? phone,
    String? typeId,
    String? numberId,
    bool? isClient,
    bool? isProvider,
    String? accountId,
  }) async {
    return await loadData(() async {
      final response = await InsertContactCall.call(
        name: name,
        lastName: lastName,
        email: email,
        phone: phone,
        typeId: typeId,
        numberId: numberId,
        isClient: isClient,
        isProvider: isProvider,
        accountId: accountId,
      );

      if (response.succeeded) {
        _contacts.clear();
        _invalidateCache();
        return getJsonField(response.jsonBody, r'$[0].id');
      }
      throw Exception('Failed to create contact');
    });
  }

  // Update contact
  Future<bool> updateContact({
    required int contactId,
    String? name,
    String? lastName,
    String? email,
    String? phone,
    String? typeId,
    String? numberId,
    bool? isClient,
    bool? isProvider,
  }) async {
    final result = await loadData(() async {
      final response = await UpdateContactCall.call(
        id: contactId.toString(),
        name: name,
        lastName: lastName,
        email: email,
        phone: phone,
        typeId: typeId,
        numberId: numberId,
        isClient: isClient,
        isProvider: isProvider,
      );

      if (response.succeeded) {
        _contacts.clear();
        _contactDetails.remove(contactId);
        _invalidateCache();
        return true;
      }
      return false;
    });

    return result ?? false;
  }

  // Delete contact
  Future<bool> deleteContact(int contactId) async {
    final result = await loadData(() async {
      // TODO: Implement proper delete API call when available
      // For now, validate if contact can be deleted
      final response =
          await ValidateDeleteContactCall.call(id: contactId.toString());

      if (response.succeeded) {
        // Remove from local cache (temporary solution)
        _contacts.removeWhere((c) => safeGet<int>(c, r'$.id') == contactId);
        _contactDetails.remove(contactId);
        _filterContactsByType();
        notifyListeners();
        return true;
      }
      return false;
    });

    return result ?? false;
  }

  // Search contacts
  List<dynamic> searchContacts(String query, {String? type}) {
    if (query.isEmpty) {
      switch (type) {
        case 'client':
          return _clients;
        case 'provider':
          return _providers;
        default:
          return _contacts;
      }
    }

    final lowercaseQuery = query.toLowerCase();
    List<dynamic> searchList;

    switch (type) {
      case 'client':
        searchList = _clients;
        break;
      case 'provider':
        searchList = _providers;
        break;
      default:
        searchList = _contacts;
    }

    return searchList.where((contact) {
      final name = safeGet<String>(contact, r'$.name', defaultValue: '');
      final lastName =
          safeGet<String>(contact, r'$.last_name', defaultValue: '');
      final email = safeGet<String>(contact, r'$.email', defaultValue: '');
      final company =
          safeGet<String>(contact, r'$.company_name', defaultValue: '');

      return name!.toLowerCase().contains(lowercaseQuery) ||
          lastName!.toLowerCase().contains(lowercaseQuery) ||
          email!.toLowerCase().contains(lowercaseQuery) ||
          company!.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get contact by email
  dynamic getContactByEmail(String email) {
    return _contacts.firstWhere(
      (c) => safeGet<String>(c, r'$.email') == email,
      orElse: () => null,
    );
  }

  // Check if contact exists
  bool contactExists(String email) {
    return getContactByEmail(email) != null;
  }

  // Get contacts by account
  List<dynamic> getContactsByAccount(int accountId) {
    return _contacts.where((contact) {
      return safeGet<int>(contact, r'$.account_id') == accountId;
    }).toList();
  }

  // Methods to manage selected contact (replacement for allDataContact pattern)
  void setSelectedContact(dynamic contact) {
    _selectedContact = contact;
    notifyListeners();
  }

  void clearSelectedContact() {
    _selectedContact = null;
    notifyListeners();
  }

  // Backward compatibility setter for allDataContact pattern
  set allDataContact(dynamic value) {
    _selectedContact = value;
    notifyListeners();
  }

  // Private method to invalidate cache
  void _invalidateCache() {
    _contacts.clear();
    _contactDetails.clear();
    _selectedContact = null;
    notifyListeners();
  }
}
