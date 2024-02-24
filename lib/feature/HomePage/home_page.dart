import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//provider

final selectedItemProvider = StateProvider<String?>((ref) => null);
final conditionCheckProvider = StateProvider<String?>((ref) => null);
final outProvider = StateProvider<List<bool>>((ref) => []);
final data = StateProvider<List>((ref) => [
      {
        "field_name": "f1",
        "widget": "dropdown",
        "valid_values": ["A", "B"]
      },
      {"field_name": "f2", "widget": "textfield", "visible": "f1=='A'"},
      {"field_name": "f3", "widget": "textfield", "visible": "f1=='A'"},
      {"field_name": "f4", "widget": "textfield", "visible": "f1=='A'"},
      {"field_name": "f5", "widget": "textfield", "visible": "f1=='B'"},
      {"field_name": "f6", "widget": "textfield", "visible": "f1=='B'"},
    ]);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  onChanged(WidgetRef ref, String? value) {
    ref.read(selectedItemProvider.notifier).update((state) => value);
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final jsonData = ref.watch(data);
    final selectedItem = ref.watch(selectedItemProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 80.h,
            padding: const EdgeInsets.only(top: 40, left: 10),
            width: double.maxFinite,
            color: Colors.blueGrey.shade700,
            child: Text(
              "Dynamic DropDowns",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(children: [
              SizedBox(
                height: 0.12.sh,
                child: ListView.builder(
                    itemCount: jsonData.length,
                    itemBuilder: (context, index) {
                      return jsonData[index]['widget'] == "dropdown"
                          ? DropdownButtonFormField<String>(
                              isDense: true,
                              value: selectedItem,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide.none)),
                              items: jsonData[index]["valid_values"]
                                  .map<DropdownMenuItem<String>>(
                                      (String option) =>
                                          DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(
                                              option,
                                              style: TextStyle(fontSize: 12.sp),
                                            ),
                                          ))
                                  .toList(),
                              onChanged: (String? value) {
                                onChanged(ref, value);
                                ref
                                    .read(conditionCheckProvider.notifier)
                                    .update((state) {
                                  return "${jsonData[index]["field_name"]}=='$value'";
                                });

                                ref.read(outProvider.notifier).update((state) {
                                  return jsonData.where((element) {
                                    return element['visible'] != null;
                                  }).map((e) {
                                    // print(e['visible']);
                                    // print(e['visible'] ==
                                    //     ref.watch(conditionCheckProvider));
                                    return e['visible'] ==
                                        ref.watch(conditionCheckProvider);
                                  }).toList();
                                });
                                print(ref.watch(outProvider));
                              })
                          : const SizedBox.shrink();
                    }),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: ref.watch(outProvider).length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: ref.watch(outProvider)[index],
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: textField(),
                      ),
                    );
                  })
            ]),
          ))
        ],
      ),
    );
  }

  Widget textField() {
    return TextField(
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: 'Enter data ....',
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none)),
    );
  }
}
