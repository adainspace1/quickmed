import 'package:flutter/material.dart';


// this is the start widget use to add to the number of star each service provider will get....
class StarsWidget extends StatelessWidget {
  final int numberOfStars;

  const StarsWidget({super.key, required this.numberOfStars});
  @override
  Widget build(BuildContext context) {
    if (numberOfStars == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          )
        ],
      );
    } else if (numberOfStars == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          )
        ],
      );
    } else if (numberOfStars == 2) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          )
        ],
      );
    } else if (numberOfStars == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          const Icon(Icons.star, color: Colors.amber),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          ),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          )
        ],
      );
    } else if (numberOfStars == 4) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.star, color: Colors.amber),
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          const Icon(Icons.star, color: Colors.amber),
          const Icon(Icons.star, color: Colors.amber),
          Icon(
            Icons.star,
            color: const Color.fromARGB(255, 79, 79, 79).withOpacity(0.4),
          )
        ],
      );
    } else {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star, color: Colors.amber),
          Icon(
            Icons.star,
            color: Colors.amber,
          ),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber),
          Icon(Icons.star, color: Colors.amber)
        ],
      );
    }
  }
}
