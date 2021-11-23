import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/presentation/cubit/tv_show/popular/popular_tv_show_cubit.dart';
import 'package:core/presentation/pages/popular_tv_show_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularTvShowCubit extends MockCubit<PopularTvShowState>
    implements PopularTvShowCubit {}

void main() {
  late final MockPopularTvShowCubit _mockPopularTvShowCubit;

  setUpAll(() {
    _mockPopularTvShowCubit = MockPopularTvShowCubit();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvShowCubit>.value(
      value: _mockPopularTvShowCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => _mockPopularTvShowCubit.state)
        .thenReturn(PopularTvShowLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvShowPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => _mockPopularTvShowCubit.state)
        .thenReturn(const PopularTvShowHasData((<TvShow>[])));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(const PopularTvShowPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => _mockPopularTvShowCubit.state)
        .thenReturn(const PopularTvShowError('Error message'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularTvShowPage()));

    expect(textFinder, findsOneWidget);
  });
}
