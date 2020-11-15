import 'package:bc4f/provider/group-provider.dart';
import 'package:bc4f/widget/components/select-list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditableGroupList extends StatefulWidget {
  final void Function(List<String> groups) onGroupFilterChange;
  final List<String> groups;
  final TextStyle textStyle;

  const EditableGroupList(
      {Key key,
      @required this.onGroupFilterChange,
      this.groups,
      this.textStyle})
      : super(key: key);

  @override
  _EditableGroupListState createState() => _EditableGroupListState();
}

class _EditableGroupListState extends State<EditableGroupList> {
  List<String> groups;

  List<String> get notNullgroups =>
      groups.where((t) => t != null && t.isNotEmpty).toList();

  @override
  void initState() {
    groups = widget.groups?.sublist(0) ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final allgroups = Provider.of<GroupProvider>(context).groups;
    if (groups == null || allgroups.length == 0) return Container();
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text('Groups: '),
            IconButton(
              icon: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white54,
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.green[600],
                ),
              ),
              onPressed: () {
                setState(() {
                  groups.add(null);
                });
              },
            ),
            ...groups.map(
              (groupId) {
                return Row(
                  children: [
                    SelectList(
                      key: ValueKey(groupId),
                      list: allgroups.map((t) => t.uid).toList(),
                      hint: Text(
                        'groups',
                        style: widget.textStyle,
                      ),
                      onChanged: (val) {
                        final idx = groups.indexOf(groupId);
                        if (idx >= 0)
                          setState(() {
                            groups[idx] = val;
                            widget.onGroupFilterChange(notNullgroups);
                          });
                      },
                      value: groupId,
                      display: (id) => Text(allgroups
                              .firstWhere((g) => g.uid == id,
                                  orElse: () => null)
                              ?.name ??
                          'null'),
                      showUnderline: false,
                      showIcon: false,
                    ),
                    IconButton(
                        icon: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white54,
                          ),
                          child: Icon(
                            Icons.cancel_outlined,
                            color: Colors.red[700],
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            groups.remove(groupId);
                            widget.onGroupFilterChange(notNullgroups);
                          });
                        }),
                  ],
                );
              },
            ).toList(),
          ],
        ),
      ),
    );
  }
}
