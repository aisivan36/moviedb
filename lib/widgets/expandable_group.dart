import 'package:flutter/material.dart';

class ExpandableGroup extends StatefulWidget {
  const ExpandableGroup({
    Key? key,
    this.isExpanded,
    this.header,
    this.collapsedIcon,
    this.expandedIcon,
    this.headerBackgroundColor,
    this.headerEdgeInsets,
    this.items,
  })  : assert(isExpanded != null, 'isExpanded must NOT be null'),
        assert(header != null, 'Header must NOT be null'),
        assert(items != null, 'Items must NOT be null'),
        super(key: key);
  final bool? isExpanded;
  final Widget? header;
  final List<ListTile>? items;
  final Widget? expandedIcon;
  final Widget? collapsedIcon;
  final EdgeInsets? headerEdgeInsets;
  final Color? headerBackgroundColor;

  @override
  State<ExpandableGroup> createState() => _ExpandableGroupState();
}

class _ExpandableGroupState extends State<ExpandableGroup> {
  late bool isExpanded;

  void updateExpandedState(bool isExpanded) {
    setState(() {});
    this.isExpanded = isExpanded;
  }

  @override
  void initState() {
    super.initState();
    updateExpandedState(widget.isExpanded!);
  }

  Widget wrapHeader() {
    List<Widget> children = [];

    if (!widget.isExpanded!) {
      children.add(const Divider());
    }
    children.add(
      ListTile(
        contentPadding: widget.headerEdgeInsets ??
            const EdgeInsets.only(left: 0.0, right: 16.0),
        title: widget.header,
        trailing: isExpanded
            ? widget.expandedIcon ?? const Icon(Icons.keyboard_arrow_down)
            : widget.collapsedIcon ??
                const Icon(
                  Icons.keyboard_arrow_right,
                ),
        onTap: () => updateExpandedState(!isExpanded),
      ),
    );

    return Ink(
      color: widget.headerBackgroundColor ??
          Theme.of(context).appBarTheme.backgroundColor,
      child: Container(
          color: isExpanded ? const Color.fromARGB(255, 123, 122, 134) : null,
          child: Column(children: [...children])),
    );
  }

  Widget buildListItems(BuildContext context) {
    List<Widget> titles = [];

    titles.add(wrapHeader());
    titles.addAll(widget.items!);
    return Column(
      children: ListTile.divideTiles(tiles: titles, context: context).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      return buildListItems(context);
    } else {
      return wrapHeader();
    }
  }
}
