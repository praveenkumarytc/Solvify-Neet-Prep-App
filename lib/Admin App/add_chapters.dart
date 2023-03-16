import 'package:flutter/material.dart';
import 'package:shield_neet/Utils/color_resources.dart';
import 'package:shield_neet/components/solvify_appbar.dart';
import 'package:shield_neet/helper/flutter_toast.dart';
import 'package:velocity_x/velocity_x.dart';

class AddChapterScreen extends StatelessWidget {
  const AddChapterScreen({super.key, required this.subjectName});
  final String subjectName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: SolvifyAppbar(title: subjectName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const AddChapterCard(),
            Column(
              children: List.generate(
                  10,
                  (index) => ChapterListCard(
                        chapterName: 'Mineral Nutrients',
                        onDelete: () {},
                      )),
            )
          ],
        ),
      ),
    );
  }
}

class ChapterListCard extends StatelessWidget {
  const ChapterListCard({super.key, required this.chapterName, required this.onDelete});

  final String chapterName;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDelete,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ColorResources.PRIMARY_MATERIAL,
            width: .4,
          ),
        ),
        child: ListTile(
          leading: Container(
            height: 45,
            width: 40,
            decoration: BoxDecoration(
              color: ColorResources.PRIMARY_MATERIAL.withOpacity(.8),
              border: Border.all(
                color: ColorResources.BLACK.withOpacity(.4),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              chapterName.split('')[0],
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          title: Text(chapterName),
          trailing: IconButton(
              onPressed: () {
                showToast(message: '$chapterName is deleted successfully');
              },
              icon: const Icon(
                Icons.delete,
                color: ColorResources.COLOR_BLUE,
              )),
        ),
      ),
    );
  }
}

class AddChapterCard extends StatelessWidget {
  const AddChapterCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          color: ColorResources.PRIMARY_MATERIAL,
          width: .4,
        ),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add,
            size: 34,
            color: ColorResources.COLOR_BLUE,
          ),
          10.widthBox,
          const Text(
            'Add a chapter',
            style: TextStyle(
              color: ColorResources.COLOR_BLUE,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }
}
