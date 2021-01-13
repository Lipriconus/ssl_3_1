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
	
	Если ОбщегоНазначения.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте.'");
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование и восстановление данных необходимо настроить средствами операционной системы или другими сторонними средствами.'");
	КонецЕсли;
	
	Настройки = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	ОтключитьНапоминания = Настройки.РезервноеКопированиеНастроено;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Настройки = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	Настройки.ПараметрОповещения = ?(ОтключитьНапоминания, "НеОповещать", "ЕщеНеНастроено");
	
	Если ОтключитьНапоминания Тогда
		РезервноеКопированиеИБКлиент.ОтключитьОбработчикОжиданияРезервногоКопирования();
	Иначе
		РезервноеКопированиеИБКлиент.ПодключитьОбработчикОжиданияРезервногоКопирования();
	КонецЕсли;
	
	УстановитьНастройкиРезервногоКопирования();
	Оповестить("ЗакрытаФормаНастройкиРезервногоКопирования");
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьНастройкиРезервногоКопирования()
	
	Настройки = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	Настройки.РезервноеКопированиеНастроено = ОтключитьНапоминания;
	Настройки.ВыполнятьАвтоматическоеРезервноеКопирование = Ложь;
	РезервноеКопированиеИБСервер.УстановитьНастройкиРезервногоКопирования(Настройки);
	
КонецПроцедуры

#КонецОбласти
