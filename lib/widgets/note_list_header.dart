import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:todo/constants/colors.dart';

class NoteListHeader extends StatelessWidget {
  const NoteListHeader({
    Key key,
    @required this.textEditingController,
    @required this.searchContoller,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final StateController<String> searchContoller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: DARKEST,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        controller: textEditingController,
        onChanged: (v) => searchContoller.state = v,
        maxLines: 1,
        minLines: 1,
        cursorColor: RED,
        style: TextStyle(
          color: WHITE,
          fontSize: 20,
        ),
        decoration: InputDecoration(labelText: 'Search'),
      ),
    );
  }
}
