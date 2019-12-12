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

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтение
	|ГДЕ
	|	ИСТИНА
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ИзменениеОбъектаРазрешено(Взаимодействие)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления

// Формирует пустую структуру для записи в регистр сведений ПредметыПапкиВзаимодействий.
//
Функция РеквизитыВзаимодействия() Экспорт

	Результат = Новый Структура;
	Результат.Вставить("Предмет"                ,Неопределено);
	Результат.Вставить("Папка"                  ,Неопределено);
	Результат.Вставить("Рассмотрено"            ,Неопределено);
	Результат.Вставить("РассмотретьПосле"       ,Неопределено);
	Результат.Вставить("РассчитыватьРассмотрено",Истина);
	
	Возврат Результат;
	
КонецФункции

// Устанавливает папку, предмет и реквизиты рассмотрения для взаимодействий.
//
// Параметры:
//  Ссылка      - ДокументСсылка.ЭлектронноеПисьмоВходящее,
//                ДокументСсылка.ЭлектронноеПисьмоИсходящее,
//                ДокументСсылка.Встреча,
//                ДокументСсылка.ЗапланированноеВзаимодействие,
//                ДокументСсылка.ТелефонныйЗвонок - взаимодействие для которого будут установлены папка и предмет.
//  Реквизиты    - см. РегистрыСведений.ПредметыПапкиВзаимодействий.РеквизитыВзаимодействия.
//  НаборЗаписей - РегистрСведений.ПредметыПапкиВзаимодействий.НаборЗаписей - набор записей регистра, если он уже создан
//                 на момент вызова процедуры.
//
Процедура ЗаписатьПредметыПапкиВзаимодействий(Взаимодействие, Реквизиты, НаборЗаписей = Неопределено) Экспорт
	
	Папка                   = Реквизиты.Папка;
	Предмет                 = Реквизиты.Предмет;
	Рассмотрено             = Реквизиты.Рассмотрено;
	РассмотретьПосле        = Реквизиты.РассмотретьПосле;
	РассчитыватьРассмотрено = Реквизиты.РассчитыватьРассмотрено;
	
	СоздаватьИЗаписывать = (НаборЗаписей = Неопределено);
	
	Если Папка = Неопределено И Предмет = Неопределено И Рассмотрено = Неопределено 
		И РассмотретьПосле = Неопределено  Тогда
		
		Возврат;
		
	ИначеЕсли Папка = Неопределено ИЛИ Предмет = Неопределено ИЛИ Рассмотрено = Неопределено 
		ИЛИ РассмотретьПосле = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ПредметыПапкиВзаимодействий.Предмет,
		|	ПредметыПапкиВзаимодействий.ПапкаЭлектронногоПисьма,
		|	ПредметыПапкиВзаимодействий.Рассмотрено,
		|	ПредметыПапкиВзаимодействий.РассмотретьПосле
		|ИЗ
		|	РегистрСведений.ПредметыПапкиВзаимодействий КАК ПредметыПапкиВзаимодействий
		|ГДЕ
		|	ПредметыПапкиВзаимодействий.Взаимодействие = &Взаимодействие";
		
		Запрос.УстановитьПараметр("Взаимодействие", Взаимодействие);
		
		Результат = Запрос.Выполнить();
		Если НЕ Результат.Пустой() Тогда
			
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			
			Если Папка = Неопределено Тогда
				Папка = Выборка.ПапкаЭлектронногоПисьма;
			КонецЕсли;
			
			Если Предмет = Неопределено Тогда
				Предмет = Выборка.Предмет;
			КонецЕсли;
			
			Если Рассмотрено = Неопределено Тогда
				Рассмотрено = Выборка.Рассмотрено;
			КонецЕсли;
			
			Если РассмотретьПосле = Неопределено Тогда
				РассмотретьПосле = Выборка.РассмотретьПосле;
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей = СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Взаимодействие.Установить(Взаимодействие);
	КонецЕсли;
	Запись = НаборЗаписей.Добавить();
	Запись.Взаимодействие          = Взаимодействие;
	Запись.Предмет                 = Предмет;
	Запись.ПапкаЭлектронногоПисьма = Папка;
	Запись.Рассмотрено             = Рассмотрено;
	Запись.РассмотретьПосле        = РассмотретьПосле;
	НаборЗаписей.ДополнительныеСвойства.Вставить("РассчитыватьРассмотрено", РассчитыватьРассмотрено);
	
	Если СоздаватьИЗаписывать Тогда
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаблокироватьПредметыПапокВзаимодействий(Блокировка, Взаимодействия) Экспорт
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПредметыПапкиВзаимодействий"); 
	Если ТипЗнч(Взаимодействия) = Тип("Массив") Тогда
		Для каждого ВзаимодействиеСсылка Из Взаимодействия Цикл
			ЭлементБлокировки.УстановитьЗначение("Взаимодействие", ВзаимодействиеСсылка);
		КонецЦикла	
	Иначе
		ЭлементБлокировки.УстановитьЗначение("Взаимодействие", Взаимодействия);
	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаблокироватьПредметыПапок(Блокировка, ИсточникДанных, ИмяПолеИсточника) Экспорт
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПредметыПапкиВзаимодействий"); 
	ЭлементБлокировки.ИсточникДанных = ИсточникДанных;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Взаимодействие", ИмяПолеИсточника);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
