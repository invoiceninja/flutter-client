import 'dart:async';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class ViewWebhookList extends AbstractNavigatorAction
    implements PersistUI, StopLoading {
  ViewWebhookList({
    @required NavigatorState navigator,
    this.force = false,
  }) : super(navigator: navigator);

  final bool force;
}

class ViewWebhook extends AbstractNavigatorAction
    implements PersistUI, PersistPrefs {
  ViewWebhook({
    @required NavigatorState navigator,
    @required this.webhookId,
    this.force = false,
  }) : super(navigator: navigator);

  final String webhookId;
  final bool force;
}

class EditWebhook extends AbstractNavigatorAction
    implements PersistUI, PersistPrefs {
  EditWebhook(
      {@required this.webhook,
      @required NavigatorState navigator,
      this.completer,
      this.cancelCompleter,
      this.force = false})
      : super(navigator: navigator);

  final WebhookEntity webhook;
  final Completer completer;
  final Completer cancelCompleter;
  final bool force;
}

class UpdateWebhook implements PersistUI {
  UpdateWebhook(this.webhook);

  final WebhookEntity webhook;
}

class LoadWebhook {
  LoadWebhook({this.completer, this.webhookId});

  final Completer completer;
  final String webhookId;
}

class LoadWebhookActivity {
  LoadWebhookActivity({this.completer, this.webhookId});

  final Completer completer;
  final String webhookId;
}

class LoadWebhooks {
  LoadWebhooks({this.completer, this.force = false});

  final Completer completer;
  final bool force;
}

class LoadWebhookRequest implements StartLoading {}

class LoadWebhookFailure implements StopLoading {
  LoadWebhookFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadWebhookFailure{error: $error}';
  }
}

class LoadWebhookSuccess implements StopLoading, PersistData {
  LoadWebhookSuccess(this.webhook);

  final WebhookEntity webhook;

  @override
  String toString() {
    return 'LoadWebhookSuccess{webhook: $webhook}';
  }
}

class LoadWebhooksRequest implements StartLoading {}

class LoadWebhooksFailure implements StopLoading {
  LoadWebhooksFailure(this.error);

  final dynamic error;

  @override
  String toString() {
    return 'LoadWebhooksFailure{error: $error}';
  }
}

class LoadWebhooksSuccess implements StopLoading, PersistData {
  LoadWebhooksSuccess(this.webhooks);

  final BuiltList<WebhookEntity> webhooks;

  @override
  String toString() {
    return 'LoadWebhooksSuccess{webhooks: $webhooks}';
  }
}

class SaveWebhookRequest implements StartSaving {
  SaveWebhookRequest({this.completer, this.webhook});

  final Completer completer;
  final WebhookEntity webhook;
}

class SaveWebhookSuccess implements StopSaving, PersistData, PersistUI {
  SaveWebhookSuccess(this.webhook);

  final WebhookEntity webhook;
}

class AddWebhookSuccess implements StopSaving, PersistData, PersistUI {
  AddWebhookSuccess(this.webhook);

  final WebhookEntity webhook;
}

class SaveWebhookFailure implements StopSaving {
  SaveWebhookFailure(this.error);

  final Object error;
}

class ArchiveWebhooksRequest implements StartSaving {
  ArchiveWebhooksRequest(this.completer, this.webhookIds);

  final Completer completer;
  final List<String> webhookIds;
}

class ArchiveWebhooksSuccess implements StopSaving, PersistData {
  ArchiveWebhooksSuccess(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class ArchiveWebhooksFailure implements StopSaving {
  ArchiveWebhooksFailure(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class DeleteWebhooksRequest implements StartSaving {
  DeleteWebhooksRequest(this.completer, this.webhookIds);

  final Completer completer;
  final List<String> webhookIds;
}

class DeleteWebhooksSuccess implements StopSaving, PersistData {
  DeleteWebhooksSuccess(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class DeleteWebhooksFailure implements StopSaving {
  DeleteWebhooksFailure(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class RestoreWebhooksRequest implements StartSaving {
  RestoreWebhooksRequest(this.completer, this.webhookIds);

  final Completer completer;
  final List<String> webhookIds;
}

class RestoreWebhooksSuccess implements StopSaving, PersistData {
  RestoreWebhooksSuccess(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class RestoreWebhooksFailure implements StopSaving {
  RestoreWebhooksFailure(this.webhooks);

  final List<WebhookEntity> webhooks;
}

class FilterWebhooks implements PersistUI {
  FilterWebhooks(this.filter);

  final String filter;
}

class SortWebhooks implements PersistUI {
  SortWebhooks(this.field);

  final String field;
}

class FilterWebhooksByState implements PersistUI {
  FilterWebhooksByState(this.state);

  final EntityState state;
}

class FilterWebhooksByCustom1 implements PersistUI {
  FilterWebhooksByCustom1(this.value);

  final String value;
}

class FilterWebhooksByCustom2 implements PersistUI {
  FilterWebhooksByCustom2(this.value);

  final String value;
}

class FilterWebhooksByCustom3 implements PersistUI {
  FilterWebhooksByCustom3(this.value);

  final String value;
}

class FilterWebhooksByCustom4 implements PersistUI {
  FilterWebhooksByCustom4(this.value);

  final String value;
}

void handleWebhookAction(
    BuildContext context, List<BaseEntity> webhooks, EntityAction action) {
  if (webhooks.isEmpty) {
    return;
  }

  final store = StoreProvider.of<AppState>(context);
  final localization = AppLocalization.of(context);
  final webhook = webhooks.first as WebhookEntity;
  final webhookIds = webhooks.map((webhook) => webhook.id).toList();

  switch (action) {
    case EntityAction.edit:
      editEntity(context: context, entity: webhook);
      break;
    case EntityAction.restore:
      store.dispatch(RestoreWebhooksRequest(
          snackBarCompleter<Null>(context, localization.restoredWebhook),
          webhookIds));
      break;
    case EntityAction.archive:
      store.dispatch(ArchiveWebhooksRequest(
          snackBarCompleter<Null>(context, localization.archivedWebhook),
          webhookIds));
      break;
    case EntityAction.delete:
      store.dispatch(DeleteWebhooksRequest(
          snackBarCompleter<Null>(context, localization.deletedWebhook),
          webhookIds));
      break;
    case EntityAction.toggleMultiselect:
      if (!store.state.webhookListState.isInMultiselect()) {
        store.dispatch(StartWebhookMultiselect());
      }

      if (webhooks.isEmpty) {
        break;
      }

      for (final webhook in webhooks) {
        if (!store.state.webhookListState.isSelected(webhook.id)) {
          store.dispatch(AddToWebhookMultiselect(entity: webhook));
        } else {
          store.dispatch(RemoveFromWebhookMultiselect(entity: webhook));
        }
      }
      break;
  }
}

class StartWebhookMultiselect {
  StartWebhookMultiselect();
}

class AddToWebhookMultiselect {
  AddToWebhookMultiselect({@required this.entity});

  final BaseEntity entity;
}

class RemoveFromWebhookMultiselect {
  RemoveFromWebhookMultiselect({@required this.entity});

  final BaseEntity entity;
}

class ClearWebhookMultiselect {
  ClearWebhookMultiselect();
}
