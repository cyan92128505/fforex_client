class CurrencyFormat {
  String nameISO;
  String name;
  int fractionSize;
  String grapheme;
  String template;
  String rtl;

  CurrencyFormat({
    this.nameISO,
    this.name,
    this.fractionSize,
    this.grapheme,
    this.template,
    this.rtl,
  });

  CurrencyFormat.fromJson(Map<String, dynamic> json) {
    nameISO = json['nameISO'];
    name = json['name'];
    fractionSize = json['fractionSize'];
    grapheme = json['grapheme'];
    template = json['template'];
    rtl = json['rtl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nameISO'] = this.nameISO;
    data['name'] = this.name;
    data['fractionSize'] = this.fractionSize;
    data['grapheme'] = this.grapheme;
    data['template'] = this.template;
    data['rtl'] = this.rtl;
    return data;
  }
}
