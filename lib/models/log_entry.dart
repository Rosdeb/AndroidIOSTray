enum LogLevel { info, warning, error }

class LogEntry {
  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.message,
  });

  final DateTime timestamp;
  final LogLevel level;
  final String message;
}
