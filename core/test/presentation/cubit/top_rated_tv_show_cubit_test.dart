import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_top_rated_tv_show.dart';
import 'package:core/presentation/cubit/tv_show/top_rated/top_rated_tv_show_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedTvShow extends Mock implements GetTopRatedTvShow {}

void main() {
  late TopRatedTvShowCubit _cubit;
  late MockGetTopRatedTvShow _mockUseCase;

  setUp(() {
    _mockUseCase = MockGetTopRatedTvShow();
    _cubit = TopRatedTvShowCubit(_mockUseCase);
  });

  test('initial state should be empty', () {
    expect(_cubit.state, TopRatedTvShowInitial());
  });

  blocTest<TopRatedTvShowCubit, TopRatedTvShowState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => Right(testTvShowList));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      TopRatedTvShowLoading(),
      TopRatedTvShowHasData(testTvShowList),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );

  blocTest<TopRatedTvShowCubit, TopRatedTvShowState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _cubit;
    },
    act: (bloc) => bloc.getAll(),
    expect: () => [
      TopRatedTvShowLoading(),
      const TopRatedTvShowError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );
}
