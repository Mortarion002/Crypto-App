class SupportedCoins {
  static const List<String> defaultMarketSymbols = [
    'BTCUSDT',
    'ETHUSDT',
    'SOLUSDT',
    'BNBUSDT',
    'ADAUSDT',
    'XRPUSDT',
  ];

  static String getCoinName(String symbol) {
    switch (symbol) {
      case 'BTCUSDT': return 'Bitcoin';
      case 'ETHUSDT': return 'Ethereum';
      case 'SOLUSDT': return 'Solana';
      case 'BNBUSDT': return 'BNB';
      case 'ADAUSDT': return 'Cardano';
      case 'XRPUSDT': return 'XRP';
      default: return symbol.replaceAll('USDT', '');
    }
  }
}
