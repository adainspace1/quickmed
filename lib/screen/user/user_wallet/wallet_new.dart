// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/util/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ade_flutterwave_working_version/core/ade_flutterwave.dart';

class WalletNew extends StatefulWidget {
  const WalletNew({super.key});

  @override
  State<WalletNew> createState() => _WalletNewState();
}

class _WalletNewState extends State<WalletNew> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  //for the nigeria currrency
  //final String currency = FlutterwaveCurrency.NGN;

  //for the form state
  final formKey = GlobalKey<FormState>();
  //amount text editing controller
  final TextEditingController amount = TextEditingController();

  void openBox({String? price}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Amount"),
        content: Column(
          children: [
            TextField(
              controller: amount,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: COLOR_ACCENT),
            onPressed: () {
              if (amount.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text("Fill The Amount")));
                return;
              }
              var data = {
                'amount': amount.text,
                'payment_options': 'card, banktransfer, ussd',
                'title': 'Flutterwave payment',
                'currency': "NGN",
                'tx_ref':
                    "AdeFlutterwave-${DateTime.now().millisecondsSinceEpoch}",
                'icon':
                    "https://www.aqskill.com/wp-content/uploads/2020/05/logo-pde.png",
                'public_key': "FLWPUBK_TEST-c3b9f15b0070b4151d09f1b7920000fa-X",
                'sk_key': 'FLWSECK_TEST-3a4c97270cc4adaa7ff769c474f846bb-X'
              };
              changeScreen(context, AdeFlutterWavePay(data));
            },
            child: const Text(
              "Fund",
              style: TextStyle(color: COLOR_BACKGROUND),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //model.UserModel? user = Provider.of<UserAppProvider>(context).getUser;

    return Container(
      decoration: BoxDecoration(gradient: appBgGradient),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: COLOR_ACCENT,
                  statusBarIconBrightness: Brightness.light,
                ),
                elevation: 0,
              )),
          body: Container(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: false,
              controller: _refreshController,
              header: const WaterDropMaterialHeader(
                backgroundColor: Colors.red,
                color: Colors.amber,
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 210,
                        padding:
                            const EdgeInsets.only(top: 30, left: 16, right: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 30,
                            ),
                            const SizedBox(
                              width: 120,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Available Balance',
                                    style: TextStyle(
                                      fontFamily: 'sfpro',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16.0,
                                      letterSpacing: 0.37,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    '0.0',
                                    style: TextStyle(
                                      fontFamily: 'sfpro',
                                      color: Colors.white,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 40.0,
                                      letterSpacing: 0.36,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(
                                            top: 16, bottom: 16),
                                        itemCount: 8,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Shimmer.fromColors(
                                          baseColor:
                                              Colors.grey.withOpacity(0.25),
                                          highlightColor:
                                              Colors.grey.withOpacity(0.5),
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            width: 20,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        separatorBuilder:
                                            (BuildContext context, int index) {
                                          return const SizedBox(height: 16);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                    top: 170,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 32,
                        height: 120,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Row(
                          children: [
                            _dashBTns(
                                svg: "plus1",
                                btnText: 'Fund',
                                onTap: () {
                                  //handlePaymentInitialization();
                                  openBox();
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Widget _dashBTns({String? svg, String? btnText, Function? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                      width: 24,
                      height: 24,
                      child: SvgPicture.asset(
                        'images/$svg.svg',
                      )),
                ],
              ),
              const SizedBox(
                height: 18,
              ),
              Text(
                '$btnText',
                style: const TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 18.0,
                  letterSpacing: 0.37,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
