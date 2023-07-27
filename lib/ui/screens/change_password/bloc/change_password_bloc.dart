import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/models/change_password/ChangePassword.dart';
import 'package:o7therapy/api/models/change_password/change_password_send_model.dart';
import 'package:o7therapy/ui/screens/change_password/bloc/change_password_repo.dart';
import 'package:o7therapy/util/validator.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final BaseChangePasswordRepo _baseRepo;

  ChangePasswordBloc(this._baseRepo) : super(ChangePasswordInitial()) {
    on<ChangePasswordApiEvent>(_onChangePasswordApiEvent);
    // on<ValidatePasswordEvent>(_onValidatePasswordEvent);
  }

  ///  Save  button Clicked
  _onChangePasswordApiEvent(ChangePasswordApiEvent event, emit) async {
    emit(const Loading());
    if (_validatePassword(event.changePasswordSendModel.newPassword ?? "")) {
      emit(await _baseRepo.changePasswordApi(event.changePasswordSendModel));
    } else {
      emit(const PasswordFormatNotCorrect());
    }
  }

  /// check the Password
  _validatePassword(String password) => Validator.isPassword(password);
}
