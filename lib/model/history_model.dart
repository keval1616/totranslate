const String tableHistory = 'history';

class HistoryFields {
  static final List<String> values = [
    id,
    langOnename,
    langOneCode,
    langTwoName,
    langTwoCode,
    origianlText,
    translatedText,
    date,
    isFav,
  ];

  static const String id = '_id';
  static const String langOnename = 'langOnename';
  static const String langOneCode = 'langOneCode';
  static const String langTwoName = 'langTwoName';
  static const String langTwoCode = 'langTwoCode';
  static const String origianlText = 'origianlText';
  static const String translatedText = 'translatedText';
  static const String date = 'date';
  static const String isFav = 'isFav';
}

class HistoryModel {
  final int? id;
  final String langOnename;
  final String langOneCode;
  final String langTwoName;
  final String langTwoCode;
  final String origianlText;
  final String translatedText;
  final String date;
  final int isFav;

  const HistoryModel({
    this.id,
    required this.langOnename,
    required this.langOneCode,
    required this.langTwoName,
    required this.langTwoCode,
    required this.origianlText,
    required this.translatedText,
    required this.date,
    required this.isFav,
  });

  HistoryModel copy({
    int? id,
    String? langOnename,
    String? langOneCode,
    String? langTwoName,
    String? langTwoCode,
    String? origianlText,
    String? translatedText,
    String? date,
    int? isFav,
  }) =>
      HistoryModel(
        id: id ?? this.id,
        langOnename: langOnename ?? this.langOnename,
        langOneCode: langOneCode ?? this.langOneCode,
        langTwoName: langTwoName ?? this.langTwoName,
        langTwoCode: langTwoCode ?? this.langTwoCode,
        origianlText: origianlText ?? this.origianlText,
        translatedText: translatedText ?? this.translatedText,
        date: date ?? this.date,
        isFav: isFav ?? this.isFav,
      );

  static HistoryModel fromJson(Map<String, Object?> json) => HistoryModel(
        id: json[HistoryFields.id] as int?,
        langOnename: json[HistoryFields.langOnename] as String,
        langOneCode: json[HistoryFields.langOneCode] as String,
        langTwoName: json[HistoryFields.langTwoName] as String,
        langTwoCode: json[HistoryFields.langTwoCode] as String,
        origianlText: json[HistoryFields.origianlText] as String,
        translatedText: json[HistoryFields.translatedText] as String,
        date: json[HistoryFields.date] as String,
        isFav: json[HistoryFields.isFav] as int,
      );

  Map<String, Object?> toJson() => {
        HistoryFields.id: id,
        HistoryFields.langOnename: langOnename,
        HistoryFields.langOneCode: langOneCode,
        HistoryFields.langTwoName: langTwoName,
        HistoryFields.langTwoCode: langTwoCode,
        HistoryFields.origianlText: origianlText,
        HistoryFields.translatedText: translatedText,
        HistoryFields.date: date,
        HistoryFields.isFav: isFav,
      };
}
