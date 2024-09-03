import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:smarthike/api/smarthike_api.dart';
import 'package:smarthike/constants.dart';
import 'package:smarthike/core/init/gen/translations.g.dart';
import 'package:smarthike/main.dart';
import 'package:smarthike/models/fav_hike.dart';
import 'package:smarthike/models/hike.dart';
import 'package:smarthike/components/hike/details_card.dart';
import 'package:smarthike/models/hike_file.dart';
import 'package:smarthike/pages/hike/add_image_page.dart';
import 'package:smarthike/providers/auth_provider.dart';
import 'package:smarthike/providers/hike_paginated_provider.dart';
import 'package:smarthike/providers/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smarthike/services/hike_service.dart';

class HikeDetailsPage extends StatefulWidget {
  const HikeDetailsPage({super.key});

  @override
  HikeDetailsPageState createState() => HikeDetailsPageState();
}

class HikeDetailsPageState extends State<HikeDetailsPage> {
  List<HikeFav> favHikes = [];
  late ApiService apiService;
  late AuthProvider authProvider;
  late Hike? hike;

  @override
  void initState() {
    super.initState();
    apiService = Provider.of<ApiService>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      getFavHikes();
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final hikeId =
        Provider.of<HikeProvider>(context, listen: false).selectedHike?.id;
    if (hikeId != null) {
      final fetchedHike = await Provider.of<HikeService>(context, listen: false)
          .getHike(hikeId);
      setState(() {
        hike = fetchedHike;
      });
    } else {
      setState(() {
        hike = null;
      });
    }
  }

  Future<void> getFavHikes() async {
    if (authProvider.user != null) {
      final response = await apiService.get('/hike/favorites');
      final data = response;

      setState(() {
        favHikes = (data["items"] as List)
            .map((item) => HikeFav.fromJson(item))
            .toList();
      });
    }
  }

  Future<void> addToFavorite(Hike hike) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .addHikeToFavorite(hike);
      setState(() {
        favHikes.add(HikeFav(id: hike.id, osmId: hike.osmId, name: hike.name));
      });
    } catch (e) {
      if (e.toString().contains('401')) {
        Fluttertoast.showToast(
          msg: LocaleKeys.api_security_must_be_login_to_favorite.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Fluttertoast.showToast(
          msg: LocaleKeys.api_error_.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  Future<void> removeFromFavorite(Hike hike) async {
    try {
      await Provider.of<UserProvider>(context, listen: false)
          .removeHikeToFavorite(hike);
      setState(() {
        favHikes.removeWhere((favHike) => favHike.id == hike.id);
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: LocaleKeys.api_error_.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Scaffold(
      backgroundColor: Constants.thirdColor,
      body: Builder(
        builder: (BuildContext context) {
          if (hike == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final isFavorite = favHikes.any((favHike) => favHike.id == hike!.id);
          final List<HikeFile> files = (hike!.files.isNotEmpty)
              ? hike!.files.map((file) {
                  return HikeFile(
                      id: file.id,
                      link: kDebugMode
                          ? 'http://10.29.125.217:9000${file.link}'
                          : file.link);
                }).toList()
              : [HikeFile(id: 0, link: "assets/images/hikeImageWaiting.jpg")];
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 30),
                  child: Stack(
                    children: [
                      _buildImageCarousel(context, files, hike!),
                      Positioned(
                        top: 35,
                        left: 16,
                        child: FloatingActionButton(
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () {
                            SmartHikeApp.navBarKey.currentState
                                ?.navigateToPage(9);
                          },
                          child:
                              const Icon(Icons.arrow_back, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hike!.name,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      user != null
                          ? IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    isFavorite ? Constants.primaryColor : null,
                              ),
                              onPressed: () {
                                if (!isFavorite) {
                                  addToFavorite(hike!);
                                } else {
                                  removeFromFavorite(hike!);
                                }
                              },
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: DetailsCard(hike: hike!),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageCarousel(
      BuildContext context, List<HikeFile> files, Hike hike) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        aspectRatio: 16 / 9,
      ),
      items: _getCarouselItems(context, files, hike),
    );
  }

  List<Widget> _getCarouselItems(
      BuildContext context, List<HikeFile> files, Hike hike) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    List<Widget> imageList = files.map((file) {
      return Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: file.link.startsWith("assets")
              ? Image.asset(file.link, fit: BoxFit.cover, width: 1000.0)
              : Image.network(file.link, fit: BoxFit.cover, width: 1000.0),
        ),
      );
    }).toList();

    imageList.add(Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GestureDetector(
        onTap: user != null
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddImagePage(hike: hike)),
                );
              }
            : null,
        child: Center(
          child: user != null
              ? Icon(Icons.add_a_photo, color: Colors.black, size: 50.0)
              : Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Center(
                      child: Text(
                        'Vous devez vous connecter pour ajouter une image',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center, // Center the text
                      ),
                    ),
                  ),
                ),
        ),
      ),
    ));

    return imageList;
  }
}
