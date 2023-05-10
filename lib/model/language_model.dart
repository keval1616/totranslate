const String tableLanguage = 'language';

class LanguageFields {
  static final List<String> values = [
    id,
    langName,
    langCode,
    localName,
  ];

  static const String id = '_id';
  static const String langName = 'langName';
  static const String langCode = 'langCode';
  static const String localName = 'localName';
}

class LanguageModel {
  final int? id;
  final String langName;
  final String langCode;
  final String localName;

  const LanguageModel({
    this.id,
    required this.langName,
    required this.langCode,
    required this.localName,
  });

  LanguageModel copy({
    int? id,
    String? langName,
    String? langCode,
    String? localName,
  }) =>
      LanguageModel(
          id: id ?? this.id,
          langName: langName ?? this.langName,
          langCode: langCode ?? this.langCode,
          localName: localName ?? this.localName);

  static LanguageModel fromJson(Map<String, Object?> json) => LanguageModel(
        id: json[LanguageFields.id] as int?,
        langName: json[LanguageFields.langName] as String,
        langCode: json[LanguageFields.langCode] as String,
        localName: json[LanguageFields.localName] as String,
      );

  Map<String, Object?> toJson() => {
        LanguageFields.id: id,
        LanguageFields.langName: langName,
        LanguageFields.langCode: langCode,
        LanguageFields.localName: localName,
      };
}
