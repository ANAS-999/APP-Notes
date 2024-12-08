import 'package:flutter/material.dart';

Widget errorWidget(bool isError, bool isLoading) {
  return Visibility(
    visible: isError && !isLoading,
    child: const Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error loading file!'),
          ],
        ),
      ),
    ),
  );
}
