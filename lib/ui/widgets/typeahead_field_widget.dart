import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:mwb_connect_app/utils/colors.dart';

class TypeAheadField extends StatefulWidget {
  const TypeAheadField({
    Key key,
    this.options,
    this.inputKey, 
    this.inputController, 
    this.inputDecoration,
    this.onFocusCallback,
    this.onChangedCallback,
    this.onSubmittedCallback,
    this.onSuggestionSelected
  }) : super(key: key);   

  final List<String> options;
  final Key inputKey;
  final TextEditingController inputController;
  final InputDecoration inputDecoration;
  final Function() onFocusCallback;
  final Function(String) onChangedCallback;
  final Function(String) onSubmittedCallback;
  final Function(String) onSuggestionSelected;

  @override
  _TypeAheadFieldState createState() => _TypeAheadFieldState();
}

class _TypeAheadFieldState extends State<TypeAheadField> {
  final FocusNode _focusNode = FocusNode();
  OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.onFocusCallback();
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    final List<Widget> optionWidgets = [];
    if (widget.options != null && widget.options.length > 0) {
      for (int i = 0; i < widget.options.length; i++) {
        final Widget option = InkWell(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
            child: Text(widget.options[i])
          ),
          onTap: () {
            widget.onSuggestionSelected(widget.options[i]); 
          }
        );
        optionWidgets.add(option);
      }
    } else {
      final Widget noItemsFound = Padding(
        padding: const EdgeInsets.only(top: 6.0),
        child: Center(
          child: Text('No items found')
        )
      );
      optionWidgets.add(noItemsFound);
    }
    double height = 160.0;
    if (optionWidgets.length < 5) {
      height = optionWidgets.length * 32.0;
    }
    double heightScrollThumb = 150.0 / (widget.options.length / 5);

    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              height: height,
              child: DraggableScrollbar(
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: optionWidgets,
                ),
                heightScrollThumb: heightScrollThumb,
                backgroundColor: AppColors.SILVER,
                scrollThumbBuilder: (
                  Color backgroundColor,
                  Animation<double> thumbAnimation,
                  Animation<double> labelAnimation,
                  double height, {
                  Text labelText,
                  BoxConstraints labelConstraints
                }) {
                  return FadeTransition(
                    opacity: thumbAnimation,
                    child: Container(
                      height: height,
                      width: 5.0,
                      color: backgroundColor,
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      )
    );
  }

  void _afterLayout(_) {
    if (_overlayEntry != null && _focusNode.hasFocus) {
      _overlayEntry.remove();
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
    }  
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        focusNode: _focusNode,
        key: widget.inputKey,
        controller: widget.inputController,
        decoration: widget.inputDecoration,
        onChanged: widget.onChangedCallback,
        onFieldSubmitted: widget.onSubmittedCallback
      ),
    );
  }
}