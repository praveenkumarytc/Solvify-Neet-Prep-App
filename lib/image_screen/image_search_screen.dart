import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/providers/admin_provider.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/pexel_image_model.dart';

class ImageListScreen extends StatefulWidget {
  const ImageListScreen({super.key});

  @override
  State<ImageListScreen> createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  int page = 1;
  Future<void> fetchImageData() async {
    await Provider.of<AdminProvider>(context, listen: false).fetchPexelImages(context, searchController.text, page);
  }

  final ScrollController scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    searchController.text = 'education';
    fetchImageData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AdminProvider>(
      builder: (context, details, child) {
        final pexelImageModel = details.pexelImageModel;

        if (pexelImageModel == null || pexelImageModel.photos == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Photo>? photos = pexelImageModel.photos;
        final int? currentPage = pexelImageModel.page;
        final int totalPages = 10;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            appBar: AppBar(
              // backgroundColor: ColorResources.CHAT_ICON_COLOR,
              title: const Text('Select Image'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(40),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoTextField(
                    controller: searchController,
                    style: TextStyle(color: ColorResources.getBlack54(context)),
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      page = 1;
                      debugPrint('current page ==>> $page');
                      fetchImageData();
                    },
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: IconButton(
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          page = 1;
                          debugPrint('current page ==>> $page');
                          fetchImageData();
                        },
                        icon: const Icon(CupertinoIcons.search),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: photos!.length,
                    itemBuilder: (context, index) {
                      final photo = photos[index];
                      return ImageCard(photo: photo);
                    },
                    separatorBuilder: (context, index) => 10.heightBox,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: ColorResources.getWhite(context),
                    border: Border(
                      top: BorderSide(
                        color: ColorResources.getBlack54(context),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                        onPressed: page < 2
                            ? null
                            : () {
                                FocusScope.of(context).requestFocus(FocusNode());
                                page--;
                                debugPrint('current page ==>> $page');
                                fetchImageData();
                              },
                        child: const Text('<'),
                      ),
                      Text('$page'),
                      OutlinedButton(
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            page++;
                            debugPrint('current page ==>> $page');
                            fetchImageData();
                            scrollController.animToTop();
                          },
                          child: const Text('>'))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ImageCard extends StatelessWidget {
  final Photo photo;

  ImageCard({required this.photo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, photo.src?.landscape);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                imageUrl: photo.src?.landscape ?? '',
                errorWidget: (context, url, error) => Text(photo.alt ?? ''),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.photographer!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    photo.alt ?? "",
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
