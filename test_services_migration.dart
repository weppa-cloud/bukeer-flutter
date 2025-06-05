import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'lib/services/product_service.dart';
import 'lib/services/contact_service.dart';
import 'lib/services/itinerary_service.dart';
import 'lib/services/user_service.dart';

/// Test file to verify services migration is working correctly
void main() {
  runApp(ServicesTestApp());
}

class ServicesTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductService()),
        ChangeNotifierProvider(create: (_) => ContactService()),
        ChangeNotifierProvider(create: (_) => ItineraryService()),
        ChangeNotifierProvider(create: (_) => UserService()),
      ],
      child: MaterialApp(
        title: 'Services Migration Test',
        home: ServicesTestScreen(),
      ),
    );
  }
}

class ServicesTestScreen extends StatefulWidget {
  @override
  _ServicesTestScreenState createState() => _ServicesTestScreenState();
}

class _ServicesTestScreenState extends State<ServicesTestScreen> {
  List<String> testResults = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      runTests();
    });
  }

  void addResult(String test, bool passed, [String? details]) {
    setState(() {
      final status = passed ? '✅' : '❌';
      final result = '$status $test';
      testResults.add(details != null ? '$result - $details' : result);
    });
  }

  void runTests() {
    addResult('Starting Services Migration Tests', true);

    // Test ProductService
    testProductService();

    // Test ContactService  
    testContactService();

    // Test ItineraryService
    testItineraryService();

    // Test UserService
    testUserService();

    addResult('All tests completed', true);
  }

  void testProductService() {
    try {
      final productService = context.read<ProductService>();
      
      // Test allDataHotel getter/setter
      productService.allDataHotel = {'id': 1, 'name': 'Test Hotel'};
      final hotel = productService.allDataHotel;
      addResult('ProductService.allDataHotel', hotel != null && hotel['name'] == 'Test Hotel');

      // Test allDataActivity getter/setter
      productService.allDataActivity = {'id': 1, 'name': 'Test Activity'};
      final activity = productService.allDataActivity;
      addResult('ProductService.allDataActivity', activity != null && activity['name'] == 'Test Activity');

      // Test allDataTransfer getter/setter
      productService.allDataTransfer = {'id': 1, 'name': 'Test Transfer'};
      final transfer = productService.allDataTransfer;
      addResult('ProductService.allDataTransfer', transfer != null && transfer['name'] == 'Test Transfer');

      // Test allDataFlight getter/setter
      productService.allDataFlight = {'id': 1, 'name': 'Test Flight'};
      final flight = productService.allDataFlight;
      addResult('ProductService.allDataFlight', flight != null && flight['name'] == 'Test Flight');

      // Test clearing
      productService.allDataHotel = null;
      addResult('ProductService.allDataHotel clear', productService.allDataHotel == null);

    } catch (e) {
      addResult('ProductService tests', false, e.toString());
    }
  }

  void testContactService() {
    try {
      final contactService = context.read<ContactService>();
      
      // Test allDataContact getter/setter
      contactService.allDataContact = {'id': 1, 'name': 'Test Contact'};
      final contact = contactService.allDataContact;
      addResult('ContactService.allDataContact', contact != null && contact['name'] == 'Test Contact');

      // Test clearing
      contactService.allDataContact = null;
      addResult('ContactService.allDataContact clear', contactService.allDataContact == null);

    } catch (e) {
      addResult('ContactService tests', false, e.toString());
    }
  }

  void testItineraryService() {
    try {
      final itineraryService = context.read<ItineraryService>();
      
      // Test allDataItinerary getter/setter
      itineraryService.allDataItinerary = {'id': 1, 'name': 'Test Itinerary'};
      final itinerary = itineraryService.allDataItinerary;
      addResult('ItineraryService.allDataItinerary', itinerary != null && itinerary['name'] == 'Test Itinerary');

      // Test allDataPassenger getter/setter  
      itineraryService.allDataPassenger = {'id': 1, 'name': 'Test Passenger'};
      final passenger = itineraryService.allDataPassenger;
      addResult('ItineraryService.allDataPassenger', passenger != null && passenger['name'] == 'Test Passenger');

      // Test clearing
      itineraryService.allDataItinerary = null;
      itineraryService.allDataPassenger = null;
      addResult('ItineraryService data clear', 
          itineraryService.allDataItinerary == null && 
          itineraryService.allDataPassenger == null);

    } catch (e) {
      addResult('ItineraryService tests', false, e.toString());
    }
  }

  void testUserService() {
    try {
      final userService = context.read<UserService>();
      
      // Test allDataUser getter/setter
      userService.allDataUser = {'id': 1, 'name': 'Test User'};
      final user = userService.allDataUser;
      addResult('UserService.allDataUser', user != null && user['name'] == 'Test User');

      // Test clearing
      userService.allDataUser = null;
      addResult('UserService.allDataUser clear', userService.allDataUser == null);

    } catch (e) {
      addResult('UserService tests', false, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services Migration Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Testing Services Migration',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: testResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      testResults[index],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}