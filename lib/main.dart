import 'package:app_local/app_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pricecal/data/models/item.dart';
import 'package:pricecal/data/models/stat.dart';
import 'package:pricecal/data/providers/item_list_provider.dart';
import 'package:pricecal/data/repository/item_list_repository.dart';
import 'package:pricecal/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ItemListDataProvider dataProvider = ItemListDataProvider();
  ItemListRepository itemListRepository = ItemListRepository(dataProvider: dataProvider);

  await Hive.initFlutter();
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(StatAdapter());

  Locales.init(
    localeNames: ['en', 'vi'],
    localPath: "assets/lang/",
  );

  await Firebase.initializeApp();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(App(itemListRepository: itemListRepository));
}

class App extends StatelessWidget {
  final ItemListRepository itemListRepository;
  const App({super.key, required this.itemListRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: itemListRepository,
      child: LocaleBuilder(builder: (locale) {
        return MaterialApp(
          /// Make sure to add this line
          localizationsDelegates: Locales.delegates,

          /// Make sure to add this line
          supportedLocales: Locales.supportedLocales,

          /// Make sure to add this line
          locale: locale,

          debugShowCheckedModeBanner: false,
          title: 'Price Cal',
          home: const Home(),
          color: Colors.yellow,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.yellow,
            ),
            useMaterial3: true,
          ).copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            }),
          ),
        );
      }),
    );
  }
}
