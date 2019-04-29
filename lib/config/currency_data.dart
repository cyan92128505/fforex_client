class CurrencyData {
  static const String SYMBAL = r'__SYMBOL__';
  static const String REGEXSYMBAL = r'\_\_SYMBOL\_\_';
  static const String MONEY = r'__1__';
  static const String REGEXMONEY = r'\_\_1\_\_';

  static const Map<String, Map<String, dynamic>> list = {
    'USD': {
      'nameISO': 'USD',
      'name': 'US Dollar',
      'fractionSize': 2,
      'grapheme': '\$',
      'template': '__SYMBOL____1__',
      'rtl': 'false'
    },
    'TWD': {
      'nameISO': 'TWD',
      'name': 'New Taiwan Dollar',
      'fractionSize': 0,
      'grapheme': 'NT\$',
      'template': '__SYMBOL____1__',
      'rtl': 'false'
    },
    'CNY': {
      'nameISO': 'CNY',
      'name': 'Yuan Renminbi',
      'fractionSize': 2,
      'grapheme': '元',
      'template': '__1__ __SYMBOL__',
      'rtl': 'false'
    },
  };
}
