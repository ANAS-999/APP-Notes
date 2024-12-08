import 'package:flutter/material.dart';

Widget loadingWidget(bool isLoading) {
  return Visibility(
    visible: isLoading,
    child: const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    ),
  );
}
