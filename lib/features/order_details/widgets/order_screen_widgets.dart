import 'package:ecommerce_major_project/constants/global_variables.dart';
import 'package:ecommerce_major_project/constants/utils.dart';
import 'package:ecommerce_major_project/features/billing/services/bill_pdf_syncfusion_api.dart';
import 'package:ecommerce_major_project/features/order_details/widgets/custom_widgets.dart';
import 'package:ecommerce_major_project/models/order.dart';
import 'package:ecommerce_major_project/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderScreenWidgets {
  ///Shows the details for the payment status and all IDs of razorpay.
  ///It also contains the link for razorpay
  static Future<void> showPaymentBottomSheet(BuildContext context) async {}

  //Opens bottom sheet for showing the items in the order
  static Future<void> showOrderBillBottomSheet(
      BuildContext context, Order orderModel) async {
    int itemSubtotal = 0;
    int discountPrice = 0;
    int discountPcnt = 0;

    for (int i = 0; i < orderModel.products.length; i++) {
      //TODO: CHange below to marked price
      itemSubtotal += (orderModel.products[i]['quantity'] as int) *
          (orderModel.products[i]['markedPrice'] as int);
    }
    discountPrice = itemSubtotal - orderModel.totalPrice;
    discountPcnt = ((discountPrice * 100) ~/ itemSubtotal);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context2) {
        return Padding(
          padding: MediaQuery.of(context2).viewInsets,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.grey[50]!,
                ),
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 15,
                  right: 15,
                  bottom: 20,
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order No. ${orderModel.id}',
                            style: GoogleFonts.itim(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Divider(
                            height: 0,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (content, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderModel.products[index]['product']
                                          ['name'],
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Color(
                                              int.parse(orderModel
                                                  .products[index]['color']),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${orderModel.products[index]['size']} (${orderModel.products[index]['quantity']} Pcs)',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${orderModel.products[index]['quantity']} x ${orderModel.products[index]['markedPrice']}',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${GlobalVariables.rupeeSymbol}${orderModel.products[index]['quantity'] * orderModel.products[index]['markedPrice']}',
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (content, index) {
                          return const SizedBox(height: 10);
                        },
                        itemCount: orderModel.products.length,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Items Total (${orderModel.orderedQuantity} Pcs.)',
                                style: GoogleFonts.lato(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${GlobalVariables.rupeeSymbol}$itemSubtotal',
                                style: GoogleFonts.lato(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Visibility(
                            visible: discountPrice > 0,
                            child: CustomWidget.spaceBetweenText(
                              'Discount ($discountPcnt%)',
                              -1 * discountPrice,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Visibility(
                            visible: true,
                            child: CustomWidget.spaceBetweenText(
                                'Delivery Charge', 40),
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: GoogleFonts.lato(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${orderModel.orderedQuantity} Pcs',
                                style: GoogleFonts.lato(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${GlobalVariables.rupeeSymbol}${UsefulFunctions.putCommasInNumbers(orderModel.totalPrice)}',
                                style: GoogleFonts.lato(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          CustomWidget.spaceBetweenText(
                            'Total Amount Paid (RazorPay)',
                            orderModel.paymentStatus.contains("PENDING")
                                ? 0
                                : -1 * orderModel.totalPrice,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Due Amount',
                                style: GoogleFonts.lato(
                                  color: orderModel.paymentStatus
                                          .contains("PENDING")
                                      ? Colors.deepOrange[400]
                                      : Colors.teal[400],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${GlobalVariables.rupeeSymbol}${orderModel.paymentStatus.contains("PENDING") ? orderModel.totalPrice : '0'}',
                                style: GoogleFonts.lato(
                                  color: orderModel.paymentStatus
                                          .contains("PENDING")
                                      ? Colors.deepOrange[400]
                                      : Colors.teal[400],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: InkWell(
                            onTap: () {
                              //TODO: Share or print bill
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: const Color(0xFF3861F6),
                                  width: 2,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: Center(
                                child: Text(
                                  'PRINT/SHARE',
                                  style: GoogleFonts.lato(
                                    color: const Color(0xFF3861F6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () async {
                              await BillPdfSyncfusionApi(
                                customerModel: Provider.of<UserProvider>(
                                        context,
                                        listen: false)
                                    .user,
                                orderModel: orderModel,
                              ).generateBillPdf();
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF3861F6),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 17),
                              child: Center(
                                child: Text(
                                  'SHOW BILL',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
