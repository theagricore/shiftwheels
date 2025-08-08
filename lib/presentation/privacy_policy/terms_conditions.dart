import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shiftwheels/core/common_widget/basic_app_bar.dart';
import 'package:shiftwheels/data/add_post/data_source/privacy_policy_source.dart';
import 'package:shiftwheels/presentation/privacy_policy/terms_conditions_bloc/terms_conditions_bloc.dart';

class TermsConditionPage extends StatelessWidget {
  const TermsConditionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TermsBloc(PrivacyPolicySource())..add(LoadTermsEvent()),
      child: Scaffold(
        appBar: BasicAppbar(title: Text('Terms & Conditions',style: Theme.of(context).textTheme.displayLarge,),),
        body: BlocBuilder<TermsBloc, TermsState>(
          builder: (context, state) {
            if (state is TermsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TermsLoaded) {
              return Markdown(
                data: state.content,
                padding: const EdgeInsets.all(16.0),
              );
            } else if (state is TermsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TermsBloc>().add(LoadTermsEvent());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}