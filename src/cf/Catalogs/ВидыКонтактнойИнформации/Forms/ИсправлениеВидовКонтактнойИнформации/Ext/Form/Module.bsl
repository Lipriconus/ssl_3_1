﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИдентификаторПроверки = Параметры.ИдентификаторПроверки;
	УстановитьТекущуюСтраницу(ЭтотОбъект, "Вопрос");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсправитьПроблему(Команда)
	
	ДлительнаяОперация = ИсправитьПроблемуВФоне(ИдентификаторПроверки);
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ИсправитьПроблемуВФонеЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьТекущуюСтраницу(Форма, ИмяСтраницы)
	
	ЭлементыФормы = Форма.Элементы;
	Если ИмяСтраницы = "ИдетИсправлениеПроблемы" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Истина;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
		ЭлементыФормы.ИсправитьПроблему.Видимость                  = Ложь;
	ИначеЕсли ИмяСтраницы = "ИсправлениеУспешноВыполнено" Тогда
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Ложь;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Истина;
		ЭлементыФормы.ИсправитьПроблему.Видимость                  = Ложь;
		ЭлементыФормы.Закрыть.КнопкаПоУмолчанию                    = Истина;
	Иначе // "Вопрос"
		ЭлементыФормы.ГруппаИндикаторИсправления.Видимость         = Ложь;
		ЭлементыФормы.ГруппаИндикаторНачалаИсправления.Видимость   = Истина;
		ЭлементыФормы.ГруппаИндикаторУспешноеИсправление.Видимость = Ложь;
		ЭлементыФормы.ИсправитьПроблему.Видимость                  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ИсправитьПроблемуВФоне(ИдентификаторПроверки)
	
	Если ДлительнаяОперация <> Неопределено Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ДлительнаяОперация.ИдентификаторЗадания);
	КонецЕсли;
	
	УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Исправление видов контактной информации'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("УправлениеКонтактнойИнформациейСлужебный.ИсправитьВидыКонтактнойИнформацииВФоне",
		Новый Структура("ИдентификаторПроверки", ИдентификаторПроверки), ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ИсправитьПроблемуВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ДлительнаяОперация = Неопределено;

	Если Результат = Неопределено Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИдетИсправлениеПроблемы");
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		УстановитьТекущуюСтраницу(ЭтотОбъект, "Вопрос");
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	ИначеЕсли Результат.Статус = "Выполнено" Тогда
		Результат = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Элементы.ТекстИтогиИсправления.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				Элементы.ТекстИтогиИсправления.Заголовок, Результат.ИсправленоОбъектов, Результат.ВсегоОбъектов);
		КонецЕсли;
		УстановитьТекущуюСтраницу(ЭтотОбъект, "ИсправлениеУспешноВыполнено");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти