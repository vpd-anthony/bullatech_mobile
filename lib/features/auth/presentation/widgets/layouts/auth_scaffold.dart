import 'package:bullatech/core/theme/app_colors.dart';
import 'package:bullatech/core/utils/exit_handler.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.path = '/',
    this.showBackButton = false,
    this.onBack,
  });

  final Widget child;
  final bool showBackButton;
  final String path;
  final VoidCallback? onBack;

  @override
  Widget build(final BuildContext context) {
    return WillPopScope(
      onWillPop: () => ExitHandler.showExitDialog(context),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8FAFC),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (final context, final constraints) {
                return Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          // 🔙 Back Button
                          if (showBackButton)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_rounded),
                                onPressed: onBack ??
                                    () {
                                      context.go(path);
                                    },
                              ),
                            ),

                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.04),
                            ),
                            child: const Image(
                              width: 80,
                              height: 80,
                              image: AssetImage(
                                'assets/images/bullacrave.png',
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          child,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
