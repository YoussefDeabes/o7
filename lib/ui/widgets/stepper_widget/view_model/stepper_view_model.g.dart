// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stepper_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StepperViewModel on _StepperViewModelBase, Store {
  late final _$currentStepAtom =
      Atom(name: '_StepperViewModelBase.currentStep', context: context);

  @override
  int get currentStep {
    _$currentStepAtom.reportRead();
    return super.currentStep;
  }

  @override
  set currentStep(int value) {
    _$currentStepAtom.reportWrite(value, super.currentStep, () {
      super.currentStep = value;
    });
  }

  late final _$_StepperViewModelBaseActionController =
      ActionController(name: '_StepperViewModelBase', context: context);

  @override
  void setStep(int step) {
    final _$actionInfo = _$_StepperViewModelBaseActionController.startAction(
        name: '_StepperViewModelBase.setStep');
    try {
      return super.setStep(step);
    } finally {
      _$_StepperViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void incrementStep() {
    final _$actionInfo = _$_StepperViewModelBaseActionController.startAction(
        name: '_StepperViewModelBase.incrementStep');
    try {
      return super.incrementStep();
    } finally {
      _$_StepperViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void decrementStep() {
    final _$actionInfo = _$_StepperViewModelBaseActionController.startAction(
        name: '_StepperViewModelBase.decrementStep');
    try {
      return super.decrementStep();
    } finally {
      _$_StepperViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentStep: ${currentStep}
    ''';
  }
}
