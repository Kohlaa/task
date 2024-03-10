import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/settings.dart';

import 'bloc/add_quote_state.dart';
import 'main.dart';

class QuoteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: BlocBuilder<QuoteCubit, List<Quote>>(
        builder: (context, quotes) {
          return ListView.builder(
            itemCount: quotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("quote " + "${index + 1} : " + quotes[index].text),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newQuote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddQuoteScreen()),
          );
          if (newQuote != null) {
            context.read<QuoteCubit>().addQuote(newQuote);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
