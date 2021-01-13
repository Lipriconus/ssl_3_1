﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПолей = Параметры.СписокПолей;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Применить(Команда)
	
	Отказ = Ложь;
	
	МассивОтмеченныхЭлементовСписка = ОбщегоНазначенияКлиентСервер.ОтмеченныеЭлементы(СписокПолей);
	
	Если МассивОтмеченныхЭлементовСписка.Количество() = 0 Тогда
		
		НСтрока = НСтр("ru = 'Следует указать хотя бы одно поле'");
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтрока,,"СписокПолей",, Отказ);
		
	ИначеЕсли МассивОтмеченныхЭлементовСписка.Количество() > МаксимальноеКоличествоПользовательскихПолей() Тогда
		
		// Значение должно быть не больше установленного.
		СтрокаСообщения = НСтр("ru = 'Уменьшите количество полей (можно выбирать не более [КоличествоПолей] полей)'");
		СтрокаСообщения = СтрЗаменить(СтрокаСообщения, "[КоличествоПолей]", Строка(МаксимальноеКоличествоПользовательскихПолей()));
		ОбщегоНазначенияКлиент.СообщитьПользователю(СтрокаСообщения,,"СписокПолей",, Отказ);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		
		ОповеститьОВыборе(СписокПолей.Скопировать());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ОповеститьОВыборе(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция МаксимальноеКоличествоПользовательскихПолей()
	
	Возврат ОбменДаннымиКлиент.МаксимальноеКоличествоПолейСопоставленияОбъектов();
	
КонецФункции

#КонецОбласти
