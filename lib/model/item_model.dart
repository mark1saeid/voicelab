class Item {
  final String key;
  final String name;
  final String voiceUrl;
  final int nShare;
  Item({
    this.key,
    this.name,
    this.voiceUrl,
    this.nShare,
  });

  Item copyWith({
    String key,
    String name,
    String voiceUrl,
    int nShare,
  }) {
    return Item(
      key: key ?? this.key,
      name: name ?? this.name,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      nShare: nShare ?? this.nShare,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key':key,
      'name': name,
      'voiceUrl': voiceUrl,
      'nShare': nShare,
    };
  }

  factory Item.fromMap(dynamic map,String key) {
    return Item(
      key: key,
      name: map['name'] as String,
      voiceUrl: map['voiceUrl'] as String,
      nShare: map['nShare'] as int,
    );
  }
}
