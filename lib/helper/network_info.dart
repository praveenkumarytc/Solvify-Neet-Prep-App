import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

/// A class that provides information about the device's network connectivity.
class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  /// Returns a [Future] that completes with a [bool] indicating whether the
  /// device has an active internet connection.
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Checks the device's connectivity status and displays a snackbar with the
  /// result.
  static void checkConnectivity(BuildContext context) {
    // Flag to ensure the initial connectivity status is not displayed.
    bool firstTime = true;

    // Listen to changes in the device's connectivity status.
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        // Check if this is the first time connectivity has changed.
        if (!firstTime) {
          bool isNotConnected;
          if (result == ConnectivityResult.none) {
            // If there is no connectivity, assume the device is not connected.
            isNotConnected = true;
          } else {
            // Otherwise, check for connectivity by attempting to lookup the
            // IP address of google.com.
            isNotConnected = !await _updateConnectivityStatus();
          }

          // If the device is not connected, display a red snackbar. Otherwise,
          // hide any currently displayed snackbar.
          isNotConnected
              ? const SizedBox()
              // ignore: use_build_context_synchronously
              : ScaffoldMessenger.of(context).hideCurrentSnackBar();

          // Log the connectivity status.
          log(isNotConnected.toString());

          // Display a snackbar indicating the current connectivity status.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: isNotConnected ? Colors.red : Colors.green,
              duration: Duration(seconds: isNotConnected ? 6000 : 3),
              content: Text(
                isNotConnected ? 'No connection' : 'Connected',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        firstTime = false;
      },
    );
  }

  /// Helper method that checks for connectivity by attempting to lookup the
  /// IP address of google.com.
  static Future<bool> _updateConnectivityStatus() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } catch (e) {
      isConnected = false;
    }
    return isConnected;
  }
}
