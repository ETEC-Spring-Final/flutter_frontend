abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServiceFailure extends Failure {
  const ServiceFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
