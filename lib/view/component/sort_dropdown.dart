import "package:flutter/material.dart";


class SortBy extends StatefulWidget {
  final List<DropdownMenuItem<String>> items;
  final Function(dynamic) onChanged;
  final dynamic value;

  const SortBy({
    super.key,
    required this.items,
    required this.onChanged,
    required this.value
  });

  @override
  State<SortBy> createState() => _SortByState();
}

class _SortByState extends State<SortBy> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: const Icon(Icons.sort, color: Colors.white, size: 20,),
      underline: Container(height: 0,),
      hint: const Text("sort by"),
      items: widget.items, 
      onChanged: widget.onChanged,
      value: widget.value,
    );
  }
}