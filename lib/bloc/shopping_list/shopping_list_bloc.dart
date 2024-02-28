import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/shopping_list/shopping_list_event.dart';
import 'package:futuremama/bloc/shopping_list/shopping_list_state.dart';
import 'package:futuremama/services/hive/shopping_list_hive.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  ShoppingListBloc() : super(ResultShoppingListState(shoppingList: [])) {
    _onLoadShoppingList();
    on<AddShoppingListEvent>(_onAddShoppingListEvent);
    on<DeleteShoppingListEvent>(_onDeleteShoppingListItem);
  }

  Future<void> _onLoadShoppingList() async {
    final shoppingResults = await ShoppingListHive.loadData();
    emit(ResultShoppingListState(shoppingList: shoppingResults));
  }

  Future<void> _onDeleteShoppingListItem(
      DeleteShoppingListEvent event, Emitter<ShoppingListState> emit) async {
    List<String> shoppingResults = await ShoppingListHive.loadData();
  }

  Future<void> _onAddShoppingListEvent(
      AddShoppingListEvent event, Emitter<ShoppingListState> emit) async {}
}
