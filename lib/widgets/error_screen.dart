import 'package:flutter/material.dart';
import 'package:movie_db/models/error_model.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key, this.error}) : super(key: key);
  final FetchDataError? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.amber,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(
                  Icons.error,
                  size: 55,
                  color: Colors.red,
                ),
              ),
              const Text('Something went wrong!'),
              const SizedBox(height: 130),
              const Text('Hints'),
              Text(error?.message ?? 'No Hints',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
