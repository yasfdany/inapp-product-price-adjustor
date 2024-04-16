import 'dart:convert';
import 'dart:io';

void main() async {
  final countryGdpString = File('gdp.json').readAsStringSync();
  final countryGdp = Map<String, double>.from(jsonDecode(countryGdpString));
  final currentGdp = 'US';
  final priceMap = <String, Map<String, int>>{};

  final pricingData = File('pricing.csv').readAsStringSync();
  final lines = pricingData.split('\n');

  for (String line in lines.sublist(1)) {
    final strings = line.split(',');
    final id = strings[0];
    priceMap[id] = {};

    if (strings.length >= 7) {
      final priceString = strings[6].split(';').sublist(2);
      for (int i = 0; i < priceString.length; i += 2) {
        final country = priceString[i].trim();
        final price = int.parse(priceString[i + 1]);
        priceMap[id]?[country] = price;
      }
    }
  }

  priceMap.removeWhere((key, value) => key.isEmpty);

  final output = {...priceMap};
  for (MapEntry item in output.entries) {
    for (MapEntry country in item.value.entries) {
      final gdp = countryGdp[country.key] ?? 0;
      final gdpComparator = countryGdp[currentGdp] ?? 1;
      final ratio = gdp / gdpComparator;
      int adjustedPrice = ((country.value as int) * ratio).toInt();
      final roundedAdjustedPrice = adjustedPrice ~/ 1000000 * 1000000;
      switch (country.key) {
        case 'ID':
          if (roundedAdjustedPrice < 1000000000) {
            adjustedPrice = adjustedPrice * 10;
          }
          break;
        case 'MM':
          if (roundedAdjustedPrice < 100000000) {
            adjustedPrice = adjustedPrice * 10;
          }
          break;
        case 'TZ':
          if (roundedAdjustedPrice < 130000000) {
            adjustedPrice = adjustedPrice * 10;
          }
          break;
        default:
          if (roundedAdjustedPrice <= 0) {
            adjustedPrice = adjustedPrice * 10;
          }
          break;
      }
      if (country.key != 'JO' && country.key != 'KH') {
        adjustedPrice = adjustedPrice ~/ 1000000 * 1000000;
      } else {
        adjustedPrice = adjustedPrice ~/ 10000 * 100000;
      }
      output[item.key]?[country.key] = adjustedPrice;
    }
  }

  final outputLine = [...lines];
  for (int i = 1; i < outputLine.length; i++) {
    final strings = outputLine[i].split(',');
    final id = strings[0];

    if (strings.length >= 7) {
      final originalPrice = strings[6].split(';').sublist(0, 2).join(';');
      strings[6] = '$originalPrice';
      for (MapEntry country in output[id]!.entries) {
        strings[6] += '; ${country.key}; ${country.value}';
      }
    }

    outputLine[i] = strings.join(',');
  }

  File('output.csv').writeAsStringSync(outputLine.join('\n'));
}
