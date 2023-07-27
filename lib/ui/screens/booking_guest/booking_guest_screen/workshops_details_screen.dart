import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/get_started_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class WorkshopsDetailsScreen extends BaseStatelessWidget {
  static const routeName = '/workshops-guest-screen';

  WorkshopsDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: const AppBarForMoreScreens(title: 'Workshop Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _getHeaderImage(),
            const SizedBox(height: 24.0),
            const Text(
              'Anger Management',
              style: TextStyle(
                  color: ConstColors.app,
                  fontWeight: FontWeight.w700,
                  fontSize: 18),
            ),
            const Text(
              'Facilitated by',
              style: TextStyle(
                  color: ConstColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
            ),
            const SizedBox(height: 9.0),
            _getTherapistsNameAndImages(),
            const SizedBox(height: 24.0),
            _getWorkshopDetails(context),
          ],
        ),
      ),
    );
  }

  //Header Image
  Widget _getHeaderImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: Container(
          color: Colors.redAccent,
          width: width,
          height: height * 0.20,
          child: CachedNetworkImage(
            imageUrl:
                "https://cdni.iconscout.com/illustration/premium/thumb/group-therapy-3163253-2655839.png",
            placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                child: Container(
                  height: double.infinity,
                  // width: SizeConfig.widthMultiplier * 100,
                  decoration: const BoxDecoration(color: Colors.black26),
                )),
            errorWidget: (context, url, error) => const SizedBox(
                // height: SizeConfig.widthMultiplier * 15,
                // width: SizeConfig.widthMultiplier * 15,
                child: Center(child: Icon(Icons.error))),
            fit: BoxFit.cover,
            fadeOutDuration: const Duration(milliseconds: 1500),
            fadeInDuration: const Duration(milliseconds: 1000),
            fadeInCurve: Curves.easeInCubic,
            placeholderFadeInDuration: const Duration(milliseconds: 10),
            cacheKey:
                "https://cdni.iconscout.com/illustration/premium/thumb/group-therapy-3163253-2655839.png",
          ),
        ),
      ),
    );
  }

  //Therapists name and images
  Widget _getTherapistsNameAndImages() {
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        _getTherapistDetailsRow(),
        _getTherapistDetailsRow(),
        _getTherapistDetailsRow(),
      ],
    );
  }

  Widget _getTherapistDetailsRow() {
    return SizedBox(
      width: width * 0.40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            backgroundImage: AssetImage(AssPath.avatar1),
          ),
          SizedBox(width: 8.0),
          Text(
            'Ashraf Adel',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: ConstColors.text),
          )
        ],
      ),
    );
  }

  //Workshop details
  Widget _getWorkshopDetails(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: const RoundedRectangleBorder(
            side: BorderSide(color: ConstColors.disabled),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            )),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                children: const [
                  Text(
                    'Want to learn about the basics of Art Therapy and its application? Then this 2-day introductory theoretical and practical workshop is for you. In this workshop, attendees are offered an insightful lecture, followed by an interactive hands-on experience using a variety of art materials – participants have the opportunity to explore different art mediums, and understand the meanings and symbols of their drawings. \n\nIf you are interested in pursuing a career in Art Therapy, or are just intrigued and want to learn more, this workshop is a perfect way to get your feet wet. Throughout the workshop, you will experience the following: Gain knowledge of what Art Therapy is, and is not Learn the history and theory of Art Therapy, and how it is applied with various populations, both adults and children How to understand your own drawings and art How to identify pathological artwork (for example: artwork that shows signs of depression, schizophrenia, bipolar, brain damage, developmental delays, etc.) ',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              const Text(
                'Disclaimer',
                style: TextStyle(
                    color: ConstColors.app,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Please note that all materials in the package are necessary to participate. \n\nIf you are located outside of Cairo or have any concerns about the package please contact us.',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text),
              ),
              const SizedBox(height: 24.0),
              _getStartedButton(() => showModalBottomSheet<void>(
                backgroundColor: Colors.white,
                context: context,
                isScrollControlled: true,
                clipBehavior: Clip.antiAlias,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    )),
                builder: (BuildContext context) =>GetStartedWidget(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  //Get Started button
  Widget _getStartedButton(Function() onPressed) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.getStarted)),
        ),
      ),
    );
  }
}
