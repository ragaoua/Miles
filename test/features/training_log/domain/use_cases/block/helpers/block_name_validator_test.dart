import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';
import 'package:mocktail/mocktail.dart';

import '../../../repository/mock_repository.dart';

class MockFailure extends Failure {}

void main() {
  late Repository mockRepository;
  late BlockNameValidator blockNameValidator;

  setUp(() {
    mockRepository = MockRepository();
    blockNameValidator = BlockNameValidator(repository: mockRepository);
  });

  test(
    'should return null when block name is valid',
    () async {
      // arrange
      const blockName = 'Block 1';
      when(
        () => mockRepository.getBlockByName(blockName),
      ).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final failure = await blockNameValidator.validate(blockName);

      // assert
      expect(failure, null);
      verify(() => mockRepository.getBlockByName(blockName));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when block name is empty',
    () async {
      // arrange
      const blockName = '';
      when(
        () => mockRepository.getBlockByName(blockName),
      ).thenAnswer(
        (_) async => Left(BlockNameEmptyFailure()),
      );

      // act
      final failure = await blockNameValidator.validate(blockName);

      // assert
      expect(failure, isA<BlockNameEmptyFailure>());
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return a Failure when block name is already used',
    () async {
      // arrange
      const blockName = 'existing name';
      when(
        () => mockRepository.getBlockByName(blockName),
      ).thenAnswer(
        (_) async => const Right(Block(id: 1, name: blockName)),
      );

      // act
      final failure = await blockNameValidator.validate(blockName);

      // assert
      expect(failure, isA<BlockNameAlreadyExistsFailure>());
      verify(() => mockRepository.getBlockByName(blockName));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test('should propagate repostiory failure', () async {
    // arrange
    const blockName = 'Block 1';
    final failure = MockFailure();
    when(
      () => mockRepository.getBlockByName(blockName),
    ).thenAnswer(
      (_) async => Left(failure),
    );

    // act
    final result = await blockNameValidator.validate(blockName);

    // assert
    expect(result, failure);
    verify(() => mockRepository.getBlockByName(blockName));
    verifyNoMoreInteractions(mockRepository);
  });
}
