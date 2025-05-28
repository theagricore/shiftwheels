import 'package:flutter/material.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';

class CustomSwipeButton extends StatefulWidget {
  final VoidCallback onSwipe;
  final String buttonText;
  final bool isLoading;

  const CustomSwipeButton({
    Key? key,
    required this.onSwipe,
    required this.buttonText,
    this.isLoading = false,
  }) : super(key: key);

  @override
  _CustomSwipeButtonState createState() => _CustomSwipeButtonState();
}

class _CustomSwipeButtonState extends State<CustomSwipeButton> {
  double _dragValue = 0;
  final double _buttonWidth = 250;
  final double _thumbSize = 50;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
     final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final secondaryTextColor = isDarkMode ? AppColors.zSecondBackground : AppColors.zWhite;
    return Center(
      child: SizedBox(
        width: _buttonWidth,
        height: 60,
        child: Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                color: secondaryTextColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: widget.isLoading || _isProcessing 
                      ? AppColors.zPrimaryColor.withOpacity(0.5)
                      : AppColors.zPrimaryColor, 
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.isLoading || _isProcessing
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 1,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.zPrimaryColor,
                          ),
                        ),
                      )
                    : Text(
                        widget.buttonText,
                        style: TextStyle(
                          color: widget.isLoading || _isProcessing
                              ? AppColors.zGrey.withOpacity(0.5)
                              : AppColors.zGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            if (!widget.isLoading && !_isProcessing)
              Positioned(
                left: _dragValue.clamp(0, _buttonWidth - _thumbSize),
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragValue += details.delta.dx;
                      if (_dragValue < 0) _dragValue = 0;
                      if (_dragValue > _buttonWidth - _thumbSize) {
                        _dragValue = _buttonWidth - _thumbSize;
                        _isProcessing = true;
                        widget.onSwipe();
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _isProcessing = false;
                              _dragValue = 0;
                            });
                          }
                        });
                      }
                    });
                  },
                  onHorizontalDragEnd: (_) {
                    if (_dragValue < _buttonWidth - _thumbSize) {
                      setState(() => _dragValue = 0);
                    }
                  },
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: AppColors.zPrimaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}