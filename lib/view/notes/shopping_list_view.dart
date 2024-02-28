import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futuremama/bloc/shopping_list/shopping_list_bloc.dart';
import 'package:futuremama/bloc/shopping_list/shopping_list_state.dart';

class ShoppingListView extends StatelessWidget {
  const ShoppingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список покупок'),
      ),
      body: BlocProvider(
          create: (context) => ShoppingListBloc(),
          child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
            builder: (context, state) {
              if (state is ResultShoppingListState) {
                return ListView.builder(
                  itemCount: state.shoppingList.length,
                  itemBuilder: (context, index) {
                    final item = state.shoppingList[index];
                    return ShoppingListItem(item: item);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
    );
  }
}

class ShoppingListItem extends StatefulWidget {
  final String item;

  const ShoppingListItem({super.key, required this.item});

  @override
  ShoppingListItemState createState() => ShoppingListItemState();
}

class ShoppingListItemState extends State<ShoppingListItem> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.item,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      leading: Checkbox(
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
        },
      ),
    );
  }
}
