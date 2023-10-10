import 'package:fentrue23/features/project/data/project/project_entity.dart';
import 'package:fentrue23/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:jlogical_utils/jlogical_utils.dart';

import '../../../constants/spacers.dart';
import '../data/fixture.dart';
import '../data/fixture_entity.dart';
import '../data/fixture_factory.dart';
import 'fixture_screen.dart';

class FixtureCard extends HookWidget {
  final FixtureEntity fixtureEntity;
  final ProjectEntity projectEntity;

  const FixtureCard(
      {super.key, required this.fixtureEntity, required this.projectEntity});

  String _detailsString() {
    String output = "";
    for (var key in fixtureEntity.value.detailsProperty.value!.keys) {
      if (key == 'location' || key == 'room' || key == 'description') continue;

      output += "$key: ${fixtureEntity.value.detailsProperty.value![key]}\n";
    }
    return output;
  }

  _delete() async {
    ProjectEntity? projectEntity = await Query.getById<ProjectEntity>(
            fixtureEntity.value.projectIdProperty.value!)
        .get();
    projectEntity?.value.fixtureIdsProperty.value?.remove(fixtureEntity.id);
    projectEntity?.save();
    FixtureFactory().deleteEntity(fixtureEntity);
  }

  @override
  Widget build(BuildContext context) {
    Fixture fixture = fixtureEntity.value;
    return Dismissible(
      onDismissed: (direction) async => await _delete(),
      background: StyledContainer(
        color: Colors.red,
        child: Center(
          child: StyledIcon(
            Icons.delete,
            size: 40,
          ),
        ),
      ),
      key: GlobalKey(),
      direction: DismissDirection.endToStart,
      child: StyledCategory.medium(
        onTapped: () {
          context.style().navigateTo(
                context: context,
                page: (_) => FixtureScreen(
                  fixtureEntity: fixtureEntity,
                  projectEntity: projectEntity,
                ),
              );
        },
        actions: [],
        body: FittedBox(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StyledContentHeaderText(
                    fixture.detailsProperty.value?['_Location'] ??
                        "${fixture.detailsProperty.value!['location'] ?? ''} "
                            "${fixture.detailsProperty.value!['room'] ?? ''} "
                            "${fixture.detailsProperty.value!['description'] ?? ''}",
                    textOverrides: StyledTextOverrides(
                      fontSize: 18,
                      fontColor: AppStyle.accentColor,
                    ),
                  ),
                  StyledContentSubtitleText(
                    fixtureEntity.value.subcategoryProperty.value!,
                    textOverrides: StyledTextOverrides(
                      textOverflow: TextOverflow.clip,
                    ),
                  ),
                  StyledDivider(),
                  Spacers.h10,
                  StyledBodyText(
                    _detailsString(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
