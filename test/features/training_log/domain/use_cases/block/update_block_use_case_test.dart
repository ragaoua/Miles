import 'package:flutter_test/flutter_test.dart';
import 'package:miles/core/failure.dart';
import 'package:miles/features/training_log/domain/entities/block.dart';
import 'package:miles/features/training_log/domain/repositories/repository.dart';
import 'package:miles/features/training_log/domain/use_cases/block/helpers/block_name_validator.dart';
import 'package:miles/features/training_log/domain/use_cases/block/update_block_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../core/mock_failure.dart';
import '../../repository/mock_repository.dart';

class MockBlockNameValidator extends Mock implements BlockNameValidator {}

void main() {
  late Repository mockRepository;
  late BlockNameValidator blockNameValidator;
  late UpdateBlockUseCase updateBlock;

  setUp(() {
    mockRepository = MockRepository();
    blockNameValidator = MockBlockNameValidator();
    updateBlock = UpdateBlockUseCase(
      repository: mockRepository,
      blockNameValidator: blockNameValidator,
    );
  });

  test("should update a block with a valid name", () async {
    // arrange
    const block = Block(id: 1, name: "Valid name");

    when(
      () => blockNameValidator.validate(block.name),
    ).thenAnswer((_) async => null);

    when(
      () => mockRepository.updateBlock(block),
    ).thenAnswer((_) async => null);

    // act
    final result = await updateBlock(block);

    // assert
    expect(result, null);
    verify(() => blockNameValidator.validate(block.name));
    verify(
      () => mockRepository.updateBlock(block),
    );
    verifyNoMoreInteractions(blockNameValidator);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should fail when updating a block with an invalid name", () async {
    // arrange
    const block = Block(name: "Invalid name");
    final failure = MockFailure();
    when(
      () => blockNameValidator.validate(block.name),
    ).thenAnswer((_) async => failure);

    // act
    final result = await updateBlock(block);

    // assert
    expect(result, failure);
    verify(() => blockNameValidator.validate(block.name));
    verifyNoMoreInteractions(blockNameValidator);
    verifyNoMoreInteractions(mockRepository);
  });

  test("should propagate repository failure when updating a block", () async {
    // arrange
    const block = Block(id: 5, name: "Block 5");
    final failure = MockFailure();

    when(
      () => blockNameValidator.validate(block.name),
    ).thenAnswer(
      (_) async => null,
    );
    when(
      () => mockRepository.updateBlock(block),
    ).thenAnswer(
      (_) async => failure,
    );

    // act
    final result = await updateBlock(block);

    // assert
    expect(result, failure);
    verify(() => blockNameValidator.validate(block.name));
    verify(() => mockRepository.updateBlock(block));
    verifyNoMoreInteractions(blockNameValidator);
    verifyNoMoreInteractions(mockRepository);
  });
}
