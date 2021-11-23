import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv_show_detail.dart';
import 'package:core/domain/usecases/get_tv_show_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'tv_show_detail_state.dart';

class TvShowDetailCubit extends Cubit<TvShowDetailState> {
  final GetTvShowDetail _getTvShowDetail;

  TvShowDetailCubit(this._getTvShowDetail) : super(TvShowDetailInitial());

  void getDetail(int id) async {
    emit(TvShowDetailLoading());

    final _result = await _getTvShowDetail.execute(id);

    _result.fold(
      (failure) {
        emit(TvShowDetailError(failure.message));
      },
      (data) {
        emit(TvShowDetailLoaded(data));
      },
    );
  }
}
