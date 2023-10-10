import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Tile<T> extends HookWidget {
  final Widget child;
  final void Function(TileData)? onNest;
  final void Function(DragTargetDetails<TileData>)? onMove;
  final void Function(TileData)? onLeave;
  final void Function(TileData)? onEnter;
  final void Function()? onReorderEnd;
  final void Function()? onReorderCanceled;
  final void Function()? onReorderCompleted;
  final void Function(TileData)? onReorderStart;
  final TileData tileData;
  final bool draggable;

  Tile({
    required this.tileData,
    required this.child,
    this.draggable = true,
    this.onNest,
    this.onMove,
    this.onLeave,
    this.onEnter,
    this.onReorderStart,
    this.onReorderEnd,
    this.onReorderCanceled,
    this.onReorderCompleted,
  }) : super(key: ObjectKey(tileData));

  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    final opacity = useState<double>(1);
    return draggable
        ? LongPressDraggable<TileData>(
            onDragCompleted: () {
              onReorderCompleted?.call();
            },
            onDraggableCanceled: (velocity, offset) {
              onReorderCanceled?.call();
            },
            onDragStarted: () {
              onReorderStart?.call(tileData);
              opacity.value = 0.5;
            },
            onDragEnd: (DraggableDetails) {
              onReorderEnd?.call();
              opacity.value = 1;
            },
            data: tileData,
            child: DragTarget<TileData>(
              onWillAccept: (data) {
                _timer = new Timer(
                  Duration(milliseconds: 700),
                  () {
                    onEnter?.call(data!);
                    tileData.onEnter?.call(data!);
                  },
                );

                return data!.canBeNested;
              },
              onAccept: (data) {
                _timer?.cancel.call();

                tileData.onNest?.call(data);
                onNest?.call(data);
              },
              onLeave: (data) {
                _timer?.cancel.call();

                tileData.onLeave?.call(data!);
                onLeave?.call(data!);
              },
              onMove: (data) {
                tileData.onMove?.call(data);
                onMove?.call(data);
              },
              builder: (context, candidateData, rejectedData) {
                return child;
              },
            ),
            childWhenDragging: Opacity(
              opacity: opacity.value,
              child: child,
            ),
            feedback: Transform.scale(
              scale: 0.5,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: child,
                ),
              ),
            ),
          )
        : child;
  }
}

class TileData<T> extends Equatable {
  final T value;
  final void Function(TileData<T>)? onNest;
  final void Function(DragTargetDetails<TileData>)? onMove;
  final void Function(TileData<T>)? onLeave;
  final void Function(TileData<T>)? onEnter;
  final bool canBeNested;
  final bool draggable;

  TileData({
    required this.value,
    this.onNest,
    this.onLeave,
    this.onMove,
    this.onEnter,
    this.canBeNested = false,
    this.draggable = true,
  });

  @override
  List<Object?> get props => [value];
}
