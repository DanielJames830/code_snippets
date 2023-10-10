import 'package:fentrue23/features/schemes/fixture_scheme.dart';
import 'package:fentrue23/features/schemes/scheme_category.dart';
import 'package:fentrue23/features/schemes/scheme_option.dart';
import 'package:fentrue23/features/schemes/scheme_section.dart';
import 'package:fentrue23/features/schemes/scheme_tab.dart';

class Presets {
  static final FixtureScheme defaultScheme = FixtureScheme(
    name: 'Default',
    tabs: [
      SchemeTab(
        name: 'Project Specs',
        categories: [
          SchemeCategory(
            name: 'Quantity',
            objects: [
              SchemeOption(name: 'quantity', inputType: 'increment'),
            ],
          ),
          SchemeCategory(
            name: 'Details',
            objects: [
              SchemeCategory(
                name: 'Measurements',
                objects: [
                  SchemeSection(
                    name: 'Description',
                    options: [
                      SchemeOption(
                        name: 'measureDesc',
                        inputType: 'chip',
                        values: [
                          {'1': null},
                          {'2': null},
                          {'3': null},
                        ],
                      ),
                    ],
                  ),
                  SchemeSection(
                    name: 'Measurements',
                    options: [
                      SchemeOption(name: 'w', inputType: 'fraction'),
                      SchemeOption(name: 'h', inputType: 'fraction'),
                    ],
                  ),
                ],
              ),
              SchemeCategory(
                name: 'Location',
                objects: [
                  SchemeSection(
                    isHorizontal: false,
                    name: 'Location',
                    options: [
                      SchemeOption(
                        inputType: 'chip',
                        name: 'location',
                        values: [
                          {'Main Level': null},
                          {'Upstairs': null},
                          {'Downstairs': null},
                          {'Basement': null},
                          {'Garage': null},
                        ],
                      ),
                      SchemeOption(
                        inputType: 'chip',
                        name: 'room',
                        values: [
                          {'Bedroom': null},
                          {'Bathroom': null},
                          {'Closet': null},
                          {'Office': null},
                          {'Kitchen': null},
                        ],
                      ),
                      SchemeOption(
                        inputType: 'chip',
                        name: 'description',
                        values: [
                          {'None': null},
                          {'Front': null},
                          {'rear': null},
                          {'side': null},
                          {'center': null},
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SchemeCategory(
                name: 'Brand',
                objects: [
                  SchemeSection(
                    name: 'Manufacturer',
                    options: [
                      SchemeOption(
                        inputType: 'chip',
                        name: 'manufacturer',
                        values: [
                          {
                            'Sunrise': SchemeOption(
                              inputType: 'chip',
                              name: 'brand',
                              values: [
                                {'Sunset': null},
                                {'Marvin': null},
                                {'Provia': null},
                                {'Pella': null},
                                {'Western': null},
                              ],
                            ),
                          },
                          {
                            'Marvin': SchemeOption(
                              inputType: 'chip',
                              name: 'brand',
                              values: [
                                {'Sunrise': null},
                                {'Marvin': null},
                                {'Provia': null},
                                {'Pella': null},
                                {'Western': null},
                              ],
                            ),
                          },
                          {
                            'Provia': SchemeOption(
                              inputType: 'chip',
                              name: 'brand',
                              values: [
                                {'Sunrise': null},
                                {'Marvin': null},
                                {'Provia': null},
                                {'Pella': null},
                                {'Western': null},
                              ],
                            ),
                          },
                          {
                            'Pella': SchemeOption(
                              inputType: 'chip',
                              name: 'brand',
                              values: [
                                {'Sunrise': null},
                                {'Marvin': null},
                                {'Provia': null},
                                {'Pella': null},
                                {'Western': null},
                              ],
                            ),
                          },
                          {
                            'Western': SchemeOption(
                              inputType: 'chip',
                              name: 'brand',
                              values: [
                                {'Sunrise': null},
                                {'Marvin': null},
                                {'Provia': null},
                                {'Pella': null},
                                {'Western': null},
                              ],
                            ),
                          },
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              SchemeCategory(
                name: 'Repair/Replace',
                objects: [
                  SchemeSection(
                    isHorizontal: false,
                    name: 'Repair/Replace',
                    options: [
                      SchemeOption(
                        inputType: 'chip',
                        name: 'interior',
                        values: [
                          {'None': null},
                          {'Stool': null},
                          {'Lest Side Casing': null},
                          {'Top Casing': null},
                        ],
                      ),
                      SchemeOption(
                        inputType: 'chip',
                        name: 'exterior',
                        values: [
                          {'None': null},
                          {'Nosing': null},
                          {'Still & Nose': null},
                          {'Left Side Casing': null},
                        ],
                      ),
                      SchemeOption(
                        inputType: 'chip',
                        name: 'frame',
                        values: [
                          {'None': null},
                          {'Left Side Jamb': null},
                          {'Right Side Jamb': null},
                          {'Head Jamb': null},
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SchemeCategory(
            name: 'Lead/Tempered',
            objects: [
              SchemeOption(name: 'lead', inputType: 'toggle'),
              SchemeOption(name: 'temper', inputType: 'toggle'),
            ],
          ),
          SchemeCategory(
            name: 'Opening Type',
            objects: [
              SchemeSection(
                name: 'Opening Type',
                options: [
                  SchemeOption(
                    name: 'openingType',
                    inputType: 'chip',
                    values: [
                      {'Wood': null},
                      {'Metal': null},
                      {'Vinyl': null},
                      {'Glass': null},
                    ],
                  ),
                ],
              ),
            ],
          ),
          SchemeCategory(
            name: 'Install Type',
            objects: [
              SchemeSection(
                name: 'Install Type',
                options: [
                  SchemeOption(
                    name: 'installType',
                    inputType: 'chip',
                    values: [
                      {'Pocket': null},
                      {'Full Frame': null},
                      {'Sash Only': null},
                      {'New Const': null},
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
        icon: 0xe800,
      ),
      SchemeTab(
        name: 'Project Specs',
        categories: [
          SchemeCategory(
            name: 'Quantity',
            objects: [],
          ),
        ],
        icon: 0xe801,
      ),
    ],
  );
}
