import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:spacex_launch/common/app_colors.dart';
import 'package:spacex_launch/models/launch.dart';
import '../../common/app_assets.dart';
import '../../common/custom_text_styles.dart';
import '../../providers/launch_provider.dart';

class LaunchItemListTile extends StatefulWidget {
  final Launch singleDetail;

  const LaunchItemListTile({Key? key, required this.singleDetail})
      : super(key: key);

  @override
  State<LaunchItemListTile> createState() => _LaunchItemListTileState();
}

class _LaunchItemListTileState extends State<LaunchItemListTile> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: AppColors.black.withOpacity(0.8),
                offset: const Offset(0, 4),
                blurRadius: 15,
                spreadRadius: 0)
          ]),
      child: Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(widget.singleDetail.links?.patch!.small),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                widget.singleDetail.name ?? "",
                style: CustomTextStyles.titleStyle(),
              ),
            ),
            IconButton(
                onPressed: () {
                  Provider.of<LaunchProvider>(context, listen: false)
                      .tapOnFavourite(widget.singleDetail.id ?? "");
                  setState(() {
                    isFavourite = !isFavourite;
                  });
                },
                icon: Provider.of<LaunchProvider>(context, listen: false)
                        .checkFavouriteStatus(widget.singleDetail.id ?? "")
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(Icons.favorite_outline, color: Colors.red))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SlideCountdown(
            onDone: () {
              debugPrint("Already Launched!!");
            },
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0XFFCBC3C3),
            ),
            textStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700),
            duration: getDuration(widget.singleDetail.dateUnix),
            separatorType: SeparatorType.title,
            slideDirection: SlideDirection.down,
          ),
        ),
        Text(
          "Launch Date: ${DateFormat("dd/MM/yyyy HH:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(widget.singleDetail.dateUnix * 1000))}",
          style: CustomTextStyles.subTitleStyle(),
        ),
      ]),
    );
  }

  Widget _buildImage(String? smallImage) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SizedBox(
          height: 80,
          width: 80,
          child: smallImage != null
              ? Image.network(smallImage, fit: BoxFit.cover)
              : CircleAvatar(
                  child: SvgPicture.asset(
                    AppAssets.logo,
                    fit: BoxFit.fitWidth,
                  ),
                ),
        ));
  }
}

/// It takes the number of seconds remaining until the launch date, and returns a
/// Duration object that represents the difference between the launch date and
/// today's date
///
/// Args:
///   secondsRemaining (int): The number of seconds remaining until the launch date.
///
/// Returns:
///   A Duration object.
getDuration(int secondsRemaining) {
  /// Assuming today date is 2006/03/23
  DateTime today = DateTime(2006, 03, 23);
  DateTime launchDate =
      DateTime.fromMillisecondsSinceEpoch(secondsRemaining * 1000);
  final duration = launchDate.difference(today);
  return duration;
}
