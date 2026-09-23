import 'package:flutter/foundation.dart';

enum AppLanguage { es, en }

class LocalizationService extends ChangeNotifier {
  static final LocalizationService instance = LocalizationService._internal();
  LocalizationService._internal();

  AppLanguage _currentLanguage = AppLanguage.es;

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
  String get appTitle => isSpanish ? 'MiauPedia' : 'MeowPedia';
  String get appSubtitle => isSpanish ? 'Tu directorio de razas felinas' : 'Your feline breed directory';
  String get searchHint => isSpanish ? 'Buscar raza por nombre...' : 'Search breed by name...';
  String get noResults => isSpanish ? 'No se encontraron razas de gato.' : 'No cat breeds found.';
  String get offlineBanner => isSpanish ? 'Modo sin conexión — mostrando datos guardados' : 'Offline mode — showing cached data';
  String get lastUpdated => isSpanish ? 'Última actualización' : 'Last updated';
  String get agoMin => isSpanish ? 'hace {min} min' : '{min} min ago';
  String get justNow => isSpanish ? 'hace un momento' : 'just now';
  String get retry => isSpanish ? 'Reintentar' : 'Retry';
  String get randomFactTitle => isSpanish ? 'Dato Curioso Aleatorio' : 'Random Fun Fact';
  String get getAnotherFact => isSpanish ? 'Obtener otro Dato Curioso' : 'Get Another Fun Fact';
  String get countryOfOrigin => isSpanish ? 'País de Origen' : 'Country of Origin';
  String get origin => isSpanish ? 'Origen' : 'Origin';
  String get coat => isSpanish ? 'Pelaje (Coat)' : 'Coat';
  String get pattern => isSpanish ? 'Patrón (Pattern)' : 'Pattern';

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

    // Automatic translation mapping for key terms and phrases in cat facts
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
    };

    phraseReplacements.forEach((en, es) {
      translated = translated.replaceAll(en, es);
    });

    return translated;
  }
}
