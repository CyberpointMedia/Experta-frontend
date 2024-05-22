import '../../../core/app_export.dart';/// This class is used in the [feedsactive_item_widget] screen.
class FeedsactiveItemModel {FeedsactiveItemModel({this.naveenverna, this.naveenverna1, this.text, this.dAgo, this.anjaliSentToMy, this.naveenverna2, this.id, }) { naveenverna = naveenverna  ?? Rx(ImageConstant.imgPlay38x38);naveenverna1 = naveenverna1  ?? Rx("Naveenverna");text = text  ?? Rx("•");dAgo = dAgo  ?? Rx("3d ago");anjaliSentToMy = anjaliSentToMy  ?? Rx("Anjali sent to my son the nices...");naveenverna2 = naveenverna2  ?? Rx(ImageConstant.imgMoreHorizontalBlueGray300);id = id  ?? Rx(""); }

Rx<String>? naveenverna;

Rx<String>? naveenverna1;

Rx<String>? text;

Rx<String>? dAgo;

Rx<String>? anjaliSentToMy;

Rx<String>? naveenverna2;

Rx<String>? id;

 }
