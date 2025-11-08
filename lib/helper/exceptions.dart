class InternalServerException implements Exception {
  final String message;

  InternalServerException({required this.message});

  @override
  String toString() => message;
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException({required this.message});

  @override
  String toString() => message;
}

class ForbiddenException implements Exception {
  final String message;

  ForbiddenException({required this.message});

  @override
  String toString() => message;
}

class BadRequestException implements Exception {
  final String message;

  BadRequestException({required this.message});

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;

  NotFoundException({required this.message});

  @override
  String toString() => message;
}
