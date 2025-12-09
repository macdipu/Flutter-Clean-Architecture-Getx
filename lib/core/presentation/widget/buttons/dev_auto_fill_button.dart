import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DevAutoFillButton extends StatelessWidget {
  const DevAutoFillButton({super.key, this.onPressed = const []});
  final List<Function> onPressed;

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox();

    // return FloatingActionButton.small(
    //   onPressed: onPressed,
    //   child: Text(
    //     "DEV",
    //     style: Theme.of(context).textTheme.titleSmall,
    //   ),
    // );

    return SizedBox(
      height: Theme.of(context).buttonTheme.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < onPressed.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () => onPressed.elementAt(i)(),
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                ),
                child: Text(i.toString()),
              ),
            )
        ],
      ),
    );
  }
}
