abstract class ShoppingListEvent {}

class LoadShoppingListEvent extends ShoppingListEvent {}

class DeleteShoppingListEvent extends ShoppingListEvent {
  final String string;

  DeleteShoppingListEvent({required this.string});
}

class AddShoppingListEvent extends ShoppingListEvent {
  final String string;

  AddShoppingListEvent({required this.string});
}
