import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/common_widget/text_form_feald_widget.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_elevated_app_button.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'package:shiftwheels/presentation/add_post/post_ad_bloc/post_ad_bloc.dart';

class ScreenPrice extends StatelessWidget {
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final String transmissionType;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;
  final List<String> imagePaths;

  ScreenPrice({
    super.key,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmissionType,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
    required this.imagePaths,
  });

  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostAdBloc, PostAdState>(
      listener: (context, state) {
        if (state is PostAdSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DonePostingSplashScreen(),
            ),
          );
          
          Future.delayed(const Duration(seconds: 3), () {
            // ignore: use_build_context_synchronously
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
        } else if (state is PostAdError) {
          BasicSnackbar(message: state.message, backgroundColor: Colors.red).show(context);
        }
      },
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Set a price",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              child: Column(
                children: [
                  TextFormFieldWidget(
                    label: "Price*",
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  const Spacer(),
                  BlocBuilder<PostAdBloc, PostAdState>(
                    builder: (context, state) {
                      return BasicElevatedAppButton(
                        onPressed: () {
                          if (priceController.text.isEmpty) {
                            BasicSnackbar(
                              message: 'Please enter a price',
                              backgroundColor: Colors.red,
                            ).show(context);
                            return;
                          }

                          final price = double.tryParse(priceController.text);
                          if (price == null || price <= 0) {
                            BasicSnackbar(
                              message: 'Please enter a valid price',
                              backgroundColor: Colors.red,
                            ).show(context);
                            return;
                          }

                          context.read<PostAdBloc>().add(
                            SubmitAdEvent(
                              userId: userId,
                              brand: brand,
                              model: model,
                              fuelType: fuelType,
                              transmissionType: transmissionType,
                              year: year,
                              kmDriven: kmDriven,
                              noOfOwners: noOfOwners,
                              description: description,
                              location: location,
                              imageFiles: imagePaths,
                              price: price,
                            ),
                          );
                        },
                        isLoading: state is PostAdLoading,
                        title: "Done",
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DonePostingSplashScreen extends StatefulWidget {
  const DonePostingSplashScreen({super.key});

  @override
  State<DonePostingSplashScreen> createState() =>
      _DonePostingSplashScreenState();
}

class _DonePostingSplashScreenState extends State<DonePostingSplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _hasPlayedSound = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        _navigateAfterAnimation();
      } else if (status == AnimationStatus.forward && !_hasPlayedSound) {
        await _playSuccessSound();
      }
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      debugPrint('Player state: $state');
      if (state == PlayerState.playing) {
        _hasPlayedSound = true;
      }
    });

    _audioPlayer.onLog.listen((event) {
      debugPrint('AudioPlayer log: $event');
    });
  }

  Future<void> _playSuccessSound() async {
    try {
      debugPrint('Attempting to play sound');

      await _audioPlayer.stop();

      await _audioPlayer.setSourceAsset('assets/images/success-1-6297.mp3');

      await _audioPlayer.resume();

      debugPrint('Sound playback initiated');
    } catch (e) {
      debugPrint('Error playing sound: $e');
      await _tryAlternativePlayMethod();
    }
  }

  Future<void> _tryAlternativePlayMethod() async {
    try {
      final bytes = await rootBundle.load('assets/images/success-1-6297.mp3');
      await _audioPlayer.setSourceBytes(bytes.buffer.asUint8List());
      await _audioPlayer.resume();
    } catch (e) {
      debugPrint('Alternative play method failed: $e');
    }
  }

  void _navigateAfterAnimation() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.zPrimaryColor,
     
      body: Center(
        child: Lottie.asset(
          'assets/images/Animation - Done-w3000-h3000.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward();
          },
        ),
      ),
    );
  }
}
