// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/return_product/services/refund_service.dart';
import 'package:ecommerce_major_project/models/returns.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/features/admin/services/admin_services.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';

class ReturnDetailsScreen extends StatefulWidget {
  static const String routeName = "/return-details";
  final Return returns;

  const ReturnDetailsScreen({Key? key, required this.returns})
      : super(key: key);

  @override
  State<ReturnDetailsScreen> createState() => _ReturnDetailsScreenState();
}

class _ReturnDetailsScreenState extends State<ReturnDetailsScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();
  //final int allowReturnProductDays = 15;
  //bool allowReturn = false;
  bool viewMoreDetails = true;
  final RefundServices refundServices = RefundServices();
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );
  List<Step> steps = [];

  @override
  void initState() {
    currentStep = getCurrentStep(widget.returns.returnStatus);
    steps = widget.returns.returnStatus.contains('ORDER_RETURN_REJECTED') ? List.from([
      Step(
        title: const Text("ORDER_RETURN_REQUESTED"),
        content: const Text("Your return is currently requested."),
        isActive: currentStep > 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text("ORDER_RETURN_REJECTED"),
        content: const Text("Your return request is rejected."),
        isActive: currentStep >= 1,
        state: currentStep >= 1 ? StepState.complete : StepState.indexed,
      ),
    ]): List.from([
      Step(
        title: const Text("ORDER_RETURN_REQUESTED"),
        content: const Text("Your return is currently requested."),
        isActive: currentStep > 0,
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text("ORDER_RETURN_ACCEPTED"),
        content: const Text("Your return request is accepted."),
        isActive: currentStep >= 1,
        state: currentStep >= 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text("ORDER_RETURN_PENDING"),
        content: const Text("Your return is in process."),
        isActive: currentStep >= 2,
        state: currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text("ORDER_RETURN_COMPLETE"),
        content: const Text("Your return is completed."),
        isActive: currentStep >= 3,
        state: currentStep >= 3 ? StepState.complete : StepState.indexed,
      ),
    ]);

    super.initState();
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          title: "Return Details",
          context: context,
          onClickSearchNavigateTo: const MySearchScreen()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mq.width * .025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Return Product(s)",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(mq.width * .025),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0;
                        i < widget.returns.returnProducts.length;
                        i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: widget.returns.returnProducts[i]
                                  ['product']['_id'],
                            );
                          },
                          child: Row(
                            children: [
                              Image.network(
                                  widget.returns.returnProducts[i]['product']
                                      ['images'][0],
                                  height: mq.width * .25,
                                  width: mq.width * .25),
                              SizedBox(width: mq.width * .0125),
                              // using expanded to allow text to overflow
                              // in case name of the product is too long
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.returns.returnProducts[i]
                                          ['product']['name'],
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Color:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 11),
                                          maxLines: 2,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: mq.width * .01),
                                          width: mq.width * .025,
                                          height: mq.width * .025,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                '${widget.returns.returnProducts[i]['color']}')),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: mq.width * .025),
                                            child: Text(
                                              "Size: ${widget.returns.returnProducts[i]['size']}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11),
                                              maxLines: 2,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: mq.width * .025),
                                            child: Text(
                                              "Quantity: x${widget.returns.returnProducts[i]['quantity']}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11),
                                              maxLines: 2,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: mq.width * .025),
              const Text(
                "Tracking",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Container(
                height: mq.height * .35,
                width: double.infinity,
                padding: EdgeInsets.all(mq.width * .04),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                ),
                child: Stepper(
                    elevation: 3,
                    controlsBuilder: (context, details) {
                      // if (user.type == "admin") {
                      //   return CustomButton(
                      //       text: "Done",
                      //       onTap: () =>
                      //           changeOrderStatus(details.currentStep));
                      // }
                      return const SizedBox();
                    },
                    currentStep: currentStep,
                    steps: steps),
              ),
              SizedBox(height: mq.width * .025),
              InkWell(
                onTap: () {
                  setState(() {
                    viewMoreDetails = !viewMoreDetails;
                  });
                },
                child: Row(
                  children: [
                    const Text("More Details",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue)),
                    viewMoreDetails
                        ? const Icon(Icons.arrow_drop_up)
                        : const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              viewMoreDetails
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(mq.width * .025),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Return Date:'),
                              Text(DateFormat('yMMMd').format(
                                  DateTime.parse(widget.returns.createdAt)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Return ID:'),
                              Text(widget.returns.id)
                            ],
                          ),
                          //TODO RETURN TOTAL
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Return Total:'),
                              // Text(indianRupeesFormat
                              //     .format(widget.returns.))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Status:'),
                              Text(widget.returns.returnStatus)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Refund Status:'),
                              Text(widget.returns.refundStatus)
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
              SizedBox(height: mq.width * .025),
            ],
          ),
        ),
      ),
    );
  }

  int getCurrentStep(String status) {
    int setStatus = 0;
    switch (status) {
      case 'ORDER_RETURN_REQUESTED':
        setStatus = 0;
        break;
      case 'ORDER_RETURN_ACCEPTED':
        setStatus = 1;
        break;
      case 'ORDER_RETURN_REJECTED':
        setStatus = 1;
        break;
      case 'ORDER_RETURN_PENDING':
        setStatus = 2;
        break;
      case 'ORDER_RETURN_COMPLETE':
        setStatus = 3;
        break;
      default:
        setStatus = 0;
        break;
    }
    return setStatus;
  }
}
