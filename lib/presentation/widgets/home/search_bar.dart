// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tudu/core/theme/app_theme.dart';

class SearchBarWithButton extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onAdd;

  const SearchBarWithButton({
    super.key,
    required this.controller,
    required this.onAdd,
  });

  @override
  State<SearchBarWithButton> createState() => _SearchBarWithButtonState();
}

class _SearchBarWithButtonState extends State<SearchBarWithButton> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget.controller,
                style:  TextStyle(
                  color: AppTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                cursorColor: AppTheme.highlight,
                decoration: InputDecoration(
                  hintText: 'Search your tasks...',
                  hintStyle: TextStyle(
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                  ),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none
                ),
              ),
            ),
           
          ],
        ),
      
      ],
    );
  }

}
