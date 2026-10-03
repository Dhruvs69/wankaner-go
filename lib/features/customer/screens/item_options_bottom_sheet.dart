import 'package:flutter/material.dart';
import '../models/item_model.dart';

class ItemOptionsBottomSheet extends StatefulWidget {
  final Item item;
  final Function(ItemVariant?, List<ItemAddon>) onAdd;

  const ItemOptionsBottomSheet({super.key, required this.item, required this.onAdd});

  @override
  State<ItemOptionsBottomSheet> createState() => _ItemOptionsBottomSheetState();
}

class _ItemOptionsBottomSheetState extends State<ItemOptionsBottomSheet> {
  ItemVariant? _selectedVariant;
  final List<ItemAddon> _selectedAddons = [];

  @override
  void initState() {
    super.initState();
    if (widget.item.variants.isNotEmpty) {
      _selectedVariant = widget.item.variants.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = (_selectedVariant?.price ?? widget.item.price) + _selectedAddons.fold(0, (sum, a) => sum + a.price);

    return Material(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Customize ${widget.item.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            if (widget.item.variants.isNotEmpty) ...[
              const Text('Size/Variant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              RadioGroup<ItemVariant>(
                groupValue: _selectedVariant,
                onChanged: (val) => setState(() => _selectedVariant = val),
                child: Column(
                children: widget.item.variants.map((v) => Material(type: MaterialType.transparency, child: RadioListTile<ItemVariant>(
                  title: Text(v.name),
                  subtitle: Text('₹${v.price}'),
                  value: v,
                ))).toList(),
              ),
              ),
              const Divider(),
            ],

            if (widget.item.addons.isNotEmpty) ...[
              const Text('Add-ons', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ...widget.item.addons.map((a) => Material(type: MaterialType.transparency, child: CheckboxListTile(
                title: Text(a.name),
                subtitle: Text('+₹${a.price}'),
                value: _selectedAddons.contains(a),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _selectedAddons.add(a);
                    } else {
                      _selectedAddons.remove(a);
                    }
                  });
                },
              ))),
              const Divider(),
            ],

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onAdd(_selectedVariant, _selectedAddons);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: Text('Add Item • ₹$total', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
