﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ЭлементыФормулы(Знач Формула) Экспорт
	
	Операнды = ПрочитатьОперандыИзФормулы(Формула);
	Для Каждого Операнд Из Операнды Цикл
		Формула = СтрЗаменить(Формула, Операнд, " ");
	КонецЦикла;
	Функции = Новый Массив;
	
	СтрокиСФункциями = СтрРазделитьСУчетомСтрок(Формула, "(", Ложь);
	
	Для Индекс = 0 По СтрокиСФункциями.ВГраница() Цикл
		СтрокаСФункцией = СтрокиСФункциями[Индекс];
		ОперандыСтроки = ОперандыСтроки(СтрокаСФункцией);
		Если ОперандыСтроки.Количество() > 0 И Индекс < СтрокиСФункциями.ВГраница() Тогда
			Функции.Добавить(СокрЛП(ОперандыСтроки[ОперандыСтроки.ВГраница()]));
		КонецЕсли;
		Для Каждого Операнд Из ОперандыСтроки Цикл
			Операнды.Добавить(Операнд);
		КонецЦикла;
	КонецЦикла;
	
	Результат = Новый Структура;
	Результат.Вставить("Операнды", Операнды);
	Результат.Вставить("Функции", Функции);
	
	Возврат Результат;
	
КонецФункции

Функция ПрочитатьОперандыИзФормулы(Формула)
	
	Операнды = Новый Массив;
	Для Каждого Строка Из СтрРазделитьСУчетомСтрок(Формула, "[", Истина) Цикл
		ЧастиСтроки = СтрРазделитьСУчетомСтрок(Строка, "]", Истина);
		Если ЧастиСтроки.Количество() > 1 Тогда
			Операнды.Добавить("[" + ЧастиСтроки[0] + "]");
		КонецЕсли;
	КонецЦикла;
	
	Возврат Операнды;
	
КонецФункции

Функция ОперандыСтроки(Знач Строка)
	
	Операнды = Новый Массив;
	
	Строка = СтрСоединить(СтрРазделитьСУчетомСтрок(Строка, "[", Истина), "*[");
	
	Для Каждого Операнд Из СтрРазделитьСУчетомСтрок(Строка, "/*-+=(),% ", Ложь) Цикл
		Операнды.Добавить(СокрЛП(Операнд));
	КонецЦикла;
	
	Возврат Операнды;
	
КонецФункции

Функция СтрРазделитьСУчетомСтрок(ИсходнаяСтрока, Разделитель, ВключатьПустые = Истина)
	
	Результат = Новый Массив;
	СтрокиМеждуКавычками = СтрРазделить(ИсходнаяСтрока, """", Истина);
	
	Если СтрокиМеждуКавычками.Количество() = 0 Тогда
		Возврат СтрРазделить(ИсходнаяСтрока, Разделитель, ВключатьПустые);
	КонецЕсли;
	
	Для Индекс = 0 По СтрокиМеждуКавычками.ВГраница() Цикл
		Если Индекс % 2 = 1 Тогда
			Если Результат.Количество() = 0 Тогда
				Результат.Добавить("");
			КонецЕсли;
			Результат[Результат.ВГраница()] = Результат[Результат.ВГраница()] + """" + СтрокиМеждуКавычками[Индекс] + ?(Индекс = СтрокиМеждуКавычками.ВГраница(), "", """");
			Продолжить;
		КонецЕсли;
		
		Если СтрокиМеждуКавычками[Индекс] = "" Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиСтроки = СтрРазделить(СтрокиМеждуКавычками[Индекс], Разделитель, Истина);
		Для Каждого ЧастьСтроки Из ЧастиСтроки Цикл
			Результат.Добавить(ЧастьСтроки);
		КонецЦикла;
	КонецЦикла;
	
	Если Не ВключатьПустые Тогда
		Для Индекс = -Результат.Количество() + 1 По 0 Цикл
			Если ПустаяСтрока(Результат[-Индекс]) Тогда
				Результат.Удалить(-Индекс);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция НастройкиСпискаПолей(Форма, ИмяСпискаПолей) Экспорт
	
	Отбор = Новый Структура("ИмяСпискаПолей", ИмяСпискаПолей);
	Для Каждого СписокПолей Из Форма.ПодключенныеСпискиПолей.НайтиСтроки(Отбор) Цикл
		Возврат СписокПолей;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПараметрыРедактированияФормулы() Экспорт
	
	Параметры = Новый Структура;
	Параметры.Вставить("Формула");
	Параметры.Вставить("Операнды");
	Параметры.Вставить("Операторы");
	Параметры.Вставить("ИмяКоллекцииСКДОперандов");
	Параметры.Вставить("ИмяКоллекцииСКДОператоров");
	Параметры.Вставить("Наименование");
	Параметры.Вставить("ДляЗапроса");
	
	Возврат Параметры;
	
КонецФункции

#КонецОбласти