import 'package:domus/config/size_config.dart';
import 'package:domus/view/home_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:domus/theme/text_theme_extension.dart';

class SavingsContainer extends StatelessWidget {
  const SavingsContainer({Key? key, required this.model}) : super(key: key);

  final HomeScreenViewModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: getProportionateScreenHeight(110),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: const Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(10),
              vertical: getProportionateScreenHeight(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Energy Saving',
                        style: Theme.of(context).textTheme.displayMedium,
                    ),
                      SizedBox(
                        height: getProportionateScreenHeight(8),
                    ),
                    Text(
                      '+35%',
                        style: Theme.of(context).textTheme.displayLarge!.copyWith(
                            color: Colors.green,
                          ),
                    ),
                    SizedBox(
                      height: getProportionateScreenHeight(5),
                    ),
                    Text(
                      '23.5 kWh',
                        style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                  ),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(100),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: -5,
          bottom: -5,
          child: Image.asset(
            'assets/images/thunder.png',
            height: getProportionateScreenHeight(100),
            width: getProportionateScreenWidth(140),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
