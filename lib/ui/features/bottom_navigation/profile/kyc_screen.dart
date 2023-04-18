import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradexpro_flutter/data/local/constants.dart';
import 'package:tradexpro_flutter/data/models/kyc_details.dart';
import 'package:tradexpro_flutter/utils/alert_util.dart';
import 'package:tradexpro_flutter/utils/button_util.dart';
import 'package:tradexpro_flutter/utils/decorations.dart';
import 'package:tradexpro_flutter/utils/image_util.dart';
import 'package:tradexpro_flutter/utils/text_util.dart';
import '../../../../helper/app_helper.dart';
import '../../../../utils/common_utils.dart';
import '../../../../utils/dimens.dart';
import '../../../../utils/spacers.dart';
import 'my_profile_controller.dart';

class KYCScreen extends StatefulWidget {
  const KYCScreen({Key? key}) : super(key: key);

  @override
  State<KYCScreen> createState() => _KYCScreenState();
}

class _KYCScreenState extends State<KYCScreen> {
  final _controller = Get.put(MyProfileController());
  Rx<KycDetails> kycDetailsRx = KycDetails().obs;
  Rx<File> frontImage = File("").obs;
  Rx<File> backImage = File("").obs;
  Rx<File> selfieImage = File("").obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getKYCDetails((kyc) => kycDetailsRx.value = kyc);
    });
  }

  @override
  void dispose() {
    clearView();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
            child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(Dimens.paddingMid),
          children: [
            Align(alignment: Alignment.centerLeft, child: textAutoSizePoppins("KYC Verification List".tr, fontSize: Dimens.regularFontSizeExtraMid)),
            if (kycDetailsRx.value.nid != null) _kycItemView(kycDetailsRx.value.nid, "National ID Card".tr, AssetConstants.imgNID),
            if (kycDetailsRx.value.nid != null) vSpacer20(),
            if (kycDetailsRx.value.passport != null) _kycItemView(kycDetailsRx.value.passport, "Passport".tr, AssetConstants.imgPassport),
            if (kycDetailsRx.value.passport != null) vSpacer20(),
            if (kycDetailsRx.value.driving != null) _kycItemView(kycDetailsRx.value.driving, "Driving License".tr, AssetConstants.imgDrivingLicense),
            if (kycDetailsRx.value.driving != null) vSpacer20(),
            if (kycDetailsRx.value.voter != null) _kycItemView(kycDetailsRx.value.voter, "Voter Card".tr, AssetConstants.imgVoterCard),
            if (kycDetailsRx.value.voter != null) vSpacer20(),
          ],
        )));
  }

  Widget _kycItemView(KycObject? kyc, String title, String imagePath) {
    return Column(
      children: [
        InkWell(
          onTap: () => showBottomSheetFullScreen(context, _showUploadView(kyc), title: title, onClose: () => clearView()),
          child: Container(
            decoration: boxDecorationRoundCorner(radius: Dimens.radiusCornerMid),
            margin: const EdgeInsets.all(Dimens.paddingLarge),
            height: context.width / 2,
            width: context.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Stack(
                    children: [
                      showImageAsset(
                          imagePath: AssetConstants.icRibbon,
                          height: Dimens.iconSizeMid,
                          width: context.width / 2.5,
                          boxFit: BoxFit.fitWidth,
                          color: getIdVerificationStatusColor(kyc?.status)),
                      Container(
                          padding: const EdgeInsets.all(Dimens.paddingMin),
                          height: Dimens.iconSizeMid,
                          width: context.width / 2.5,
                          child: textAutoSizePoppins(getIdVerificationStatus(kyc?.status), color: Colors.white))
                    ],
                  ),
                ),
                Align(alignment: Alignment.center, child: showImageAsset(imagePath: imagePath, height: context.width / 4)),
              ],
            ),
          ),
        ),
        textAutoSizePoppins(title, fontSize: Dimens.regularFontSizeExtraMid)
      ],
    );
  }

  Widget _showUploadView(KycObject? kyc) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(Dimens.paddingMid),
        children: [
          vSpacer10(),
          textAutoSizeKarla("Front side".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
          Obx(() => _showUploadImage(frontImage.value, PhotoType.front, kyc?.frontImage)),
          vSpacer20(),
          textAutoSizeKarla("Back side".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
          Obx(() => _showUploadImage(backImage.value, PhotoType.back, kyc?.backImage)),
          vSpacer20(),
          textAutoSizeKarla("Selfie".tr, textAlign: TextAlign.start, fontSize: Dimens.regularFontSizeMid),
          Obx(() => _showUploadImage(selfieImage.value, PhotoType.selfie, kyc?.selfieImage)),
          vSpacer20(),
          if (kyc?.status == IdVerificationStatus.notSubmitted || kyc?.status == IdVerificationStatus.rejected)
            buttonRoundedMain(text: "Upload".tr, onPressCallback: () => checkInputData(kyc)),
          vSpacer10(),
        ],
      ),
    );
  }

  Widget _showUploadImage(File file, PhotoType photoType, String? prePath) {
    prePath = prePath ?? "";
    return InkWell(
      child: Container(
        height: context.width / 2,
        width: context.width,
        margin: const EdgeInsets.all(Dimens.paddingLarge),
        decoration: boxDecorationRoundCorner(color: context.theme.backgroundColor),
        child: file.path.isNotEmpty
            ? showImageLocal(file)
            : prePath.isNotEmpty
                ? showImageNetwork(imagePath: prePath)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buttonOnlyIcon(iconPath: AssetConstants.icUpload, size: Dimens.iconSizeMid),
                      vSpacer10(),
                      textAutoSizePoppins("Tap to upload photo".tr),
                    ],
                  ),
      ),
      onTap: () {
        showImageChooser(context, (chooseFile, isGallery) {
          isGallery
              ? setImageInFile(photoType, chooseFile)
              : saveFileOnTempPath(chooseFile, onNewFile: (newFile) => setImageInFile(photoType, newFile));
        }, isCrop: photoType == PhotoType.selfie, isGallery: photoType != PhotoType.selfie);
      },
    );
  }

  void setImageInFile(PhotoType photoType, File file) {
    switch (photoType) {
      case PhotoType.front:
        frontImage.value = file;
        break;
      case PhotoType.back:
        backImage.value = file;
        break;
      case PhotoType.selfie:
        selfieImage.value = file;
        break;
    }
  }

  void clearView() {
    frontImage.value = File("");
    backImage.value = File("");
    selfieImage.value = File("");
  }

  void checkInputData(KycObject? kycObj) {
    if (frontImage.value.path.isEmpty) {
      showToast("Front image can not be empty".tr, isError: true);
      return;
    }
    if (backImage.value.path.isEmpty) {
      showToast("Back image can not be empty".tr, isError: true);
      return;
    }
    if (selfieImage.value.path.isEmpty) {
      showToast("Selfie image can not be empty".tr, isError: true);
      return;
    }
    IdVerificationType type = IdVerificationType.none;
    if (identical(kycObj, kycDetailsRx.value.nid)) {
      type = IdVerificationType.nid;
    } else if (identical(kycObj, kycDetailsRx.value.passport)) {
      type = IdVerificationType.passport;
    } else if (identical(kycObj, kycDetailsRx.value.driving)) {
      type = IdVerificationType.driving;
    } else if (identical(kycObj, kycDetailsRx.value.voter)) {
      type = IdVerificationType.voter;
    }

    // final type = identical(kycObj, kycDetailsRx.value.nid)
    //     ? IdVerificationType.nid
    //     : (identical(kycObj, kycDetailsRx.value.passport) ? IdVerificationType.passport : IdVerificationType.driving);

    _controller.uploadDocuments(type, frontImage.value, backImage.value, selfieImage.value, (kyc) => kycDetailsRx.value = kyc);
  }
}
