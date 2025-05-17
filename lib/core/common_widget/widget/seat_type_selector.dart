import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shiftwheels/core/config/theme/app_colors.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_bloc.dart';
import 'package:shiftwheels/presentation/add_post/seat_type_bloc/seat_type_state.dart';

class SeatTypeSelector extends StatelessWidget {
  final Function(int)? onSeatTypeSelected;

  const SeatTypeSelector({Key? key, this.onSeatTypeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocBuilder<SeatTypeBloc, SeatTypeState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                context.read<SeatTypeBloc>().add(ChangeSeatTypeEvent(5));
                onSeatTypeSelected?.call(5);
              },
              child: Container(
                width: size.width * 0.40,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.zBackGround,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: state.seatCount == 5
                        ? AppColors.zPrimaryColor
                        : AppColors.zfontColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '5-Seat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: state.seatCount == 5
                        ? AppColors.zPrimaryColor
                        : AppColors.zWhite,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                context.read<SeatTypeBloc>().add(ChangeSeatTypeEvent(7));
                onSeatTypeSelected?.call(7);
              },
              child: Container(
                width: size.width * 0.40,
                height: size.height * 0.06,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.zBackGround,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: state.seatCount == 7
                        ? AppColors.zPrimaryColor
                        : AppColors.zfontColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  '7-Seat',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: state.seatCount == 7
                        ? AppColors.zPrimaryColor
                        : AppColors.zWhite,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
