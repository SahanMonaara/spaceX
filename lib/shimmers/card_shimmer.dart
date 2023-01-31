import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:spacex_launch/shimmers/shimmer_config.dart';
import '../common/app_colors.dart';

class TripCardShimmer extends StatelessWidget {
  final int itemCount;
  final Axis axis;
  final EdgeInsets padding;
  final bool primary;
  final bool shrinkWrap;

  const TripCardShimmer(
      {Key? key,
      this.itemCount = 10,
      this.axis = Axis.vertical,
      this.padding = const EdgeInsets.only(right: 10),
      this.primary = false,
      this.shrinkWrap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: axis,
      itemCount: itemCount,
      primary: primary,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          direction: ShimmerConfig.shimmerDirection,
          baseColor: ShimmerConfig.baseColor,
          highlightColor: ShimmerConfig.highlightColor,
          period: ShimmerConfig.period,
          child: Container(
            height: 250,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.bgBlue,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 20,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        Container(
                          margin:
                              const EdgeInsets.only(left: 9, top: 5, bottom: 5),
                          width: 2,
                          height: 20,
                          color: Colors.white,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 20,
                              height: 10,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 20,
                            height: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 15,
                            height: 10,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 10,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
