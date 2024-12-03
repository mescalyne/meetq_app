import 'package:flutter/material.dart';
import 'package:meetbot_app/widgets/localization.dart';

class DialogPopup extends StatelessWidget {
  final String title;
  final String description;
  final Function onTap;
  
  const DialogPopup({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.only(
            top: 30,
            left: 20,
            right: 20,
            bottom: 30,
          ),
          child: Column(children: [
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  onTap();
                  Navigator.pop(context);
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Text(
                      context.localize('rateNow'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Text(
                      context.localize('maybeLater'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    )),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
