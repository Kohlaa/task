import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/providers/app_config_provider.dart';
import 'package:task/quote_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppConfigProvider(), child: MyApp()));
}

class Quote {
  final int id;
  final String text;
  final String author;

  Quote({
    required this.id,
    required this.text,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'] ?? 0,
      text: json['quote'] ?? "",
      author: json['author'] ?? "",
    );
  }
}

class QuoteCubit extends Cubit<List<Quote>> {
  QuoteCubit() : super([]);

  void fetchQuotes() async {
    try {
      final response = await Dio().get('https://dummyjson.com/quotes');
      final Map<String, dynamic> responseData = response.data;
      final List<dynamic> jsonList = responseData['quotes'];
      List<Quote> quotes =
      jsonList.map((json) => Quote.fromJson(json)).toList();
      emit(quotes);
    } catch (e) {
      print("Error fetching quotes: $e");
    }
  }

  void addQuote(String quote) async {
    try {
      emitLoading();

      final response =
      await Dio().post('https://dummyjson.com/quotes/add', data: [
        {'quote': quote, 'id': 1, 'author': 'Kohlaa'}
      ]);

      if (response.statusCode == 200) {
        fetchQuotes();
      }
    } catch (e) {
      print("Error adding quote: $e");
    } finally {
      emitLoaded();
    }
  }

  void emitLoading() {
    emit([Quote(id: -1, text: '', author: '')]);
  }

  void emitLoaded() {
    fetchQuotes();
  }
}

class MyApp extends StatelessWidget {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    initSharedpref();
    return MaterialApp(
      title: 'Quote App',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.appLanguage),
      theme: _buildThemeData(provider.appTheme), // Apply selected theme
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => QuoteCubit()..fetchQuotes()),
        ],
        child: QuoteScreen(),
      ),
    );
  }

  ThemeData _buildThemeData(AppTheme theme) {
    switch (theme) {
      case AppTheme.Green:
        return ThemeData(
          primarySwatch: Colors.green,
          hintColor: Colors.lightGreen,
          // Add other theme attributes as needed
        );
      case AppTheme.Blue:
        return ThemeData(
          primarySwatch: Colors.blue,
          hintColor: Colors.lightBlue,
          // Add other theme attributes as needed
        );
      case AppTheme.Orange:
        return ThemeData(
          primarySwatch: Colors.orange,
          hintColor: Colors.amber,
          // Add other theme attributes as needed
        );
    }
  }

  Future<void> initSharedpref() async {
    final prefs = await SharedPreferences.getInstance();
    String lang = prefs.getString("lang") ?? "en";
    provider.changeLanguage(lang);
  }
}

class LanguageBottomSheet extends StatefulWidget {
  @override
  State<LanguageBottomSheet> createState() => _LanguageBottomSheetState();
}

class _LanguageBottomSheetState extends State<LanguageBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return Container(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              provider.changeLanguage('en');
            },
            child: provider.appLanguage == 'en'
                ? getSelectedItemWidget(AppLocalizations.of(context)!.localeName)
                : getUnSelectedItemWidget(AppLocalizations.of(context)!.localeName),
          ),
          SizedBox(
            height: 18,
          ),
          InkWell(
            onTap: () {
              provider.changeLanguage('ar');
            },
            child: provider.appLanguage == 'ar'
                ? getSelectedItemWidget(AppLocalizations.of(context)!.localeName)
                : getUnSelectedItemWidget(AppLocalizations.of(context)!.localeName),
          )
        ],
      ),
    );
  }

  Widget getSelectedItemWidget(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(Icons.check_circle,
            size: 25, color: Theme.of(context).primaryColor),
      ],
    );
  }

  Widget getUnSelectedItemWidget(String text) {
    return Text(
      text,
    );
  }
}
