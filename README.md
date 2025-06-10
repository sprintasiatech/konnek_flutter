# konnek_flutter

Konnek SDK for Flutter tools

## Usage/Examples

How to use `konnek_flutter` package

There are two setups should be added
1. Initialize method (`initKonnek()`) with a clientId and clientSecret parameter
2. Floating Button Widget to screen

First you should add `initKonnek()` method with clientId and clientSecret. Don't forget to use `WidgetsFlutterBinding.ensureInitialized()` before calling `initKonnek()` method
Example as below:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await KonnekFlutter.initKonnek(
    inputClientId: 'your-client-id',
    inputClientSecret: 'your-client-secret',
  );
}
```

Example as below:
Add `LiveChatSdkScreen` Widget on the top of your screen which exampled below is using `Scaffold`
```dart
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LiveChatSdkScreen(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Konnek Example App'),
          ),
          body: Center(
            child: Text('Your screen'),
          ),
        ),
      ),
    );
  }
}

```