import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:boardease_application/classes/model/tenant.dart';
import 'package:flutter/cupertino.dart';

import '../classes/model/tenantpayment.dart';

class PopUpNotification{

  static void saveInfo(BuildContext context, int indicator){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'SUCCESS',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
        ),
      desc: indicator == 1 ? 'TENANT ADDED' : indicator == 2 ? 'TENANT EDITED' : indicator == 3 ? 'TENANT STATUS SAVED' : indicator == 4 ? 'PAYMENT ADDED' : 'PAYMENT EDITED',
        btnOkText: 'OK',
        descTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      btnOkOnPress: (){
        Navigator.pop(context,true);
      }
    ).show();
  }

  static void removeTenantInfo(BuildContext context, Tenant tenant){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Remove Tenant?',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
        ),
        btnOkText: 'YES',
        btnOkOnPress: (){
          tenant.removeTenant();
        },
        btnCancelText: 'NO',
        btnCancelOnPress: (){
        }
    ).show();
  }

  static void removePaymentInfo(BuildContext context, TenantPayment tPayment){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'Remove Payment?',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
        ),
        btnOkText: 'YES',
        btnOkOnPress: (){
          tPayment.removeTPayment(context);
        },
        btnCancelText: 'NO',
        btnCancelOnPress: (){
        }
    ).show();
  }

  static void cancelInfo(BuildContext context){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Are you sure you want to discard changes?',
      btnOkText: 'YES',
      btnOkOnPress: (){
        Navigator.pop(context, false);
      },
      btnCancelText: 'NO',
      btnCancelOnPress: (){
      }
    ).show();
  }

  static void appInfo(BuildContext context){
    AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        title: 'BOARDEASE APPLICATION',
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 25.0,
        ),
        desc: 'BoardEase is a user-friendly application that provides landlords with an efficient payment tracking feature, allowing them to easily monitor and manage the payment status of their tenants. It simplifies the process of tracking rental payments, ensuring timely and accurate payment records for landlords financial management.',
        btnOkOnPress: (){},
      btnOkText: 'OK',
        descTextStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
    ).show();
  }

}