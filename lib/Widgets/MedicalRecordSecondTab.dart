import 'package:flutter/material.dart';

class SecondTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints boxConstraints) { //
        final axisCount = boxConstraints.maxWidth ~/ 170;
        return Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axisCount,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    children: [
                      _buildButton(
                        'Monitoring Sheets',
                        Icons.monitor,
                        Colors.blue.shade400,
                        context,
                      ),
                      _buildButton(
                        'Observations',
                        Icons.remove_red_eye,
                        Colors.purple.shade400,
                        context,
                      ),
                      _buildButton(
                        'Complementary Examinations',
                        Icons.assignment,
                        Colors.green.shade400,
                        context,
                      ),
                      _buildButton(
                        'Medicine Requests',
                        Icons.medication,
                        Colors.red.shade400,
                        context,
                      ),
                      _buildButton(
                        'Medicine Requests',
                        Icons.medication,
                        Colors.red.shade400,
                        context,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },

    );
  }

  Widget _buildButton(
      String title, IconData iconData, Color color, BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You tapped $title'),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 64.0,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
