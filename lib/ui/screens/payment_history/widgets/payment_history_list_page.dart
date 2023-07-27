import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/payment_history/widgets/payment_history_card.dart';

class PaymentHistoryListPage extends BaseStatefulWidget {
  const PaymentHistoryListPage({Key? key}) : super(key: key);

  @override
  _PaymentHistoryListPageState baseCreateState() =>
      _PaymentHistoryListPageState();
}

class _PaymentHistoryListPageState extends BaseState<PaymentHistoryListPage> {
  static int _pageKey = 0;
  DateTime initialDateFilter = DateTime.now();

  final PagingController<int, PaymentHistoryModel> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
      _pageKey = pageKey;
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<PaymentHistoryModel> newItems =
          await RemoteApi.getCharacterList();
      // TODO the backend url to view the list
      // if (lastIN) {
      //   _pagingController.appendLastPage(newItems);
      // } else {
      final nextPageKey = _pageKey + newItems.length;
      _pagingController.appendPage(newItems, nextPageKey);
      // }
    } catch (error) {
      log("e", error: error);
      _pagingController.error = error;
    }
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: _getDateFilter(),
        ),
        Expanded(
          child: PagedListView<int, PaymentHistoryModel>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<PaymentHistoryModel>(
              itemBuilder: (context, item, index) => PaymentHistoryCard(
                paymentModel: item,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getDateFilter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  initialDateFilter = DateTime(
                      initialDateFilter.year, initialDateFilter.month - 1);
                });
              },
              icon: SvgPicture.asset(
                AssPath.leftCircle,
                matchTextDirection: true,
                height: 50,
              ),
              color: ConstColors.app,
            ),
            SizedBox(
              width: width / 4,
              child: Center(
                child: Text(
                  DateFormat('MMM').format(initialDateFilter) +
                      ", " +
                      initialDateFilter.year.toString(),
                  style: const TextStyle(
                      color: ConstColors.app,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  initialDateFilter = DateTime(
                      initialDateFilter.year, initialDateFilter.month + 1);
                });
              },
              icon: SvgPicture.asset(
                AssPath.rightCircle,
                matchTextDirection: true,
                height: 50,
              ),
              color: ConstColors.app,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
