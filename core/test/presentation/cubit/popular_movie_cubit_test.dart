import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/presentation/cubit/movie/popular/popular_movie_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularMovie extends Mock implements GetPopularMovies {}

void main() {
  late PopularMovieCubit _cubit;
  late MockGetPopularMovie _mockUseCase;

  setUp(() {
    _mockUseCase = MockGetPopularMovie();
    _cubit = PopularMovieCubit(_mockUseCase);
  });

  test('initial state should be empty', () {
    expect(_cubit.state, PopularMovieInitial());
  });

  blocTest<PopularMovieCubit, PopularMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return _cubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );

  blocTest<PopularMovieCubit, PopularMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _cubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );
}
