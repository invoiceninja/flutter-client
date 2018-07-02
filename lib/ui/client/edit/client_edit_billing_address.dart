import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:invoiceninja/data/models/entities.dart';
import 'package:invoiceninja/ui/app/entity_dropdown.dart';
import 'package:invoiceninja/ui/app/form_card.dart';
import 'package:invoiceninja/ui/client/edit/client_edit_vm.dart';
import 'package:invoiceninja/utils/localization.dart';

class ClientEditBillingAddress extends StatefulWidget {
  ClientEditBillingAddress({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final ClientEditVM viewModel;

  @override
  ClientEditBillingAddressState createState() =>
      new ClientEditBillingAddressState();
}

class ClientEditBillingAddressState extends State<ClientEditBillingAddress> {

  final _address1Controller = TextEditingController();
  final _address2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {

    _controllers = [
      _address1Controller,
      _address2Controller,
      _cityController,
      _stateController,
      _postalCodeController,
    ];

    _controllers.forEach((dynamic controller) => controller.removeListener(_onChanged));

    final client = widget.viewModel.client;
    _address1Controller.text = client.address1;
    _address2Controller.text = client.address2;
    _cityController.text = client.city;
    _stateController.text = client.state;
    _postalCodeController.text = client.postalCode;

    _controllers.forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    final client = widget.viewModel.client.rebuild((b) => b
      ..address1 = _address1Controller.text.trim()
        ..address2 = _address2Controller.text.trim()
        ..city = _cityController.text.trim()
        ..state = _stateController.text.trim()
        ..postalCode = _postalCodeController.text.trim()
    );
    if (client != widget.viewModel.client) {
      widget.viewModel.onChanged(client);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final client = viewModel.client;

    return ListView(shrinkWrap: true, children: <Widget>[
      FormCard(
        children: <Widget>[
          TextFormField(
            autocorrect: false,
            controller: _address1Controller,
            decoration: InputDecoration(
              labelText: localization.address1,
            ),
          ),
          TextFormField(
            autocorrect: false,
            controller: _address2Controller,
            decoration: InputDecoration(
              labelText: localization.address2,
            ),
          ),
          TextFormField(
            autocorrect: false,
            controller: _cityController,
            decoration: InputDecoration(
              labelText: localization.city,
            ),
          ),
          TextFormField(
            autocorrect: false,
            controller: _stateController,
            decoration: InputDecoration(
              labelText: localization.state,
            ),
          ),
          TextFormField(
            autocorrect: false,
            controller: _postalCodeController,
            decoration: InputDecoration(
              labelText: localization.postalCode,
            ),
            keyboardType: TextInputType.phone,
          ),
          EntityDropdown(
            entityType: EntityType.country,
            entityMap: viewModel.countryMap,
            labelText: localization.country,
            initialValue: viewModel.countryMap[client.countryId]?.name,
            onSelected: (int countryId) => viewModel
                .onChanged(client.rebuild((b) => b..countryId = countryId)),
          ),
        ],
      )
    ]);
  }
}
