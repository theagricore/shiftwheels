import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/data/add_post/data_source/privacy_policy_source.dart';
import 'package:shiftwheels/presentation/privacy_policy/privacy%20_policy_bloc/privacy_policy_bloc.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              PrivacyPolicyBloc(PrivacyPolicySource())
                ..add(LoadPrivacyPolicyEvent()),
      child: Scaffold(
        appBar: BasicAppbar(title: Text('Privacy Policy',style: Theme.of(context).textTheme.displayLarge,)),
        body: BlocBuilder<PrivacyPolicyBloc, PrivacyPolicyState>(
          builder: (context, state) {
            if (state is PrivacyPolicyLoading) {
              return _buildLoadingState();
            } else if (state is PrivacyPolicyLoaded) {
              return _buildContent(state.content);
            } else if (state is PrivacyPolicyError) {
              return _buildErrorState(state.message, context);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent(String content) {
    return Markdown(data: content, padding: const EdgeInsets.all(16.0));
  }

  Widget _buildErrorState(String message, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Error: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<PrivacyPolicyBloc>().add(LoadPrivacyPolicyEvent());
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
