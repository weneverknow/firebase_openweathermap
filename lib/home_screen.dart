import 'package:firebase_app/constants/constant.dart';
import 'package:firebase_app/profile_screen.dart';
import 'package:firebase_app/providers/login_provider.dart';
import 'package:firebase_app/providers/registration_provider.dart';
import 'package:firebase_app/services/my_location.dart';
import 'package:firebase_app/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Consumer<RegistrationProvider>(
              builder: (context, provider, _) => Consumer<LoginProvider>(
                builder: (context, loginProvider, _) => Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => const ProfileScreen()));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.white54,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(loginProvider
                                        .member?.imageUrl ??
                                    provider.member?.imageUrl ??
                                    'https://cdn.iconscout.com/icon/free/png-256/person-1767893-1502146.png'),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(provider.member?.name ?? '')
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FutureBuilder(
                  future: MyLocation.getCity(),
                  builder: (context, snapshot) {
                    String subLocality = "";
                    if (snapshot.hasData) {
                      subLocality = snapshot.data as String;
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.pin_drop_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              subLocality,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: WeatherService.getCurrentWeather(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                final weather = snapshot.data as Weather;
                                return Column(
                                  children: [
                                    Text(
                                      '${weather.temp.round()}',
                                      style: const TextStyle(
                                          fontSize: 80,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: Image.network(
                                                    iconUrl +
                                                        weather.icon +
                                                        '.png',
                                                    loadingBuilder: (context,
                                                        widget, chunk) {
                                                      return CircularProgressIndicator();
                                                    },
                                                    errorBuilder:
                                                        (context, obj, trace) {
                                                      print("error");
                                                      return Icon(
                                                        Icons.error_rounded,
                                                        color: Colors.white,
                                                      );
                                                    },
                                                  ).image)),
                                        ),
                                        Text(
                                          '${weather.main}',
                                          style: TextStyle(fontSize: 22),
                                        )
                                      ],
                                    ),
                                    Text(
                                      '${weather.description}',
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                );
                              }
                              return const SizedBox.shrink();
                            }),
                      ],
                    );
                  })
            ],
          ))
        ],
      )),
    );
  }
}
