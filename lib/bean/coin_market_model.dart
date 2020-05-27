class CoinMarketModel {
  int status;
  int code;
  String message;
  String messageEn;
  Data data;
  String timestamp;

  CoinMarketModel(
      {this.status,
      this.code,
      this.message,
      this.messageEn,
      this.data,
      this.timestamp});

  CoinMarketModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    messageEn = json['message_en'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['message'] = this.message;
    data['message_en'] = this.messageEn;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Data {
  List<SymbolBalance> symbolBalance;
  UsdJpy usdJpy;

  Data({this.symbolBalance, this.usdJpy});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['symbol_balance'] != null) {
      symbolBalance = new List<SymbolBalance>();
      json['symbol_balance'].forEach((v) {
        symbolBalance.add(new SymbolBalance.fromJson(v));
      });
    }
    usdJpy =
        json['usd-jpy'] != null ? new UsdJpy.fromJson(json['usd-jpy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.symbolBalance != null) {
      data['symbol_balance'] =
          this.symbolBalance.map((v) => v.toJson()).toList();
    }
    if (this.usdJpy != null) {
      data['usd-jpy'] = this.usdJpy.toJson();
    }
    return data;
  }
}

class SymbolBalance {
  String priceUsd;
  String changeUsd1h;
  String changUsd24h;
  String symbol;
  String balance;
  String address;
  String priceJpy;

  SymbolBalance(
      {this.priceUsd,
      this.changeUsd1h,
      this.changUsd24h,
      this.symbol,
      this.balance,
      this.address,
      this.priceJpy});

  SymbolBalance.fromJson(Map<String, dynamic> json) {
    priceUsd = json['price_usd'];
    changeUsd1h = json['change_usd_1h'];
    changUsd24h = json['chang_usd_24h'];
    symbol = json['symbol'];
    balance = json['balance'];
    address = json['address'];
    priceJpy = json['price_jpy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price_usd'] = this.priceUsd;
    data['change_usd_1h'] = this.changeUsd1h;
    data['chang_usd_24h'] = this.changUsd24h;
    data['symbol'] = this.symbol;
    data['balance'] = this.balance;
    data['address'] = this.address;
    data['price_jpy'] = this.priceJpy;
    return data;
  }
}

class UsdJpy {
  double usd;
  int jpy;

  UsdJpy({this.usd, this.jpy});

  UsdJpy.fromJson(Map<String, dynamic> json) {
    usd = json['usd'];
    jpy = json['jpy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['usd'] = this.usd;
    data['jpy'] = this.jpy;
    return data;
  }
}