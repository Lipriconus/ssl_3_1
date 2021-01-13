﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// См. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов
// 
// Параметры:
//  Настройки - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНастройкеНачальногоЗаполненияЭлементов.Настройки
//
Процедура ПриНастройкеНачальногоЗаполненияЭлементов(Настройки) Экспорт

	Настройки.ПриНачальномЗаполненииЭлемента = Ложь;

КонецПроцедуры

// См. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов
// 
// Параметры:
//   КодыЯзыков - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.КодыЯзыков
//   Элементы - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.Элементы
//   ТабличныеЧасти - см. ОбновлениеИнформационнойБазыПереопределяемый.ПриНачальномЗаполненииЭлементов.ТабличныеЧасти
//
Процедура ПриНачальномЗаполненииЭлементов(КодыЯзыков, Элементы, ТабличныеЧасти) Экспорт

	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ФормаНапечатана";
	Элемент.Наименование = НСтр("ru='Форма напечатана'",ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Описание = НСтр("ru='Состояние, означающее, что  печатная форма только печаталась.'") ;
	Элемент.Код = "000000001";
	Элемент.РеквизитДопУпорядочивания = "1";

	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОригиналыНеВсе";
	Элемент.Наименование = НСтр("ru='Оригиналы не все'",ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Описание = НСтр("ru='Общее состояние для документа, у которого оригиналы печатных форм находятся в разных состояниях.'");
	Элемент.Код = "000000002";
	Элемент.РеквизитДопУпорядочивания = "99998";

	Элемент = Элементы.Добавить();
	Элемент.ИмяПредопределенныхДанных = "ОригиналПолучен";
	Элемент.Наименование = НСтр("ru='Оригинал получен'",ОбщегоНазначения.КодОсновногоЯзыка());
	Элемент.Описание = НСтр("ru='Состояние, означающее, что подписанный оригинал печатной формы есть в наличии.'");
	Элемент.Код = "000000003";
	Элемент.РеквизитДопУпорядочивания = "99999";

КонецПроцедуры

#КонецОбласти

#КонецЕсли

