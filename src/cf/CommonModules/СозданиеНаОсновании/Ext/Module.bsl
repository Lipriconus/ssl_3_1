﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Добавляет в список команд создания на основании команду создания указанного объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  ОбъектМетаданных - ОбъектМетаданных - объект, для которого добавляется команда.
// 
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, ОбъектМетаданных) Экспорт
	Если ПравоДоступа("Добавление", ОбъектМетаданных) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = ОбъектМетаданных.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначения.ПредставлениеОбъекта(ОбъектМетаданных);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Записывать";
		
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииСоставаНастроекПодключаемыхОбъектов.
Процедура ПриОпределенииСоставаНастроекПодключаемыхОбъектов(НастройкиПрограммногоИнтерфейса) Экспорт
	Настройка = НастройкиПрограммногоИнтерфейса.Добавить();
	Настройка.Ключ          = "ДобавитьКомандыСозданияНаОсновании";
	Настройка.ОписаниеТипов = Новый ОписаниеТипов("Булево");
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииВидовПодключаемыхКоманд.
Процедура ПриОпределенииВидовПодключаемыхКоманд(ВидыПодключаемыхКоманд) Экспорт
	
	Если Не НастройкиПодсистемы().ИспользоватьКомандыВводаНаОсновании Тогда
		Возврат;
	КонецЕсли;
	
	Вид = ВидыПодключаемыхКоманд.Добавить();
	Вид.Имя         = "СозданиеНаОсновании";
	Вид.ИмяПодменю  = "ПодменюСоздатьНаОсновании";
	Вид.Заголовок   = НСтр("ru = 'Создать на основании';
							|en = 'Create on the basis'");
	Вид.Порядок     = 60;
	Вид.Картинка    = БиблиотекаКартинок.ВводНаОсновании;
	Вид.Отображение = ОтображениеКнопки.Картинка;
	
КонецПроцедуры

// См. ПодключаемыеКомандыПереопределяемый.ПриОпределенииКомандПодключенныхКОбъекту.
Процедура ПриОпределенииКомандПодключенныхКОбъекту(НастройкиФормы, Источники, ПодключенныеОтчетыИОбработки, Команды) Экспорт
	КомандыСозданияНаОсновании = Команды.СкопироватьКолонки();
	КомандыСозданияНаОсновании.Колонки.Добавить("Обработана", Новый ОписаниеТипов("Булево"));
	КомандыСозданияНаОсновании.Индексы.Добавить("Обработана");
	
	СтандартнаяОбработка = Источники.Строки.Количество() > 0;
	ИнтеграцияПодсистемБСП.ПередДобавлениемКомандСозданияНаОсновании(КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
	СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании(КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
	
	КомандыСозданияНаОсновании.ЗаполнитьЗначения(Истина, "Обработана");
	
	ДопустимыеТипы = Новый Массив; // Типы источников, которые пользователь может изменять (см. ниже проверку права "Изменение").
	Если СтандартнаяОбработка Тогда
		ОбъектыСКомандамиСозданияНаОсновании = ОбъектыСКомандамиСозданияНаОсновании();
		Для Каждого Источник Из Источники.Строки Цикл
			Для Каждого ДокументРегистратор Из Источник.Строки Цикл
				ПодключаемыеКоманды.ДополнитьМассивТипов(ДопустимыеТипы, ДокументРегистратор.ТипСсылкиДанных);
				
				СтандартнаяОбработка = Истина;
				ИнтеграцияПодсистемБСП.ПриДобавленииКомандСозданияНаОсновании(
					ДокументРегистратор.Метаданные, КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
				СозданиеНаОснованииПереопределяемый.ПриДобавленииКомандСозданияНаОсновании(
					ДокументРегистратор.Метаданные, КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
					
				Если СтандартнаяОбработка И ОбъектыСКомандамиСозданияНаОсновании[ДокументРегистратор.Метаданные.ПолноеИмя()] <> Неопределено Тогда
					ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, ДокументРегистратор, НастройкиФормы);
				КонецЕсли;
			КонецЦикла;
			
			ПодключаемыеКоманды.ДополнитьМассивТипов(ДопустимыеТипы, Источник.ТипСсылкиДанных);
			
			СтандартнаяОбработка = Истина;
			ИнтеграцияПодсистемБСП.ПриДобавленииКомандСозданияНаОсновании(
				Источник.Метаданные, КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
			СозданиеНаОснованииПереопределяемый.ПриДобавленииКомандСозданияНаОсновании(
				Источник.Метаданные, КомандыСозданияНаОсновании, НастройкиФормы, СтандартнаяОбработка);
					
			Если СтандартнаяОбработка И ОбъектыСКомандамиСозданияНаОсновании[Источник.Метаданные.ПолноеИмя()] <> Неопределено Тогда
				ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, Источник, НастройкиФормы);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ДопустимыеТипы.Количество() = 0 Тогда
		Возврат; // Все закрыто и команд расширений с допустимыми типами тоже не будет.
	КонецЕсли;
	
	Найденные = ПодключенныеОтчетыИОбработки.НайтиСтроки(Новый Структура("ДобавитьКомандыСозданияНаОсновании", Истина));
	Для Каждого ПодключенныйОбъект Из Найденные Цикл
		ПриДобавленииКомандСозданияНаОсновании(КомандыСозданияНаОсновании, ПодключенныйОбъект, НастройкиФормы, ДопустимыеТипы);
	КонецЦикла;
	
	Для Каждого КомандаСозданияНаОсновании Из КомандыСозданияНаОсновании Цикл
		Команда = Команды.Добавить();
		ЗаполнитьЗначенияСвойств(Команда, КомандаСозданияНаОсновании);
		Команда.Вид = "СозданиеНаОсновании";
		Если Команда.Порядок = 0 Тогда
			Команда.Порядок = 50;
		КонецЕсли;
		Если Команда.РежимЗаписи = "" Тогда
			Команда.РежимЗаписи = "Записывать";
		КонецЕсли;
		Если Команда.МножественныйВыбор = Неопределено Тогда
			Команда.МножественныйВыбор = Ложь;
		КонецЕсли;
		Если Команда.ПараметрыФормы = Неопределено Тогда
			Команда.ПараметрыФормы = Новый Структура;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Список объектов, в которых используются команды создания на основании.
//
// Возвращаемое значение:
//   Массив из Строка - имена объектов метаданных, подключенных к подсистеме.
//
Функция ОбъектыСКомандамиСозданияНаОсновании()
	
	Возврат Новый Соответствие(СозданиеНаОснованииПовтИсп.ОбъектыСКомандамиСозданияНаОсновании());
	
КонецФункции

Процедура ПриДобавленииКомандСозданияНаОсновании(Команды, СведенияОбОбъекте, НастройкиФормы, ДопустимыеТипы = Неопределено)
	СведенияОбОбъекте.Менеджер.ДобавитьКомандыСозданияНаОсновании(Команды, НастройкиФормы);
	ДобавленныеКоманды = Команды.НайтиСтроки(Новый Структура("Обработана", Ложь));
	Для Каждого Команда Из ДобавленныеКоманды Цикл
		Если Не ЗначениеЗаполнено(Команда.Менеджер) Тогда
			Команда.Менеджер = СведенияОбОбъекте.ПолноеИмя;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Команда.ТипПараметра) Тогда
			Команда.ТипПараметра = СведенияОбОбъекте.ТипСсылкиДанных;
		КонецЕсли;
		Если ДопустимыеТипы <> Неопределено И Не ТипВМассиве(Команда.ТипПараметра, ДопустимыеТипы) Тогда
			Команды.Удалить(Команда);
			Продолжить;
		КонецЕсли;
		Найденные = Команды.НайтиСтроки(Новый Структура("Обработана, Представление", Истина, Команда.Менеджер));
		Если Найденные.Количество() > 0 Тогда
			Найденные[0].ТипПараметра = ОбъединитьТипы(Найденные[0].ТипПараметра, Команда.ТипПараметра);
			Команды.Удалить(Команда);
			Продолжить;
		КонецЕсли;
		Команда.Обработана = Истина;
		Если Не ЗначениеЗаполнено(Команда.Обработчик) И Не ЗначениеЗаполнено(Команда.ИмяФормы) Тогда
			Команда.ИмяФормы = "ФормаОбъекта";
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Команда.ИмяПараметраФормы) Тогда
			Команда.ИмяПараметраФормы = "Основание";
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция ТипВМассиве(ТипИлиОписаниеТипов, МассивТипов)
	Если ТипЗнч(ТипИлиОписаниеТипов) = Тип("ОписаниеТипов") Тогда
		Для Каждого Тип Из ТипИлиОписаниеТипов.Типы() Цикл
			Если МассивТипов.Найти(Тип) <> Неопределено Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь
	Иначе
		Возврат МассивТипов.Найти(ТипИлиОписаниеТипов) <> Неопределено;
	КонецЕсли;
КонецФункции

Функция ОбъединитьТипы(Тип1, Тип2)
	Тип1ЭтоОписаниеТипов = ТипЗнч(Тип1) = Тип("ОписаниеТипов");
	Тип2ЭтоОписаниеТипов = ТипЗнч(Тип2) = Тип("ОписаниеТипов");
	Если Тип1ЭтоОписаниеТипов И Тип1.Типы().Количество() > 0 Тогда
		ИсходноеОписаниеТипов = Тип1;
		ДобавляемыеТипы = ?(Тип2ЭтоОписаниеТипов, Тип2.Типы(), ЗначениеВМассив(Тип2));
	ИначеЕсли Тип2ЭтоОписаниеТипов И Тип2.Типы().Количество() > 0 Тогда
		ИсходноеОписаниеТипов = Тип2;
		ДобавляемыеТипы = ЗначениеВМассив(Тип1);
	ИначеЕсли ТипЗнч(Тип1) <> Тип("Тип") Тогда
		Возврат Тип2;
	ИначеЕсли ТипЗнч(Тип2) <> Тип("Тип") Тогда
		Возврат Тип1;
	Иначе
		Типы = Новый Массив;
		Типы.Добавить(Тип1);
		Типы.Добавить(Тип2);
		Возврат Новый ОписаниеТипов(Типы);
	КонецЕсли;
	Если ДобавляемыеТипы.Количество() = 0 Тогда
		Возврат ИсходноеОписаниеТипов;
	Иначе
		Возврат Новый ОписаниеТипов(ИсходноеОписаниеТипов, ДобавляемыеТипы);
	КонецЕсли;
КонецФункции

Функция ЗначениеВМассив(Значение)
	Результат = Новый Массив;
	Результат.Добавить(Значение);
	Возврат Результат;
КонецФункции

Функция НастройкиПодсистемы()
	
	Настройки = Новый Структура;
	Настройки.Вставить("ИспользоватьКомандыВводаНаОсновании", Истина);
	
	СозданиеНаОснованииПереопределяемый.ПриОпределенииНастроек(Настройки);
	
	Возврат Настройки;
	
КонецФункции

Процедура ПриВыводеКоманд(Форма, ВидКоманд, СведенияОПодменюПоУмолчанию, ПараметрыРазмещения) Экспорт
	
	Если ВидКоманд.Имя <> "СозданиеНаОсновании" Тогда
		Возврат;
	КонецЕсли;
		
	Если ПараметрыРазмещения.ВводНаОснованииЧерезПодключаемыеКоманды Тогда
		СкрытьСтандартноеПодменюВводаНаОсновании(Форма, СведенияОПодменюПоУмолчанию);
	КонецЕсли;
	
КонецПроцедуры

Процедура СкрытьСтандартноеПодменюВводаНаОсновании(Форма, ДинамическоеПодменюСозданияНаОсновании)
	
	ПодменюСоздатьНаОсновании = Форма.Элементы.Найти("ФормаСоздатьНаОсновании");
	Если ПодменюСоздатьНаОсновании = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПодменюСоздатьНаОсновании.Видимость = Ложь;
	
	ИменаАвтогенерируемыхКоманд = Новый Соответствие;
	Для Каждого Элемент Из ОбъектыСКомандамиСозданияНаОсновании() Цикл
		ИменаАвтогенерируемыхКоманд.Вставить("Форма" + СтрЗаменить(Элемент.Ключ, ".", "") + "СоздатьНаОсновании", Истина);
	КонецЦикла;
		
	Для Каждого Элемент Из ПодменюСоздатьНаОсновании.ПодчиненныеЭлементы Цикл
		Если ИменаАвтогенерируемыхКоманд[Элемент.Имя] = Неопределено Тогда
			Форма.Элементы.Переместить(Элемент, ДинамическоеПодменюСозданияНаОсновании.Группы.Обычное);
			ДинамическоеПодменюСозданияНаОсновании.ВыведеноКоманд = ДинамическоеПодменюСозданияНаОсновании.ВыведеноКоманд + 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ОбъектыПодключеныКПодсистеме(Типы) Экспорт
	
	ОбъектыСКомандамиСозданияНаОсновании = ОбъектыСКомандамиСозданияНаОсновании();

	Для Каждого Тип Из Типы Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(Тип);
		Если ОбъектыСКомандамиСозданияНаОсновании[ОбъектМетаданных.ПолноеИмя()] = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
