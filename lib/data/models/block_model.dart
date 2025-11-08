class Block {
  String formattedText;
  String freeText;
  String format;

  Block(
      {required this.formattedText,
      required this.freeText,
      required this.format});

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      formattedText: json['formattedText'],
      freeText: json['freeText'],
      format: json['format'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formattedText': formattedText,
      'freeText': freeText,
      'format': format,
    };
  }
}

class BlocksModel {
  List<Block> blocks;
  String idConsultation;

  BlocksModel({
    required this.blocks,
    required this.idConsultation,
  });

  factory BlocksModel.fromJson(
    Map<String, dynamic> json,
    String idConsultation,
  ) {
    var list = json['blocks'] as List;
    List<Block> blockList = list.map((i) => Block.fromJson(i)).toList();
    return BlocksModel(
      blocks: blockList,
      idConsultation: idConsultation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
  }
}
