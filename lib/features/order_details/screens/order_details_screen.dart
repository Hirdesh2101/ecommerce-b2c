// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_major_project/features/product_details/screens/product_detail_screen.dart';
import 'package:ecommerce_major_project/features/return_product/return_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_major_project/common/widgets/custom_button.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/admin/services/admin_services.dart';
import 'package:ecommerce_major_project/features/search/screens/search_screen.dart';
import 'package:ecommerce_major_project/features/search_delegate/my_search_screen.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "/order-details";
  final Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  int currentStep = 0;
  final AdminServices adminServices = AdminServices();
  final int allowReturnProductDays = 15;
  bool allowReturn = false;
  bool viewMoreDetails = true;
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );
  List<Step> steps = [];

  @override
  void initState() {
    currentStep = getCurrentStep(widget.order.status);
    steps = widget.order.status.contains('ORDER_RETURN')
        ? List.from([
            Step(
              title: const Text("ORDER_RETURN_REQUESTED"),
              content: const Text("Your order is yet to be delivered"),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("ORDER_RETURN_ACCEPTED"),
              content: const Text("Your order is yet to be delivered"),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("ORDER_RETURN_REJECTED"),
              content: const Text("Your order is yet to be delivered"),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("ORDER_RETURN_PENDING"),
              content: const Text("Your order is yet to be delivered"),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
            Step(
              title: const Text("ORDER_RETURN_COMPLETE"),
              content: const Text("Your order is yet to be delivered"),
              isActive: currentStep > 0,
              state: currentStep > 0 ? StepState.complete : StepState.indexed,
            ),
          ])
        : widget.order.status.contains('ORDER_CANCELLED')
            ? List.from([
                Step(
                  title: const Text("ORDER_CANCELLED"),
                  content: const Text("Your order is yet to be delivered"),
                  isActive: currentStep > 0,
                  state:
                      currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
              ])
            : List.from([
                Step(
                  title: const Text("ORDER_RECEIVED"),
                  content: const Text("Your order is yet to be delivered"),
                  isActive: currentStep > 0,
                  state:
                      currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  // title: Text("Shipping"),
                  title: const Text("ORDER_PACKING"),
                  content: const Text("Your are order has been shipped"),
                  isActive: currentStep > 1,
                  state:
                      currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text("ORDER_IN_TRANSIT"),
                  content:
                      const Text("Your order has been delievered successfully"),
                  isActive: currentStep > 2,
                  state:
                      currentStep > 2 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  // title: Text("Completed"),
                  title: const Text("ORDER_OUT_FOR_DELIVERY"),
                  content: const Text("Your order is completed."),
                  isActive: currentStep >= 3,
                  state:
                      currentStep >= 3 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  // title: Text("Completed"),
                  title: const Text("ORDER_DELIVERED"),
                  content: const Text("Your order is completed."),
                  isActive: currentStep >= 3,
                  state:
                      currentStep >= 3 ? StepState.complete : StepState.indexed,
                ),
              ]);
    super.initState();
  }

  void navigateToSearchScreen(String query) {
    //make sure to pass the arguments here!
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  // only for admins
  void changeOrderStatus(int status) {
    adminServices.changeOrderStatus(
        context: context,
        status: status + 1,
        order: widget.order,
        onSuccess: () {
          // setState(() {
          //   if (currentStep <= 2) {
          //     currentStep += 1;
          //   }
          // });
        });
  }

  // find the number of dayssince the order was placed
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateOfPurchase =
        DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt);
    DateTime presentDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);

    daysBetween(dateOfPurchase, presentDate) <= allowReturnProductDays
        ? allowReturn = true
        : allowReturn = false;

    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: GlobalVariables.getAppBar(
          title: "Order Details",
          context: context,
          onClickSearchNavigateTo: const MySearchScreen()),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(mq.width * .025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Product(s) purchased",
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
                    for (int i = 0; i < widget.order.products.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              ProductDetailScreen.routeName,
                              arguments: widget.order.products[i]['product']
                                  ['_id'],
                            );
                          },
                          child: Row(
                            children: [
                              Image.network(
                                  widget.order.products[i]['product']['images']
                                      [0],
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
                                      widget.order.products[i]['product']
                                          ['name'],
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
                                            color: Color(int.parse('0xFF'
                                                '${widget.order.products[i]['color'].substring(1)}')),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: mq.width * .025),
                                            child: Text(
                                              "Size: ${widget.order.products[i]['size']}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11),
                                              maxLines: 2,
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: mq.width * .025),
                                            child: Text(
                                              "Quantity: x${widget.order.products[i]['quantity']}",
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
                      if (user.type == "admin") {
                        return CustomButton(
                            text: "Done",
                            onTap: () =>
                                changeOrderStatus(details.currentStep));
                      }
                      return const SizedBox();
                    },
                    currentStep: currentStep,
                    steps: steps),
              ),
              SizedBox(height: mq.width * .025),
              user.type == "admin"
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: allowReturn
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          const ReturnProductScreen()));
                              showSnackBar(
                                  context: context,
                                  text: "Return product yet to be implemented");
                            }
                          : () {
                              // if you still want to complain flow in didilogflow chatbot
                              // you can mail the authorities or anything
                              showErrorSnackBar(
                                  context: context,
                                  text: "Return product timeline expired");
                            },
                      style: ElevatedButton.styleFrom(
                          // alignment: Alignment.center,
                          backgroundColor: allowReturn
                              ? const Color.fromARGB(255, 255, 100, 100)
                              : const Color.fromARGB(255, 255, 168, 168)),
                      child: const Text(
                        "Return Product",
                        style: TextStyle(color: Colors.white),
                      )),
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
                          // format date using intl package
                          Text(
                              "Order Date   : ${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(widget.order.orderedAt))}"),
                          Text("Order ID        : ${widget.order.id}"),
                          Text(
                              "Order Total   : ${indianRupeesFormat.format(widget.order.totalPrice)}"),
                          Text("Status            : ${widget.order.status}")
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
      case 'ORDER_RECEIVED':
        setStatus = 0;
        break;
      case 'ORDER_CANCELLED':
        setStatus = 0;
        break;
      case 'ORDER_PACKING':
        setStatus = 1;
        break;
      case 'ORDER_IN_TRANSIT':
        setStatus = 2;
        break;
      case 'ORDER_OUT_FOR_DELIVERY':
        setStatus = 3;
        break;
      case 'ORDER_DELIVERED':
        setStatus = 4;
        break;
      case 'ORDER_RETURN_REQUESTED':
        setStatus = 0;
        break;
      case 'ORDER_RETURN_ACCEPTED':
        setStatus = 1;
        break;
      case 'ORDER_RETURN_REJECTED':
        setStatus = 1;
        break;
      case 'ORDER_RETURN_COMPLETE':
        setStatus = 3;
        break;
      case 'ORDER_RETURN_PENDING':
        setStatus = 2;
        break;
      default:
        setStatus = 0;
        break;
    }
    return setStatus;
  }
}
