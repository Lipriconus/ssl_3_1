﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Возвращает основной производственный календарь, используемый в учете.
//
// Возвращаемое значение:
//   СправочникСсылка.ПроизводственныеКалендари, Неопределено - основной производственный календарь или 
//                                                              Неопределено, в случае если он не обнаружен.
//
Функция ОсновнойПроизводственныйКалендарь() Экспорт
	
	// Производственный календарь, составленный в соответствии с ст. 112 ТК РФ.
	ПроизводственныйКалендарь = Справочники.ПроизводственныеКалендари.НайтиПоКоду("РФ");
	Если ПроизводственныйКалендарь.Пустая() Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Возврат ПроизводственныйКалендарь;
	
КонецФункции

Функция РегиональныйПроизводственныйКалендарь(КПП) Экспорт
	
	Если Не ЗначениеЗаполнено(КПП) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	РегиональныйКалендарь = Справочники.ПроизводственныеКалендари.НайтиПоКоду(Лев(СокрЛП(КПП), 2));
	
	Если РегиональныйКалендарь.Пустая() Тогда
		Возврат ОсновнойПроизводственныйКалендарь();
	КонецЕсли;
	
	Возврат РегиональныйКалендарь;
	
КонецФункции

Функция ВерсияКалендарей() Экспорт
	
	Возврат 4;
	
КонецФункции

Функция ВерсияОбновленияПроизводственныхКалендарей() Экспорт
	
	Возврат "3.1.2.383";
	
КонецФункции

Функция ВерсияОбновленияДанныхПроизводственныхКалендарей() Экспорт
	
	Возврат "3.1.2.366";
	
КонецФункции

Функция ПериодыНерабочихДней(ПроизводственныйКалендарь, Период) Экспорт

	Периоды = Новый Массив;
	
	ТаблицаПериодов = РегистрыСведений.ПериодыНерабочихДнейКалендаря.ПериодыНерабочихДней(ПроизводственныйКалендарь);
	Для Каждого СтрокаТаблицы Из ТаблицаПериодов Цикл
		Периоды.Добавить(
			ОписаниеПериодаНерабочихДней(
				СтрокаТаблицы.ДатаНачала, СтрокаТаблицы.ДатаОкончания, СтрокаТаблицы.Основание, СтрокаТаблицы.НомерПериода));
	КонецЦикла;

	Возврат Периоды;

КонецФункции

// Заполняет даты праздничных дней по производственному календарю для конкретного календарного года.
// 
// Параметры:
//   КодПроизводственногоКалендаря - Строка - код производственного календаря.
//   НомерГода                     - Число  - номер года, для которого требуется заполнить праздничные дни.
//   ПраздничныеДни                - ТаблицаЗначений - заполняет переданную таблицу с колонками:
//     * Дата               - Дата   - календарная дата праздничного дня.
//     * ПереноситьВыходной - Булево - Истина, если нужен перенос праздничного дня, если он приходится на выходной.
//
Процедура ЗаполнитьПраздничныеДни(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни) Экспорт
	
	ЗаполнитьПраздничныеДниРоссийскаяФедерация(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиАдыгея(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиБашкортостан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиБурятия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиДагестан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниКабардиноБалкарскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиКалмыкия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниКарачаевоЧеркесскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиКоми(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиСахаЯкутия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиТатарстан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиТыва(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниЧеченскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниЧувашскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниСтавропольскогоКрая(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниПензенскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниСаратовскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниЗабайкальскогоКрая(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниУстьОрдынскогоБурятскогоОкругаИркутскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниРеспубликиКрым(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	ЗаполнитьПраздничныеДниСевастополя(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРоссийскаяФедерация(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "РФ" Тогда
		Возврат;
	КонецЕсли;
		
	ДобавитьПраздничныеДниРоссийскойФедерации(НомерГода, ПраздничныеДни);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиАдыгея(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "01" Тогда
		Возврат;
	КонецЕсли;
		
	// 5 октября - День образования Республики Адыгея.
	ДобавитьПраздничныйДень(ПраздничныеДни, 5, 10, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиБашкортостан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "02" Тогда
		Возврат;
	КонецЕсли;
	
	// 11 октября - День Республики - 
	// День принятия Декларации о государственном суверенитете Башкирской Советской Социалистической Республики.
	ДобавитьПраздничныйДень(ПраздничныеДни, 11, 10, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиБурятия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "03" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникЦаганСар(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиДагестан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "05" Тогда
		Возврат;
	КонецЕсли;
	
	// 26 июля - День Конституции.
	ДобавитьПраздничныйДень(ПраздничныеДни, 26, 7, НомерГода);
	
	// 15 сентября - День единства народов Дагестана.
	ДобавитьПраздничныйДень(ПраздничныеДни, 15, 9, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниКабардиноБалкарскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "07" Тогда
		Возврат;
	КонецЕсли;
	
	// 28 марта - День возрождения балкарского народа.
	ДобавитьПраздничныйДень(ПраздничныеДни, 28, 3, НомерГода, Ложь, Ложь);
	
	// 21 мая - День памяти адыгов (черкесов) - жертв Русско-Кавказской войны.
	ДобавитьПраздничныйДень(ПраздничныеДни, 21, 5, НомерГода, Ложь, Ложь);
	
	// 1 сентября - День государственности Кабардино-Балкарской Республики (День Республики).
	ДобавитьПраздничныйДень(ПраздничныеДни, 1, 9, НомерГода, Ложь, Ложь);
	
	// 20 сентября - День адыгов (черкесов).
	ДобавитьПраздничныйДень(ПраздничныеДни, 20, 9, НомерГода, Ложь, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиКалмыкия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "08" Тогда
		Возврат;
	КонецЕсли;
	
	// 5 апреля - День принятия Степного Уложения (Конституции).
	ДобавитьПраздничныйДень(ПраздничныеДни, 5, 4, НомерГода);
	
	// 28 декабря - День памяти жертв депортации калмыцкого народа.
	ДобавитьПраздничныйДень(ПраздничныеДни, 28, 12, НомерГода, Ложь, Ложь, Истина);
	
	ДобавитьПраздникЦаганСар(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниКарачаевоЧеркесскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "09" Тогда
		Возврат;
	КонецЕсли;
	
	// 3 мая - День возрождения карачаевского народа.
	ДобавитьПраздничныйДень(ПраздничныеДни, 3, 5, НомерГода);
	
	Если НомерГода >= 2017 Тогда
		ДобавитьПраздникРадоница(ПраздничныеДни, НомерГода, Ложь, Ложь, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиКоми(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "11" Тогда
		Возврат;
	КонецЕсли;
	
	// 22 августа - День Республики Коми.
	ДобавитьПраздничныйДень(ПраздничныеДни, 22, 8, НомерГода, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиСахаЯкутия(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "14" Тогда
		Возврат;
	КонецЕсли;
	
	// 27 апреля - День Республики Саха (Якутия).
	ДобавитьПраздничныйДень(ПраздничныеДни, 27, 4, НомерГода);
	
	// 21 июня - День национального праздника "Ысыах".
	ДобавитьПраздничныйДень(ПраздничныеДни, 21, 6, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиТатарстан(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "16" Тогда
		Возврат;
	КонецЕсли;
	
	// 30 августа - День Республики Татарстан.
	ДобавитьПраздничныйДень(ПраздничныеДни, 30, 8, НомерГода, Ложь);
	
	// 6 ноября - День Конституции Республики Татарстан.
	ДобавитьПраздничныйДень(ПраздничныеДни, 6, 11, НомерГода, Ложь);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиТыва(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "17" Тогда
		Возврат;
	КонецЕсли;
	
	// 6 мая - День Конституции.
	ДобавитьПраздничныйДень(ПраздничныеДни, 6, 5, НомерГода);
	
	// 15 августа - День Республики.
	ДобавитьПраздничныйДень(ПраздничныеДни, 15, 8, НомерГода);
	
	ДобавитьПраздникЦаганСар(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниЧеченскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "20" Тогда
		Возврат;
	КонецЕсли;
	
	// 23 марта - День Конституции.
	ДобавитьПраздничныйДень(ПраздничныеДни, 23, 3, НомерГода);
	
	// 16 апреля - День мира.
	ДобавитьПраздничныйДень(ПраздничныеДни, 16, 4, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниЧувашскойРеспублики(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "21" Тогда
		Возврат;
	КонецЕсли;
	
	// 24 июня - День республики.
	ДобавитьПраздничныйДень(ПраздничныеДни, 24, 6, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниСтавропольскогоКрая(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "26" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникРадоница(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниЗабайкальскогоКрая(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "75" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникЦаганСар(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниУстьОрдынскогоБурятскогоОкругаИркутскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "85" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникЦаганСар(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниПензенскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "58" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникРадоница(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниСаратовскойОбласти(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "64" Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздникРадоница(ПраздничныеДни, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниРеспубликиКрым(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "91" Тогда
		Возврат;
	КонецЕсли;
	
	// 18 марта - День воссоединения Крыма с Россией.
	ДобавитьПраздничныйДень(ПраздничныеДни, 18, 3, НомерГода);
	
КонецПроцедуры

Процедура ЗаполнитьПраздничныеДниСевастополя(КодПроизводственногоКалендаря, НомерГода, ПраздничныеДни)
	
	Если КодПроизводственногоКалендаря <> "92" Тогда
		Возврат;
	КонецЕсли;
	
	// 18 марта - День воссоединения Крыма с Россией.
	Если НомерГода < 2020 Тогда
		// Отменен с 2020 года.
		ДобавитьПраздничныйДень(ПраздничныеДни, 18, 3, НомерГода);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПраздничныеДниРоссийскойФедерации(НомерГода, ПраздничныеДни)
		
	// 1, 2, 3, 4, 5, 6 и 8 января - Новогодние каникулы.
	ДобавитьПраздничныйДень(ПраздничныеДни, 1, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 2, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 3, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 4, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 5, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 6, 1, НомерГода, Ложь);
	ДобавитьПраздничныйДень(ПраздничныеДни, 8, 1, НомерГода, Ложь);
	
	// 7 января - Рождество Христово.
	ДобавитьПраздничныйДень(ПраздничныеДни, 7, 1, НомерГода, Ложь);
	
	// 23 февраля - День защитника Отечества.
	ДобавитьПраздничныйДень(ПраздничныеДни, 23, 2, НомерГода);
	
	// 8 марта - Международный женский день.
	ДобавитьПраздничныйДень(ПраздничныеДни, 8, 3, НомерГода);
	
	// 1 мая - Праздник Весны и Труда.
	ДобавитьПраздничныйДень(ПраздничныеДни, 1, 5, НомерГода);
	
	// 9 мая - День Победы
	ДобавитьПраздничныйДень(ПраздничныеДни, 9, 5, НомерГода);
	
	// 12 июня - День России
	ДобавитьПраздничныйДень(ПраздничныеДни, 12, 6, НомерГода);
	
	// 4 ноября - День народного единства.
	ДобавитьПраздничныйДень(ПраздничныеДни, 4, 11, НомерГода);
	
КонецПроцедуры

Процедура ДобавитьПраздничныйДень(ПраздничныеДни, День, Месяц, Год, ПереноситьВыходной = Истина, ДобавлятьПредпраздничный = Истина, ТолькоНерабочий = Ложь) 
	
	НоваяСтрока = ПраздничныеДни.Добавить();
	НоваяСтрока.Дата = Дата(Год, Месяц, День);
	НоваяСтрока.ПереноситьВыходной = ПереноситьВыходной;
	НоваяСтрока.ДобавлятьПредпраздничный = ДобавлятьПредпраздничный;
	НоваяСтрока.ТолькоНерабочий = ТолькоНерабочий;
	
КонецПроцедуры

Процедура ДобавитьПраздникЦаганСар(ПраздничныеДни, Год, ПереноситьВыходной = Истина, ДобавлятьПредпраздничный = Истина, ТолькоНерабочий = Ложь)
	
	ДатаЦаганСар = ДатаПраздникаЦаганСар(Год);
	Если ДатаЦаганСар = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздничныйДень(ПраздничныеДни, День(ДатаЦаганСар), Месяц(ДатаЦаганСар), Год, ПереноситьВыходной, ДобавлятьПредпраздничный, ТолькоНерабочий);
	
КонецПроцедуры

Функция ДатаПраздникаЦаганСар(НомерГода)
	
	ТекстовыйДокумент = ПолучитьМакет("ДатыЦаганСар");
	ДатыЦаганСар = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	ОтборСтрок = Новый Структура("Year");
	ОтборСтрок.Year = Формат(НомерГода, "ЧГ=");
	
	НайденныеСтроки = ДатыЦаганСар.НайтиСтроки(ОтборСтрок);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Дата(НайденныеСтроки[0]["Date"]);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Процедура ДобавитьПраздникРадоница(ПраздничныеДни, Год, ПереноситьВыходной = Истина, ДобавлятьПредпраздничный = Истина, ТолькоНерабочий = Ложь)
	
	ДатаРадоницы = ДатаПраздникаРадоница(Год);
	Если ДатаРадоницы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДобавитьПраздничныйДень(ПраздничныеДни, День(ДатаРадоницы), Месяц(ДатаРадоницы), Год, ПереноситьВыходной, ДобавлятьПредпраздничный, ТолькоНерабочий);
	
КонецПроцедуры

Функция ДатаПраздникаРадоница(НомерГода)
	
	ТекстовыйДокумент = ПолучитьМакет("ДатыРадоница");
	ДатыЦаганСар = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ТекстовыйДокумент.ПолучитьТекст()).Данные;
	
	ОтборСтрок = Новый Структура("Year");
	ОтборСтрок.Year = Формат(НомерГода, "ЧГ=");
	
	НайденныеСтроки = ДатыЦаганСар.НайтиСтроки(ОтборСтрок);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат Дата(НайденныеСтроки[0]["Date"]);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ОписаниеПериодаНерабочихДней(Начало, Окончание, Основание = "", Номер = 0)
	
	ОбщегоНазначенияКлиентСервер.Проверить(Начало <= Окончание, НСтр("ru = 'Начало периода позже его завершения'"));
	
	ОписаниеПериода = Новый Структура("Номер, Период, Основание, Даты, Представление");
	ОписаниеПериода.Номер = Номер;
	ОписаниеПериода.Период = Новый СтандартныйПериод(Начало, Окончание);
	ОписаниеПериода.Основание = Основание;
	ОписаниеПериода.Даты = Новый Массив;
	ОписаниеПериода.Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'с %1 по %2 - %3'"), Формат(Начало, "ДЛФ=D;"), Формат(Окончание, "ДЛФ=D;"), ОписаниеПериода.Основание);
	
	ДатаОбхода = НачалоДня(Начало);
	Пока ДатаОбхода <= Окончание Цикл
		ОписаниеПериода.Даты.Добавить(ДатаОбхода);
		ДатаОбхода = ДатаОбхода + 86400;
	КонецЦикла;
	
	Возврат ОписаниеПериода;
	
КонецФункции

#КонецОбласти

#КонецЕсли