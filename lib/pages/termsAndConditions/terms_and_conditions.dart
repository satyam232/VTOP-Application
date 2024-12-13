import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsAndConditionsPage extends StatelessWidget {
  Future<String> loadTermsAndConditions() async {
    return await rootBundle.loadString('assets/terms_and_conditions.txt');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<String>(
        future: loadTermsAndConditions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading terms and conditions.'));
          } else {
            // Split the content into lines
            final lines = snapshot.data!.split('\n');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lines.map((line) {
                  // Check if the line is a heading (starts with "### ")
                  if (line.startsWith('### ')) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        line.replaceFirst('### ', ''),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        line,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
