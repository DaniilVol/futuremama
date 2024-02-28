abstract class ShoppingListState {}

class ResultShoppingListState extends ShoppingListState {
  final List<String> shoppingList;

  ResultShoppingListState({required this.shoppingList});
}
