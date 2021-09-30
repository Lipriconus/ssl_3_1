﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  Идентификатор - Строка
//  Версия - Строка
//         - Неопределено
//  ПутьКМакетуДляПоискаПоследнейВерсии - Неопределено, Строка
//
// Возвращаемое значение:
//   см. ВнешниеКомпонентыСлужебный.ИнформацияОСохраненнойКомпоненте
//
Функция ИнформацияОСохраненнойКомпоненте(Идентификатор, Версия = Неопределено, ПутьКМакетуДляПоискаПоследнейВерсии = Неопределено) Экспорт
	
	Результат = ВнешниеКомпонентыСлужебный.ИнформацияОСохраненнойКомпоненте(Идентификатор, Версия, ПутьКМакетуДляПоискаПоследнейВерсии);
	Если Результат.Состояние = "НайденаВХранилище" Или Результат.Состояние = "НайденаВОбщемХранилище" Тогда 
		Версия = Результат.Реквизиты.Версия;
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для идентификатора %1 (версия %2) получена внешняя компонента %3 (версия %4).
			|Состояние: %5'"), 
			Идентификатор, ?(Версия <> Неопределено, Версия, НСтр("ru = 'не указана'")), Результат.Реквизиты.Наименование, 
			Результат.Реквизиты.Версия, Результат.Состояние);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Внешние компоненты'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,, Результат.Ссылка, ТекстСообщения);
	Иначе
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для идентификатора %1 (версия %2) не удалось получить внешнюю компоненту.
			|Состояние: %3'"),
			Идентификатор, ?(Версия <> Неопределено, Версия, НСтр("ru = 'не указана'")), Результат.Состояние);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Внешние компоненты'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Предупреждение,,, ТекстСообщения);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

// Имя файла компоненты для сохранения в файл.
//
Функция ИмяФайлаКомпоненты(Ссылка) Экспорт 
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "ИмяФайла");
	
КонецФункции

#КонецОбласти

