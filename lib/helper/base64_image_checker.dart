bool isBase64Image(String data) {
  final RegExp base64ImageRegex = RegExp(
    '^data:image/[a-zA-Z]{3,};base64,',
  );
  return base64ImageRegex.hasMatch(data);
}
