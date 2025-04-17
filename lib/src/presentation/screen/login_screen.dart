import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_test2/assets/assets.dart';
import 'package:flutter_plugin_test2/src/data/source/local/chat_local_source.dart';
import 'package:flutter_plugin_test2/src/presentation/controller/app_controller.dart';
import 'package:flutter_plugin_test2/src/presentation/screen/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = "test";
    emailController.text = "test@test.com";

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await AppController().getConfig(
        onSuccess: () async {
          // AppLoggerCS.debugLog("[getConfig] success");
          setState(() {});
        },
        onFailed: (errorMessage) {
          // AppLoggerCS.debugLog("[getConfig] onFailed $errorMessage");
          setState(() {});
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        AppLoggerCS.debugLog("didPop: $didPop");
        AppLoggerCS.debugLog("result: $result");
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Center(
                    // child: (AppController.dataGetConfigValue != null)
                    //     ? Image.memory(
                    //         Uri.parse(AppController.dataGetConfigValue!.avatarImage!).data!.contentAsBytes(),
                    //         // base64Decode(dataGetConfig!.avatarImage!),
                    //         height: 100,
                    //         width: 100,
                    //         fit: BoxFit.cover,
                    //       )
                    //     : Text(
                    //         // "App!",
                    //         (AppController.dataGetConfigValue != null) ? "${AppController.dataGetConfigValue?.avatarName}" : "Cust Service",
                    //         textAlign: TextAlign.center,
                    //         style: GoogleFonts.lato(
                    //           fontSize: 34,
                    //           fontWeight: FontWeight.w700,
                    //         ),
                    //       ),
                    child: (AppController.dataGetConfigValue != null)
                        ? Text(
                            (AppController.dataGetConfigValue != null) ? "${AppController.dataGetConfigValue?.avatarName}" : "Cust Service",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            "App!",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                    // child: Text(
                    //   "App!",
                    //   textAlign: TextAlign.center,
                    //   style: GoogleFonts.lato(
                    //     fontSize: 34,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    // ),
                  ),
                  SizedBox(height: 80),
                  Text(
                    "Name",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "Your name",
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Email",
                    style: GoogleFonts.lato(
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 45,
                    child: TextField(
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Your email",
                        hintStyle: GoogleFonts.lato(
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black38,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.lightBlue.shade100.withOpacity(0.5),
                              blurRadius: 2,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Start Chat!",
                            style: GoogleFonts.lato(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        await AppController()
                            .loadData(
                          name: nameController.text,
                          email: emailController.text,
                        )
                            .then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ChatScreen();
                              },
                            ),
                          );
                        });

                        await ChatLocalSource().getClientData();
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Powered By",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 5),
                        Image.asset(
                          Assets.icKonnek,
                          package: "flutter_plugin_test2",
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
