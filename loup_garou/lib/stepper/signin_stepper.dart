import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class SigninStepper extends StatefulWidget {
  const SigninStepper({super.key, required this.indexStepper});

  final int indexStepper;
  @override
  State createState() => _SigninStepperState(indexStepper: indexStepper);
}
class _SigninStepperState extends State<SigninStepper> {
  _SigninStepperState({required this.indexStepper});
   int indexStepper;
  static const Color bgField = Color(0xFFE7E7E7);
  final Color bgContainer = const Color.fromARGB(60, 136, 136, 136);
  static const Color yellow = Color.fromARGB(255, 255, 200, 20);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      width: 500,
      child: EasyStepper(
        showStepBorder: false,
        showLoadingAnimation: false,
        internalPadding: 0,
        defaultStepBorderType: BorderType.normal,
        stepShape: StepShape.rRectangle,
        lineStyle: const LineStyle(
          lineLength: 90,
          lineType: LineType.normal,
          lineThickness: 5,
          lineSpace: 0,
          activeLineColor: yellow,
          defaultLineColor: bgField,
          finishedLineColor: yellow,
          unreachedLineType: LineType.normal,
        ),
        fitWidth: true,
        activeStep: indexStepper,
        steps: [
          EasyStep(
            customStep: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Container(
                    color: indexStepper >= 0 ? yellow : bgField,
                    height: 0,
                    width: 0)),
          ),
          EasyStep(
            
            customStep: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Container(
                    color: indexStepper >= 1 ? yellow : bgField,
                    height: 20,
                    width: 20)),
          ),
          EasyStep(
            customStep: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Container(
                    color: indexStepper >= 2 ? yellow : bgField,
                    height: 20,
                    width: 20)),
          ),
        ],
        onStepReached: (index) =>
            setState(() => indexStepper = index),
    )
      );
  }
}