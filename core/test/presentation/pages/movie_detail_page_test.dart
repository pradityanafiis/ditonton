import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/presentation/cubit/movie/detail/movie_detail_cubit.dart';
import 'package:core/presentation/cubit/movie/recommendation/movie_recommendation_cubit.dart';
import 'package:core/presentation/cubit/movie/watchlist/movie_watchlist_cubit.dart';
import 'package:core/presentation/cubit/movie/watchlist_status/movie_watchlist_status_cubit.dart';
import 'package:core/presentation/pages/movie_detail_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailCubit extends MockCubit<MovieDetailState>
    implements MovieDetailCubit {}

class MockMovieRecommendationCubit extends MockCubit<MovieRecommendationState>
    implements MovieRecommendationCubit {}

class MockMovieWatchlistStatusCubit extends MockCubit<MovieWatchlistStatusState>
    implements MovieWatchlistStatusCubit {}

class MockMovieWatchlistCubit extends MockCubit<MovieWatchlistState>
    implements MovieWatchlistCubit {}

void main() {
  late MockMovieDetailCubit mockMovieDetailCubit;
  late MockMovieRecommendationCubit mockMovieRecommendationCubit;
  late MockMovieWatchlistStatusCubit mockMovieWatchlistStatusCubit;
  late MockMovieWatchlistCubit mockMovieWatchlistCubit;

  setUpAll(() {
    mockMovieDetailCubit = MockMovieDetailCubit();
    mockMovieRecommendationCubit = MockMovieRecommendationCubit();
    mockMovieWatchlistStatusCubit = MockMovieWatchlistStatusCubit();
    mockMovieWatchlistCubit = MockMovieWatchlistCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieDetailCubit>.value(
          value: mockMovieDetailCubit,
        ),
        BlocProvider<MovieRecommendationCubit>.value(
          value: mockMovieRecommendationCubit,
        ),
        BlocProvider<MovieWatchlistStatusCubit>.value(
          value: mockMovieWatchlistStatusCubit,
        ),
        BlocProvider<MovieWatchlistCubit>.value(
          value: mockMovieWatchlistCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationCubit.state)
        .thenReturn(MovieRecommendationLoaded(const <Movie>[]));
    when(() => mockMovieWatchlistStatusCubit.state)
        .thenReturn(MovieWatchlistStatusNotAdded());

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationCubit.state)
        .thenReturn(MovieRecommendationLoaded(const <Movie>[]));
    when(() => mockMovieWatchlistStatusCubit.state)
        .thenReturn(MovieWatchlistStatusAdded());

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    when(() => mockMovieDetailCubit.state)
        .thenReturn(MovieDetailLoaded(testMovieDetail));
    when(() => mockMovieRecommendationCubit.state)
        .thenReturn(MovieRecommendationLoaded(const <Movie>[]));
    when(() => mockMovieWatchlistStatusCubit.state)
        .thenReturn(MovieWatchlistStatusNotAdded());
    when(() => mockMovieWatchlistStatusCubit.stream).thenAnswer((_) =>
        Stream.value(MovieWatchlistStatusAdded(message: 'Added to Watchlist')));
    when(() => mockMovieWatchlistCubit.state)
        .thenReturn(MovieWatchlistLoaded(const <Movie>[]));

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.movieState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.movie).thenReturn(testMovieDetail);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.movieRecommendations).thenReturn(<Movie>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //   when(mockNotifier.watchlistMessage).thenReturn('Failed');

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });
}
