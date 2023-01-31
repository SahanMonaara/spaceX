import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:spacex_launch/common/app_colors.dart';
import 'package:spacex_launch/network/net_exception.dart';
import 'package:spacex_launch/network/net_result.dart';
import 'package:spacex_launch/providers/launch_provider.dart';
import 'package:spacex_launch/screens/launch_details_screen.dart';
import 'package:spacex_launch/screens/widgets/launch_item_list_tile.dart';

import '../common/app_assets.dart';
import '../shimmers/card_shimmer.dart';

class LaunchesListScreen extends StatefulWidget {
  static const routeName = '/launches-list-screen';

  const LaunchesListScreen({Key? key}) : super(key: key);

  @override
  State<LaunchesListScreen> createState() => _LaunchesListScreenState();
}

class _LaunchesListScreenState extends State<LaunchesListScreen> {
  bool isDataLoading = false;
  final ScrollController _scrollController = ScrollController();
  int notifyTabCurrentPage = 1;

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // if (Provider.of<NotificationProvider>(context, listen: false)
      //         .notification
      //         .nextPageUrl !=
      //     null) {
      //   notifyTabCurrentPage += notifyTabCurrentPage;
      //   // getRequestedRides(page: notifyTabCurrentPage);
      // }
    }
  }

  getLaunchesList({int? page}) async {
    if (page == null || page == 1) {}
    Provider.of<LaunchProvider>(context, listen: false)
        .changeDataLoadingStatus(true);
    Result result = await Provider.of<LaunchProvider>(context, listen: false)
        .getLaunchesList();
    if (result.exception != null) {
      if (result.exception!.messageId == CommonMessageId.UNAUTHORIZED) {
        return;
      }
    }
  }

  Future<void> onRefresh() async {
    await getLaunchesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlue,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.bgBlue,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Upcoming Launches',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Consumer<LaunchProvider>(builder: (context, launchProvider, _) {
          if (launchProvider.isDataLoading) {
            return const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Center(child: TripCardShimmer()));
          }
          if (launchProvider.launchesList.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('No data'),
              ),
            );
          }
          return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              controller: _scrollController,
              itemCount: launchProvider.launchesList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: InkWell(
                      onTap: () => Navigator.pushNamed(
                          context, LaunchDetailScreen.routeName,
                          arguments: {
                            'id': launchProvider.launchesList[index].id,
                            'title': launchProvider.launchesList[index].name
                          }),
                      child: LaunchItemListTile(
                        singleDetail:launchProvider.launchesList[index],
                      ),
                    ));
              });
        }),
      ),
    );
  }
}

