import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show.dart';
import 'package:core/domain/usecases/get_popular_tv_show.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'popular_tv_show_state.dart';

class PopularTvShowCubit extends Cubit<PopularTvShowState> {
  final GetPopularTvShow _getPopularTvShow;

  PopularTvShowCubit(this._getPopularTvShow) : super(PopularTvShowInitial());

  void resetState() {
    emit(PopularTvShowInitial());
  }

  void getAll() async {
    emit(PopularTvShowLoading());

    final _result = await _getPopularTvShow.execute();

    _result.fold(
      (failure) {
        emit(PopularTvShowError(failure.message));
      },
      (data) {
        if (data.isNotEmpty) {
          emit(PopularTvShowHasData(data));
        } else {
          emit(const PopularTvShowError('TV Show not found.'));
        }
      },
    );
  }
}
