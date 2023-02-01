import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:spacex_launch/common/app_assets.dart';
import 'package:spacex_launch/common/app_colors.dart';
import 'package:spacex_launch/common/custom_text_styles.dart';
import 'package:spacex_launch/helpers/utils.dart';
import 'package:spacex_launch/models/launch.dart';
import 'package:spacex_launch/network/net_exception.dart';
import 'package:spacex_launch/providers/launch_provider.dart';
import 'package:spacex_launch/screens/widgets/launch_item_list_tile.dart';
import '../network/net_result.dart';

class LaunchDetailScreen extends StatefulWidget {
  static const routeName = '/launches-detail-screen';

  const LaunchDetailScreen({Key? key}) : super(key: key);

  @override
  State<LaunchDetailScreen> createState() => _LaunchDetailScreenState();
}

class _LaunchDetailScreenState extends State<LaunchDetailScreen> {
  bool _isInit = false;
  String title = '';
  String? id;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Map data = ModalRoute.of(context)?.settings.arguments as Map;
      if (data['title'] != null) title = data['title'];
      if (data['id'] != null) id = data['id'];
      if (id != null) {
        getLaunchesList(id!);
      }
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  /// > This function is used to get the launch details of a particular launch
  ///
  /// Args:
  ///   id (String): The id of the launch you want to get details for.
  ///
  /// Returns:
  ///   The result of the function is a Future<Result>
  void getLaunchesList(String id) async {
    Provider.of<LaunchProvider>(context, listen: false)
        .changeDetailDataLoadingStatus(true);
    Result result = await Provider.of<LaunchProvider>(context, listen: false)
        .getLaunchDetails(id);
    if (result.exception != null) {
      if (result.exception!.messageId == CommonMessageId.UNAUTHORIZED) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.bgColor,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black)),
          title: Text(
            title,
            style: const TextStyle(color: Colors.black),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: IconButton(
                  onPressed: () {
                    Provider.of<LaunchProvider>(context, listen: false)
                        .tapOnFavourite(id!);
                    setState(() {});
                  },
                  icon: Provider.of<LaunchProvider>(context, listen: false)
                          .checkFavouriteStatus(id!)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        )
                      : const Icon(
                          Icons.favorite_outline,
                          color: Colors.red,
                          size: 30,
                        )),
            ),
          ],
        ),
        body: Consumer<LaunchProvider>(builder: (context, launchProvider, _) {
          if (launchProvider.isDetailDataLoading) {
            return const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Center(child: CircularProgressIndicator()));
          }
          if (launchProvider.currentLaunch == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('No data'),
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildImage(
                        launchProvider.currentLaunch!.links?.patch!.small),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.all(10.0),
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
                        duration:
                            getDuration(launchProvider.currentLaunch!.dateUnix),
                        separatorType: SeparatorType.title,
                        slideDirection: SlideDirection.down,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetailText('Details',
                            launchProvider.currentLaunch!.details ?? "Space X"),
                        buildDetailText(
                            'Flight number',
                            launchProvider.currentLaunch!.flightNumber
                                .toString()),
                        buildDetailText('Launchpad',
                            launchProvider.currentLaunch!.launchpad.toString()),
                      ],
                    ),
                  ],
                ),
                Positioned(
                    bottom: 0,
                    child: buildSocialMediaList(
                        launchProvider.currentLaunch?.links))
              ],
            ),
          );
        }));
  }

  /// It builds a list of social media icons.
  ///
  /// Args:
  ///   links (Links): This is the object that contains the links to the social media
  /// sites.
  ///
  /// Returns:
  ///   A Container widget with a Row widget inside it.
  Widget buildSocialMediaList(Links? links) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: links?.webcast != null,
            child: InkWell(
                onTap: () {
                  Utils.launchWebUrl(links?.webcast ?? "");
                },
                child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset(AppAssets.youTubeLogo))),
          ),
          Visibility(
              visible: links?.article != null,
              child: InkWell(
                onTap: () {
                  Utils.launchWebUrl(links?.article ?? "");
                },
                child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset(AppAssets.article)),
              )),
          Visibility(
              visible: links?.wikipedia != null,
              child: InkWell(
                onTap: () {
                  Utils.launchWebUrl(links?.wikipedia ?? "");
                },
                child: SizedBox(
                    height: 45,
                    width: 45,
                    child: Image.asset(AppAssets.wikipedia)),
              )),
        ],
      ),
    );
  }

  /// It returns a widget that displays a title and a detail.
  ///
  /// Args:
  ///   title (String): The title of the text
  ///   detail (String): The detail text to be displayed.
  ///
  /// Returns:
  ///   A SizedBox widget with a width of the width of the screen.
  Widget buildDetailText(String title, String detail) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTextStyles.titleStyle(),
            ),
            Text(
              detail,
              style: CustomTextStyles.regularStyle(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  /// If the imageUrl is not null, then display the image, otherwise display a grey
  /// box
  ///
  /// Args:
  ///   imageUrl (String): The URL of the image to display.
  ///
  /// Returns:
  ///   A widget that displays an image.
  Widget _buildImage(String? imageUrl) {
    return Center(
      child: ClipRRect(
          child: SizedBox(
        height: 200,
        child: imageUrl != null
            ? Image.network(imageUrl, fit: BoxFit.cover)
            : Container(
                color: Colors.grey.withOpacity(0.5),
              ),
      )),
    );
  }
}
