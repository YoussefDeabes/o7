import 'package:mobx/mobx.dart';

part 'stepper_view_model.g.dart';

class StepperViewModel = _StepperViewModelBase with _$StepperViewModel;

abstract class _StepperViewModelBase with Store {
  @observable
  int currentStep = 0;

  @action
  void setStep(int step) => currentStep = step;

  @action
  void incrementStep() {
    if (currentStep < 4) {
      currentStep++;
    }
  }

  @action
  void decrementStep() {
    if (currentStep > 0) {
      currentStep--;
    }
  }
}
