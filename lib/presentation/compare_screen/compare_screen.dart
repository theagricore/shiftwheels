import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/compare_screen/compare_bloc/compare_bloc.dart';
import 'package:shiftwheels/presentation/compare_screen/widget/comparison_view_widget.dart';

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    return BlocProvider(
      create:
          (context) =>
              CompareBloc()..add(LoadFavoritesForComparison(currentUserId)),
      child: const _CompareContent(),
    );
  }
}

class _CompareContent extends StatelessWidget {
  const _CompareContent();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;

    return Scaffold(
      appBar: BasicAppbar(
        title: Text("Compare screen", style: TextStyle(color: textColor)),
      ),
      backgroundColor:
          isDarkMode ? AppColors.zDarkBackground : AppColors.zWhite,
      body: BlocBuilder<CompareBloc, CompareState>(
        builder: (context, state) => _buildContentBasedOnState(context, state),
      ),
    );
  }

  Widget _buildContentBasedOnState(BuildContext context, CompareState state) {
    if (state is CompareInitial || state is CompareLoading) {
      return _buildLoadingView();
    } else if (state is CompareError) {
      return _buildErrorView(context, state);
    } else if (state is PdfGenerated) {
      return _buildPdfGeneratedView(context);
    } else if (state is FavoritesLoadedForComparison) {
      return ComparisonViewWidget(state: state);
    }
    return const SizedBox();
  }

  Widget _buildLoadingView() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.zPrimaryColor,
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, CompareError state) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final errorTextColor = isDarkMode ? AppColors.zred : Colors.red;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: errorTextColor, size: 60),
            const SizedBox(height: 20),
            Text(
              state.message,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: errorTextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPdfGeneratedView(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppColors.zDarkPrimaryText : AppColors.zLightPrimaryText;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.zGreen, size: 60),
            const SizedBox(height: 20),
            Text(
              'PDF generated and shared successfully!',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildBackButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        context.read<CompareBloc>().add(LoadFavoritesForComparison(userId));
      },
      icon: const Icon(Icons.arrow_back, color: AppColors.zDarkPrimaryText),
      label: const Text(
        'Back to Selection',
        style: TextStyle(color: AppColors.zDarkPrimaryText),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.zPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
