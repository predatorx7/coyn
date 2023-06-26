import 'package:coyn/coyn.dart';

class InvalidBlockchainIntegrityError extends Error {
  final Block invalidBlock;

  InvalidBlockchainIntegrityError(this.invalidBlock);

  @override
  String toString() {
    return 'InvalidBlockchainIntegrityError: Invalid block hash is "${invalidBlock.hash}"';
  }
}
