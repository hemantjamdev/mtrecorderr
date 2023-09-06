import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/image_provider.dart';
import '../utils/app_colors.dart';
import '../utils/strings.dart';
import 'images_list.dart';

class FolderList extends StatelessWidget {
  const FolderList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ImageListProvider>(context, listen: false).getAllFolderList();
    return Consumer<ImageListProvider>(
      builder: (context, ImageListProvider provider, child) {
        return provider.modelList.isEmpty
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(Strings.noScreenshots),
                  const SizedBox(height: 10),
                  const Text(
                    "There is no Images",
                    style: TextStyle(color: AppColors.primaryColor),
                  ),
                ],
              ))
            : SingleChildScrollView(
                primary: false,
                //physics: NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Folders : ${provider.modelList.length}"),
                            Text("Images : ${provider.totalImages}"),
                          ],
                        ),
                      )),
                    ),
                    ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      primary: true,
                      shrinkWrap: true,
                      itemCount: provider.modelList.length,
                      itemBuilder: (context, index) =>provider.modelList[index].images!.isNotEmpty? ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageList(
                                        title: provider
                                            .modelList[index].folderName,
                                        images: provider.modelList[index].images
                                                ?.toList() ??
                                            [],
                                      )));
                        },
                        trailing: Text(provider.modelList[index].images!.length
                            .toString()),
                        leading: const Icon(Icons.folder_rounded),
                        title: Text(provider.modelList[index].folderName),
                      ):SizedBox(),
                    )
                  ],
                ),
              );
      },
    );
  }
}
