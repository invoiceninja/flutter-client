import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/actions_menu_button.dart';
import 'package:invoiceninja_flutter/ui/app/dismissible_entity.dart';
import 'package:invoiceninja_flutter/ui/app/entity_state_label.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';

class ProductListItem extends StatelessWidget {
  const ProductListItem({
    @required this.userCompany,
    @required this.product,
    @required this.filter,
    this.onTap,
    this.onLongPress,
    this.onCheckboxChanged,
    this.isChecked = false,
    this.isDismissible = true,
  });

  final UserCompanyEntity userCompany;
  final GestureTapCallback onTap;
  final GestureTapCallback onLongPress;
  final Function(bool) onCheckboxChanged;
  final bool isChecked;
  final bool isDismissible;

  //final ValueChanged<bool> onCheckboxChanged;
  final ProductEntity product;
  final String filter;

  @override
  Widget build(BuildContext context) {
    final filterMatch = filter != null && filter.isNotEmpty
        ? product.matchesFilterValue(filter)
        : null;
    final subtitle = filterMatch ?? product.notes;
    final store = StoreProvider.of<AppState>(context);
    final state = store.state;
    final uiState = store.state.uiState;
    final productUIState = uiState.productUIState;
    final listUIState = productUIState.listUIState;
    final isInMultiselect = listUIState.isInMultiselect();
    final showCheckbox = onCheckboxChanged != null || isInMultiselect;
    final textStyle = TextStyle(fontSize: 16);

    return DismissibleEntity(
      isDismissible: isDismissible,
      isSelected: isDesktop(context) &&
          product.id ==
              (uiState.isEditing
                  ? productUIState.editing.id
                  : productUIState.selectedId),
      userCompany: userCompany,
      entity: product,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth > kTableListWidthCutoff
            ? InkWell(
                onTap: () => onTap != null
                    ? onTap()
                    : selectEntity(entity: product, context: context),
                onLongPress: () => onLongPress != null
                    ? onLongPress()
                    : selectEntity(
                        entity: product, context: context, longPress: true),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 28,
                    top: 4,
                    bottom: 4,
                  ),
                  child: Row(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: showCheckbox
                              ? IgnorePointer(
                                  ignoring: listUIState.isInMultiselect(),
                                  child: Checkbox(
                                    value: isChecked,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) =>
                                        onCheckboxChanged(value),
                                    activeColor: Theme.of(context).accentColor,
                                  ),
                                )
                              : ActionMenuButton(
                                  entityActions: product.getActions(
                                      userCompany: state.userCompany),
                                  isSaving: false,
                                  entity: product,
                                  onSelected: (context, action) =>
                                      handleEntityAction(
                                          context, product, action),
                                )),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.productKey +
                                  (product.documents.isNotEmpty ? '  📎' : ''),
                              style: textStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (!product.isActive) EntityStateLabel(product)
                          ],
                        ),
                        width: 120,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.notes,
                              style: textStyle,
                              maxLines: 6,
                            ),
                            if (filterMatch != null)
                              Text(
                                filterMatch,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        formatNumber(product.price, context,
                            roundToPrecision: false),
                        style: textStyle,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              )
            : ListTile(
                onTap: () => onTap != null
                    ? onTap()
                    : selectEntity(entity: product, context: context),
                onLongPress: () => onLongPress != null
                    ? onLongPress()
                    : selectEntity(
                        entity: product, context: context, longPress: true),
                leading: showCheckbox
                    ? IgnorePointer(
                        ignoring: listUIState.isInMultiselect(),
                        child: Checkbox(
                          value: isChecked,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) => onCheckboxChanged(value),
                          activeColor: Theme.of(context).accentColor,
                        ),
                      )
                    : null,
                title: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          product.productKey +
                              (product.documents.isNotEmpty ? '  📎' : ''),
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Text(
                          formatNumber(product.price, context,
                              roundToPrecision: false),
                          style: Theme.of(context).textTheme.headline6),
                    ],
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    subtitle != null && subtitle.isNotEmpty
                        ? Text(
                            subtitle,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          )
                        : Container(),
                    EntityStateLabel(product),
                  ],
                ),
              );
      }),
    );
  }
}
