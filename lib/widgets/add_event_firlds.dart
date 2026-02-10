import 'package:flutter/material.dart';

class AddEventFirlds extends StatefulWidget {
  final String topicTitle;
  final String hintText;
  final int? maxLines;
  final TextEditingController filedContraller;
  final String? Function(String?)? validator;

  const AddEventFirlds({
    super.key,
    required this.topicTitle,
    required this.hintText,
    required this.filedContraller,
    this.validator,
    this.maxLines,
  });

  @override
  State<AddEventFirlds> createState() => _AddEventFirldsState();
}

class _AddEventFirldsState extends State<AddEventFirlds> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.topicTitle,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: widget.filedContraller,
          validator: widget.validator,
          maxLines: widget.maxLines ?? 1,
          decoration: InputDecoration(
            hintText: widget.hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}
