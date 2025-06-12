import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const String INITIAL_TEXT = 'Initial Text';

class textColumn extends StatefulWidget {
  const textColumn({super.key});

  _textColumn createState() => _textColumn();
}

class _textColumn extends State<textColumn> {
  final List<String> inputs = List.empty(growable: true);
  late ScrollController _scrollController;
  late TextEditingController _inputTextController;
  late TextEditingController _exampleTextController;

  void inputText(String text) {
    //need to make this more dynamic to screen size
    setState(() {
      _inputTextController.text = INITIAL_TEXT;
      _exampleTextController.text = text;
      inputs.add(text);
    });
  }

  @override
  void initState() {
    super.initState();
    _exampleTextController = TextEditingController(text: '');
    _scrollController = ScrollController()..addListener(_scrollListener);
    _inputTextController = TextEditingController(text: INITIAL_TEXT);
  }

  @override
  void dispose() {
    _exampleTextController.dispose();
    _scrollController.dispose();
    _inputTextController.dispose();
    inputs.removeRange(0, inputs.length - 1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Run below function after widget is rebuilt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
    });

    var messageFontSize = Theme.of(context).textTheme.bodyMedium!;

    return (Column(
      children: [
        Expanded(
          child: CupertinoScrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: inputs.length,
              controller: _scrollController,
              itemBuilder: (context, index) {
                //Message Reply Box
                return (Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsetsDirectional.fromSTEB(20, 5, 10, 5),
                    padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${inputs[index]}: $index",
                      style: messageFontSize,
                    ),
                  ),
                ));
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CupertinoTextField(
              controller: _inputTextController,
              style: Theme.of(context).textTheme.bodyMedium,
              suffixMode: OverlayVisibilityMode.always,
              maxLines: 4,
              minLines: 1,
              suffix: CupertinoButton(
                borderRadius: BorderRadius.circular(0.5),
                onPressed: () => inputText(_inputTextController.text),
                sizeStyle: CupertinoButtonSize.medium,
                child: Icon(CupertinoIcons.arrow_up_circle_fill),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  void _scrollListener() {
    //print("Scroll Position: ${_scrollController.position.pixels}");
  }
}
