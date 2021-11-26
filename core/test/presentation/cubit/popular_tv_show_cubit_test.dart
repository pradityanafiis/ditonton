import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_popular_tv_show.dart';
import 'package:core/presentation/cubit/tv_show/popular/popular_tv_show_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularTvShow extends Mock implements GetPopularTvShow {}

void main() {
  late PopularTvShowCubit _cubit;
  late MockGetPopularTvShow _mockUseCase;

  setUp(() {
    _mockUseCase = MockGetPopularTvShow();
    _cubit = PopularTvShowCubit(_mockUseCase);
  });

  test('initial state should be empty', () {
    expect(_cubit.state, PopularTvShowInitial());
  });

  blocTest<PopularTvShowCubit, PopularTvShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      PopularTvShowLoading(),
      PopularTvShowHasData(testTvShowList),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );

  blocTest<PopularTvShowCubit, PopularTvShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      PopularTvShowLoading(),
      const PopularTvShowError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );
}
