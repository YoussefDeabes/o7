class IpApiDataModel {
  const IpApiDataModel({
    required this.ip,
    required this.version,
    required this.city,
    required this.region,
    required this.regionCode,
    required this.countryCode,
    required this.countryCodeIso3,
    required this.countryName,
    required this.countryCapital,
    required this.countryTld,
    required this.continentCode,
    required this.inEu,
    required this.postal,
    required this.timezone,
    required this.utcOffset,
    required this.countryCallingCode,
    required this.currency,
    required this.currencyName,
    required this.languages,
    required this.asn,
    required this.org,
    required this.hostname,
  });

  final String? ip;
  final String? version;
  final String? city;
  final String? region;
  final String? regionCode;
  final String? countryCode;
  final String? countryCodeIso3;
  final String? countryName;
  final String? countryCapital;
  final String? countryTld;
  final String? continentCode;
  final bool? inEu;
  final String? postal;
  final String? timezone;
  final String? utcOffset;
  final String? countryCallingCode;
  final String? currency;
  final String? currencyName;
  final String? languages;
  final String? asn;
  final String? org;
  final String? hostname;

  factory IpApiDataModel.fromJson(json) => IpApiDataModel(
        ip: json["ip"],
        version: json["version"],
        city: json["city"],
        region: json["region"],
        regionCode: json["region_code"],
        countryCode: json["country_code"],
        countryCodeIso3: json["country_code_iso3"],
        countryName: json["country_name"],
        countryCapital: json["country_capital"],
        countryTld: json["country_tld"],
        continentCode: json["continent_code"],
        inEu: json["in_eu"],
        postal: json["postal"],
        timezone: json["timezone"],
        utcOffset: json["utc_offset"],
        countryCallingCode: json["country_calling_code"],
        currency: json["currency"],
        currencyName: json["currency_name"],
        languages: json["languages"],
        asn: json["asn"],
        org: json["org"],
        hostname: json["hostname"],
      );
}
