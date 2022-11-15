class ItemModel {
  String? itemCode;
  String? itemDesc;
  String? engDesc;
  dynamic avgWt;
  String? shortCode;
  dynamic? limminRat;
  dynamic? limmaxRat;
  dynamic? limmaxWt;
  String? loosSale;
  String? dhadaent;
  dynamic? limminWt;
  String? gstCode;
  String? frOn;
  String? ukatayn;
  String? isdeleted;
  dynamic? addratper;
  String? itemColor;

  ItemModel(
      {this.itemCode,
        this.itemDesc,
        this.engDesc,
        this.avgWt,
        this.shortCode,
        this.limminRat,
        this.limmaxRat,
        this.limmaxWt,
        this.loosSale,
        this.dhadaent,
        this.limminWt,
        this.gstCode,
        this.frOn,
        this.ukatayn,
        this.isdeleted,
        this.addratper,
        this.itemColor});

  ItemModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    itemDesc = json['item_desc'];
    engDesc = json['eng_desc'];
    avgWt = json['avg_wt'];
    shortCode = json['short_code'];
    limminRat = json['limmin_rat'];
    limmaxRat = json['limmax_rat'];
    limmaxWt = json['limmax_wt'];
    loosSale = json['loos_sale'];
    dhadaent = json['dhadaent'];
    limminWt = json['limmin_wt'];
    gstCode = json['gst_code'];
    frOn = json['fr_on'];
    ukatayn = json['ukatayn'];
    isdeleted = json['isdeleted'];
    addratper = json['addratper'];
    itemColor = json['item_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['item_code'] = this.itemCode;
    data['item_desc'] = this.itemDesc;
    data['eng_desc'] = this.engDesc;
    data['avg_wt'] = this.avgWt;
    data['short_code'] = this.shortCode;
    data['limmin_rat'] = this.limminRat;
    data['limmax_rat'] = this.limmaxRat;
    data['limmax_wt'] = this.limmaxWt;
    data['loos_sale'] = this.loosSale;
    data['dhadaent'] = this.dhadaent;
    data['limmin_wt'] = this.limminWt;
    data['gst_code'] = this.gstCode;
    data['fr_on'] = this.frOn;
    data['ukatayn'] = this.ukatayn;
    data['isdeleted'] = this.isdeleted;
    data['addratper'] = this.addratper;
    data['item_color'] = this.itemColor;
    return data;
  }
}