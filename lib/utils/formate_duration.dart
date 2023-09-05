String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String formatDoubleDuration(double durationInSeconds) {
  Duration duration = Duration(seconds: durationInSeconds.round());

  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

  return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
}

String getFormattedDuration(double? durationInMilliseconds) {
  if (durationInMilliseconds == null) return '00:00:00';

  int seconds = (durationInMilliseconds / 1000).round();
  return formatDoubleDuration(seconds.toDouble());
}
String formatIntDuration(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds ~/ 60) % 60;
  int remainingSeconds = seconds % 60;

  String hoursStr = hours.toString().padLeft(2, '0');
  String minutesStr = minutes.toString().padLeft(2, '0');
  String secondsStr = remainingSeconds.toString().padLeft(2, '0');

  return '$hoursStr:$minutesStr:$secondsStr';
}