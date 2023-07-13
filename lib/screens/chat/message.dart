import 'package:flutter/material.dart';
import 'package:gazali_chat/services/models.dart';

class SentMessage extends StatelessWidget {
  final Message message;

  const SentMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(), // Dynamic width spacer
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 310.0,
                ),
                padding: const EdgeInsets.only(
                  left: 10.0,
                  top: 5.0,
                  bottom: 5.0,
                  right: 5.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        message.text,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
            ],
          ),
          Text(TimeOfDay(hour: message.createdAt.toDate().hour, minute: message.createdAt.toDate().minute).format(context))
        ],
      ),
    );
  }
}

class ReceivedMessage extends StatelessWidget {
  final Message message;

  const ReceivedMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 310.0,
                ),
                padding: const EdgeInsets.only(
                  left: 5.0,
                  top: 5.0,
                  bottom: 5.0,
                  right: 10.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10.0),
                    Flexible(
                      child: Text(
                        message.text,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(), // Dynamic width spacer
            ],
          ),
          Text(TimeOfDay(hour: message.createdAt.toDate().hour, minute: message.createdAt.toDate().minute).format(context))
        ],
      ),
    );
  }
}
