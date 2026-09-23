import 'package:flutter/foundation.dart';

enum AppLanguage { es, en }

class LocalizationService extends ChangeNotifier {
  static final LocalizationService instance = LocalizationService._internal();
  LocalizationService._internal();

  AppLanguage _currentLanguage = AppLanguage.en;

  AppLanguage get currentLanguage => _currentLanguage;
  bool get isSpanish => _currentLanguage == AppLanguage.es;

  void toggleLanguage() {
    _currentLanguage = _currentLanguage == AppLanguage.es ? AppLanguage.en : AppLanguage.es;
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  // Common UI Translations
  String get appTitle => 'MeowPedia';
  String get appSubtitle => 'Your feline breed directory';
  String get searchHint => 'Search breed by name...';
  String get noResults => 'No cat breeds found.';
  String get offlineBanner => 'Offline mode — showing cached data';
  String get lastUpdated => 'Last updated';
  String get agoMin => '{min} min ago';
  String get justNow => 'just now';
  String get retry => 'Retry';
  String get randomFactTitle => 'Random Fun Fact';
  String get getAnotherFact => 'Get Another Fun Fact';
  String get countryOfOrigin => 'Country of Origin';
  String get origin => 'Origin';
  String get coat => 'Coat';
  String get pattern => 'Pattern';

  // Country Translations
  String translateCountry(String country) {
    if (!isSpanish || country.isEmpty) return country;
    final lower = country.toLowerCase().trim();

    final countryTranslations = <String, String>{
      'ethiopia': 'Etiopía',
      'greece': 'Grecia',
      'united states': 'Estados Unidos',
      'usa': 'EE. UU.',
      'united kingdom': 'Reino Unido',
      'uk': 'Reino Unido',
      'thailand': 'Tailandia',
      'russia': 'Rusia',
      'japan': 'Japón',
      'egypt': 'Egipto',
      'france': 'Francia',
      'turkey': 'Turquía',
      'canada': 'Canadá',
      'china': 'China',
      'iran': 'Irán',
      'burma': 'Birmania (Myanmar)',
      'somalia': 'Somalia',
      'singapore': 'Singapur',
      'australia': 'Australia',
      'isle of man': 'Isla de Man',
      'cyprus': 'Chipre',
    };

    return countryTranslations[lower] ?? country;
  }

  // Dynamic Translations for API Breed Values
  String translateValue(String value) {
    if (!isSpanish || value.isEmpty) return value;

    final lower = value.toLowerCase().trim();

    final translations = <String, String>{
      // Coat
      'short': 'Corto',
      'long': 'Largo',
      'semi-long': 'Semi-largo',
      'short/long': 'Corto / Largo',
      'hairless': 'Sin pelo (Calvo)',
      'all': 'Todos los tipos',

      // Origin
      'natural': 'Natural',
      'natural/standard': 'Natural / Estándar',
      'mutation': 'Mutación genética',
      'crossbreed': 'Cruce / Híbrido',

      // Pattern
      'ticked': 'Jaspeado (Ticked)',
      'bi- or tri-colored': 'Bicolor o Tricolor',
      'all but colorpoint': 'Todos excepto Colorpoint',
      'colorpoint': 'Colorpoint (Puntas coloreadas)',
      'spotted': 'Moteado',
      'striped': 'Rayado',
    };

    return translations[lower] ?? value;
  }

  // Common Cat Facts Spanish Translation Dictionary / Mapper
  String translateFact(String fact) {
    if (!isSpanish || fact.isEmpty) return fact;

    var translated = fact;

    final Map<String, String> phraseReplacements = {
      'Cats sleep': 'Los gatos duermen',
      'of their lives': 'de sus vidas',
      'A group of cats is called a': 'Un grupo de gatos se llama',
      'Cats have': 'Los gatos tienen',
      'whiskers': 'bigotes',
      'Cats can make over': 'Los gatos pueden hacer más de',
      'vocal sounds': 'sonidos vocales',
      'Cats use their tails for': 'Los gatos usan su cola para',
      'balance': 'equilibrio',
      'Cats are': 'Los gatos son',
      'cats': 'gatos',
      'cat': 'gato',
      'hours': 'horas',
      'a day': 'al día',
      'percent': 'por ciento',
      'years': 'años',
    };

    phraseReplacements.forEach((en, es) {
      translated = translated.replaceAll(RegExp('\\b$en\\b', caseSensitive: false), es);
    });

    return translated;
  }
}
