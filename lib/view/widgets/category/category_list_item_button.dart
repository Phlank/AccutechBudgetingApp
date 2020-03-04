import 'package:budgetflow/model/budget/category/category.dart';
import 'package:budgetflow/view/pages/priority/category_transaction_page.dart';
import 'package:budgetflow/view/utils/routes.dart';
import 'package:budgetflow/view/widgets/category/category_list_item.dart';
import 'package:flutter/material.dart';

class CategoryListItemButton extends StatelessWidget {
  final Category category;

  CategoryListItemButton(this.category);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CategoryListItem(category),
      onTap: () {
        Navigator.of(context).push(RouteUtil.routeWithSlideTransition(
            CategoryTransactionPage(category)));
      },
    );
  }
}
