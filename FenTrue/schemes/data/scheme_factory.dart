import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:fentrue23/abstracts/entity_factory.dart';
import 'package:fentrue23/features/fixture/data/fixture.dart';
import 'package:fentrue23/features/fixture/data/fixture_form_controller.dart';
import 'package:fentrue23/features/schemes/data/scheme.dart';
import 'package:fentrue23/features/schemes/data/scheme_entity.dart';
import 'package:fentrue23/features/schemes/fixture_scheme.dart';
import 'package:fentrue23/features/schemes/scheme_category.dart';
import 'package:fentrue23/features/schemes/scheme_object.dart';
import 'package:fentrue23/features/schemes/scheme_option.dart';
import 'package:fentrue23/features/schemes/scheme_section.dart';
import 'package:fentrue23/features/schemes/scheme_tab.dart';
import 'package:fentrue23/features/widgets/chip_selection_field.dart';
import 'package:fentrue23/features/widgets/fixture_field_category.dart';
import 'package:fentrue23/features/widgets/fixture_field_set.dart';
import 'package:fentrue23/features/widgets/fixture_page.dart';
import 'package:fentrue23/features/widgets/smart_fraction_field.dart';
import 'package:fentrue23/features/widgets/smart_quantity_field.dart';
import 'package:fentrue23/features/widgets/smart_toggle_field.dart';
import 'package:fentrue23/features/widgets/smart_wheel_selection.dart';
import 'package:fentrue23/style.dart';
import 'package:fentrue23/utils/layout_tools.dart';
import 'package:flutter/material.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

class SchemeFactory extends EntityFactory<SchemeEntity, Scheme> {
  @override
  Future<SchemeEntity?> createNewEntity({
    required Map<String, dynamic> data,
  }) async {
    final entity = EntityFactory.createDefault<SchemeEntity, Scheme>();
    final object = entity.value;

    for (var field in data.keys) {
      if (object.propertiesByKey[field] is AssetFieldProperty) {
        if (data[field] is Asset) {
          await object.fileProperty.uploadNewAssetAndSet(data[field]);
        } else if (data[field] is String) {
          final bytes = Uint8List.fromList(
              utf8.encode(data[field])); // utf8 from dart:convert library
          final asset = Asset.createNew(
            value: bytes,
            id: UuidIdGenerator().getId(),
          );

          await object.fileProperty.uploadNewAssetAndSet(asset);
        }
      } else {
        object.propertiesByKey[field]?.value = data[field];
      }
    }

    entity.value = object;
    await entity.createOrSave();
    return entity;
  }

  static Widget buildForm({
    required BuildContext context,
    required FixtureScheme scheme,
    SmartFormController? controller,
    Fixture? fixture,
  }) {
    final Map<String, dynamic> fixtureDetails =
        fixture?.detailsProperty.value! ?? {};

    final List<String> fieldNames = [];

    SmartFormField field(SchemeOption option) {
      late SmartFormField returnField;

      if (!fieldNames.contains(option.name)) fieldNames.add(option.name);

      switch (option.inputType) {
        case 'chip':
          Map<dynamic, SmartFormField?> subsets = {};

          for (Map<dynamic, SchemeOption?> value in option.values ?? []) {
            subsets.addAll(Map.fromIterables(
                value.keys.toList(),
                value.values.map((suboption) =>
                    suboption != null ? field(suboption) : null)));
          }

          returnField = SmartChipSelectionField(
            canBeNone: false,
            initialValue: fixtureDetails[option.name],
            name: option.name,
            label: LayoutTools.normalizeWords(option.name),
            options:
                option.values?.map((e) => e.keys.toList()[0]).toList() ?? [],
            subsets: subsets,
          );
          break;
        case 'fraction':
          returnField = SmartFractionField(
            initialValue: fixtureDetails[option.name],
            name: option.name,
            label: LayoutTools.normalizeWords(option.name),
          );
          break;
        case 'wheel':
          returnField = SmartIncrementField(
            initialValue: fixtureDetails[option.name],
            name: option.name,
            label: LayoutTools.normalizeWords(option.name),
            minValue: option.values?[0].keys.toList()[0] ?? 0,
            maxValue: option.values?[1].keys.toList()[0] ?? 10,
          );
          break;
        case 'increment':
          int? initialValue;

          fixture!.propertiesByKey.containsKey(option.name)
              ? initialValue = fixture.propertiesByKey[option.name]?.value
              : initialValue = fixtureDetails[option.name];

          returnField = SmartQuantityField(
            name: option.name,
            initialValue: initialValue,
            label: LayoutTools.normalizeWords(option.name),
            minValue: 0,
            maxValue: 10,
          );
          break;
        case 'toggle':
          returnField = SmartToggleField(
            name: option.name,
            labelText: LayoutTools.normalizeWords(option.name),
            initiallyChecked: fixtureDetails[option.name] ?? false,
          );
      }

      return returnField;
    }

    FixtureFieldSet set(SchemeSection section) {
      List<SmartFormField> fields =
          section.options.map((option) => field(option)).toList();

      return FixtureFieldSet(
        direction: section.isHorizontal
            ? FlowDirection.horizontal
            : FlowDirection.vertical,
        label: section.name,
        children: fields,
      );
    }

    FixtureFieldCategory group(SchemeCategory category) {
      fieldNames.clear();
      List<Widget> objects = category.objects.map((object) {
        if (object is SchemeOption) {
          return field(object);
        } else if (object is SchemeSection) {
          return set(object);
        } else if (object is SchemeCategory) {
          fieldNames.clear();
          List<Widget> children = object.objects.map(
            (object) {
              if (object is SchemeOption) {
                return field(object);
              } else if (object is SchemeSection) {
                return set(object);
              } else {
                return Container();
              }
            },
          ).toList();

          return FixturePage(
            controller: controller ?? SmartFormController(),
            label: (object.name),
            fixture: fixture ?? Fixture(),
            subfields: [...fieldNames],
            children: children,
          );
        } else {
          return Container();
        }
      }).toList();

      return FixtureFieldCategory(
        label: category.name,
        children: objects,
      );
    }

    Widget form = StyledTabbedPage(
      allowSwipes: false,
      sideBarNavigation: true,
      pages: [
        ...scheme.tabs.map(
          (tab) {
            return StyledTab(
              body: SmartForm(
                controller: controller ?? SmartFormController(),
                child: ScrollColumn(
                  children: [
                    ...tab.categories.map(
                      (category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: group(category),
                        );
                      },
                    ).toList(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: StyledButton.high(
                          borderRadius: BorderRadius.circular(10),
                          onTapped: () async {
                            (controller as FixtureFormController).save(context);
                          },
                          child: StyledSubtitleText(
                            "Save",
                            textOverrides: StyledTextOverrides(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              title: tab.name,
              icon: IconData(tab.icon, fontFamily: 'Fenesphere'),
            );
          },
        ).toList(),
        StyledTab(
          icon: IconData(0xe801, fontFamily: 'Fenesphere'),
          title: 'Notes',
          body: SmartForm(
            controller: controller ?? SmartFormController(),
            child: ScrollColumn(
              children: [
                FixtureFieldCategory(
                  label: 'Notes',
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ),
                      child: StyledSmartTextField(
                        initialValue: fixtureDetails['notes'],
                        label: StyledContentHeaderText(
                          'Notes',
                          textOverrides: StyledTextOverrides(
                            fontSize: 20,
                            fontColor: AppStyle.accentColor,
                          ),
                        ),
                        backgroundColor: AppStyle.backgroundColor,
                        name: 'notes',
                        maxLines: 10,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: StyledButton.high(
                      borderRadius: BorderRadius.circular(10),
                      onTapped: () async {
                        (controller as FixtureFormController).save(context);
                      },
                      child: StyledSubtitleText(
                        "Save",
                        textOverrides: StyledTextOverrides(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        StyledTab(
          icon: IconData(0xe807, fontFamily: 'Fenesphere'),
          title: 'Images',
          body: SmartForm(
            controller: controller ?? SmartFormController(),
            child: ScrollColumn(
              children: [],
            ),
          ),
        ),
      ],
    );
    return form;
  }

  static FixtureScheme? jsonToScheme(dynamic parsedJson) {
    SchemeObject? buildObject(dynamic object) {
      if (object == null) return null;

      switch (object['type']) {
        case 'field':
          return SchemeOption(
            name: object['name'],
            inputType: object['inputType'],
            values: [
              ...object['values']?.map(
                    (value) => <dynamic, SchemeOption?>{
                      value.keys.toList()[0]:
                          buildObject(value[value.keys.toList()[0]])
                              as SchemeOption?
                    },
                  ) ??
                  []
            ],
          );
        case 'set':
          return SchemeSection(
              name: object['name'],
              options: [
                ...object['options']
                    .map((option) => buildObject(option) as SchemeOption),
              ],
              isHorizontal: object['isHorizontal']);
        case 'group':
          return SchemeCategory(name: object['name'], objects: [
            ...object['objects']?.map((object) => buildObject(object))
          ]);
        default:
      }
      return null;
    }

    return FixtureScheme(
      name: parsedJson['name'],
      tabs: [
        ...parsedJson['tabs'].map(
          (tab) => SchemeTab(
            name: tab['name'],
            categories: [
              ...tab['categories'].map(
                (category) {
                  return SchemeCategory(
                    name: category['name'],
                    objects: [
                      ...category['objects']
                          ?.map((object) => buildObject(object))
                    ],
                  );
                },
              ),
            ],
            icon: int.tryParse(tab['icon'].toString()) ?? 0xe800,
          ),
        ),
      ],
    );
  }

  static Future<dynamic> getJsonString(
    String formId,
  ) async {
    try {
      final asset = await locate<AssetModule>()
          .assetProvider
          .getDataSource(formId)
          .getData();
      final assetBytes = asset?.value;

      if (assetBytes != null) {
        return json.decode(utf8.decode(assetBytes.toList()));
      } else {
        return null;
      }
    } catch (e) {
      throw e;
    }
  }

  static String processString(String input) {
    // Replace non-alphanumeric characters (except '/' and ',') with spaces
    String processed = input.replaceAll(RegExp(r'[^a-zA-Z0-9/, ]'), '');

    // Remove the word 'null'
    processed = processed.replaceAll('null', '');

    // Trim any leading or trailing spaces
    processed = processed.trim();

    return processed;
  }
}
