import 'package:dating_app/common/enum/gender_enum.dart';
import 'package:dating_app/features/match/models/preference_model.dart';
import 'package:dating_app/features/match/providers/match_provider.dart';
import 'package:dating_app/features/match/services/fetch_matches_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MatchProvider>(
      builder: (context, matchProvider, child) {
        return Scaffold(
          appBar: AppBar(title: const Text("Filter")),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    title: const Text("Age Range"),
                    subtitle: RangeSlider(
                      min: 18.0,
                      max: 120.0,
                      divisions: (120 - 18).toInt(),
                      labels: RangeLabels(
                          matchProvider.preference.minAge.toString(),
                          matchProvider.preference.maxAge.toString()),
                      values: RangeValues(
                        matchProvider.preference.minAge.toDouble(),
                        matchProvider.preference.maxAge.toDouble(),
                      ),
                      onChanged: (o) {
                        matchProvider.updatePreference(
                          preferenceModel: PreferenceModel(
                            maxAge: o.end.toInt(),
                            minAge: o.start.toInt(),
                            gender: matchProvider.preference.gender,
                            interests: matchProvider.preference.interests,
                            distance: matchProvider.preference.distance,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    title: const Text("Distance away"),
                    subtitle: Slider(
                      max: 5000.0,
                      min: 100.0,
                      divisions: (5000 - 100),
                      label:
                          "${matchProvider.preference.distance.toInt().toString()} m",
                      value: matchProvider.preference.distance,
                      onChanged: (o) {
                        matchProvider.updatePreference(
                          preferenceModel: PreferenceModel(
                            maxAge: matchProvider.preference.maxAge,
                            minAge: matchProvider.preference.minAge,
                            gender: matchProvider.preference.gender,
                            interests: matchProvider.preference.interests,
                            distance: o,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  child: ListTile(
                    title: const Text("Gender"),
                    subtitle: Column(
                      children: [
                        RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          value: matchProvider.preference.gender,
                          groupValue: Gender.man,
                          onChanged: (value) {
                            matchProvider.updatePreference(
                              preferenceModel: PreferenceModel(
                                maxAge: matchProvider.preference.maxAge,
                                minAge: matchProvider.preference.minAge,
                                gender: Gender.man,
                                interests: matchProvider.preference.interests,
                                distance: matchProvider.preference.distance,
                              ),
                            );
                          },
                          title: const Text("Man"),
                        ),
                        RadioListTile(
                          contentPadding: const EdgeInsets.all(0),
                          value: matchProvider.preference.gender,
                          groupValue: Gender.woman,
                          onChanged: (value) {
                            matchProvider.updatePreference(
                              preferenceModel: PreferenceModel(
                                maxAge: matchProvider.preference.maxAge,
                                minAge: matchProvider.preference.minAge,
                                gender: Gender.woman,
                                interests: matchProvider.preference.interests,
                                distance: matchProvider.preference.distance,
                              ),
                            );
                          },
                          title: const Text("Woman"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () {
                    FetchMatchesService.execute(matchProvider: matchProvider);
                    Navigator.pop(context);
                  },
                  child: const Text("Confrim"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
