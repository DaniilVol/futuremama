// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:futuremama/bloc/shopping_list/shopping_list_event.dart';
// import 'package:futuremama/bloc/shopping_list/shopping_list_state.dart';
// import 'package:futuremama/services/hive/shopping_list_hive.dart';

// class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
//   ShoppingListBloc() : super(ResultShoppingListState(room: [], transport: [])) {
//     _onLoadShoppingList();
//     on<IsCheckShoppingListEvent>(_onChangeIsCheck);
//     on<AddShoppingListEvent>(_onAddShoppingListEvent);
//     // on<DeleteShoppingListEvent>(_onDeleteShoppingListItem);
//   }

//   Future<void> _onLoadShoppingList() async {
//     final room = await ShoppingListHive.loadDataRoom();
//     final transport = await ShoppingListHive.loadDataTransport();
//     emit(ResultShoppingListState(room: room, transport: transport));
//   }

//   // Future<void> _onDeleteShoppingListItem(
//   //     DeleteShoppingListEvent event, Emitter<ShoppingListState> emit) async {
//   //   List<dynamic> shoppingResults = await ShoppingListHive.loadData();
//   // }

//   Future<void> _onChangeIsCheck(
//       IsCheckShoppingListEvent event, Emitter<ShoppingListState> emit) async {
//     await ShoppingListHive.changeCheckDataRoom(
//         event.category, event.index, event.isChecked);
//     await _onLoadShoppingList();
//   }

//   Future<void> _onAddShoppingListEvent(
//       AddShoppingListEvent event, Emitter<ShoppingListState> emit) async {}
// }
