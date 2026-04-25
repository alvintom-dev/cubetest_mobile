import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/test_set.dart';
import '../repository/test_set_repository.dart';

@injectable
class GetTestSetsUsecase
    extends UseCase<Either<Failure, List<TestSet>>, GetTestSetsUsecaseParam> {
  const GetTestSetsUsecase(this.repository);

  final TestSetRepository repository;

  @override
  Future<Either<Failure, List<TestSet>>> call(
      GetTestSetsUsecaseParam? params) async {
    return repository.getTestSets(
      siteId: params?.siteId,
      isDeleted: params?.isDeleted,
    );
  }
}

class GetTestSetsUsecaseParam extends Equatable {
  const GetTestSetsUsecaseParam({this.siteId, this.isDeleted});

  final String? siteId;
  final bool? isDeleted;

  @override
  List<Object?> get props => [siteId, isDeleted];
}
