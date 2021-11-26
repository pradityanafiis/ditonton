import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/presentation/cubit/movie/top_rated/top_rated_movie_cubit.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedMovie extends Mock implements GetTopRatedMovies {}

void main() {
  late TopRatedMovieCubit _cubit;
  late MockGetTopRatedMovie _mockUseCase;

  setUp(() {
    _mockUseCase = MockGetTopRatedMovie();
    _cubit = TopRatedMovieCubit(_mockUseCase);
  });

  test('initial state should be empty', () {
    expect(_cubit.state, TopRatedMovieInitial());
  });

  blocTest<TopRatedMovieCubit, TopRatedMovieState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return _cubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieLoaded(testMovieList),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );

  blocTest<TopRatedMovieCubit, TopRatedMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(() => _mockUseCase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return _cubit;
    },
    act: (bloc) => bloc.fetch(),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(() => _mockUseCase.execute());
    },
  );
}
