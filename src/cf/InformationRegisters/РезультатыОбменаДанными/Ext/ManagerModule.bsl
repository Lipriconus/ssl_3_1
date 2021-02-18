﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура ЗарегистрироватьУстранениеПроблемы(Источник, ТипПроблемы, УзелИнформационнойБазы = Неопределено) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Источник.Метаданные();
	
	Если ОбщегоНазначения.ЭтоРегистр(МетаданныеОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	Если МетаданныеОбъекта.РасширениеКонфигурации() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ОбменДаннымиПовтИсп.ИспользуемыеПланыОбмена().Количество() > 0
		И (БезопасныйРежим() = Ложь Или Пользователи.ЭтоПолноправныйПользователь()) Тогда
		
		СсылкаНаИсточник = Источник.Ссылка;
		
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
		
			ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыОбменаДанными");
			ЭлементБлокировки.УстановитьЗначение("ТипПроблемы", ТипПроблемы);
			Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
				ЭлементБлокировки.УстановитьЗначение("УзелИнформационнойБазы", УзелИнформационнойБазы);				
			КонецЕсли;
			ЭлементБлокировки.УстановитьЗначение("ПроблемныйОбъект", СсылкаНаИсточник);
			
			Блокировка.Заблокировать();
			
			НаборЗаписейКонфликта = СоздатьНаборЗаписей();
			НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
			Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
				НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);			
			КонецЕсли;
			НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(СсылкаНаИсточник);
			
			НаборЗаписейКонфликта.Прочитать();
			
			Если НаборЗаписейКонфликта.Количество() > 0 Тогда
				
				НовоеЗначениеПометкиУдаления = Источник.ПометкаУдаления;
				Если НовоеЗначениеПометкиУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаИсточник, "ПометкаУдаления") Тогда
					Для Каждого ЗаписьКонфликта Из НаборЗаписейКонфликта Цикл
						ЗаписьКонфликта.ПометкаУдаления = НовоеЗначениеПометкиУдаления;
					КонецЦикла;
					НаборЗаписейКонфликта.Записать();
				Иначе
					НаборЗаписейКонфликта.Очистить();
					НаборЗаписейКонфликта.Записать();
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗарегистрироватьОшибкуПроверкиОбъекта(ПроблемныйОбъект, УзелИнформационнойБазы, Причина, ТипПроблемы) Экспорт
	
	МетаданныеОбъекта                   = ПроблемныйОбъект.Метаданные();
	ИдентификаторОбъектаМетаданных      = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъекта);
	Ссылка                              = Неопределено;
	ЗначенияОтборовНезависимогоРегистра = Неопределено;
	
	Если МетаданныеОбъекта.РасширениеКонфигурации() <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта) Тогда
		Ссылка = ПроблемныйОбъект;
	ИначеЕсли ОбщегоНазначения.ЭтоРегистр(МетаданныеОбъекта) Тогда
		
		Если ОбщегоНазначения.ЭтоРегистрСведений(МетаданныеОбъекта)
			И МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.Независимый Тогда
			
			ЗначенияОтборовНезависимогоРегистра = Новый Структура();
			
			Для Каждого ЭлементОтбора Из ПроблемныйОбъект.Отбор Цикл
				ЗначенияОтборовНезависимогоРегистра.Вставить(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
			КонецЦикла;
			
		Иначе
			Ссылка = ПроблемныйОбъект.Отбор.Регистратор.Значение;
		КонецЕсли;	
	Иначе
		Возврат;
	КонецЕсли;
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);
	НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(ПроблемныйОбъект);
	
	СериализованныеЗначенияОтборов = Неопределено;
	Если ЗначенияОтборовНезависимогоРегистра <> Неопределено Тогда
		СериализованныеЗначенияОтборов = СериализоватьЗначенияОтбора(ЗначенияОтборовНезависимогоРегистра, МетаданныеОбъекта);
		НаборЗаписейКонфликта.Отбор.КлючУникальности.Установить(
			РассчитатьХешНезависимогоРегистра(СериализованныеЗначенияОтборов));
	КонецЕсли;
	
	ЗаписьКонфликта = НаборЗаписейКонфликта.Добавить();
	ЗаписьКонфликта.ТипПроблемы            = ТипПроблемы;
	ЗаписьКонфликта.УзелИнформационнойБазы = УзелИнформационнойБазы;
	ЗаписьКонфликта.ОбъектМетаданных       = ИдентификаторОбъектаМетаданных;
	ЗаписьКонфликта.ПроблемныйОбъект       = Ссылка;
	ЗаписьКонфликта.ДатаВозникновения      = ТекущаяДатаСеанса();
	ЗаписьКонфликта.Причина                = СокрЛП(Причина);
	ЗаписьКонфликта.ПредставлениеОбъекта   = Строка(ПроблемныйОбъект); 
	ЗаписьКонфликта.Пропущена              = Ложь;
	
	Если ЗначенияОтборовНезависимогоРегистра <> Неопределено Тогда
		ЗаписьКонфликта.КлючУникальности = РассчитатьХешНезависимогоРегистра(СериализованныеЗначенияОтборов);
		ЗаписьКонфликта.ЗначенияОтборовНезависимогоРегистра = СериализованныеЗначенияОтборов;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоОбъектСсылочногоТипа(МетаданныеОбъекта) Тогда
		
		Если ТипПроблемы = Перечисления.ТипыПроблемОбменаДанными.НепроведенныйДокумент Тогда
			
			Если Ссылка.Метаданные().ДлинаНомера > 0 Тогда
				ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПроблемныйОбъект, "ПометкаУдаления, Номер, Дата");
				ЗаписьКонфликта.НомерДокумента = ЗначенияРеквизитов.Номер;
			Иначе
				ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПроблемныйОбъект, "ПометкаУдаления, Дата");
			КонецЕсли;
			
			ЗаписьКонфликта.ДатаДокумента   = ЗначенияРеквизитов.Дата;
			ЗаписьКонфликта.ПометкаУдаления = ЗначенияРеквизитов.ПометкаУдаления;
			
		Иначе
			
			ЗаписьКонфликта.ПометкаУдаления = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПроблемныйОбъект, "ПометкаУдаления");
			
		КонецЕсли;
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Процедура ОчиститьПроблемыПриОтправке(УзлыИнформационнойБазы = Неопределено) Экспорт

	ТипыПроблем = Новый Массив;
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаПроверкиСконвертированногоОбъекта);
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаВыполненияКодаОбработчиковПриОтправкеДанных);
	
	Если ЗначениеЗаполнено(УзлыИнформационнойБазы) Тогда
		КоллекцияУзлов = ?(ТипЗнч(УзлыИнформационнойБазы) = Тип("Массив"),
			УзлыИнформационнойБазы,
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(УзлыИнформационнойБазы));
			
		Для Каждого Узел Из КоллекцияУзлов Цикл
			ПараметрыОтбора = Новый Структура("УзелИнформационнойБазы", Узел);
			Для Каждого ТипПроблемы Из ТипыПроблем Цикл
				ПараметрыОтбора.Вставить("ТипПроблемы", ТипПроблемы);
				ОчиститьЗаписиРегистра(ПараметрыОтбора);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого ТипПроблемы Из ТипыПроблем Цикл
			ПараметрыОтбора = Новый Структура("ТипПроблемы", ТипПроблемы);
			ОчиститьЗаписиРегистра(ПараметрыОтбора);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ОчиститьПроблемыПриПолучении(УзлыИнформационнойБазы = Неопределено) Экспорт

	ТипыПроблем = Новый Массив();
	ТипыПроблем.Добавить(Перечисления.ТипыПроблемОбменаДанными.ОшибкаВыполненияКодаОбработчиковПриПолученииДанных);
	
	Для Каждого Проблема Из ТипыПроблем Цикл
		
		ПоляОтбора = ПараметрыОтборыРегистра();
		
		Если ЗначениеЗаполнено(УзлыИнформационнойБазы) Тогда
			
			Если ТипЗнч(УзлыИнформационнойБазы) = Тип("Массив") Тогда
				Для Каждого УзелИнформационнойБазы Из УзлыИнформационнойБазы Цикл
					
					ПоляОтбора.ТипПроблемы            = Проблема;
					ПоляОтбора.УзелИнформационнойБазы = УзелИнформационнойБазы;
					ОчиститьЗаписиРегистра(ПоляОтбора);
					
				КонецЦикла;
			Иначе
				
				ПоляОтбора.ТипПроблемы            = Проблема;
				ПоляОтбора.УзелИнформационнойБазы = УзлыИнформационнойБазы;
				ОчиститьЗаписиРегистра(ПоляОтбора);
				
			КонецЕсли;
			
		Иначе	
			ПоляОтбора.ТипПроблемы = Проблема;
			ОчиститьЗаписиРегистра(ПоляОтбора);
		КонецЕсли;
	
	КонецЦикла;

КонецПроцедуры	

Функция ПараметрыПоискаПроблем() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("ТипПроблемы",                Неопределено);
	Параметры.Вставить("УчитыватьПроигнорированные", Ложь);
	Параметры.Вставить("Период",                     Неопределено);
	Параметры.Вставить("УзлыПланаОбмена",            Неопределено);
	Параметры.Вставить("СтрокаПоиска",               "");
	Параметры.Вставить("ПроблемныйОбъект",           Неопределено);	
	
	Возврат Параметры;
	
КонецФункции

Функция КоличествоПроблем(ПараметрыПоиска = Неопределено) Экспорт
	
	Количество = 0;
	
	Если ПараметрыПоиска = Неопределено Тогда
		ПараметрыПоиска = ПараметрыПоискаПроблем();
	КонецЕсли;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РезультатыОбменаДанными.ПроблемныйОбъект) КАК КоличествоПроблем
	|ИЗ
	|	РегистрСведений.РезультатыОбменаДанными КАК РезультатыОбменаДанными
	|ГДЕ
	|	ИСТИНА
	|	И &ОтборПоПропущенным
	|	И &ОтборПоУзлуПланаОбмена
	|	И &ОтборПоТипуПроблемы
	|	И &ОтборПоПериоду
	|	И &ОтборПоПричине
	|	И &ОтборПоОбъекту");

	// Отбор по проигнорированным проблемам.
	СтрокаОтбора = "";
	УчитыватьПроигнорированные = Неопределено;
	Если Не ПараметрыПоиска.Свойство("УчитыватьПроигнорированные", УчитыватьПроигнорированные)
		Или УчитыватьПроигнорированные = Ложь Тогда
		СтрокаОтбора = "И НЕ РезультатыОбменаДанными.Пропущена";
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоПропущенным", СтрокаОтбора);
	
	// Отбор по узлу плана обмена.
	СтрокаОтбора = "";
	УзлыПланаОбмена = Неопределено;
	Если ПараметрыПоиска.Свойство("УзлыПланаОбмена", УзлыПланаОбмена) 
		И ЗначениеЗаполнено(УзлыПланаОбмена) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.УзелИнформационнойБазы В (&УзлыОбмена)";
		Запрос.УстановитьПараметр("УзлыОбмена", ПараметрыПоиска.УзлыПланаОбмена);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоУзлуПланаОбмена", СтрокаОтбора);
	
	// Отбор по типу проблемы.
	СтрокаОтбора = "";
	ТипПроблемы = Неопределено;
	Если ПараметрыПоиска.Свойство("ТипПроблемы", ТипПроблемы)
		И ЗначениеЗаполнено(ТипПроблемы) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.ТипПроблемы В (&ТипыПроблемы)";
		Запрос.УстановитьПараметр("ТипыПроблемы", ТипПроблемы);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоТипуПроблемы", СтрокаОтбора);
	
	// Отбор по периоду.
	СтрокаОтбора = "";
	Период = Неопределено;
	Если ПараметрыПоиска.Свойство("Период", Период) 
		И ЗначениеЗаполнено(Период)
		И ТипЗнч(Период) = Тип("СтандартныйПериод") Тогда
		СтрокаОтбора = "И (РезультатыОбменаДанными.ДатаВозникновения >= &ДатаНачала
		|		И РезультатыОбменаДанными.ДатаВозникновения <= &ДатаОкончания)";
		Запрос.УстановитьПараметр("ДатаНачала",    Период.ДатаНачала);
		Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоПериоду", СтрокаОтбора);
	
	// Отбор по причине.
	СтрокаОтбора = "";
	СтрокаПоиска = Неопределено;
	Если ПараметрыПоиска.Свойство("СтрокаПоиска", СтрокаПоиска) 
		И ЗначениеЗаполнено(СтрокаПоиска) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.Причина ПОДОБНО &Причина";
		Запрос.УстановитьПараметр("Причина", "%" + СтрокаПоиска + "%");
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоПричине", СтрокаОтбора);
	
	// Отбор по объекту.
	СтрокаОтбора = "";
	ПроблемныеОбъекты = Неопределено;
	Если ПараметрыПоиска.Свойство("ПроблемныеОбъекты", ПроблемныеОбъекты)
		И ЗначениеЗаполнено(ПроблемныеОбъекты) Тогда
		СтрокаОтбора = "И РезультатыОбменаДанными.ПроблемныйОбъект В (&ПроблемныеОбъекты)";
		Запрос.УстановитьПараметр("ПроблемныеОбъекты", ПроблемныеОбъекты);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "И &ОтборПоОбъекту", СтрокаОтбора);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Количество = Выборка.КоличествоПроблем;
	КонецЕсли;
	
	Возврат Количество;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СериализоватьЗначенияОтбора(ПараметрыОтбора, МетаданныеОбъекта)
	
	НаборЗаписей = НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора, МетаданныеОбъекта);
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
    ЗаписатьXML(ЗаписьXML, НаборЗаписей);
	
	Возврат ЗаписьXML.Закрыть();

КонецФункции

Функция РассчитатьХешНезависимогоРегистра(СериализованныеЗначенияОтбора)
	
	ХешОтбораМД5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешОтбораМД5.Добавить(СериализованныеЗначенияОтбора);
	
	ХешСуммаОтбора = ХешОтбораМД5.ХешСумма;
	ХешСуммаОтбора = СтрЗаменить(ХешСуммаОтбора, " ", "");
	
	Возврат ХешСуммаОтбора;

КонецФункции

Функция ПараметрыОтборыРегистра()
	
	ПоляОтбора = Новый Структура();
	ПоляОтбора.Вставить("ТипПроблемы",            Перечисления.ТипыПроблемОбменаДанными.ПустаяСсылка());
	ПоляОтбора.Вставить("УзелИнформационнойБазы", Неопределено);
	ПоляОтбора.Вставить("ОбъектМетаданных",       Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка());
	ПоляОтбора.Вставить("ПроблемныйОбъект",       Неопределено);
	ПоляОтбора.Вставить("КлючУникальности",       "");
	
	Возврат ПоляОтбора;
	
КонецФункции

Процедура Игнорировать(Ссылка, ТипПроблемы, Игнорировать, УзелИнформационнойБазы = Неопределено) Экспорт
	
	НаборЗаписейКонфликта = СоздатьНаборЗаписей();
	
	Если Ссылка <> Неопределено Тогда
		
		МетаданныеОбъекта              = Ссылка.Метаданные();
		ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МетаданныеОбъекта);
		
		НаборЗаписейКонфликта.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);	
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Отбор.ПроблемныйОбъект.Установить(Ссылка);
	НаборЗаписейКонфликта.Отбор.ТипПроблемы.Установить(ТипПроблемы);
	
	Если ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		
		НаборЗаписейКонфликта.Отбор.УзелИнформационнойБазы.Установить(УзелИнформационнойБазы);	
		
	КонецЕсли;
	
	НаборЗаписейКонфликта.Прочитать();
	НаборЗаписейКонфликта[0].Пропущена = Игнорировать;
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

Функция НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора, МетаданныеОбъекта)
	
	НаборЗаписей = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(МетаданныеОбъекта.ПолноеИмя()).СоздатьНаборЗаписей();
	
	Для Каждого ЭлементОтбора Из НаборЗаписей.Отбор Цикл
		ЗначениеОтбора = Неопределено;
		Если ПараметрыОтбора.Свойство(ЭлементОтбора.Имя, ЗначениеОтбора) Тогда
			ЭлементОтбора.Установить(ЗначениеОтбора);
		КонецЕсли;
	КонецЦикла;	
	
	Возврат НаборЗаписей;
	
КонецФункции

Процедура ОчиститьЗаписиРегистра(ПараметрыОтбора)
	
	НаборЗаписейКонфликта = НаборЗаписейРегистраПоПараметрамОтбора(ПараметрыОтбора, Метаданные.РегистрыСведений.РезультатыОбменаДанными);
	НаборЗаписейКонфликта.Записать();
	
КонецПроцедуры

#Область ОбработчикиОбновления

Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
	ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
	ДополнительныеПараметры.ПолноеИмяРегистра             = "РегистрСведений.УдалитьРезультатыОбменаДанными";
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УдалитьРезультатыОбменаДанными.ПроблемныйОбъект КАК ПроблемныйОбъект,
	|	УдалитьРезультатыОбменаДанными.ТипПроблемы КАК ТипПроблемы
	|ИЗ
	|	РегистрСведений.УдалитьРезультатыОбменаДанными КАК УдалитьРезультатыОбменаДанными");
	
	Результат = Запрос.Выполнить().Выгрузить();
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Результат, ДополнительныеПараметры);
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаЗавершена = Истина;
	
	МетаданныеРегистра    = Метаданные.РегистрыСведений.УдалитьРезультатыОбменаДанными;
	ПолноеИмяРегистра     = МетаданныеРегистра.ПолноеИмя();
	ПредставлениеРегистра = МетаданныеРегистра.Представление();
	
	ДополнительныеПараметрыВыборкиДанныхДляОбработки = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыВыборкиДанныхДляОбработки();
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, ПолноеИмяРегистра, ДополнительныеПараметрыВыборкиДанныхДляОбработки);
	
	Обработано = 0;
	Проблемных = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ПеренестиЗаписиРегистра(Выборка);
			Обработано = Обработано + 1;
			
		Исключение
			
			Проблемных = Проблемных + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать набор записей регистра ""%1"" по причине:
				|%2'"), ПредставлениеРегистра, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеРегистра, , ТекстСообщения);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Если Не ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяРегистра) Тогда
		ОбработкаЗавершена = Ложь;
	КонецЕсли;
	
	Если Обработано = 0 И Проблемных <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыСведений.РезультатыОбменаДанными.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые записи. Пропущены: %1'"), 
			Проблемных);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			, ,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедура РегистрыСведений.РезультатыОбменаДанными.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию записей: %1'"),
			Обработано));
	КонецЕсли;
	
	Параметры.ОбработкаЗавершена = ОбработкаЗавершена;
	
КонецПроцедуры

Процедура ПеренестиЗаписиРегистра(ЗаписьРегистра) 
	
	Если Не ЗначениеЗаполнено(ЗаписьРегистра.ПроблемныйОбъект) Тогда
		НаборЗаписейСтарый = РегистрыСведений.УдалитьРезультатыОбменаДанными.СоздатьНаборЗаписей();
		НаборЗаписейСтарый.Отбор.ПроблемныйОбъект.Установить(ЗаписьРегистра.ПроблемныйОбъект);
		НаборЗаписейСтарый.Отбор.ТипПроблемы.Установить(ЗаписьРегистра.ТипПроблемы);
		
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейСтарый);
		Возврат;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		
		ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ЗаписьРегистра.ПроблемныйОбъект.Метаданные());
		
		Блокировка = Новый БлокировкаДанных;
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.УдалитьРезультатыОбменаДанными");
		ЭлементБлокировки.УстановитьЗначение("ПроблемныйОбъект", ЗаписьРегистра.ПроблемныйОбъект);
		ЭлементБлокировки.УстановитьЗначение("ТипПроблемы",      ЗаписьРегистра.ТипПроблемы);		
		
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.РезультатыОбменаДанными");
		ЭлементБлокировки.УстановитьЗначение("ТипПроблемы",      ЗаписьРегистра.ТипПроблемы);
		ЭлементБлокировки.УстановитьЗначение("ОбъектМетаданных", ИдентификаторОбъектаМетаданных);
		ЭлементБлокировки.УстановитьЗначение("ПроблемныйОбъект", ЗаписьРегистра.ПроблемныйОбъект);
		
		Блокировка.Заблокировать();
		
		НаборЗаписейСтарый = РегистрыСведений.УдалитьРезультатыОбменаДанными.СоздатьНаборЗаписей();
		НаборЗаписейСтарый.Отбор.ПроблемныйОбъект.Установить(ЗаписьРегистра.ПроблемныйОбъект);
		НаборЗаписейСтарый.Отбор.ТипПроблемы.Установить(ЗаписьРегистра.ТипПроблемы);
		
		НаборЗаписейСтарый.Прочитать();
		
		Если НаборЗаписейСтарый.Количество() = 0 Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписейСтарый);
		Иначе
			
			НаборЗаписейНовый = СоздатьНаборЗаписей();
			НаборЗаписейНовый.Отбор.ТипПроблемы.Установить(ЗаписьРегистра.ТипПроблемы);		
			НаборЗаписейНовый.Отбор.ОбъектМетаданных.Установить(ИдентификаторОбъектаМетаданных);
			НаборЗаписейНовый.Отбор.ПроблемныйОбъект.Установить(ЗаписьРегистра.ПроблемныйОбъект);
			
			ЗаписьНовый = НаборЗаписейНовый.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНовый, НаборЗаписейСтарый[0]);
			
			ЗаписьНовый.ОбъектМетаданных = ИдентификаторОбъектаМетаданных;
			
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейНовый);
			
			НаборЗаписейСтарый.Очистить();
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписейСтарый);
			
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли