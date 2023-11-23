import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ShippingModel {
  final String title;
  final String subtitle;
  ShippingModel({required this.subtitle, required this.title});
}

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  GlobalKey<AnimatedListState> animationListKey =
      GlobalKey<AnimatedListState>();

  List<ShippingModel> data = [
    ShippingModel(subtitle: "Summer Linen", title: "#NEJ20089934122231"),
    ShippingModel(
        subtitle: "Tapere-fit jeans AW", title: "#NEJ20089934122231 -> Paris"),
    ShippingModel(subtitle: "Mackbook pro M2", title: "#NEJ20089934122231"),
    ShippingModel(subtitle: "Office setup desk", title: "#NEJ20089934122231"),
    ShippingModel(subtitle: "Office setup desk", title: "#NEJ20089934122231"),
  ];

  List<ShippingModel> datas = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      updateUi(data);
    });
  }

  void updateUi(List<ShippingModel> shippingData) async {
    final ls = animationListKey.currentState!;
    for (var i = 0; i < shippingData.length; i++) {
      datas.add(shippingData[i]);
      ls.insertItem(
        datas.length - 1,
        duration: const Duration(milliseconds: 500),
      );
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = TabController(length: 4, vsync: this);
    final tController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("ARICH"),
        bottom: TabBar(
          isScrollable: true,
          controller: controller,
          tabs: List.generate(
            4,
            (index) => Tab(
                child: Row(
              children: const [
                Text("data"),
                SizedBox(width: 5.0),
              ],
            )),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("data"),
          Expanded(
            flex: 3,
            child: TabBarView(
              controller: controller,
              children: const [
                Text("Qazeem"),
                Text("ORITOKE"),
                Text("ASAKE"),
                Text("ASAKE"),
              ],
            ),
          ),
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                final da = data
                    .where((element) =>
                        element.title.toLowerCase().contains(val) ||
                        element.subtitle.toLowerCase().contains(val))
                    .toList();
                datas = [];
                updateUi(da);
                print("sjjsdjs");
              },
              controller: tController,
            ),
          ),
          const SizedBox(height: 10.0),
          ValueListenableBuilder(
            valueListenable: tController,
            builder: (context, value, _) {
              return Expanded(
                flex: 10,
                child: Card(
                  color: Colors.white,
                  elevation: 15.0,
                  child: AnimatedList(
                    initialItemCount: datas.length,
                    key: animationListKey,
                    itemBuilder: (context, index, animation) {
                      return SlideTransition(
                        position: animation.drive(Tween<Offset>(
                          begin: const Offset(0, 1),
                          end: Offset.zero,
                        )),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(datas[index].title),
                              subtitle: Text(datas[index].subtitle),
                              leading: const CircleAvatar(
                                child: Icon(Icons.sports_basketball),
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              final ls = animationListKey.currentState!;
              datas.add(data.last);
              ls.insertItem(
                datas.length - 1,
                duration: const Duration(seconds: 1),
              );
            },
            child: const Text("Add"),
          ),
          ElevatedButton(
            onPressed: () {
              final ls = animationListKey.currentState!;
              datas.removeLast();
              ls.removeItem(
                datas.length,
                (context, animation) {
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ),
                    ),
                    child: const ListTile(
                      title: Text(""),
                      subtitle: Text(""),
                    ),
                  );
                },
              );
            },
            child: const Text("Remove"),
          ),
        ],
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(kBottomNavigationBarHeight),
        child: TabBar(
          labelColor: Colors.red,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          controller: controller,
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.secondary,
                width: 5.0,
              ),
            ),
          ),
          tabs: List.generate(
            4,
            (index) => const Tab(
              text: "Home",
              iconMargin: EdgeInsets.only(bottom: 5.0),
              icon: Icon(
                Icons.directions_car,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.layout, required this.icon, required this.label});

  final BottomNavigationBarLandscapeLayout layout;
  final Widget icon;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData data = MediaQuery.of(context);
    if (data.orientation == Orientation.landscape &&
        layout == BottomNavigationBarLandscapeLayout.linear) {
      return Align(
        heightFactor: 1,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[icon, const SizedBox(width: 8), label],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[icon, label],
    );
  }
}

class AnimatedTest extends StatelessWidget {
  AnimatedTest({super.key});

  GlobalKey<AnimatedListState> animationListKey =
      GlobalKey<AnimatedListState>();

  List<String> data = ["Man", "Woman" "Girl"];

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: animationListKey,
      itemBuilder: (context, index, animation) {
        return Text(
          data[index],
          style: const TextStyle(fontSize: 10.0),
        );
      },
    );
  }
}

class QuadrantPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);
    final paint = Paint()..color = Colors.red;
    canvas.drawArc(
        Rect.fromCenter(center: center, width: width, height: height),
        0.0,
        pi / 2,
        true,
        paint);
  }

  @override
  bool shouldRepaint(QuadrantPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(QuadrantPainter oldDelegate) => false;
}

class CustomColumn extends MultiChildRenderObjectWidget {
  @override
  CustomColumn({super.key, super.children});

  @override
  RenderObject createRenderObject(BuildContext context) {
    throw RenderCustomColumn();
  }
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  @override
  bool get sizedByParent => true;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

  @override
  void performLayout() {
    RenderBox? child = firstChild;
    Size currentSize = Size.zero;
    final parentData = child?.parentData as CustomColumnParentData;
    while (child != null) {
      child.layout(constraints.loosen());
      final childSize = child.size;
      currentSize += Offset(childSize.width, childSize.height);
      parentData.offset = currentSize.toOffSet;
      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    final parentData = child?.parentData as CustomColumnParentData;
    while (child != null) {
      child.paint(context, parentData.offset);
      child = parentData.nextSibling;
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  // (any fields you might need for these children)
}

extension XSize on Size {
  Offset get toOffSet => Offset(width, height);
}
