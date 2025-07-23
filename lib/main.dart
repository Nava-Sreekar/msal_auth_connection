import 'package:flutter/material.dart';
import 'package:msal_auth/msal_auth.dart';

const _clientId = '45b0b48a-279d-4b11-b67d-00edd7b3997f';
const _redirectUri =
    'msauth://com.example.test/yRsbbsf04GR9QKgK+y3ksruhmMM=';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late SingleAccountPca _pca;
  String? _accessToken;
  bool _initializing = true;

  @override
  void initState() {
    super.initState();
    _initPca();
  }

  Future<void> _initPca() async {
    _pca = await SingleAccountPca.create(
      clientId: _clientId,
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        redirectUri: _redirectUri,
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.b2c,
        broker: Broker.msAuthenticator,
      ),
    );
    setState(() => _initializing = false);
  }

  Future<void> _signIn() async {
    try {
      final result = await _pca.acquireToken(
        scopes: const ['https://graph.microsoft.com/user.read'],
      );
      setState(() => _accessToken = result.accessToken);
    } catch (e) {
      debugPrint('MSAL sign-in failed: $e');
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: _initializing
            ? const CircularProgressIndicator()
            : _accessToken == null
            ? ElevatedButton(
                onPressed: _signIn,
                child: const Text('Sign in with Microsoft'),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Access Token:\n\n$_accessToken',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
      ),
    );
  }
}
