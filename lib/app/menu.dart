import 'package:ffi_test/app/performance.dart';
import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              fillColor: const Color.fromRGBO(95, 79, 188, 1),
              shape: const StadiumBorder(),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerformanceView(),
                  ),
                );
              },
              child: Container(
                width: 150,
                alignment: Alignment.center,
                child: const Text(
                  'Performance test',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            RawMaterialButton(
              fillColor: const Color.fromRGBO(95, 79, 188, 1),
              shape: const StadiumBorder(),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const ImageListView(
                //       useImageService: true,
                //     ),
                //   ),
                // );
              },
              child: Container(
                width: 150,
                alignment: Alignment.center,
                child: const Text(
                  'List with smart cache',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
