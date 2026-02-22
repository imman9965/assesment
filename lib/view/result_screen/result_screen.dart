import 'package:assesment/core/helpers/widgets/common_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/helpers/widgets/test.dart';
import '../../core/services/fcm_notifications.dart';
import '../../viewmodels/game_view_model.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<GameViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Result")),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center ,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height/3.2),
          Center(
            child: Text(
              "Score: ${vm.score}/${vm.questions.length}",
              style: const TextStyle(fontSize: 34),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () async {
              final scoreText =
                  "Your Score: ${vm.score}/${vm.questions.length}";

              // Show notification
              await FCMService.showLocalNotification(
                title: "Quiz Completed 🎉",
                body: scoreText,
              );

              // Navigate after short delay
              await Future.delayed(const Duration(milliseconds: 500));

              if (context.mounted) {
                context.go("/home");
              }
            },
            child: Container(
              width: 180,
              height: 40,
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Completed",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}