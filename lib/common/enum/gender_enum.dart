enum Gender { man, woman }

Gender enumGender({required String string}) =>
    Gender.values.firstWhere((e) => e.toString().split('.').last == string);

String enumStringGender({required Gender gender}) =>
    gender.toString().substring(gender.toString().indexOf('.') + 1);
