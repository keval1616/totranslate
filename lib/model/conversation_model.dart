const String tableConversation = 'convs';

class ConversationFields {
  static final List<String> values = [
    id,
    sourceCode,
    targetCode,
    source,
    target,
    side,
    date,
    lable,
  ];

  static const String id = '_id';
  static const String sourceCode = 'sourceCode';
  static const String targetCode = 'targetCode';
  static const String source = 'source';
  static const String target = 'target';
  static const String side = 'side';
  static const String date = 'date';
  static const String lable = 'lable';
}

class ConversationModel {
  final int? id;
  final String sourceCode;
  final String targetCode;
  final String source;
  final String target;
  final int side;
  final String date;
  final String lable;

  const ConversationModel({
    this.id,
    required this.sourceCode,
    required this.targetCode,
    required this.source,
    required this.target,
    required this.side,
    required this.date,
    required this.lable,
  });

  ConversationModel copy({
    int? id,
    String? sourceCode,
    String? targetCode,
    String? source,
    String? target,
    int? side,
    String? date,
    String? lable,
  }) =>
      ConversationModel(
        id: id ?? this.id,
        sourceCode: sourceCode ?? this.sourceCode,
        targetCode: targetCode ?? this.targetCode,
        source: source ?? this.source,
        target: target ?? this.target,
        side: side ?? this.side,
        date: date ?? this.date,
        lable: lable ?? this.lable,
      );

  static ConversationModel fromJson(Map<String, Object?> json) =>
      ConversationModel(
        id: json[ConversationFields.id] as int?,
        sourceCode: json[ConversationFields.sourceCode] as String,
        targetCode: json[ConversationFields.targetCode] as String,
        source: json[ConversationFields.source] as String,
        target: json[ConversationFields.target] as String,
        side: json[ConversationFields.side] as int,
        date: json[ConversationFields.date] as String,
        lable: json[ConversationFields.lable] as String,
      );

  Map<String, Object?> toJson() => {
        ConversationFields.id: id,
        ConversationFields.sourceCode: sourceCode,
        ConversationFields.targetCode: targetCode,
        ConversationFields.source: source,
        ConversationFields.target: target,
        ConversationFields.side: side,
        ConversationFields.date: date,
        ConversationFields.lable: lable,
      };
}
