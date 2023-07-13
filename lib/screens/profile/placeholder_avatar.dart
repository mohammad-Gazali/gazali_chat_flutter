import 'package:flutter/material.dart';

class PlaceholderAvatar extends StatelessWidget {
  const PlaceholderAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 60,
            ),
          ),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(1000)),
                child: OverflowBox(
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 150,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
