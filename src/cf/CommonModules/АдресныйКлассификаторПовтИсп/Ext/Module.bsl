﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// HTTPСоединение для вызова веб-сервиса 1С.
//
// Возвращаемое значение:
//     HTTPСоединение - объект для вызовов сервиса.
//
Функция СервисКлассификатора1С(ВремяОжидания = 120) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	Авторизация = АдресныйКлассификаторСлужебный.ПараметрыАутентификацииНаСайте();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Авторизация = Неопределено Тогда
		ИмяПользователя    = "неавторизованный";
		ПарольПользователя = "";
	Иначе
		ИмяПользователя    = Авторизация.Логин;
		ПарольПользователя = Авторизация.Пароль;
	КонецЕсли;
	
	СтруктураURIВебСервиса = ОбщегоНазначенияКлиентСервер.СтруктураURI(АдресныйКлассификаторСлужебный.АдресВебСервисаКонтактнойИнформации());
	ИмяСервера = СтруктураURIВебСервиса.ИмяСервера;
	
	Порт = ?(ЗначениеЗаполнено(СтруктураURIВебСервиса.Порт), СтруктураURIВебСервиса.Порт, Неопределено);
	Прокси = Неопределено;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
		Прокси = МодульПолучениеФайловИзИнтернета.ПолучитьПрокси(СтруктураURIВебСервиса.Схема);
	КонецЕсли;

	ЗащищенноеСоединение         = ОбщегоНазначенияКлиентСервер.НовоеЗащищенноеСоединение();
	ИспользоватьАутентификациюОС = Ложь;
	
	СохраненныйТекущийURLВебСервиса = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("АдресныйКлассификатор", "URLСервисаКлассификатора1С");
	Если ТипЗнч(СохраненныйТекущийURLВебСервиса) = Тип("Строка") И ЗначениеЗаполнено(СохраненныйТекущийURLВебСервиса) Тогда
		URLВебСервисаПоЧастям = СтрРазделить(СохраненныйТекущийURLВебСервиса, ":", Ложь);
		ИмяСервера = СокрЛП(URLВебСервисаПоЧастям[0]);
		Если URLВебСервисаПоЧастям.Количество() > 1 Тогда
			ТипЧисло = Новый ОписаниеТипов("Число");
			Порт = ТипЧисло.ПривестиЗначение(URLВебСервисаПоЧастям[1]);
			ЗащищенноеСоединение = Неопределено;
			Если Порт = 0 Тогда
				Порт = 80;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
			
			Соединение = Новый HTTPСоединение(
				ИмяСервера,
				Порт,
				ИмяПользователя,
				ПарольПользователя,
				Прокси,
				ВремяОжидания,
				ЗащищенноеСоединение,
				ИспользоватьАутентификациюОС);
			
			Сервер = Соединение.Сервер;
			Порт   = Соединение.Порт;
			
	Исключение
		
		ШаблонЗапроса = "%1:%2%3ping";
		URL = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗапроса, ИмяСервера, Порт,
			АдресныйКлассификаторСлужебный.ПрефиксВерсииЗапроса());
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось установить HTTP-соединение с сервером %1:%2
			           |по причине:
			           |%3'"),
			Сервер, Формат(Порт, "ЧГ="),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
			МодульПолучениеФайловИзИнтернета = ОбщегоНазначения.ОбщийМодуль("ПолучениеФайловИзИнтернета");
			РезультатДиагностики = МодульПолучениеФайловИзИнтернета.ДиагностикаСоединения(URL);
			
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1
				           |Результат диагностики:
				           |%2'"),
				РезультатДиагностики.ОписаниеОшибки);
		КонецЕсли;
		
		ЗаписьЖурналаРегистрации(АдресныйКлассификаторСлужебный.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		
	КонецПопытки;
	
	Возврат Соединение;
	
КонецФункции

Функция СведенияОЗагрузкеСубъектовРФ() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Новый Соответствие;
	
	// Веб-сервис 1С
	Если НЕ ОбщегоНазначения.РазделениеВключено() Тогда
		СервисРезультат = АдресныйКлассификаторСлужебный.ВерсияПоставщикаДанных();
		КлассификаторДоступен = (СервисРезультат.Данные = Истина);
	Иначе
		КлассификаторДоступен = Ложь;
	КонецЕсли;
	Результат.Вставить("КлассификаторДоступен", КлассификаторДоступен);
	
	ИспользоватьЗагруженные = Ложь;
	ЕстьЗагруженныеСведения = Ложь;
	
	СведенияОЗагрузкеСубъектовРФ = АдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	Для каждого СведенияОбСубъектеРФ Из СведенияОЗагрузкеСубъектовРФ Цикл
		
		ЗагруженныеСведенияРегионаАктуальны = СведенияОбСубъектеРФ.Загружено;
		
		Если КлассификаторДоступен И СведенияОбСубъектеРФ.Устарело = Истина Тогда
			ЗагруженныеСведенияРегионаАктуальны = Ложь;
		КонецЕсли;
		
		Если СведенияОбСубъектеРФ.Загружено Тогда
			ЕстьЗагруженныеСведения = Истина;
		КонецЕсли;
		
		Если ЗагруженныеСведенияРегионаАктуальны Тогда
			ИспользоватьЗагруженные = Истина;
		КонецЕсли;
		
		Сведения = Новый Структура();
		Сведения.Вставить("ИспользоватьЗагруженные", ЗагруженныеСведенияРегионаАктуальны);
		Сведения.Вставить("ДатаЗагрузки", СведенияОбСубъектеРФ.ДатаЗагрузки);
		Результат.Вставить(СведенияОбСубъектеРФ.КодСубъектаРФ, Сведения);
		
	КонецЦикла;
	
	Результат.Вставить("ИспользоватьЗагруженные", ИспользоватьЗагруженные);
	Результат.Вставить("ЕстьЗагруженныеСведения", ЕстьЗагруженныеСведения);
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

// Возвращает является ли источником данных веб сервис.
//
// Возвращаемое значение:
//     Булево - Если веб сервис является источником адресных сведений, то возвращает Истина.
//
Функция ИсточникДанныхАдресногоКлассификатораВебСервис() Экспорт
	
	СервисРезультат = АдресныйКлассификаторСлужебный.ВерсияПоставщикаДанных();
	Возврат СервисРезультат.Данные = Истина;
	
КонецФункции

Функция НаименованиеВладенийИСтроений() Экспорт
	
	Результат = Новый Структура("Владения, Строения", Новый Соответствие, Новый Соответствие);
	Результат.Владения.Вставить(0, "Дом");
	Результат.Строения.Вставить(0, "Строение");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СлужебныеАдресныеСведения.Тип КАК Тип,
		|	СлужебныеАдресныеСведения.Идентификатор КАК Идентификатор,
		|	СлужебныеАдресныеСведения.Ключ КАК Ключ,
		|	СлужебныеАдресныеСведения.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.СлужебныеАдресныеСведения КАК СлужебныеАдресныеСведения
		|ГДЕ
		|	СлужебныеАдресныеСведения.Тип = ""ESTSTAT""
		|			ИЛИ СлужебныеАдресныеСведения.Тип = ""STRSTAT""";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока РезультатЗапроса.Следующий() Цикл
		Если РезультатЗапроса.Тип = "ESTSTAT" Тогда
			Результат.Владения.Вставить(РезультатЗапроса.Идентификатор, РезультатЗапроса.Значение);
		ИначеЕсли РезультатЗапроса.Тип = "STRSTAT" Тогда
			Результат.Строения.Вставить(РезультатЗапроса.Идентификатор, РезультатЗапроса.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Параметры:
//  НаименованиеРегиона  - Строка - Полное наименование региона
// 
// Возвращаемое значение:
//  ФиксированнаяСтруктура - где:
//    * Загружен - Булево -
//    * Устарел - Булево -
//    * КодСубъектаРФ - Число -
//
Функция СведенияОРегионе(Знач НаименованиеРегиона)  Экспорт
	
	Результат = Новый Структура("Загружен, Устарел, КодСубъектаРФ", Ложь, Ложь, Неопределено);
	
	СведенияОРегионе = АдресныйКлассификаторСлужебный.НаименованиеИСокращение(НаименованиеРегиона);
	РезультатЗапроса = АдресныйКлассификаторСлужебный.АктуальныеДанныеОРегионе(СведенияОРегионе);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		АдресныйКлассификаторСлужебный.ВыполнитьНачальноеЗаполнение();
		РезультатЗапроса = АдресныйКлассификаторСлужебный.АктуальныеДанныеОРегионе(СведенияОРегионе);
		
		Если РезультатЗапроса.Пустой() Тогда
			
			АдресныйКлассификаторСлужебный.ПроверкаНаУстаревшийРегион(Результат, СведенияОРегионе);
			Возврат Новый ФиксированнаяСтруктура(Результат);
			
		КонецЕсли;
	КонецЕсли;
	
	ИнформацияОРегионе = РезультатЗапроса.Выбрать();
	
	Если ИнформацияОРегионе.Следующий() Тогда
		Результат.Загружен = ИнформацияОРегионе.РегионЗагружен;
		Результат.КодСубъектаРФ = ИнформацияОРегионе.КодСубъектаРФ;
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

Функция СписокРегионов() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	АдресныеОбъекты.КодСубъектаРФ КАК КодСубъектаРФ,
		|	АдресныеОбъекты.Наименование КАК Наименование,
		|	АдресныеОбъекты.Наименование + "" "" + АдресныеОбъекты.Сокращение КАК ПолноеНаименование
		|ИЗ
		|	РегистрСведений.АдресныеОбъекты КАК АдресныеОбъекты
		|ГДЕ
		|	АдресныеОбъекты.Уровень = 1";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(ВыборкаДетальныеЗаписи.Наименование, ВыборкаДетальныеЗаписи.КодСубъектаРФ);
		Результат.Вставить(ВыборкаДетальныеЗаписи.ПолноеНаименование, ВыборкаДетальныеЗаписи.КодСубъектаРФ);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

Функция СписокСокращений() Экспорт
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	УровниСокращенийАдресныхСведений.Сокращение КАК Сокращение,
		|	УровниСокращенийАдресныхСведений.Уровень КАК Уровень,
		|	УровниСокращенийАдресныхСведений.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.УровниСокращенийАдресныхСведений КАК УровниСокращенийАдресныхСведений";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Вставить(Строка(ВыборкаДетальныеЗаписи.Уровень) + ВыборкаДетальныеЗаписи.Сокращение, 
			ВыборкаДетальныеЗаписи.Значение);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Результат);
	
КонецФункции

#КонецОбласти
