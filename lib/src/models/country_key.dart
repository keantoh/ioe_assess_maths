import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CountryKey {
  final String countryKeyCode;
  final String translation;

  CountryKey({required this.countryKeyCode, required this.translation});

  static List<CountryKey> getAllCountries(BuildContext context) {
    return [
      CountryKey(
          countryKeyCode: 'AFG',
          translation: AppLocalizations.of(context)!.country_AFG),
      CountryKey(
          countryKeyCode: 'ALB',
          translation: AppLocalizations.of(context)!.country_ALB),
      CountryKey(
          countryKeyCode: 'DZA',
          translation: AppLocalizations.of(context)!.country_DZA),
      CountryKey(
          countryKeyCode: 'ASM',
          translation: AppLocalizations.of(context)!.country_ASM),
      CountryKey(
          countryKeyCode: 'AND',
          translation: AppLocalizations.of(context)!.country_AND),
      CountryKey(
          countryKeyCode: 'AGO',
          translation: AppLocalizations.of(context)!.country_AGO),
      CountryKey(
          countryKeyCode: 'AIA',
          translation: AppLocalizations.of(context)!.country_AIA),
      CountryKey(
          countryKeyCode: 'ATA',
          translation: AppLocalizations.of(context)!.country_ATA),
      CountryKey(
          countryKeyCode: 'ATG',
          translation: AppLocalizations.of(context)!.country_ATG),
      CountryKey(
          countryKeyCode: 'ARG',
          translation: AppLocalizations.of(context)!.country_ARG),
      CountryKey(
          countryKeyCode: 'ARM',
          translation: AppLocalizations.of(context)!.country_ARM),
      CountryKey(
          countryKeyCode: 'ABW',
          translation: AppLocalizations.of(context)!.country_ABW),
      CountryKey(
          countryKeyCode: 'AUS',
          translation: AppLocalizations.of(context)!.country_AUS),
      CountryKey(
          countryKeyCode: 'AUT',
          translation: AppLocalizations.of(context)!.country_AUT),
      CountryKey(
          countryKeyCode: 'AZE',
          translation: AppLocalizations.of(context)!.country_AZE),
      CountryKey(
          countryKeyCode: 'BHS',
          translation: AppLocalizations.of(context)!.country_BHS),
      CountryKey(
          countryKeyCode: 'BHR',
          translation: AppLocalizations.of(context)!.country_BHR),
      CountryKey(
          countryKeyCode: 'BGD',
          translation: AppLocalizations.of(context)!.country_BGD),
      CountryKey(
          countryKeyCode: 'BRB',
          translation: AppLocalizations.of(context)!.country_BRB),
      CountryKey(
          countryKeyCode: 'BLR',
          translation: AppLocalizations.of(context)!.country_BLR),
      CountryKey(
          countryKeyCode: 'BEL',
          translation: AppLocalizations.of(context)!.country_BEL),
      CountryKey(
          countryKeyCode: 'BLZ',
          translation: AppLocalizations.of(context)!.country_BLZ),
      CountryKey(
          countryKeyCode: 'BEN',
          translation: AppLocalizations.of(context)!.country_BEN),
      CountryKey(
          countryKeyCode: 'BMU',
          translation: AppLocalizations.of(context)!.country_BMU),
      CountryKey(
          countryKeyCode: 'BTN',
          translation: AppLocalizations.of(context)!.country_BTN),
      CountryKey(
          countryKeyCode: 'BOL',
          translation: AppLocalizations.of(context)!.country_BOL),
      CountryKey(
          countryKeyCode: 'BIH',
          translation: AppLocalizations.of(context)!.country_BIH),
      CountryKey(
          countryKeyCode: 'BWA',
          translation: AppLocalizations.of(context)!.country_BWA),
      CountryKey(
          countryKeyCode: 'BRA',
          translation: AppLocalizations.of(context)!.country_BRA),
      CountryKey(
          countryKeyCode: 'BRN',
          translation: AppLocalizations.of(context)!.country_BRN),
      CountryKey(
          countryKeyCode: 'BGR',
          translation: AppLocalizations.of(context)!.country_BGR),
      CountryKey(
          countryKeyCode: 'BFA',
          translation: AppLocalizations.of(context)!.country_BFA),
      CountryKey(
          countryKeyCode: 'BDI',
          translation: AppLocalizations.of(context)!.country_BDI),
      CountryKey(
          countryKeyCode: 'CPV',
          translation: AppLocalizations.of(context)!.country_CPV),
      CountryKey(
          countryKeyCode: 'KHM',
          translation: AppLocalizations.of(context)!.country_KHM),
      CountryKey(
          countryKeyCode: 'CMR',
          translation: AppLocalizations.of(context)!.country_CMR),
      CountryKey(
          countryKeyCode: 'CAN',
          translation: AppLocalizations.of(context)!.country_CAN),
      CountryKey(
          countryKeyCode: 'CYM',
          translation: AppLocalizations.of(context)!.country_CYM),
      CountryKey(
          countryKeyCode: 'CAF',
          translation: AppLocalizations.of(context)!.country_CAF),
      CountryKey(
          countryKeyCode: 'TCD',
          translation: AppLocalizations.of(context)!.country_TCD),
      CountryKey(
          countryKeyCode: 'CHL',
          translation: AppLocalizations.of(context)!.country_CHL),
      CountryKey(
          countryKeyCode: 'CHN',
          translation: AppLocalizations.of(context)!.country_CHN),
      CountryKey(
          countryKeyCode: 'COL',
          translation: AppLocalizations.of(context)!.country_COL),
      CountryKey(
          countryKeyCode: 'COM',
          translation: AppLocalizations.of(context)!.country_COM),
      CountryKey(
          countryKeyCode: 'COG',
          translation: AppLocalizations.of(context)!.country_COG),
      CountryKey(
          countryKeyCode: 'COD',
          translation: AppLocalizations.of(context)!.country_COD),
      CountryKey(
          countryKeyCode: 'COK',
          translation: AppLocalizations.of(context)!.country_COK),
      CountryKey(
          countryKeyCode: 'CRI',
          translation: AppLocalizations.of(context)!.country_CRI),
      CountryKey(
          countryKeyCode: 'CIV',
          translation: AppLocalizations.of(context)!.country_CIV),
      CountryKey(
          countryKeyCode: 'HRV',
          translation: AppLocalizations.of(context)!.country_HRV),
      CountryKey(
          countryKeyCode: 'CUB',
          translation: AppLocalizations.of(context)!.country_CUB),
      CountryKey(
          countryKeyCode: 'CYP',
          translation: AppLocalizations.of(context)!.country_CYP),
      CountryKey(
          countryKeyCode: 'CZE',
          translation: AppLocalizations.of(context)!.country_CZE),
      CountryKey(
          countryKeyCode: 'DNK',
          translation: AppLocalizations.of(context)!.country_DNK),
      CountryKey(
          countryKeyCode: 'DJI',
          translation: AppLocalizations.of(context)!.country_DJI),
      CountryKey(
          countryKeyCode: 'DMA',
          translation: AppLocalizations.of(context)!.country_DMA),
      CountryKey(
          countryKeyCode: 'DOM',
          translation: AppLocalizations.of(context)!.country_DOM),
      CountryKey(
          countryKeyCode: 'ECU',
          translation: AppLocalizations.of(context)!.country_ECU),
      CountryKey(
          countryKeyCode: 'EGY',
          translation: AppLocalizations.of(context)!.country_EGY),
      CountryKey(
          countryKeyCode: 'SLV',
          translation: AppLocalizations.of(context)!.country_SLV),
      CountryKey(
          countryKeyCode: 'GNQ',
          translation: AppLocalizations.of(context)!.country_GNQ),
      CountryKey(
          countryKeyCode: 'ERI',
          translation: AppLocalizations.of(context)!.country_ERI),
      CountryKey(
          countryKeyCode: 'EST',
          translation: AppLocalizations.of(context)!.country_EST),
      CountryKey(
          countryKeyCode: 'SWZ',
          translation: AppLocalizations.of(context)!.country_SWZ),
      CountryKey(
          countryKeyCode: 'ETH',
          translation: AppLocalizations.of(context)!.country_ETH),
      CountryKey(
          countryKeyCode: 'FJI',
          translation: AppLocalizations.of(context)!.country_FJI),
      CountryKey(
          countryKeyCode: 'FIN',
          translation: AppLocalizations.of(context)!.country_FIN),
      CountryKey(
          countryKeyCode: 'FRA',
          translation: AppLocalizations.of(context)!.country_FRA),
      CountryKey(
          countryKeyCode: 'GAB',
          translation: AppLocalizations.of(context)!.country_GAB),
      CountryKey(
          countryKeyCode: 'GMB',
          translation: AppLocalizations.of(context)!.country_GMB),
      CountryKey(
          countryKeyCode: 'GEO',
          translation: AppLocalizations.of(context)!.country_GEO),
      CountryKey(
          countryKeyCode: 'DEU',
          translation: AppLocalizations.of(context)!.country_DEU),
      CountryKey(
          countryKeyCode: 'GHA',
          translation: AppLocalizations.of(context)!.country_GHA),
      CountryKey(
          countryKeyCode: 'GRC',
          translation: AppLocalizations.of(context)!.country_GRC),
      CountryKey(
          countryKeyCode: 'GRD',
          translation: AppLocalizations.of(context)!.country_GRD),
      CountryKey(
          countryKeyCode: 'GTM',
          translation: AppLocalizations.of(context)!.country_GTM),
      CountryKey(
          countryKeyCode: 'GIN',
          translation: AppLocalizations.of(context)!.country_GIN),
      CountryKey(
          countryKeyCode: 'GNB',
          translation: AppLocalizations.of(context)!.country_GNB),
      CountryKey(
          countryKeyCode: 'GUY',
          translation: AppLocalizations.of(context)!.country_GUY),
      CountryKey(
          countryKeyCode: 'HTI',
          translation: AppLocalizations.of(context)!.country_HTI),
      CountryKey(
          countryKeyCode: 'HND',
          translation: AppLocalizations.of(context)!.country_HND),
      CountryKey(
          countryKeyCode: 'HUN',
          translation: AppLocalizations.of(context)!.country_HUN),
      CountryKey(
          countryKeyCode: 'ISL',
          translation: AppLocalizations.of(context)!.country_ISL),
      CountryKey(
          countryKeyCode: 'IND',
          translation: AppLocalizations.of(context)!.country_IND),
      CountryKey(
          countryKeyCode: 'IDN',
          translation: AppLocalizations.of(context)!.country_IDN),
      CountryKey(
          countryKeyCode: 'IRN',
          translation: AppLocalizations.of(context)!.country_IRN),
      CountryKey(
          countryKeyCode: 'IRQ',
          translation: AppLocalizations.of(context)!.country_IRQ),
      CountryKey(
          countryKeyCode: 'IRL',
          translation: AppLocalizations.of(context)!.country_IRL),
      CountryKey(
          countryKeyCode: 'ISR',
          translation: AppLocalizations.of(context)!.country_ISR),
      CountryKey(
          countryKeyCode: 'ITA',
          translation: AppLocalizations.of(context)!.country_ITA),
      CountryKey(
          countryKeyCode: 'JAM',
          translation: AppLocalizations.of(context)!.country_JAM),
      CountryKey(
          countryKeyCode: 'JPN',
          translation: AppLocalizations.of(context)!.country_JPN),
      CountryKey(
          countryKeyCode: 'JOR',
          translation: AppLocalizations.of(context)!.country_JOR),
      CountryKey(
          countryKeyCode: 'KAZ',
          translation: AppLocalizations.of(context)!.country_KAZ),
      CountryKey(
          countryKeyCode: 'KEN',
          translation: AppLocalizations.of(context)!.country_KEN),
      CountryKey(
          countryKeyCode: 'KIR',
          translation: AppLocalizations.of(context)!.country_KIR),
      CountryKey(
          countryKeyCode: 'PRK',
          translation: AppLocalizations.of(context)!.country_PRK),
      CountryKey(
          countryKeyCode: 'KOR',
          translation: AppLocalizations.of(context)!.country_KOR),
      CountryKey(
          countryKeyCode: 'KWT',
          translation: AppLocalizations.of(context)!.country_KWT),
      CountryKey(
          countryKeyCode: 'KGZ',
          translation: AppLocalizations.of(context)!.country_KGZ),
      CountryKey(
          countryKeyCode: 'LAO',
          translation: AppLocalizations.of(context)!.country_LAO),
      CountryKey(
          countryKeyCode: 'LVA',
          translation: AppLocalizations.of(context)!.country_LVA),
      CountryKey(
          countryKeyCode: 'LBN',
          translation: AppLocalizations.of(context)!.country_LBN),
      CountryKey(
          countryKeyCode: 'LSO',
          translation: AppLocalizations.of(context)!.country_LSO),
      CountryKey(
          countryKeyCode: 'LBR',
          translation: AppLocalizations.of(context)!.country_LBR),
      CountryKey(
          countryKeyCode: 'LBY',
          translation: AppLocalizations.of(context)!.country_LBY),
      CountryKey(
          countryKeyCode: 'LIE',
          translation: AppLocalizations.of(context)!.country_LIE),
      CountryKey(
          countryKeyCode: 'LTU',
          translation: AppLocalizations.of(context)!.country_LTU),
      CountryKey(
          countryKeyCode: 'LUX',
          translation: AppLocalizations.of(context)!.country_LUX),
      CountryKey(
          countryKeyCode: 'MDG',
          translation: AppLocalizations.of(context)!.country_MDG),
      CountryKey(
          countryKeyCode: 'MWI',
          translation: AppLocalizations.of(context)!.country_MWI),
      CountryKey(
          countryKeyCode: 'MYS',
          translation: AppLocalizations.of(context)!.country_MYS),
      CountryKey(
          countryKeyCode: 'MDV',
          translation: AppLocalizations.of(context)!.country_MDV),
      CountryKey(
          countryKeyCode: 'MLI',
          translation: AppLocalizations.of(context)!.country_MLI),
      CountryKey(
          countryKeyCode: 'MLT',
          translation: AppLocalizations.of(context)!.country_MLT),
      CountryKey(
          countryKeyCode: 'MHL',
          translation: AppLocalizations.of(context)!.country_MHL),
      CountryKey(
          countryKeyCode: 'MRT',
          translation: AppLocalizations.of(context)!.country_MRT),
      CountryKey(
          countryKeyCode: 'MUS',
          translation: AppLocalizations.of(context)!.country_MUS),
      CountryKey(
          countryKeyCode: 'MEX',
          translation: AppLocalizations.of(context)!.country_MEX),
      CountryKey(
          countryKeyCode: 'FSM',
          translation: AppLocalizations.of(context)!.country_FSM),
      CountryKey(
          countryKeyCode: 'MDA',
          translation: AppLocalizations.of(context)!.country_MDA),
      CountryKey(
          countryKeyCode: 'MCO',
          translation: AppLocalizations.of(context)!.country_MCO),
      CountryKey(
          countryKeyCode: 'MNG',
          translation: AppLocalizations.of(context)!.country_MNG),
      CountryKey(
          countryKeyCode: 'MNE',
          translation: AppLocalizations.of(context)!.country_MNE),
      CountryKey(
          countryKeyCode: 'MAR',
          translation: AppLocalizations.of(context)!.country_MAR),
      CountryKey(
          countryKeyCode: 'MOZ',
          translation: AppLocalizations.of(context)!.country_MOZ),
      CountryKey(
          countryKeyCode: 'MMR',
          translation: AppLocalizations.of(context)!.country_MMR),
      CountryKey(
          countryKeyCode: 'NAM',
          translation: AppLocalizations.of(context)!.country_NAM),
      CountryKey(
          countryKeyCode: 'NRU',
          translation: AppLocalizations.of(context)!.country_NRU),
      CountryKey(
          countryKeyCode: 'NPL',
          translation: AppLocalizations.of(context)!.country_NPL),
      CountryKey(
          countryKeyCode: 'NLD',
          translation: AppLocalizations.of(context)!.country_NLD),
      CountryKey(
          countryKeyCode: 'NZL',
          translation: AppLocalizations.of(context)!.country_NZL),
      CountryKey(
          countryKeyCode: 'NIC',
          translation: AppLocalizations.of(context)!.country_NIC),
      CountryKey(
          countryKeyCode: 'NER',
          translation: AppLocalizations.of(context)!.country_NER),
      CountryKey(
          countryKeyCode: 'NGA',
          translation: AppLocalizations.of(context)!.country_NGA),
      CountryKey(
          countryKeyCode: 'NOR',
          translation: AppLocalizations.of(context)!.country_NOR),
      CountryKey(
          countryKeyCode: 'OMN',
          translation: AppLocalizations.of(context)!.country_OMN),
      CountryKey(
          countryKeyCode: 'PAK',
          translation: AppLocalizations.of(context)!.country_PAK),
      CountryKey(
          countryKeyCode: 'PLW',
          translation: AppLocalizations.of(context)!.country_PLW),
      CountryKey(
          countryKeyCode: 'PAN',
          translation: AppLocalizations.of(context)!.country_PAN),
      CountryKey(
          countryKeyCode: 'PNG',
          translation: AppLocalizations.of(context)!.country_PNG),
      CountryKey(
          countryKeyCode: 'PRY',
          translation: AppLocalizations.of(context)!.country_PRY),
      CountryKey(
          countryKeyCode: 'PER',
          translation: AppLocalizations.of(context)!.country_PER),
      CountryKey(
          countryKeyCode: 'PHL',
          translation: AppLocalizations.of(context)!.country_PHL),
      CountryKey(
          countryKeyCode: 'POL',
          translation: AppLocalizations.of(context)!.country_POL),
      CountryKey(
          countryKeyCode: 'PRT',
          translation: AppLocalizations.of(context)!.country_PRT),
      CountryKey(
          countryKeyCode: 'QAT',
          translation: AppLocalizations.of(context)!.country_QAT),
      CountryKey(
          countryKeyCode: 'ROU',
          translation: AppLocalizations.of(context)!.country_ROU),
      CountryKey(
          countryKeyCode: 'RUS',
          translation: AppLocalizations.of(context)!.country_RUS),
      CountryKey(
          countryKeyCode: 'RWA',
          translation: AppLocalizations.of(context)!.country_RWA),
      CountryKey(
          countryKeyCode: 'KNA',
          translation: AppLocalizations.of(context)!.country_KNA),
      CountryKey(
          countryKeyCode: 'LCA',
          translation: AppLocalizations.of(context)!.country_LCA),
      CountryKey(
          countryKeyCode: 'VCT',
          translation: AppLocalizations.of(context)!.country_VCT),
      CountryKey(
          countryKeyCode: 'WSM',
          translation: AppLocalizations.of(context)!.country_WSM),
      CountryKey(
          countryKeyCode: 'SMR',
          translation: AppLocalizations.of(context)!.country_SMR),
      CountryKey(
          countryKeyCode: 'STP',
          translation: AppLocalizations.of(context)!.country_STP),
      CountryKey(
          countryKeyCode: 'SAU',
          translation: AppLocalizations.of(context)!.country_SAU),
      CountryKey(
          countryKeyCode: 'SEN',
          translation: AppLocalizations.of(context)!.country_SEN),
      CountryKey(
          countryKeyCode: 'SRB',
          translation: AppLocalizations.of(context)!.country_SRB),
      CountryKey(
          countryKeyCode: 'SYC',
          translation: AppLocalizations.of(context)!.country_SYC),
      CountryKey(
          countryKeyCode: 'SLE',
          translation: AppLocalizations.of(context)!.country_SLE),
      CountryKey(
          countryKeyCode: 'SGP',
          translation: AppLocalizations.of(context)!.country_SGP),
      CountryKey(
          countryKeyCode: 'SVK',
          translation: AppLocalizations.of(context)!.country_SVK),
      CountryKey(
          countryKeyCode: 'SVN',
          translation: AppLocalizations.of(context)!.country_SVN),
      CountryKey(
          countryKeyCode: 'SLB',
          translation: AppLocalizations.of(context)!.country_SLB),
      CountryKey(
          countryKeyCode: 'SOM',
          translation: AppLocalizations.of(context)!.country_SOM),
      CountryKey(
          countryKeyCode: 'ZAF',
          translation: AppLocalizations.of(context)!.country_ZAF),
      CountryKey(
          countryKeyCode: 'SSD',
          translation: AppLocalizations.of(context)!.country_SSD),
      CountryKey(
          countryKeyCode: 'ESP',
          translation: AppLocalizations.of(context)!.country_ESP),
      CountryKey(
          countryKeyCode: 'LKA',
          translation: AppLocalizations.of(context)!.country_LKA),
      CountryKey(
          countryKeyCode: 'SDN',
          translation: AppLocalizations.of(context)!.country_SDN),
      CountryKey(
          countryKeyCode: 'SUR',
          translation: AppLocalizations.of(context)!.country_SUR),
      CountryKey(
          countryKeyCode: 'SWE',
          translation: AppLocalizations.of(context)!.country_SWE),
      CountryKey(
          countryKeyCode: 'CHE',
          translation: AppLocalizations.of(context)!.country_CHE),
      CountryKey(
          countryKeyCode: 'SYR',
          translation: AppLocalizations.of(context)!.country_SYR),
      CountryKey(
          countryKeyCode: 'TWN',
          translation: AppLocalizations.of(context)!.country_TWN),
      CountryKey(
          countryKeyCode: 'TJK',
          translation: AppLocalizations.of(context)!.country_TJK),
      CountryKey(
          countryKeyCode: 'TZA',
          translation: AppLocalizations.of(context)!.country_TZA),
      CountryKey(
          countryKeyCode: 'THA',
          translation: AppLocalizations.of(context)!.country_THA),
      CountryKey(
          countryKeyCode: 'TLS',
          translation: AppLocalizations.of(context)!.country_TLS),
      CountryKey(
          countryKeyCode: 'TGO',
          translation: AppLocalizations.of(context)!.country_TGO),
      CountryKey(
          countryKeyCode: 'TON',
          translation: AppLocalizations.of(context)!.country_TON),
      CountryKey(
          countryKeyCode: 'TTO',
          translation: AppLocalizations.of(context)!.country_TTO),
      CountryKey(
          countryKeyCode: 'TUN',
          translation: AppLocalizations.of(context)!.country_TUN),
      CountryKey(
          countryKeyCode: 'TUR',
          translation: AppLocalizations.of(context)!.country_TUR),
      CountryKey(
          countryKeyCode: 'TKM',
          translation: AppLocalizations.of(context)!.country_TKM),
      CountryKey(
          countryKeyCode: 'TUV',
          translation: AppLocalizations.of(context)!.country_TUV),
      CountryKey(
          countryKeyCode: 'UGA',
          translation: AppLocalizations.of(context)!.country_UGA),
      CountryKey(
          countryKeyCode: 'UKR',
          translation: AppLocalizations.of(context)!.country_UKR),
      CountryKey(
          countryKeyCode: 'ARE',
          translation: AppLocalizations.of(context)!.country_ARE),
      CountryKey(
          countryKeyCode: 'GBR',
          translation: AppLocalizations.of(context)!.country_GBR),
      CountryKey(
          countryKeyCode: 'USA',
          translation: AppLocalizations.of(context)!.country_USA),
      CountryKey(
          countryKeyCode: 'URY',
          translation: AppLocalizations.of(context)!.country_URY),
      CountryKey(
          countryKeyCode: 'UZB',
          translation: AppLocalizations.of(context)!.country_UZB),
      CountryKey(
          countryKeyCode: 'VUT',
          translation: AppLocalizations.of(context)!.country_VUT),
      CountryKey(
          countryKeyCode: 'VEN',
          translation: AppLocalizations.of(context)!.country_VEN),
      CountryKey(
          countryKeyCode: 'VNM',
          translation: AppLocalizations.of(context)!.country_VNM),
      CountryKey(
          countryKeyCode: 'YEM',
          translation: AppLocalizations.of(context)!.country_YEM),
      CountryKey(
          countryKeyCode: 'ZMB',
          translation: AppLocalizations.of(context)!.country_ZMB),
      CountryKey(
          countryKeyCode: 'ZWE',
          translation: AppLocalizations.of(context)!.country_ZWE),
    ];
  }
}
