import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:totranslate/model/language_model.dart';

class GetLanguages {
  static const List<LanguageModel> langList = [
    LanguageModel(
        langName: 'Afrikaans', langCode: 'af', localName: 'Afrikaans'),
    LanguageModel(langName: 'Arabic', langCode: 'ar', localName: 'عربي'),
    LanguageModel(
        langName: 'Belarusian', langCode: 'be', localName: 'беларускі'),
    LanguageModel(
        langName: 'Bulgarian', langCode: 'bg', localName: 'български'),
    LanguageModel(langName: 'Bengali', langCode: 'bn', localName: 'বাংলা'),
    LanguageModel(langName: 'Catalan', langCode: 'ca', localName: 'català'),
    LanguageModel(langName: 'Czech', langCode: 'cz', localName: 'čeština'),
    LanguageModel(langName: 'Welsh', langCode: 'cy', localName: 'Cymraeg'),
    LanguageModel(langName: 'Danish', langCode: 'da', localName: 'dansk'),
    LanguageModel(langName: 'German', langCode: 'de', localName: 'Deutsch'),
    LanguageModel(langName: 'Greek', langCode: 'el', localName: 'Ελληνικά'),
    LanguageModel(langName: 'English', langCode: 'en', localName: 'English'),
    LanguageModel(
        langName: 'Esperanto', langCode: 'eo', localName: 'Esperanto'),
    LanguageModel(langName: 'Spanish', langCode: 'es', localName: 'Español'),
    LanguageModel(
        langName: 'Estonian', langCode: 'et', localName: 'eesti keel'),
    LanguageModel(langName: 'Persian', langCode: 'fa', localName: 'فارسی'),
    LanguageModel(
        langName: 'Finnish', langCode: 'fi', localName: 'Suomalainen'),
    LanguageModel(
        langName: 'French', langCode: 'fr', localName: 'Ranskan kieli'),
    LanguageModel(langName: 'Irish', langCode: 'ga', localName: 'Gaeilge'),
    LanguageModel(langName: 'Galician', langCode: 'gl', localName: 'galego'),
    LanguageModel(langName: 'Gujarati', langCode: 'gu', localName: 'ગુજરાતી'),
    LanguageModel(langName: 'Hebrew', langCode: 'he', localName: 'ગעִברִית'),
    LanguageModel(langName: 'Hindi', langCode: 'hi', localName: 'हिन्दी'),
    LanguageModel(langName: 'Croatian', langCode: 'hr', localName: 'Hrvatski'),
    LanguageModel(langName: 'Haitian', langCode: 'ht', localName: 'ayisyen'),
    LanguageModel(langName: 'Hungarian', langCode: 'hu', localName: 'Magyar'),
    LanguageModel(
        langName: 'Indonesian', langCode: 'id', localName: 'bahasa Indonesia'),
    LanguageModel(
        langName: 'Icelandic', langCode: 'is', localName: 'íslenskur'),
    LanguageModel(langName: 'Italian', langCode: 'it', localName: 'Italiano'),
    LanguageModel(langName: 'Japanese', langCode: 'ja', localName: '日本'),
    LanguageModel(langName: 'Georgian', langCode: 'ka', localName: 'ქართული'),
    LanguageModel(langName: 'Kannada', langCode: 'kn', localName: 'ಕನ್ನಡ'),
    LanguageModel(langName: 'Korean', langCode: 'ko', localName: '한국인'),
    LanguageModel(
        langName: 'Lithuanian', langCode: 'lt', localName: 'lietuvių'),
    LanguageModel(langName: 'Latvian', langCode: 'lv', localName: 'latviski'),
    LanguageModel(
        langName: 'Macedonian', langCode: 'mk', localName: 'македонски'),
    LanguageModel(langName: 'Marathi', langCode: 'mr', localName: 'मराठी'),
    LanguageModel(langName: 'Malay', langCode: 'ms', localName: 'Melayu'),
    LanguageModel(langName: 'Maltese', langCode: 'mt', localName: 'Malti'),
    LanguageModel(langName: 'Dutch', langCode: 'nl', localName: 'Nederlands'),
    LanguageModel(langName: 'Norwegian', langCode: 'no', localName: 'norsk'),
    LanguageModel(langName: 'Polish', langCode: 'pl', localName: 'Polski'),
    LanguageModel(
        langName: 'Portuguese', langCode: 'pt', localName: 'Português'),
    LanguageModel(langName: 'Romanian', langCode: 'ro', localName: 'Română'),
    LanguageModel(langName: 'Russian', langCode: 'ru', localName: 'Русский'),
    LanguageModel(langName: 'Slovak', langCode: 'sk', localName: 'slovenský'),
    LanguageModel(
        langName: 'Slovenian', langCode: 'sl', localName: 'Slovenščina'),
    LanguageModel(langName: 'Albanian', langCode: 'sq', localName: 'shqiptare'),
    LanguageModel(langName: 'Swedish', langCode: 'sv', localName: 'svenska'),
    LanguageModel(langName: 'Swahili', langCode: 'sw', localName: 'Kiswidi'),
    LanguageModel(langName: 'Tamil', langCode: 'ta', localName: 'தமிழ்'),
    LanguageModel(langName: 'Telugu', langCode: 'te', localName: 'తమిళం'),
    LanguageModel(langName: 'Thai', langCode: 'th', localName: 'ภาษาทมิฬ'),
    LanguageModel(langName: 'Tagalog', langCode: 'tl', localName: 'Tagalog'),
    LanguageModel(langName: 'Turkish', langCode: 'tr', localName: 'Türk'),
    LanguageModel(
        langName: 'Ukrainian', langCode: 'uk', localName: 'українська'),
    LanguageModel(langName: 'Urdu', langCode: 'ur', localName: 'اردو'),
    LanguageModel(
        langName: 'Vietnamese', langCode: 'vi', localName: 'Tiếng Việt'),
    LanguageModel(langName: 'Chinese', langCode: 'zh', localName: '中国人'),
  ];

  static TranslateLanguage getLang(String name) {
    var lang = TranslateLanguage.english;
    switch (name) {
      case 'Afrikaans':
        lang = TranslateLanguage.afrikaans;
        break;
      case 'Arabic':
        lang = TranslateLanguage.arabic;
        break;
      case 'Belarusian':
        lang = TranslateLanguage.belarusian;
        break;
      case 'Bulgarian':
        lang = TranslateLanguage.bulgarian;
        break;
      case 'Bengali':
        lang = TranslateLanguage.bengali;
        break;
      case 'Catalan':
        lang = TranslateLanguage.catalan;
        break;
      case 'Czech':
        lang = TranslateLanguage.czech;
        break;
      case 'Welsh':
        lang = TranslateLanguage.welsh;
        break;
      case 'Danish':
        lang = TranslateLanguage.danish;
        break;
      case 'German':
        lang = TranslateLanguage.german;
        break;
      case 'Greek':
        lang = TranslateLanguage.greek;
        break;
      case 'English':
        lang = TranslateLanguage.english;
        break;
      case 'Esperanto':
        lang = TranslateLanguage.esperanto;
        break;
      case 'Spanish':
        lang = TranslateLanguage.spanish;
        break;
      case 'Estonian':
        lang = TranslateLanguage.estonian;
        break;
      case 'Persian':
        lang = TranslateLanguage.persian;
        break;
      case 'Finnish':
        lang = TranslateLanguage.finnish;
        break;
      case 'French':
        lang = TranslateLanguage.french;
        break;
      case 'Irish':
        lang = TranslateLanguage.irish;
        break;
      case 'Galician':
        lang = TranslateLanguage.galician;
        break;
      case 'Gujarati':
        lang = TranslateLanguage.gujarati;
        break;
      case 'Hebrew':
        lang = TranslateLanguage.hebrew;
        break;
      case 'Hindi':
        lang = TranslateLanguage.hindi;
        break;
      case 'Croatian':
        lang = TranslateLanguage.croatian;
        break;
      case 'Haitian':
        lang = TranslateLanguage.haitian;
        break;
      case 'Hungarian':
        lang = TranslateLanguage.hungarian;
        break;
      case 'Indonesian':
        lang = TranslateLanguage.indonesian;
        break;
      case 'Icelandic':
        lang = TranslateLanguage.icelandic;
        break;
      case 'Italian':
        lang = TranslateLanguage.italian;
        break;
      case 'Japanese':
        lang = TranslateLanguage.japanese;
        break;
      case 'Georgian':
        lang = TranslateLanguage.georgian;
        break;
      case 'Kannada':
        lang = TranslateLanguage.kannada;
        break;
      case 'Korean':
        lang = TranslateLanguage.korean;
        break;
      case 'Lithuanian':
        lang = TranslateLanguage.lithuanian;
        break;
      case 'Latvian':
        lang = TranslateLanguage.latvian;
        break;
      case 'Macedonian':
        lang = TranslateLanguage.macedonian;
        break;
      case 'Marathi':
        lang = TranslateLanguage.marathi;
        break;
      case 'Malay':
        lang = TranslateLanguage.malay;
        break;
      case 'Maltese':
        lang = TranslateLanguage.maltese;
        break;
      case 'Dutch':
        lang = TranslateLanguage.dutch;
        break;
      case 'Norwegian':
        lang = TranslateLanguage.norwegian;
        break;
      case 'Polish':
        lang = TranslateLanguage.polish;
        break;
      case 'Portuguese':
        lang = TranslateLanguage.portuguese;
        break;
      case 'Romanian':
        lang = TranslateLanguage.romanian;
        break;
      case 'Russian':
        lang = TranslateLanguage.russian;
        break;
      case 'Slovak':
        lang = TranslateLanguage.slovak;
        break;
      case 'Slovenian':
        lang = TranslateLanguage.slovenian;
        break;
      case 'Albanian':
        lang = TranslateLanguage.albanian;
        break;
      case 'Swedish':
        lang = TranslateLanguage.swedish;
        break;
      case 'Swahili':
        lang = TranslateLanguage.swahili;
        break;
      case 'Tamil':
        lang = TranslateLanguage.tamil;
        break;
      case 'Telugu':
        lang = TranslateLanguage.telugu;
        break;
      case 'Thai':
        lang = TranslateLanguage.thai;
        break;
      case 'Tagalog':
        lang = TranslateLanguage.tagalog;
        break;
      case 'Turkish':
        lang = TranslateLanguage.turkish;
        break;
      case 'Ukrainian':
        lang = TranslateLanguage.ukrainian;
        break;
      case 'Urdu':
        lang = TranslateLanguage.urdu;
        break;
      case 'Vietnamese':
        lang = TranslateLanguage.vietnamese;
        break;
      case 'Chinese':
        lang = TranslateLanguage.chinese;
        break;
    }
    return lang;
  }
}
