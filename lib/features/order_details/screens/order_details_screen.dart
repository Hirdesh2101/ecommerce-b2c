// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/order_details/services/order_services.dart';
import 'package:ecommerce_major_project/features/order_details/services/order_tracking_graph.dart';
import 'package:ecommerce_major_project/features/order_details/widgets/custom_widgets.dart';
import 'package:ecommerce_major_project/features/order_details/widgets/order_screen_widgets.dart';
import 'package:ecommerce_major_project/features/return_product/services/refund_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/main.dart';
import 'package:ecommerce_major_project/models/order.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String routeName = "/order-details";
  final Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  //Loading for whole screen
  bool showProgress = false;
  //Loading for user
  bool showProgress2 = false;
  bool showProgressForOrderStatusButtonAccept = false;
  bool showProgressForOrderStatusButtonDecline = false;
  late Order orderModel;
  final ReturnServices refundServices = ReturnServices();
  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0,
    symbol: '₹ ',
  );

  ///Fetches the order history for the order
  Future<bool> _loadOrderHistory() async {
    setState(() {
      showProgress = true;
    });

    bool isSuccess = false;

    try {
      isSuccess = await OrderServices().fetchOrderHistory(context, orderModel);

      if (isSuccess && orderModel.orderHistoryList.isEmpty) {
        OrderHistoryModel orderHistoryModel = OrderTrackingGraph()
            .orderPreTrackingDefinedModels["ORDER_RECEIVED"]!;
        orderHistoryModel.orderId = orderModel.id;
        orderHistoryModel.userId = orderModel.userId;

        if (context.mounted) {
          isSuccess = await OrderServices().updateOrderHistory(
              context, orderHistoryModel,
              orderModel: orderModel);
        }

        if (isSuccess) {
          orderModel.orderHistoryList.add(orderHistoryModel);
        } else {
          print(
              "Failed while adding new order history model but got success in fetching");
        }
      }

      if (isSuccess) {
        OrderTrackingGraph orderTrackingGraph = OrderTrackingGraph();
        OrderHistoryModel? nextOrderHistoryModel =
            await orderTrackingGraph.nextStep(orderModel.orderHistoryList);

        if (nextOrderHistoryModel != null &&
            nextOrderHistoryModel.stepName !=
                orderModel
                    .orderHistoryList[orderModel.orderHistoryList.length - 1]
                    .stepName) {
          nextOrderHistoryModel.orderId = orderModel.id;
          nextOrderHistoryModel.userId = orderModel.userId;
          nextOrderHistoryModel.stepRequestedAt ??= DateTime.now();

          if (context.mounted) {
            isSuccess = await OrderServices().updateOrderHistory(
                context, nextOrderHistoryModel,
                orderModel: orderModel);
          }

          if (isSuccess) {
            orderModel.orderHistoryList.add(nextOrderHistoryModel);
          } else {
            print(
                "Failed while adding new order history model but got success in fetching");
          }
        }
      }
    } catch (e) {
      print("Error loading order history: $e");
      isSuccess = false;
    }

    setState(() {
      showProgress = false;
    });

    return isSuccess;
  }

  @override
  void initState() {
    super.initState();

    orderModel = widget.order;
    _loadOrderHistory();
  }

  // find the number of dayssince the order was placed
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: [
              const Icon(Icons.send_rounded),
              const SizedBox(width: 5),
              Text(
                'Contact Seller',
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF3861F6),
          tooltip: 'Contact the seller for the information on your order!',
          elevation: 10,
          onPressed: () {
            //TODO: Implement ways to contact seller
            setState(() {});
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SafeArea(
          child: showProgress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF242030),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await _loadOrderHistory();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CustomWidget.borderedIcon(
                                Icons.keyboard_arrow_left_rounded,
                                padding: 2,
                                size: 35,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  UsefulFunctions.toCamelCase(
                                      UsefulFunctions.removeSpecificString(
                                              orderModel.status, '_',
                                              replaceWith: ' ')
                                          .toLowerCase()),
                                  style: GoogleFonts.lato(
                                    color: Colors.black87,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Payment: ${UsefulFunctions.toCamelCase(UsefulFunctions.removeSpecificString(orderModel.paymentStatus, '_', replaceWith: ' ').toLowerCase())}',
                                  style: GoogleFonts.itim(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            CustomWidget.borderedIcon(
                              Icons.more_vert_rounded,
                              size: 25,
                              padding: 7,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(thickness: 1),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  'Order summary',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Order No. ${orderModel.id}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Order Date: ${DateFormat('yMMMd').format(DateTime.fromMillisecondsSinceEpoch(orderModel.orderedAt))}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Amount: ${GlobalVariables.rupeeSymbol}${UsefulFunctions.putCommasInNumbers(orderModel.totalPrice)}.00',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Quantity: ${orderModel.orderedQuantity} Pcs${orderModel.returnedQuantity > 0 ? ' (${orderModel.returnedQuantity} Returned' : ''}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Order Status: ${UsefulFunctions.toCamelCase(UsefulFunctions.removeSpecificString(orderModel.status, '_', replaceWith: ' ').toLowerCase())}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Payment Status: ${UsefulFunctions.toCamelCase(UsefulFunctions.removeSpecificString(orderModel.paymentStatus, '_', replaceWith: ' ').toLowerCase())}',
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.lato(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                InkWell(
                                  onTap: () async {
                                    await OrderScreenWidgets
                                        .showOrderBillBottomSheet(
                                      context,
                                      orderModel,
                                    );
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.receipt_long_rounded,
                                          size: 22,
                                          color: Colors.black87,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'View Bill',
                                          style: GoogleFonts.lato(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                const Divider(thickness: 1),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Order status',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    orderModel.status == "ORDER_DELIVERED"
                                        ? ElevatedButton(
                                            onPressed: () {
                                              if (orderModel.products.length ==
                                                      1 &&
                                                  orderModel.products[0]
                                                          ['quantity'] ==
                                                      1) {
                                                context.go('newreturn', extra: [
                                                  orderModel,
                                                  orderModel.products
                                                ]);
                                              } else {
                                                context.go('newreturn/select',
                                                    extra: [orderModel]);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                // alignment: Alignment.center,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 255, 100, 100)),
                                            child: const Text(
                                              "Return Product",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))
                                        : orderModel.status ==
                                                    "ORDER_RECEIVED" ||
                                                orderModel.status ==
                                                    "ORDER_PACKING"
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  showAdaptiveDialog(
                                                      barrierDismissible: true,
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: const Text(
                                                              'Are you sure you want to cancel the order?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  refundServices.requestCancel(
                                                                      context:
                                                                          context,
                                                                      order: widget
                                                                          .order);
                                                                },
                                                                child:
                                                                    const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ))
                                                          ],
                                                        );
                                                      });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255,
                                                            255,
                                                            100,
                                                            100)),
                                                child: const Text(
                                                  "Cancel Order",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                            : const SizedBox.shrink()
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ListView.separated(
                                  itemCount: orderModel.orderHistoryList.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 15);
                                  },
                                  itemBuilder: ((context, index) {
                                    TextEditingController trackingController =
                                        TextEditingController();

                                    return StatefulBuilder(
                                        builder: (context, listSetState) {
                                      Future<void> selectStepAction(
                                          String actionName) async {
                                        if (showProgressForOrderStatusButtonDecline ||
                                            showProgressForOrderStatusButtonAccept) {
                                          print(
                                              "One button is already pressed");
                                          return;
                                        }
                                        listSetState(() {
                                          if (actionName == "accept") {
                                            showProgressForOrderStatusButtonAccept =
                                                true;
                                          } else {
                                            showProgressForOrderStatusButtonDecline =
                                                true;
                                          }
                                        });

                                        if (orderModel.orderHistoryList[index]
                                                    .isTrackingDetailsRequired ==
                                                false ||
                                            (orderModel.orderHistoryList[index]
                                                    .isTrackingDetailsRequired &&
                                                orderModel
                                                        .orderHistoryList[index]
                                                        .trackingDetails !=
                                                    null &&
                                                (trackingController
                                                        .text.isNotEmpty ||
                                                    orderModel
                                                        .orderHistoryList[index]
                                                        .trackingDetails!
                                                        .values
                                                        .first
                                                        .isNotEmpty))) {
                                          //This model is created for temp purpose to store the
                                          //update in firestore first and update the original model in list
                                          //only if update in firestore passes.
                                          OrderHistoryModel orderHistoryModel =
                                              OrderHistoryModel(
                                            id: orderModel
                                                .orderHistoryList[index].id,
                                            orderId: orderModel
                                                .orderHistoryList[index]
                                                .orderId,
                                            userId: orderModel
                                                .orderHistoryList[index].userId,
                                            stepName: orderModel
                                                .orderHistoryList[index]
                                                .stepName,
                                            stepStatus: orderModel
                                                .orderHistoryList[index]
                                                .stepStatus,
                                            acceptActionName: orderModel
                                                .orderHistoryList[index]
                                                .acceptActionName,
                                            declineActionName: orderModel
                                                .orderHistoryList[index]
                                                .declineActionName,
                                            trackingDetails: orderModel
                                                .orderHistoryList[index]
                                                .trackingDetails,
                                            isTrackingDetailsRequired:
                                                orderModel
                                                    .orderHistoryList[index]
                                                    .isTrackingDetailsRequired,
                                            notes: orderModel
                                                .orderHistoryList[index].notes,
                                            actionRequiredBy: orderModel
                                                .orderHistoryList[index]
                                                .actionRequiredBy,
                                            stepRequestedAt: orderModel
                                                .orderHistoryList[index]
                                                .stepRequestedAt,
                                            stepCompletedAt: orderModel
                                                .orderHistoryList[index]
                                                .stepCompletedAt,
                                          );

                                          if (actionName == "accept") {
                                            orderHistoryModel.setStepStatus(
                                                orderHistoryModel
                                                    .acceptActionName);
                                          } else {
                                            orderHistoryModel.setStepStatus(
                                                orderHistoryModel
                                                    .declineActionName);
                                          }

                                          if (orderHistoryModel
                                                  .isTrackingDetailsRequired &&
                                              orderHistoryModel.trackingDetails!
                                                  .values.first.isEmpty) {
                                            orderHistoryModel.trackingDetails![
                                                    orderHistoryModel
                                                        .trackingDetails!
                                                        .keys
                                                        .first] =
                                                trackingController.text;
                                          }

                                          bool isSuccess = false;

                                          if (context.mounted) {
                                            isSuccess = await OrderServices()
                                                .updateOrderHistory(
                                                    context, orderHistoryModel,
                                                    orderModel: orderModel);
                                          }

                                          //Updating the Model in list after firestore & node is success.
                                          //Both are upated with same firestore function above.
                                          if (isSuccess) {
                                            orderModel.orderHistoryList[index]
                                                    .notes =
                                                orderHistoryModel.notes;
                                            orderModel.orderHistoryList[index]
                                                    .stepCompletedAt =
                                                orderHistoryModel
                                                    .stepCompletedAt;
                                            orderModel.orderHistoryList[index]
                                                    .stepStatus =
                                                orderHistoryModel.stepStatus;
                                            orderModel.orderHistoryList[index]
                                                    .stepStatusColor =
                                                orderHistoryModel
                                                    .stepStatusColor;
                                            orderModel.orderHistoryList[index]
                                                    .trackingDetails =
                                                orderHistoryModel
                                                    .trackingDetails;

                                            OrderTrackingGraph
                                                orderTrackingGraph =
                                                OrderTrackingGraph();
                                            OrderHistoryModel?
                                                nextOrderHistoryModel =
                                                await orderTrackingGraph
                                                    .nextStep(orderModel
                                                        .orderHistoryList);
                                            if (nextOrderHistoryModel != null) {
                                              OrderHistoryModel
                                                  orderHistoryModel =
                                                  OrderHistoryModel(
                                                      orderId: orderModel.id,
                                                      userId: orderModel.userId,
                                                      stepName:
                                                          nextOrderHistoryModel
                                                              .stepName,
                                                      stepStatus:
                                                          nextOrderHistoryModel
                                                              .stepStatus,
                                                      acceptActionName: nextOrderHistoryModel
                                                          .acceptActionName,
                                                      declineActionName:
                                                          nextOrderHistoryModel
                                                              .declineActionName,
                                                      isTrackingDetailsRequired:
                                                          nextOrderHistoryModel
                                                              .isTrackingDetailsRequired,
                                                      trackingDetails:
                                                          nextOrderHistoryModel
                                                              .trackingDetails,
                                                      actionRequiredBy:
                                                          nextOrderHistoryModel
                                                              .actionRequiredBy,
                                                      stepRequestedAt:
                                                          DateTime.now());

                                              orderModel.orderHistoryList
                                                  .add(orderHistoryModel);

                                              if (context.mounted) {
                                                isSuccess =
                                                    await OrderServices()
                                                        .updateOrderHistory(
                                                            context,
                                                            orderHistoryModel,
                                                            orderModel:
                                                                orderModel);
                                              }

                                              if (!isSuccess) {
                                                print(
                                                    "Updating the next order history model has failed");
                                              }
                                            }
                                          }
                                        } else if (context.mounted) {
                                          showSnackBar(
                                            context: context,
                                            text: "Details are required!",
                                          );
                                        }

                                        setState(() {
                                          if (actionName == "accept") {
                                            showProgressForOrderStatusButtonAccept =
                                                false;
                                          } else {
                                            showProgressForOrderStatusButtonDecline =
                                                false;
                                          }
                                        });
                                      }

                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: orderModel
                                                        .orderHistoryList[index]
                                                        .stepStatusColor
                                                        .keys
                                                        .first
                                                        .contains("green")
                                                    ? const Icon(
                                                        Icons
                                                            .check_circle_rounded,
                                                        color: Colors.teal,
                                                      )
                                                    : orderModel
                                                            .orderHistoryList[
                                                                index]
                                                            .stepStatusColor
                                                            .keys
                                                            .contains('red')
                                                        ? const Icon(
                                                            Icons
                                                                .cancel_rounded,
                                                            color: Colors
                                                                .deepOrange,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .pending_rounded,
                                                            color: Colors.amber,
                                                          ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                flex: 10,
                                                child: Text(
                                                  UsefulFunctions.toCamelCase(
                                                      UsefulFunctions
                                                              .removeSpecificString(
                                                                  orderModel
                                                                      .orderHistoryList[
                                                                          index]
                                                                      .stepName,
                                                                  '_',
                                                                  replaceWith:
                                                                      ' ')
                                                          .toLowerCase()),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lato(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          IntrinsicHeight(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: !(orderModel
                                                          .orderHistoryList[
                                                              index]
                                                          .actionRequiredBy
                                                          .toLowerCase()
                                                          .contains("none"))
                                                      ? const VerticalDivider(
                                                          color: Colors.black,
                                                          thickness: 2.0,
                                                        )
                                                      : const SizedBox(),
                                                ),
                                                const SizedBox(width: 20),
                                                Expanded(
                                                  flex: 10,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Visibility(
                                                        visible: orderModel
                                                                    .orderHistoryList[
                                                                        index]
                                                                    .stepCompletedAt !=
                                                                null ||
                                                            orderModel
                                                                    .orderHistoryList[
                                                                        index]
                                                                    .stepRequestedAt !=
                                                                null,
                                                        child: Text(
                                                          orderModel
                                                                      .orderHistoryList[
                                                                          index]
                                                                      .stepCompletedAt !=
                                                                  null
                                                              ? '${orderModel.orderHistoryList[index].stepCompletedAt?.day} ${GlobalVariables.monthMapping[orderModel.orderHistoryList[index].stepCompletedAt?.month]} ${orderModel.orderHistoryList[index].stepCompletedAt?.year} at ${orderModel.orderHistoryList[index].stepCompletedAt?.hour}:${orderModel.orderHistoryList[index].stepCompletedAt?.minute}'
                                                              : '${orderModel.orderHistoryList[index].stepRequestedAt?.day} ${GlobalVariables.monthMapping[orderModel.orderHistoryList[index].stepRequestedAt?.month]} ${orderModel.orderHistoryList[index].stepRequestedAt?.year} at ${orderModel.orderHistoryList[index].stepRequestedAt?.hour}:${orderModel.orderHistoryList[index].stepRequestedAt?.minute}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        orderModel
                                                            .orderHistoryList[
                                                                index]
                                                            .stepStatus,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: GoogleFonts.lato(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: orderModel
                                                                    .orderHistoryList[
                                                                        index]
                                                                    .trackingDetails !=
                                                                null &&
                                                            orderModel
                                                                .orderHistoryList[
                                                                    index]
                                                                .trackingDetails!
                                                                .isNotEmpty &&
                                                            orderModel
                                                                .orderHistoryList[
                                                                    index]
                                                                .trackingDetails!
                                                                .values
                                                                .first
                                                                .isNotEmpty,
                                                        child: Text(
                                                          orderModel
                                                                          .orderHistoryList[
                                                                              index]
                                                                          .trackingDetails !=
                                                                      null &&
                                                                  orderModel
                                                                      .orderHistoryList[
                                                                          index]
                                                                      .trackingDetails!
                                                                      .isNotEmpty
                                                              ? '${orderModel.orderHistoryList[index].trackingDetails!.keys.first}: ${orderModel.orderHistoryList[index].trackingDetails!.values.first}'
                                                              : '',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: orderModel
                                                            .orderHistoryList[
                                                                index]
                                                            .notes
                                                            .isNotEmpty,
                                                        child: Text(
                                                          orderModel
                                                              .orderHistoryList[
                                                                  index]
                                                              .notes,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              GoogleFonts.lato(
                                                            color: Colors.grey,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      Visibility(
                                                          visible: orderModel
                                                              .orderHistoryList[
                                                                  index]
                                                              .stepStatusColor
                                                              .containsKey(
                                                                  "amber"),
                                                          child: const SizedBox(
                                                              height: 5)),
                                                      Visibility(
                                                        visible: orderModel
                                                                .orderHistoryList[
                                                                    index]
                                                                .stepStatusColor
                                                                .keys
                                                                .first
                                                                .contains(
                                                                    "amber") &&
                                                            (orderModel
                                                                    .orderHistoryList[
                                                                        index]
                                                                    .actionRequiredBy
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        "user") ||
                                                                orderModel
                                                                    .orderHistoryList[
                                                                        index]
                                                                    .actionRequiredBy
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        "customer")),
                                                        child: Row(
                                                          children: [
                                                            Visibility(
                                                              visible: orderModel
                                                                  .orderHistoryList[
                                                                      index]
                                                                  .declineActionName
                                                                  .isNotEmpty,
                                                              child: Expanded(
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    selectStepAction(
                                                                        "decline");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                              .grey[
                                                                          200],
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: showProgressForOrderStatusButtonDecline
                                                                          ? const CupertinoActivityIndicator(
                                                                              radius: 10,
                                                                              color: Colors.black,
                                                                            )
                                                                          : Text(
                                                                              orderModel.orderHistoryList[index].declineActionName,
                                                                              style: GoogleFonts.lato(
                                                                                color: Colors.black87,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Visibility(
                                                              visible: orderModel
                                                                  .orderHistoryList[
                                                                      index]
                                                                  .acceptActionName
                                                                  .isNotEmpty,
                                                              child: Expanded(
                                                                child: InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    selectStepAction(
                                                                        "accept");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                      vertical:
                                                                          8,
                                                                    ),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: Color(
                                                                          0xFF3861F6),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child: showProgressForOrderStatusButtonAccept
                                                                          ? const CupertinoActivityIndicator(
                                                                              radius: 10,
                                                                              color: Colors.white,
                                                                            )
                                                                          : Text(
                                                                              orderModel.orderHistoryList[index].acceptActionName,
                                                                              style: GoogleFonts.lato(
                                                                                color: Colors.white,
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                            ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: orderModel
                                                                .orderHistoryList[
                                                                    index]
                                                                .stepStatusColor
                                                                .keys
                                                                .first
                                                                .contains(
                                                                    "amber") &&
                                                            (orderModel
                                                                        .orderHistoryList[
                                                                            index]
                                                                        .isTrackingDetailsRequired &&
                                                                    orderModel
                                                                        .orderHistoryList[
                                                                            index]
                                                                        .actionRequiredBy
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            "user") ||
                                                                orderModel
                                                                        .orderHistoryList[
                                                                            index]
                                                                        .isTrackingDetailsRequired &&
                                                                    orderModel
                                                                        .orderHistoryList[
                                                                            index]
                                                                        .actionRequiredBy
                                                                        .toLowerCase()
                                                                        .contains(
                                                                            "customer")),
                                                        child: Column(
                                                          children: [
                                                            const SizedBox(
                                                                height: 10),
                                                            CustomWidget
                                                                .onlyBorderedTextField(
                                                              textController:
                                                                  trackingController,
                                                              hint: (orderModel
                                                                              .orderHistoryList[
                                                                                  index]
                                                                              .trackingDetails !=
                                                                          null &&
                                                                      orderModel
                                                                          .orderHistoryList[
                                                                              index]
                                                                          .trackingDetails!
                                                                          .keys
                                                                          .isNotEmpty)
                                                                  ? orderModel
                                                                      .orderHistoryList[
                                                                          index]
                                                                      .trackingDetails!
                                                                      .keys
                                                                      .first
                                                                  : "Enter Details",
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                                  }),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Products Ordered',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
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
                                          i < orderModel.products.length;
                                          i++)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              context.push(
                                                  '/product/${orderModel.products[i]['product']['_id']}');
                                            },
                                            child: Row(
                                              children: [
                                                Image.network(
                                                    orderModel.products[i]
                                                            ['product']
                                                        ['images'][0],
                                                    height: mq.width * .25,
                                                    width: mq.width * .25),
                                                SizedBox(
                                                    width: mq.width * .0125),
                                                // using expanded to allow text to overflow
                                                // in case name of the product is too long
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        orderModel.products[i]
                                                            ['product']['name'],
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Color:",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 11),
                                                            maxLines: 2,
                                                          ),
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left:
                                                                        mq.width *
                                                                            .01),
                                                            width:
                                                                mq.width * .025,
                                                            height:
                                                                mq.width * .025,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  int.parse(
                                                                      '${orderModel.products[i]['color']}')),
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                          ),
                                                          Container(
                                                              padding: EdgeInsets.only(
                                                                  left:
                                                                      mq.width *
                                                                          .025),
                                                              child: Text(
                                                                "Size: ${orderModel.products[i]['size']}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        11),
                                                                maxLines: 2,
                                                              )),
                                                          Container(
                                                              padding: EdgeInsets.only(
                                                                  left:
                                                                      mq.width *
                                                                          .025),
                                                              child: Text(
                                                                "Quantity: ${orderModel.products[i]['quantity']}",
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        11),
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
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: GlobalVariables.getAppBar(
  //         title: "Order Details", context: context, wantActions: false
  //         //onClickSearchNavigateTo: const MySearchScreen()
  //         ),
  //     body: SingleChildScrollView(
  //       child: Padding(
  //         padding: EdgeInsets.all(mq.width * .025),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text("Product(s) purchased",
  //                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
  //             Container(
  //               width: double.infinity,
  //               padding: EdgeInsets.all(mq.width * .025),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.black12),
  //               ),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   for (int i = 0; i < orderModel.products.length; i++)
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 8.0),
  //                       child: InkWell(
  //                         onTap: () {
  //                           context.push(
  //                               '/product/${orderModel.products[i]['product']['_id']}');
  //                         },
  //                         child: Row(
  //                           children: [
  //                             Image.network(
  //                                 orderModel.products[i]['product']['images']
  //                                     [0],
  //                                 height: mq.width * .25,
  //                                 width: mq.width * .25),
  //                             SizedBox(width: mq.width * .0125),
  //                             // using expanded to allow text to overflow
  //                             // in case name of the product is too long
  //                             Expanded(
  //                               child: Column(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     orderModel.products[i]['product']
  //                                         ['name'],
  //                                     style: const TextStyle(
  //                                       fontSize: 15,
  //                                       fontWeight: FontWeight.w500,
  //                                     ),
  //                                     maxLines: 2,
  //                                     overflow: TextOverflow.ellipsis,
  //                                   ),
  //                                   Row(
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.start,
  //                                     children: [
  //                                       const Text(
  //                                         "Color:",
  //                                         style: TextStyle(
  //                                             color: Colors.black,
  //                                             fontSize: 11),
  //                                         maxLines: 2,
  //                                       ),
  //                                       Container(
  //                                         margin: EdgeInsets.only(
  //                                             left: mq.width * .01),
  //                                         width: mq.width * .025,
  //                                         height: mq.width * .025,
  //                                         decoration: BoxDecoration(
  //                                           color: Color(int.parse(
  //                                               '${orderModel.products[i]['color']}')),
  //                                           shape: BoxShape.circle,
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                           padding: EdgeInsets.only(
  //                                               left: mq.width * .025),
  //                                           child: Text(
  //                                             "Size: ${orderModel.products[i]['size']}",
  //                                             style: const TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontSize: 11),
  //                                             maxLines: 2,
  //                                           )),
  //                                       Container(
  //                                           padding: EdgeInsets.only(
  //                                               left: mq.width * .025),
  //                                           child: Text(
  //                                             "Quantity: x${orderModel.products[i]['quantity']}",
  //                                             style: const TextStyle(
  //                                                 color: Colors.black,
  //                                                 fontSize: 11),
  //                                             maxLines: 2,
  //                                           )),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: mq.width * .025),
  //             const Text(
  //               "Tracking",
  //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
  //             ),
  //             Container(
  //               height: mq.height * .35,
  //               width: double.infinity,
  //               padding: EdgeInsets.all(mq.width * .04),
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.black12),
  //               ),
  //               child: Stepper(
  //                   elevation: 3,
  //                   controlsBuilder: (context, details) {
  //                     // if (user.type == "admin") {
  //                     //   return CustomButton(
  //                     //       text: "Done",
  //                     //       onTap: () =>
  //                     //           changeOrderStatus(details.currentStep));
  //                     // }
  //                     return const SizedBox();
  //                   },
  //                   currentStep: currentStep,
  //                   steps: steps),
  //             ),
  //             SizedBox(height: mq.width * .025),
  //             // user.type == "admin"
  //             //     ? const SizedBox.shrink()
  //             //     :
  //             orderModel.status == "ORDER_DELIVERED" && copy.isNotEmpty
  //                 ? ElevatedButton(
  //                     onPressed: () {
  //                       if (orderModel.products.length == 1 &&
  //                           orderModel.products[0]['quantity'] == 1) {
  //                         context.go('newreturn',
  //                             extra: [orderModel, orderModel.products]);
  //                       } else {
  //                         context.go('newreturn/select',
  //                             extra: [copy, orderModel]);
  //                       }
  //                     },
  //                     // if you still want to complain flow in didilogflow chatbot
  //                     // you can mail the authorities or anything
  //                     // showErrorSnackBar(
  //                     //     context: context,
  //                     //     text: "Return product timeline expired");
  //                     //},
  //                     style: ElevatedButton.styleFrom(
  //                         // alignment: Alignment.center,
  //                         backgroundColor:
  //                             const Color.fromARGB(255, 255, 100, 100)),
  //                     child: const Text(
  //                       "Return Product",
  //                       style: TextStyle(color: Colors.white),
  //                     ))
  //                 : orderModel.status == "ORDER_RECEIVED" ||
  //                         orderModel.status == "ORDER_PACKING"
  //                     ? ElevatedButton(
  //                         onPressed: () {
  //                           showAdaptiveDialog(
  //                               barrierDismissible: true,
  //                               context: context,
  //                               builder: (context) {
  //                                 return AlertDialog(
  //                                   content: const Text(
  //                                       'Are you sure you want to cancel the order?'),
  //                                   actions: [
  //                                     TextButton(
  //                                         onPressed: () {
  //                                           refundServices.requestCancel(
  //                                               context: context,
  //                                               order: orderModel);
  //                                         },
  //                                         child: const Text(
  //                                           'Cancel',
  //                                           style: TextStyle(color: Colors.red),
  //                                         ))
  //                                   ],
  //                                 );
  //                               });
  //                         },
  //                         style: ElevatedButton.styleFrom(
  //                             backgroundColor:
  //                                 const Color.fromARGB(255, 255, 100, 100)),
  //                         child: const Text(
  //                           "Cancel Order",
  //                           style: TextStyle(color: Colors.white),
  //                         ))
  //                     : const SizedBox.shrink(),
  //             SizedBox(height: mq.width * .025),
  //             InkWell(
  //               onTap: () {
  //                 setState(() {
  //                   viewMoreDetails = !viewMoreDetails;
  //                 });
  //               },
  //               child: Row(
  //                 children: [
  //                   const Text("More Details",
  //                       style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w400,
  //                           color: Colors.blue)),
  //                   viewMoreDetails
  //                       ? const Icon(Icons.arrow_drop_up)
  //                       : const Icon(Icons.arrow_drop_down),
  //                 ],
  //               ),
  //             ),
  //             viewMoreDetails
  //                 ? Container(
  //                     width: double.infinity,
  //                     padding: EdgeInsets.all(mq.width * .025),
  //                     decoration: BoxDecoration(
  //                         border: Border.all(color: Colors.black12)),
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text('Order Date:'),
  //                             Text(DateFormat('yMMMd').format(
  //                                 DateTime.fromMillisecondsSinceEpoch(
  //                                     orderModel.orderedAt)))
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text('Order ID:'),
  //                             Text(orderModel.id)
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text('Order Total:'),
  //                             Text(indianRupeesFormat
  //                                 .format(orderModel.totalPrice))
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text('Status:'),
  //                             Text(orderModel.status)
  //                           ],
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Text('Payment Status:'),
  //                             Text(orderModel.paymentStatus)
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 : const SizedBox.shrink(),
  //             SizedBox(height: mq.width * .025),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // int getCurrentStep(String status) {
  //   int setStatus = 0;
  //   switch (status) {
  //     case 'ORDER_RECEIVED':
  //       setStatus = 0;
  //       break;
  //     case 'ORDER_CANCELLED':
  //       setStatus = 0;
  //       break;
  //     case 'ORDER_PACKING':
  //       setStatus = 1;
  //       break;
  //     case 'ORDER_IN_TRANSIT':
  //       setStatus = 2;
  //       break;
  //     case 'ORDER_OUT_FOR_DELIVERY':
  //       setStatus = 3;
  //       break;
  //     case 'ORDER_DELIVERED':
  //       setStatus = 4;
  //       break;
  //     default:
  //       setStatus = 0;
  //       break;
  //   }
  //   return setStatus;
  // }
}
