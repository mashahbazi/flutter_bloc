class BreweryModel {
  final int id;
  final String? name;
  final String? breweryType;
  final String? street;
  final String? address_2;
  final String? address_3;
  final String? city;
  final String? state;
  final String? countyProvince;
  final String? postalCode;
  final String? country;
  final String? longitude;
  final String? latitude;
  final String? phone;
  final String? websiteUrl;
  final String? updatedAt;
  final String? createdAt;

  BreweryModel()
      : id = -1,
        name = null,
        breweryType = null,
        street = null,
        address_2 = null,
        address_3 = null,
        city = null,
        state = null,
        countyProvince = null,
        postalCode = null,
        country = null,
        longitude = null,
        latitude = null,
        phone = null,
        websiteUrl = null,
        updatedAt = null,
        createdAt = null;

  BreweryModel.fromJson(Map<String, dynamic> _json)
      : id = _json["id"],
        name = _json["name"],
        breweryType = _json["brewery_type"],
        street = _json["street"],
        address_2 = _json["address_2"],
        address_3 = _json["address_3"],
        city = _json["city"],
        state = _json["state"],
        countyProvince = _json["county_province"],
        postalCode = _json["postal_code"],
        country = _json["country"],
        longitude = _json["longitude"],
        latitude = _json["latitude"],
        phone = _json["phone"],
        websiteUrl = _json["website_url"],
        updatedAt = _json["updated_at"],
        createdAt = _json["created_at"];
}
