﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует строковое представление телефона.
//
// Параметры:
//    КодСтраны     - Строка - код страны.
//    КодГорода     - Строка - код города.
//    НомерТелефона - Строка - номер телефона.
//    Добавочный    - Строка - добавочный номер.
//    Комментарий   - Строка - комментарий.
//
// Возвращаемое значение:
//   - Строка - представление телефона.
//
Функция СформироватьПредставлениеТелефона(КодСтраны, КодГорода, НомерТелефона, Добавочный, Комментарий) Экспорт
	
	Представление = СокрЛП(КодСтраны);
	Если Не ПустаяСтрока(Представление) И Не СтрНачинаетсяС(Представление, "+") Тогда
		Представление = "+" + Представление;
	КонецЕсли;
	
	Если Не ПустаяСтрока(КодГорода) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", " ") + "(" + СокрЛП(КодГорода) + ")";
	КонецЕсли;
	
	Если Не ПустаяСтрока(НомерТелефона) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", " ") + СокрЛП(НомерТелефона);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Добавочный) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", ", ") + "доб. " + СокрЛП(Добавочный);
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Комментарий) Тогда
		Представление = Представление + ?(ПустаяСтрока(Представление), "", ", ") + СокрЛП(Комментарий);
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

// Возвращает признак того, является ли строка данных контактной информации XML данными.
//
// Параметры:
//     Текст - Строка - проверяемая строка.
//
// Возвращаемое значение:
//     Булево - результат проверки.
//
Функция ЭтоКонтактнаяИнформацияВXML(Знач Текст) Экспорт
	
	Возврат ТипЗнч(Текст) = Тип("Строка") И СтрНачинаетсяС(СокрЛ(Текст), "<");
	
КонецФункции

// Возвращает признак того, является ли строка данных контактной информации JSON данными.
//
// Параметры:
//     Текст - Строка - проверяемая строка.
//
// Возвращаемое значение:
//     Булево - результат проверки.
//
Функция ЭтоКонтактнаяИнформацияВJSON(Знач Текст) Экспорт
	
	Возврат ТипЗнч(Текст) = Тип("Строка") И СтрНачинаетсяС(СокрЛ(Текст), "{");
	
КонецФункции

// Текст, который выводится в поле контактной информации, когда контактная информация не заполнена и отображается в виде
// гиперссылки.
// 
// Возвращаемое значение:
//  Строка - текст, который выводится в поле с контактной информацией.
//
Функция ТекстПустогоАдресаВВидеГиперссылки() Экспорт
	Возврат НСтр("ru = 'Заполнить'");
КонецФункции

// Определяет, введена ли информация в поле контактной информации, для случаев когда она отображается в виде гиперссылки.
//
// Параметры:
//  Значение - Строка - значение контактной информации.
// 
// Возвращаемое значение:
//  Булево  - если Истина, то поле контактной информации было заполнено.
//
Функция КонтактнаяИнформацияЗаполнена(Значение) Экспорт
	Возврат СокрЛП(Значение) <> ТекстПустогоАдресаВВидеГиперссылки();
КонецФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации
// Формирует представление с указанным видом для формы ввода адреса.
//
// Параметры:
//    СтруктураАдреса  - Структура - адрес в виде структуры.
//                                   Описание структуры см. в функции РаботаСАдресами.СведенияОбАдресе.
//                                   Описание предыдущей версии структуры см. в функции РаботаСАдресами.ПредыдущаяСтруктураКонтактнойИнформацииXML.
//    Представление    - Строка    - представление адреса.
//    НаименованиеВида - Строка    - наименование вида.
//
// Возвращаемое значение:
//    Строка - представление адреса с видом.
//
Функция СформироватьПредставлениеАдреса(СтруктураАдреса, Представление, НаименованиеВида = Неопределено) Экспорт
	
	Представление = "";
	
	Если ТипЗнч(СтруктураАдреса) <> Тип("Структура") Тогда
		Возврат Представление;
	КонецЕсли;
	
	ФорматФИАС = СтруктураАдреса.Свойство("Округ");
	
	Если СтруктураАдреса.Свойство("Страна") Тогда
		Представление = СтруктураАдреса.Страна;
	КонецЕсли;
	
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Индекс", Представление);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Регион", Представление, "РегионСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Округ", Представление, "ОкругСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Район", Представление, "РайонСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Город", Представление, "ГородСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "ВнутригородскойРайон", Представление, "ВнутригородскойРайонСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "НаселенныйПункт", Представление, "НаселенныйПунктСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Территория", Представление, "ТерриторияСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "Улица", Представление, "УлицаСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "ДополнительнаяТерритория", Представление, "ДополнительнаяТерриторияСокращение", ФорматФИАС);
	ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, "ЭлементДополнительнойТерритории", Представление, "ЭлементДополнительнойТерриторииСокращение", ФорматФИАС);
	
	Если СтруктураАдреса.Свойство("Здание") Тогда
		ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Номер", СтруктураАдреса.Здание)), ", " + ЗначениеПоКлючуСтруктуры("ТипЗдания", СтруктураАдреса.Здание) + " ", Представление);
	Иначе
		ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Дом", СтруктураАдреса)), ", " + ЗначениеПоКлючуСтруктуры("ТипДома", СтруктураАдреса) + " ", Представление);
	КонецЕсли;
	
	Если СтруктураАдреса.Свойство("Корпуса") Тогда
		Для каждого Корпус Из СтруктураАдреса.Корпуса Цикл
			ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Номер", Корпус )), ", " + ЗначениеПоКлючуСтруктуры("ТипКорпуса", Корпус)+ " ", Представление);
		КонецЦикла;
	Иначе
		ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Корпус", СтруктураАдреса)), ", " + ЗначениеПоКлючуСтруктуры("ТипКорпуса", СтруктураАдреса)+ " ", Представление);
	КонецЕсли;
	
	Если СтруктураАдреса.Свойство("Помещения") Тогда
		Для каждого Помещение Из СтруктураАдреса.Помещения Цикл
			ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Номер", Помещение)), ", " + ЗначениеПоКлючуСтруктуры("ТипПомещения", Помещение)+ " ", Представление);
		КонецЦикла;
	Иначе
		ДополнитьПредставлениеАдреса(СокрЛП(ЗначениеПоКлючуСтруктуры("Квартира", СтруктураАдреса)), ", " + ЗначениеПоКлючуСтруктуры("ТипКвартиры", СтруктураАдреса) + " ", Представление);
	КонецЕсли;
	
	НаименованиеВида = ЗначениеПоКлючуСтруктуры("НаименованиеВида", СтруктураАдреса);
	ПредставлениеСВидом = НаименованиеВида + ": " + Представление;
	
	Возврат ПредставлениеСВидом;
	
КонецФункции

// Устарела. Для получения адреса следует использовать РаботаСАдресами.СведенияОбАдресе,
// для получения структуры телефона или факса УправлениеКонтактнойИнформацией.СведенияОТелефоне.
// Возвращает структуру контактной информации по типу.
//
// Параметры:
//  ТипКИ - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип контактной информации.
//  ФорматАдреса - Строка - не используется, оставлен для обратной совместимости.
// 
// Возвращаемое значение:
//  Структура - пустая структура контактной информации, ключи - имена полей, значения поля.
//
Функция СтруктураКонтактнойИнформацииПоТипу(ТипКИ, ФорматАдреса = Неопределено) Экспорт
	
	Если ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		Возврат СтруктураПолейАдреса();
	ИначеЕсли ТипКИ = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон") Тогда
		Возврат СтруктураПолейТелефона();
	Иначе
		Возврат Новый Структура;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Описание ключей контактной информации для хранения ее значений в формате JSON.
// Список ключей может быть расширен национальными полями в одноименной функции общего модуля РаботаСАдресамиКлиентСервер.
//
// Параметры:
//  ТипКонтактнойИнформации  - ПеречислениеСсылка.ТипыКонтактнойИнформации - тип контактной информации,
//                             определяющий состав полей контактной информации.
//
// Возвращаемое значение:
//   Структура - поля контактной информации:
//     * Value - Строка - представление контактной информации.
//     * Comment - Строка - комментарий.
//     * Type - Строка - тип контактной информации. См. значение в Перечисление.ТипыКонтактнойИнформации.Адрес.
//     Расширенный состав полей для типа контактной информации адрес:
//     * Country - Строка - наименование страны, например "Россия".
//     * CountryCode - Строка -код страны.
//     * ZIPcode- Строка - почтовый индекс.
//     * Area - Строка - наименование региона.
//     * AreaType - Строка - сокращение(тип) региона.
//     * City - Строка - наименование города.
//     * CityType - Строка - сокращение (тип) города, например "г".
//     * Street - Строка - наименование улицы.
//     * StreetType - Строка - сокращение (тип) улицы, например "ул".
//     Расширенный состав полей для типа контактной информации телефон:
//     * CountryCode - Строка - код страны.
//     * AreaCode - Строка - региональный код.
//     * Number - Строка - телефонный номер.
//     * ExtNumber - Строка - дополнительный телефонный номер.
//
Функция ОписаниеНовойКонтактнойИнформации(Знач ТипКонтактнойИнформации) Экспорт
	
	Если ТипЗнч(ТипКонтактнойИнформации) <> Тип("ПеречислениеСсылка.ТипыКонтактнойИнформации") Тогда
		ТипКонтактнойИнформации = "";
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Результат.Вставить("value",   "");
	Результат.Вставить("comment", "");
	Результат.Вставить("type",    ТипКонтактнойИнформацииВСтроку(ТипКонтактнойИнформации));
	
	Если ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес") Тогда
		
		Результат.Вставить("country",     "");
		Результат.Вставить("addressType", АдресВСвободнойФорме());
		Результат.Вставить("countryCode", "");
		Результат.Вставить("ZIPcode",     "");
		Результат.Вставить("area",        "");
		Результат.Вставить("areaType",    "");
		Результат.Вставить("city",        "");
		Результат.Вставить("cityType",    "");
		Результат.Вставить("street",      "");
		Результат.Вставить("streetType",  "");
		
	ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон")
		Или ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс") Тогда
		
		Результат.Вставить("countryCode", "");
		Результат.Вставить("areaCode", "");
		Результат.Вставить("number", "");
		Результат.Вставить("extNumber", "");
		
	ИначеЕсли ТипКонтактнойИнформации = ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница") Тогда
		
		Результат.Вставить("name", "");
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Параметры:
//  Форма- ФормаКлиентскогоПриложения
// 
// Возвращаемое значение:
//  ДанныеФормыКоллекция:
//   *  ИмяРеквизита  - Строка
//   *  Вид           - СправочникСсылка.ВидыКонтактнойИнформации
//   *  Тип           - ПеречислениеСсылка.ТипыКонтактнойИнформации
//   *  Значение      - Строка
//   *  Представление - Строка
//   *  Комментарий   - Строка
//   *  ЭтоРеквизитТабличнойЧасти - Булево
//   *  ЭтоИсторическаяКонтактнаяИнформация - Булево
//   *  ДействуетС - Дата
//   *  ХранитьИсториюИзменений - Булево
//   *  ИмяЭлементаДляРазмещения - Строка
//   *  МеждународныйФорматАдреса - Булево
//   *  Маска - Строка
//
Функция ОписаниеКонтактнойИнформацииНаФорме(Форма) Экспорт
	Возврат Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТипКонтактнойИнформацииВСтроку(Знач ТипКонтактнойИнформации)
	
	Результат = Новый Соответствие;
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Адрес"), "Адрес");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Телефон"), "Телефон");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.АдресЭлектроннойПочты"), "АдресЭлектроннойПочты");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Skype"), "Skype");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.ВебСтраница"), "ВебСтраница");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Факс"), "Факс");
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ТипыКонтактнойИнформации.Другое"), "Другое");
	Результат.Вставить("", "");
	Возврат Результат[ТипКонтактнойИнформации];
	
КонецФункции

Функция АдресВСвободнойФорме() Экспорт
	Возврат "ВСвободнойФорме";
КонецФункции

Функция АдресЕАЭС() Экспорт
	Возврат "ЕАЭС";
КонецФункции

Функция ИностранныйАдрес() Экспорт
	Возврат "Иностранный";
КонецФункции

Функция ЭтоАдресВСвободнойФорме(ТипАдреса) Экспорт
	Возврат СтрСравнить(АдресВСвободнойФорме(), ТипАдреса) = 0;
КонецФункции

Функция ЗначениеСтроенияИлиПомещения(Тип, Значение) Экспорт
	Возврат Новый Структура("type, number", Тип, Значение);
КонецФункции

// Возвращает пустую структура адреса.
//
// Возвращаемое значение:
//    Структура - адрес, ключи - имена полей, значения поля.
//
Функция СтруктураПолейАдреса() Экспорт
	
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("Представление", "");
	СтруктураАдреса.Вставить("Страна", "");
	СтруктураАдреса.Вставить("НаименованиеСтраны", "");
	СтруктураАдреса.Вставить("КодСтраны","");
	
	Возврат СтруктураАдреса;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииПоРаботеСXMLАдресами

// Возвращает структуру с наименованием и сокращением от значения.
//
// Параметры:
//     Текст - Строка - полное наименование.
//
// Возвращаемое значение:
//     Структура:
//         * Наименование - Строка - часть текста.
//         * Сокращение   - Строка - часть текста.
//
Функция НаименованиеСокращение(Знач Текст) Экспорт
	Результат = Новый Структура("Наименование, Сокращение");
	
	Текст = СокрЛП(Текст);
	
	ТекстВерхнийРегистр = ВРег(Текст);
	Если СтрЗаканчиваетсяНа(ТекстВерхнийРегистр, "ТЕР. СНТ")
		Или СтрЗаканчиваетсяНа(ТекстВерхнийРегистр, "ТЕР. ДНТ") Тогда
		Результат.Сокращение = Прав(Текст, 8);
		Результат.Наименование = Лев(Текст, СтрДлина(Текст) - 9);
		Возврат Результат;
	КонецЕсли;
	
	Части = НаборНаименованийИСокращений(Текст, Истина);
	Если Части.Количество() > 0 Тогда
		ЗаполнитьЗначенияСвойств(Результат, Части[0]);
	Иначе
		Результат.Наименование = Текст;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Разделяет текст на слова по указанным разделителям. По умолчанию разделители - пробельные символы.
//
// Параметры:
//     Текст       - Строка - разделяемая строка.
//     Разделители - Строка - необязательная строка символов-разделителей.
//
// Возвращаемое значение:
//     Массив - строки, слова
//
Функция СловаТекста(Знач Текст, Знач Разделители = Неопределено)
	
	НачалоСлова = 0;
	Состояние   = 0;
	Результат   = Новый Массив;
	
	Для Позиция = 1 По СтрДлина(Текст) Цикл
		ТекущийСимвол = Сред(Текст, Позиция, 1);
		ЭтоРазделитель = ?(Разделители = Неопределено, ПустаяСтрока(ТекущийСимвол), СтрНайти(Разделители, ТекущийСимвол) > 0);
		
		Если Состояние = 0 И (Не ЭтоРазделитель) Тогда
			НачалоСлова = Позиция;
			Состояние   = 1;
		ИначеЕсли Состояние = 1 И ЭтоРазделитель Тогда
			Результат.Добавить(Сред(Текст, НачалоСлова, Позиция-НачалоСлова));
			Состояние = 0;
		КонецЕсли;
	КонецЦикла;
	
	Если Состояние = 1 Тогда
		Результат.Добавить(Сред(Текст, НачалоСлова, Позиция-НачалоСлова));    
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Разделяет текст, разделенный запятыми.
//
// Параметры:
//     Текст              - Срока  - разделяемый текст.
//     ВыделятьСокращения - Булево - опциональный параметр режима работы.
//
// Возвращаемое значение:
//     Массив - содержит структуры "Наименование, Сокращение".
//
Функция НаборНаименованийИСокращений(Знач Текст, Знач ВыделятьСокращения = Истина)
	
	Результат = Новый Массив;
	Для Каждого Часть Из СловаТекста(Текст, ",") Цикл
		СтрокаЧасти = СокрЛП(Часть);
		Если ПустаяСтрока(СтрокаЧасти) Тогда
			Продолжить;
		КонецЕсли;
		
		Позиция = ?(ВыделятьСокращения, СтрДлина(СтрокаЧасти), 0);
		Пока Позиция > 0 Цикл
			Если Сред(СтрокаЧасти, Позиция, 1) = " " Тогда
				Результат.Добавить(Новый Структура("Наименование, Сокращение",
					СокрЛП(Лев(СтрокаЧасти, Позиция-1)), СокрЛП(Сред(СтрокаЧасти, Позиция))));
				Позиция = -1;
				Прервать;
			КонецЕсли;
			Позиция = Позиция - 1;
		КонецЦикла;
		Если Позиция = 0 Тогда
			Результат.Добавить(Новый Структура("Наименование, Сокращение", СтрокаЧасти));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область ПрочиеСлужебныеПроцедурыИФункции

// Дополняет представление адреса строкой.
//
// Параметры:
//    Дополнение         - Строка - дополнение адреса.
//    СтрокаКонкатенации - Строка - строка конкатенации.
//    Представление      - Строка - представление адреса.
//
Процедура ДополнитьПредставлениеАдреса(Дополнение, СтрокаКонкатенации, Представление)
	
	Если Дополнение <> "" Тогда
		Представление = Представление + СтрокаКонкатенации + Дополнение;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает строку значения по свойству структуры.
// 
// Параметры:
//    Ключ - Строка - ключ структуры.
//    Структура - Структура - передаваемая структура.
//
// Возвращаемое значение:
//    Произвольный - значение.
//    Строка       - пустая строка, если нет значения.
//
Функция ЗначениеПоКлючуСтруктуры(Ключ, Структура)
	
	Значение = Неопределено;
	
	Если Структура.Свойство(Ключ, Значение) Тогда 
		Возврат Строка(Значение);
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

Процедура ПредставлениеАдресаПоСтруктуре(СтруктураАдреса, КлючНаименование, Представление, КлючСокращения = "", ДобавлятьСокращения = Ложь, СтрокаКонкатенации = ", ")
	
	Если СтруктураАдреса.Свойство(КлючНаименование) Тогда
		Дополнение = СокрЛП(СтруктураАдреса[КлючНаименование]);
		Если ЗначениеЗаполнено(Дополнение) Тогда
			Если ДобавлятьСокращения И СтруктураАдреса.Свойство(КлючСокращения) Тогда
				Дополнение = Дополнение + " " + СокрЛП(СтруктураАдреса[КлючСокращения]);
			КонецЕсли;
			Если ЗначениеЗаполнено(Представление) Тогда
				Представление = Представление + СтрокаКонкатенации + Дополнение;
			Иначе
				Представление = Дополнение;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Возвращает пустую структура телефона.
//
// Возвращаемое значение:
//    Структура - ключи - имена полей, значения поля.
//
Функция СтруктураПолейТелефона() Экспорт
	
	СтруктураТелефона = Новый Структура;
	СтруктураТелефона.Вставить("Представление", "");
	СтруктураТелефона.Вставить("КодСтраны", "");
	СтруктураТелефона.Вставить("КодГорода", "");
	СтруктураТелефона.Вставить("НомерТелефона", "");
	СтруктураТелефона.Вставить("Добавочный", "");
	СтруктураТелефона.Вставить("Комментарий", "");
	
	Возврат СтруктураТелефона;
	
КонецФункции

Функция АдресСайта(Знач Представление, Знач Ссылка, ТолькоПросмотр) Экспорт
	
	Если ПустаяСтрока(Представление) Или ПустаяСтрока(Ссылка)  Тогда
		Представление = ТекстПустогоАдресаВВидеГиперссылки();
		Ссылка = НавигационнаяСсылкаВебСайта();
	КонецЕсли;
	
	Если СтрСравнить(Представление, ТекстПустогоАдресаВВидеГиперссылки()) = 0 И ТолькоПросмотр Тогда
		Возврат Представление;
	КонецЕсли;
	
	ТекстПредставления = Новый ФорматированнаяСтрока(Представление,,,, Ссылка);
	
	Если ТолькоПросмотр Тогда
		Возврат ТекстПредставления;
	КонецЕсли;
	
	КартинкаИзменить = Новый ФорматированнаяСтрока(БиблиотекаКартинок.РедактироватьАдресСайта,,,, НавигационнаяСсылкаВебСайта());
	Возврат Новый ФорматированнаяСтрока(ТекстПредставления, "  ", КартинкаИзменить);

КонецФункции

Функция НавигационнаяСсылкаВебСайта() Экспорт
	Возврат "e1cib/app/Обработка.ВводКонтактнойИнформации.Форма.ВебСайт";
КонецФункции

#КонецОбласти

#КонецОбласти
