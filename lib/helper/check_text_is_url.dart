bool checkForImage(String text) {
  return text.startsWith(urlPattern);
}

String urlPattern = 'http';
