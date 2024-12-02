import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T extends Object> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T extends Object> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          return Draggable<T>(
            data: item,
            feedback: widget.builder(item),
            childWhenDragging: const SizedBox.shrink(),
            onDragStarted: () => setState(() {}),
            onDragCompleted: () => setState(() {}),
            child: DragTarget<T>(
              onAccept: (data) {
                setState(() {
                  final oldIndex = _items.indexOf(data);
                  _items.removeAt(oldIndex);
                  _items.insert(index, data);
                });
              },
              onWillAccept: (data) => data != null && data != item,
              builder: (context, candidateData, rejectedData) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  constraints: const BoxConstraints(minWidth: 48),
                  height: 48,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: candidateData.isNotEmpty
                        ? Colors.grey
                        : Colors
                        .primaries[item.hashCode % Colors.primaries.length],
                  ),
                  child: widget.builder(item),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
