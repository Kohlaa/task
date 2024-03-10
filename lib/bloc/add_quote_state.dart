import 'package:flutter/material.dart';

class _AddQuoteScreenState extends State<AddQuoteScreen> {
  final TextEditingController _quoteController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Quote'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _quoteController,
              decoration: InputDecoration(labelText: 'Enter Quote'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                      });

                      String quote = _quoteController.text.trim();
                      if (quote.isNotEmpty) {
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.pop(context, quote);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please enter a quote'),
                        ));
                      }
                      setState(() {
                        _isLoading = false;
                      });
                    },
              child:
                  _isLoading ? CircularProgressIndicator() : Text('Add Quote'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quoteController.dispose();
    super.dispose();
  }
}

class AddQuoteScreen extends StatefulWidget {
  @override
  State<AddQuoteScreen> createState() => _AddQuoteScreenState();
}
