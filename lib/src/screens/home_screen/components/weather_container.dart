import 'package:domus/config/size_config.dart';
import 'package:domus/view/home_screen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:domus/theme/text_theme_extension.dart';

class WeatherContainer extends StatefulWidget {
  const WeatherContainer({Key? key, required this.model}) : super(key: key);

  final HomeScreenViewModel model;

  @override
  State<WeatherContainer> createState() => _WeatherContainerState();
}

class _WeatherContainerState extends State<WeatherContainer> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadWeather());
  }

  Future<void> _loadWeather() async {
    await widget.model.initWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: getProportionateScreenHeight(120),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: getProportionateScreenWidth(100),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.model.isLoadingWeather) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 8),
                        Text(
                          'Loading weather...',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ] else if (widget.model.currentWeather != null) ...[
                        Text(
                          '${widget.model.currentWeather!.temperature.round()}°C',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          widget.model.currentWeather!.condition,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(5),
                        ),
                        Text(
                          widget.model.formattedDate,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          widget.model.currentWeather!.location,
                          style: Theme.of(context).textTheme.bodyLarge,
                        )
                      ] else ...[
                        Text(
                          widget.model.weatherError ?? 'Unable to load weather',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _loadWeather,
                          child: const Text('Retry'),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          bottom: -5,
          child: Image.asset(
            'assets/images/weather/0.png',
            height: getProportionateScreenHeight(110),
            width: getProportionateScreenWidth(140),
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
