String formatMb(int mb) {
  if (mb < 1024) return "${mb.toStringAsFixed(2)}MB";
  double gb = mb / 1024;
  return "${gb.toStringAsFixed(2)}GB";
}

String formatBytes(int bytes) {
  const int kb = 1024;
  const int mb = kb * 1024;
  const int gb = mb * 1024;

  if (bytes >= gb) {
    return '${(bytes / gb).toStringAsFixed(2)} GB';
  } else if (bytes >= mb) {
    return '${(bytes / mb).toStringAsFixed(2)} MB';
  } else if (bytes >= kb) {
    return '${(bytes / kb).toStringAsFixed(2)} KB';
  } else {
    return '$bytes bytes';
  }
}
