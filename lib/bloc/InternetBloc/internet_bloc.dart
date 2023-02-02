import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(YesInternet()) {
    on<InternetOff>((event, emit) {
      emit(NoInternet(timestamp: event.timeStamp));
    });
    on<InternetOn>((event, emit) {
      emit(YesInternet());
    });
  }
}
