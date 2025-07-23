import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/common_widget/widget/basic_snakbar.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/presentation/screen_home/call_bloc/call_bloc.dart';

class InterestedUsersBottomSheet extends StatelessWidget {
  final List<UserModel> users;
  final String title;
  final void Function(UserModel user)? onChatPressed;

  const InterestedUsersBottomSheet({
    super.key,
    required this.users,
    this.title = 'Interested Users',
    this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => CallBloc())],
      child: _InterestedUsersBottomSheetContent(
        users: users,
        title: title,
        onChatPressed: onChatPressed,
      ),
    );
  }
}

class _InterestedUsersBottomSheetContent extends StatelessWidget {
  final List<UserModel> users;
  final String title;
  final void Function(UserModel user)? onChatPressed;

  const _InterestedUsersBottomSheetContent({
    required this.users,
    required this.title,
    this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallFailure) {
          BasicSnackbar(
            message: state.message,
            backgroundColor: AppColors.zred,
          ).show(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDragHandle(),
            _buildTitle(context),
            const SizedBox(height: 16),
            users.isEmpty
                ? _buildEmptyMessage()
                : Flexible(child: _buildUserList(context)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.zGrey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Text(
        'No users have ${title.toLowerCase()} this ad yet.',
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildUserList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final hasImage = user.image != null && user.image!.isNotEmpty;
        final hasPhone = user.phoneNo != null && user.phoneNo!.isNotEmpty;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading:
              hasImage
                  ? CircleAvatar(
                    radius: 25,
                    backgroundImage: CachedNetworkImageProvider(user.image!),
                  )
                  : CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.zPrimaryColor,
                    child: Text(
                      user.fullName?.isNotEmpty == true
                          ? user.fullName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          title: Text(
            user.fullName ?? 'Unknown User',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasPhone)
                Text(
                  user.phoneNo!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              if (user.email != null && user.email!.isNotEmpty)
                Text(user.email!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasPhone)
                BlocBuilder<CallBloc, CallState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        Icons.call,
                        color:
                            state is CallLoading
                                ? AppColors.zGrey
                                : AppColors.zPrimaryColor,
                      ),
                      onPressed:
                          state is CallLoading
                              ? null
                              : () => context.read<CallBloc>().add(
                                MakePhoneCall(user.phoneNo!),
                              ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
