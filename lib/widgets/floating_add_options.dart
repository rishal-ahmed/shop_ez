import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shop_ez/core/constant/color.dart';
import 'package:shop_ez/core/routes/router.dart';

class FloatingAddOptions extends StatelessWidget {
  const FloatingAddOptions({
    Key? key,
    required this.isDialOpen,
  }) : super(key: key);

  final ValueNotifier<bool> isDialOpen;

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: mainColor,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      animatedIcon: AnimatedIcons.add_event,
      spacing: 5,
      openCloseDial: isDialOpen,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.receipt_long_rounded),
          label: 'Item Master',
          onTap: () => Navigator.pushNamed(context, routeItemMaster),
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_business_outlined),
          label: 'Supplier',
          onTap: () => Navigator.pushNamed(context, routeManageSupplier),
        ),
        SpeedDialChild(
          child: const Icon(Icons.person_add),
          label: 'Customer',
        ),
        SpeedDialChild(
          child: const Icon(Icons.category),
          label: 'Category',
        ),
        SpeedDialChild(
          child: const Icon(Icons.verified_outlined),
          label: 'Brand',
        ),
      ],
    );
  }
}
