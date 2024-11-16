import 'package:flutter/material.dart';
import 'package:promise/util/layout_util.dart';

class WrapRadio<T, V> extends StatelessWidget {
  final String label;
  late T selected;
  final List<T> options;
  final String Function(T) getDisplayTextFn;
  final V Function(T) getValueFn;
  final ValueChanged<T> onChanged;
  final Axis axis;

  WrapRadio(
      {super.key,
      required this.label,
      required this.onChanged,
      required this.options,
      required this.getDisplayTextFn,
      required this.getValueFn,
      this.axis = Axis.horizontal,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: paddingTop,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label),
              if (axis == Axis.horizontal)
               SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ListTile.divideTiles(
                        color: Colors.transparent,
                        context: context,
                        tiles: options.map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio.adaptive(
                                  value: item,
                                  groupValue: selected,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (T? value) {
                                    _changeValue(value);
                                  }),
                              InkWell(
                                onTap: () => _changeValue(item),
                                child: Text(getDisplayTextFn(item)),
                              )
                            ],
                          );
                        })).toList())),
              if (axis == Axis.vertical)
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: ListTile.divideTiles(
                        context: context,
                        tiles: options.map((item) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Radio.adaptive(
                                  value: item,
                                  groupValue: selected,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (T? value) {
                                    _changeValue(value);
                                  }),
                              InkWell(
                                onTap: () => _changeValue(item),
                                child: Text(getDisplayTextFn(item)),
                              )
                            ],
                          );
                        })).toList()),
            ]));
  }

  _changeValue(T? value) {
    if (value != null && getValueFn(value) != getValueFn(selected)) {
      onChanged(value);
    }
  }
}
