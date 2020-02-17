﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления.

// Регистрирует на плане обмена ОбновлениеИнформационнойБазы объекты,
// для которых необходимо обновить записи в регистре.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Ссылка = "";
	ОтработаныВсеВладельцыФайлов = Ложь;
	Пока Не ОтработаныВсеВладельцыФайлов Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	Файлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Файлы КАК Файлы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
		|		ПО Файлы.Ссылка = СведенияОФайлах.Файл
		|ГДЕ
		|	Файлы.Ссылка > &Ссылка
		|	И СведенияОФайлах.Файл ЕСТЬ NULL";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"); 
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, МассивСсылок);
		
		КоличествоСсылок = МассивСсылок.Количество();
		Если КоличествоСсылок < 1000 Тогда
			ОтработаныВсеВладельцыФайлов = Истина;
		КонецЕсли;
		
		Если КоличествоСсылок > 0 Тогда
			Ссылка = МассивСсылок[КоличествоСсылок-1];
		КонецЕсли;
		
	КонецЦикла;
	
	Файл = "";
	ОтработаныВсеЗаписиРегистра = Ложь;
	Пока Не ОтработаныВсеЗаписиРегистра Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1000
		|	СведенияОФайлах.Файл КАК Файл
		|ИЗ
		|	РегистрСведений.СведенияОФайлах КАК СведенияОФайлах
		|ГДЕ
		|	СведенияОФайлах.Файл > &Файл
		|	И СведенияОФайлах.ТипХраненияФайла = ЗНАЧЕНИЕ(Перечисление.ТипыХраненияФайлов.ПустаяСсылка)";
		Запрос.УстановитьПараметр("Файл", Файл);
		ИзмеренияРегистра = Запрос.Выполнить().Выгрузить();
		
		ДополнительныеПараметры = ОбновлениеИнформационнойБазы.ДополнительныеПараметрыОтметкиОбработки();
		ДополнительныеПараметры.ЭтоНезависимыйРегистрСведений = Истина;
		ДополнительныеПараметры.ПолноеИмяРегистра = "РегистрСведений.СведенияОФайлах";
		
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ИзмеренияРегистра, ДополнительныеПараметры);
		
		КоличествоЗаписей = ИзмеренияРегистра.Количество();
		Если КоличествоЗаписей < 1000 Тогда
			ОтработаныВсеЗаписиРегистра = Истина;
		КонецЕсли;
		
		Если КоличествоЗаписей > 0 Тогда
			Файл = ИзмеренияРегистра[КоличествоЗаписей-1].Файл;
		КонецЕсли;
		
	КонецЦикла;
		
КонецПроцедуры

// Обновить записи регистра.
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, "Справочник.Файлы");
	ОбъектовОбработано = 0;
	ПроблемныхОбъектов = 0;
	
	Пока Выборка.Следующий() Цикл
		НачатьТранзакцию();
		Попытка
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить("Справочник.Файлы");
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Разделяемый;
			Блокировка.Заблокировать();
			
			НаборЗаписей = СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Файл.Установить(Выборка.Ссылка);
			
			ЗаписьНабора = НаборЗаписей.Добавить();
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, Выборка.Ссылка);
			
			ЗаписьНабора.Файл          = Выборка.Ссылка;
			СтруктураРеквизитов        = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.Ссылка, "Автор, ВладелецФайла");
			ЗаписьНабора.Автор         = СтруктураРеквизитов.Автор;
			ЗаписьНабора.ВладелецФайла = СтруктураРеквизитов.ВладелецФайла;
			
			Если Выборка.Ссылка.ПодписанЭП И Выборка.Ссылка.Зашифрован Тогда
				ЗаписьНабора.НомерКартинкиПодписанЗашифрован = 2;
			ИначеЕсли Выборка.Ссылка.Зашифрован Тогда
				ЗаписьНабора.НомерКартинкиПодписанЗашифрован = 1;
			ИначеЕсли Выборка.Ссылка.ПодписанЭП Тогда
				ЗаписьНабора.НомерКартинкиПодписанЗашифрован = 0;
			Иначе
				ЗаписьНабора.НомерКартинкиПодписанЗашифрован = -1;
			КонецЕсли;
			ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей, Истина);
			
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			// Если не удалось обработать какой-либо документ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать файл: %1 по причине:
				|%2'"), 
				Выборка.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	ОбработкаФайловЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Справочник.Файлы");
	
	Выборка = ОбновлениеИнформационнойБазы.ВыбратьИзмеренияНезависимогоРегистраСведенийДляОбработки(
		Параметры.Очередь, "РегистрСведений.СведенияОФайлах");
		
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Выборка.Файл, "ТипХраненияФайла");
			
			НаборЗаписей = РегистрыСведений.СведенияОФайлах.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Файл.Установить(Выборка.Файл);
			НаборЗаписей.Прочитать();
			
			Для Каждого СведенияОФайле Из НаборЗаписей Цикл
				СведенияОФайле.ТипХраненияФайла = ТипХраненияФайла;
			КонецЦикла;
			
			НаборЗаписей.Записать();
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(НаборЗаписей);
			
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать тип хранения файла: %1 по причине:
				|%2'"), 
				Выборка.Файл, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Выборка.Ссылка.Метаданные(), Выборка.Ссылка, ТекстСообщения);
				
		КонецПопытки;
		
	КонецЦикла;
	
	ОбработкаРегистраЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "РегистрСведений.СведенияОФайлах");
	
	Параметры.ОбработкаЗавершена = ОбработкаФайловЗавершена И ОбработкаРегистраЗавершена;
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре РегистрыСведений.СведенияОФайлах.ОбработатьДанныеДляПереходаНаНовуюВерсию не удалось обработать некоторые файлы файлов (пропущены): %1'"), 
			ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Справочники.Файлы,,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Процедура РегистрыСведений.СведенияОФайлах.ОбработатьДанныеДляПереходаНаНовуюВерсию обработала очередную порцию файлов: %1'"),
				ОбъектовОбработано));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
