﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Взаимодействия

// Процедура формирует строки списка участников.
//
// Параметры:
//  Контакты  - Массив - массив, содержащий участников взаимодействия.
//
Процедура ЗаполнитьКонтакты(Контакты) Экспорт
	
	Если Не Взаимодействия.КонтактыЗаполнены(Контакты) Тогда
		Возврат;
	КонецЕсли;
	
	// В телефонный звонок переносим первого контакта.
	Параметр = Контакты[0];
	Если ТипЗнч(Параметр) = Тип("Структура") Тогда
		АбонентКонтакт       = Параметр.Контакт;
		АбонентКакСвязаться  = Параметр.Адрес;
		АбонентПредставление = Параметр.Представление;
	Иначе
		АбонентКонтакт = Параметр;
	КонецЕсли;
	
	Взаимодействия.ДозаполнитьПоляКонтактов(АбонентКонтакт, АбонентПредставление, 
		АбонентКакСвязаться, Перечисления.ТипыКонтактнойИнформации.Телефон);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступом.ЗаполнитьНаборыЗначенийДоступа.
//
// Параметры:
//   Таблица - см. УправлениеДоступом.ТаблицаНаборыЗначенийДоступа.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ВзаимодействияСобытия.ЗаполнитьНаборыЗначенийДоступа(ЭтотОбъект, Таблица);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Взаимодействия.ЗаполнитьРеквизитыПоУмолчанию(ЭтотОбъект, ДанныеЗаполнения);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли