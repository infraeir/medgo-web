class InfoPainel {
  String? title;
  String? associatedBackendAttribute;
  List<InfoPainelBlock>? blocks;
  List<String>? references;
  bool? isMinimized;

  InfoPainel({
    this.title,
    this.associatedBackendAttribute,
    this.blocks,
    this.references,
    this.isMinimized,
  });

  InfoPainel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    associatedBackendAttribute = json['associatedBackendAttribute'];
    blocks = json['blocks'] != null
        ? List<InfoPainelBlock>.from(
            json['blocks'].map((v) => InfoPainelBlock.fromJson(v)))
        : null;
    references = json['references'] != null
        ? List<String>.from(json['references'])
        : [];
    isMinimized = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['associatedBackendAttribute'] = associatedBackendAttribute;
    if (blocks != null) {
      data['blocks'] = blocks!.map((v) => v.toJson()).toList();
    }
    if (references != null) {
      data['references'] = references;
    }
    data['isMinimized'] = isMinimized;
    return data;
  }
}

class InfoPainelBlock {
  String? title;
  String? content;

  InfoPainelBlock({this.title, this.content});

  InfoPainelBlock.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}