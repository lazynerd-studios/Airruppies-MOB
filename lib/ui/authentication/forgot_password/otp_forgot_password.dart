import 'package:airruppies/themes.dart';
import 'package:airruppies/ui/authentication/auth_service.dart';
import 'package:airruppies/utils/network.dart';
import 'package:airruppies/widget/appbar.dart';
import 'package:airruppies/widget/button/button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class OtpForgotPassword extends StatefulWidget {

  const OtpForgotPassword({
    Key? key,
    this.data,
  }) : super(key: key);
  // String email;
 final  dynamic data;

  @override
  State<OtpForgotPassword> createState() => _OtpForgotPasswordState();
}

class _OtpForgotPasswordState extends State<OtpForgotPassword> {
  String? currentText;

  var textEditingController;
  late DateTime alert;
  @override
  void initState() {
    super.initState();
    alert = DateTime.now().add(const Duration(seconds: 60));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBars().backButton(context),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Verify your identity',
                    style: TextStyles()
                        .blackTextStyle()
                        .copyWith(fontWeight: FontWeight.w900, fontSize: 20)),
                const SizedBox(
                  height: 8,
                ),
                Text(
                    'An authentication code has been sent to ${widget.data['identifier']}',
                    textAlign: TextAlign.center,
                    style: TextStyles().greyTextStyle()),
                const SizedBox(
                  height: 48,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      keyboardType: TextInputType.number,
                       textStyle: TextStyles().blackTextStyle(),
                      pastedTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white,
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      // obscuringWidget: const FlutterLogo(
                      //   size: 24,
                      // ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        borderWidth: 1.5,
                        activeFillColor: Colors.white,
                        inactiveColor: const Color.fromARGB(255, 214, 214, 218),
                        selectedFillColor: Colors.white,
                        selectedColor: const Color.fromARGB(255, 214, 214, 218),
                        disabledColor: const Color.fromARGB(255, 214, 214, 218),
                        inactiveFillColor:
                            const Color.fromARGB(255, 214, 214, 218),
                      ),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      // errorAnimationController: errorController,
                      controller: textEditingController,
                      //  keyboardType: TextI,

                      onCompleted: (v) {
                        debugPrint('Completed');
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        debugPrint(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        debugPrint('Allowing to paste $text');
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
                const SizedBox(
                  height: 20,
                ),
                TimerBuilder.scheduled([alert], builder: (context) {
                  // This function will be called once the alert time is reached
                  var now = DateTime.now();
                  var reached = now.compareTo(alert) >= 0;

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Icon(
                        //   reached ? Icons.alarm_on : Icons.alarm,
                        //   color: reached ? Colors.red : Colors.green,
                        //   size: 48,
                        // ),
                        !reached
                            ? TimerBuilder.periodic(const Duration(seconds: 1),
                                alignment: Duration.zero, builder: (context) {
                                // This function will be called every second until the alert time
                                var now = DateTime.now();
                                var remaining = alert.difference(now);
                                return Text(formatDuration(remaining)
                                    // remaining.toString().trim(),

                                    );
                              })
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    alert = DateTime.now()
                                        .add(const Duration(seconds: 60));

                                    AuthService().resendResetPasswordOtp(
                                        context, widget.data);
                                  });

                                  //sendOtp()
                                },
                                child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: 'Still not getting OPT?  ',
                                            style: TextStyles()
                                                .greyTextStyle()
                                                .copyWith(fontSize: 14)),
                                        TextSpan(
                                            text: ' Resend Otp',
                                            style: TextStyles()
                                                .purpleTextStyle()
                                                .copyWith(fontSize: 14)),
                                      ],
                                    )),
                              ),
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 30,
                ),
                MyButton(
                    text: 'Continue',
                    onPressed: () {
                      AuthService().verifyOtpforResetPassword(context, {
                        'identifier': widget.data!['identifier'],
                        'otp': currentText
                      });
                    }),
                const SizedBox(
                  height: 20,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: 'Want to switch?  ',
                            style: TextStyles()
                                .greyTextStyle()
                                .copyWith(fontSize: 14)),
                        TextSpan(
                            text: ' Email address',
                            style: TextStyles()
                                .purpleTextStyle()
                                .copyWith(fontSize: 14)),
                      ],
                    )),
              ],
            )),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String hours = duration.inHours.toString().padLeft(0, '2');
    String minutes =
        duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  resendOtpForgotPassword() {


    // if (textController1.text.isEmpty) {
    //   setState(() {
    //     Navigator.push(
    //         context, MaterialPageRoute(builder: (context) => HomeNavBar()));
    //   });
    // } else {
    //Navigator.push(context,
    //    MaterialPageRoute(builder: (context) => LoadingListPage()));
    //
    var body = {
      //"email": widget.email,
    };
    var header = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (kDebugMode) {
      print(body);
    }
    HttpRequest('/user/auth/forgot-password',
        body: body,
        headers: header,
        context: context,
        loader: LoaderType.popup, onSuccess: (_, result) async {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: result['message'],
        ),
      );
    }, onFailure: (_, result) {
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: result['message'],
        ),
      );

      // print(result['details']);
      return;
    }).send();

    // }
  }
}
