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
	ЕстьБазоваяФункциональность = ОценкаПроизводительностиСлужебный.ПодсистемаСуществует("СтандартныеПодсистемы.БазоваяФункциональность");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗагрузитьПрофильКлючевыхОпераций(Команда)
	
	Если ЕстьБазоваяФункциональность Тогда
		МодульФайловаяСистемаКлиент = Вычислить("ФайловаяСистемаКлиент");
		Если ТипЗнч(МодульФайловаяСистемаКлиент) = Тип("ОбщийМодуль") Тогда
			ПараметрыЗагрузки = МодульФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
			ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите файл профиля ключевых операций'");
			ПараметрыЗагрузки.Диалог.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ДиалогВыбораФайлаЗавершение", ЭтотОбъект, Неопределено);
			МодульФайловаяСистемаКлиент.ЗагрузитьФайл(ОписаниеОповещения, ПараметрыЗагрузки);
		КонецЕсли;
	Иначе          		
		ДополнительныеПараметры = Новый Структура("Режим, Заголовок, ОповещениеОЗакрытии",  
		РежимДиалогаВыбораФайла.Открытие, 
		НСтр("ru = 'Выберите файл профиля ключевых операций'"),
		Новый ОписаниеОповещения("ДиалогВыбораФайлаЗавершение", ЭтотОбъект, Неопределено));  
		#Если ВебКлиент Тогда
			Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект,
			Новый ОписаниеОповещения("ДиалогВыбораФайлаПоказать", ЭтотОбъект, ДополнительныеПараметры));
			НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
		#Иначе
			ДиалогВыбораФайлаПоказать(Истина, ДополнительныеПараметры);
		#КонецЕсли  		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьПрофильКлючевыхОпераций(Команда)
	
	Если ЕстьБазоваяФункциональность Тогда
		МодульФайловаяСистемаКлиент = Вычислить("ФайловаяСистемаКлиент");
		Если ТипЗнч(МодульФайловаяСистемаКлиент) = Тип("ОбщийМодуль") Тогда
			ПараметрыСохранения = МодульФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
			ПараметрыСохранения.Диалог.Заголовок = НСтр("ru = 'Сохранить профиль ключевых операций в файл'");
			ПараметрыСохранения.Диалог.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";  		
			МодульФайловаяСистемаКлиент.СохранитьФайл(Новый ОписаниеОповещения("ДиалогСохраненияФайлаЗавершение", ЭтотОбъект, Неопределено), СохранитьПрофильКлючевыхОперацийНаСервере(), , ПараметрыСохранения);
		КонецЕсли;
	Иначе              		
		ДополнительныеПараметры = Новый Структура("Режим, Заголовок, ОповещениеОЗакрытии",  
			РежимДиалогаВыбораФайла.Сохранение, 
			НСтр("ru = 'Сохранить профиль ключевых операций в файл'"),
			Новый ОписаниеОповещения("ДиалогСохраненияФайлаЗавершение", ЭтотОбъект, Неопределено));  
		#Если ВебКлиент Тогда
		Оповещение = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект,
			Новый ОписаниеОповещения("ДиалогВыбораФайлаПоказать", ЭтотОбъект, ДополнительныеПараметры));
		НачатьПодключениеРасширенияРаботыСФайлами(Оповещение);
		#Иначе
			ДиалогВыбораФайлаПоказать(Истина, ДополнительныеПараметры);
		#КонецЕсли     		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Заполнить(Команда)
	ЗаполнитьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДиалогВыбораФайлаПоказать(Результат, ДополнительныеПараметры) Экспорт
	Если Результат Тогда
		ДиалогВыбора = Новый ДиалогВыбораФайла(ДополнительныеПараметры.Режим);
		ДиалогВыбора.Заголовок = ДополнительныеПараметры.Заголовок;
		ДиалогВыбора.Фильтр = "Файлы профиля ключевых операций (*.xml)|*.xml";
		Если ДополнительныеПараметры.Режим = РежимДиалогаВыбораФайла.Открытие Тогда
			НачатьПомещениеФайлов(ДополнительныеПараметры.ОповещениеОЗакрытии,, ДиалогВыбора, Истина, ЭтотОбъект.УникальныйИдентификатор);
		ИначеЕсли ДополнительныеПараметры.Режим = РежимДиалогаВыбораФайла.Сохранение Тогда
			Получаемые = Новый Массив;
			Получаемые.Добавить(Новый ОписаниеПередаваемогоФайла("", СохранитьПрофильКлючевыхОперацийНаСервере()));
			НачатьПолучениеФайлов(ДополнительныеПараметры.ОповещениеОЗакрытии, Получаемые, ДиалогВыбора, Истина);
		КонецЕсли;
		
	Иначе
		СообщитьПользователю(НСтр("ru = 'Без расширения работы с файлами невозможно работать с файлами.'"), "Объект");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораФайлаЗавершение(ВыбранныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЕстьБазоваяФункциональность Тогда		
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			ФайлИмя = Новый Файл(ВыбранныйФайл.Имя);
			Объект.Наименование = ФайлИмя.ИмяБезРасширения;
		КонецЕсли;
		ЗагрузитьПрофильКлючевыхОперацийНаСервере(ВыбранныйФайл.Хранение);		
	Иначе
		Если НЕ ЗначениеЗаполнено(Объект.Наименование) Тогда
			ФайлИмя = Новый Файл(ВыбранныйФайл[0].Имя);
			Объект.Наименование = ФайлИмя.ИмяБезРасширения;
		КонецЕсли;
			
		ЗагрузитьПрофильКлючевыхОперацийНаСервере(ВыбранныйФайл[0].Хранение);				
	КонецЕсли;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогСохраненияФайлаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
    
	Состояние(НСтр("ru = 'Сохранение файлов завершено.'"));
    
КонецПроцедуры

&НаКлиенте
Процедура НачатьПодключениеРасширенияРаботыСФайламиЗавершение(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если РасширениеПодключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры, Истина);
		Возврат;
	КонецЕсли;
	
	Если Не ЗаданВопросОбУстановкеРасширения Тогда
		ЗаданВопросОбУстановкеРасширения = Истина;
		ОписаниеОповещенияВопрос = Новый ОписаниеОповещения("ВопросОбУстановкеРасширения", ЭтотОбъект, ДополнительныеПараметры);
		НачатьУстановкуРасширенияРаботыСФайлами(ОписаниеОповещенияВопрос );
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры, РасширениеПодключено);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбУстановкеРасширения(Оповещение) Экспорт
	
	ОповещениеПроверки = Новый ОписаниеОповещения("НачатьПодключениеРасширенияРаботыСФайламиЗавершение", ЭтотОбъект,
			Новый ОписаниеОповещения("ДиалогВыбораФайлаПоказать", ЭтотОбъект, Оповещение));
	НачатьПодключениеРасширенияРаботыСФайлами(ОповещениеПроверки);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщитьПользователю(ТекстСообщения, ПутьКДанным = "")
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщения;
	Сообщение.ПутьКДанным = ПутьКДанным;
	Сообщение.Сообщить();
	
КонецПроцедуры


&НаСервере
Функция СохранитьПрофильКлючевыхОперацийНаСервере()
    
    ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
    
    ЗаписьXML = Новый ЗаписьXML;
    ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла);
    
    ЗаписьXML.ЗаписатьНачалоЭлемента("Items");
    ЗаписьXML.ЗаписатьАтрибут("Description", Объект.Наименование);
    ЗаписьXML.ЗаписатьАтрибут("Columns", "Имя,ЦелевоеВремя,Важность");
    
    Для Каждого ТекСтрока Из Объект.КлючевыеОперацииПрофиля Цикл
        ЗаписьXML.ЗаписатьНачалоЭлемента("Item");
        ЗаписьXML.ЗаписатьАтрибут("Имя", ТекСтрока.КлючеваяОперация.Имя);
        ЗаписьXML.ЗаписатьАтрибут("ЦелевоеВремя", Формат(ТекСтрока.ЦелевоеВремя, "ЧГ=0"));
        ЗаписьXML.ЗаписатьАтрибут("Важность", Формат(ТекСтрока.Приоритет, "ЧГ=0"));
        ЗаписьXML.ЗаписатьКонецЭлемента();
    КонецЦикла;
        
    ЗаписьXML.ЗаписатьКонецЭлемента();
    
    ЗаписьXML.Закрыть();
    
    ДвоичныеДанные = Новый ДвоичныеДанные(ИмяВременногоФайла);
    АдресХранилища = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
    
    УдалитьФайлы(ИмяВременногоФайла);
    
    Возврат АдресХранилища;
    
КонецФункции

&НаСервере
Процедура ЗагрузитьПрофильКлючевыхОперацийНаСервере(АдресХранилища)
    
    ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища); // ДвоичныеДанные
        
    ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
    ДвоичныеДанные.Записать(ИмяВременногоФайла);
    
    ЧтениеXML = Новый ЧтениеXML;
    ЧтениеXML.ОткрытьФайл(ИмяВременногоФайла);
    КлючевыеОперации = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML);
    
    Колонки = СтрРазделить(КлючевыеОперации["Columns"], ",",Ложь);
    Если КлючевыеОперации.Свойства().Получить("Item") <> Неопределено Тогда
	    Если ТипЗнч(КлючевыеОперации["Item"]) = Тип("ОбъектXDTO") Тогда
	        ЗагрузитьОбъектXDTO(КлючевыеОперации["Item"], Колонки);
	    Иначе
	        Для Каждого ТекЭлемент Из КлючевыеОперации["Item"] Цикл
	            ЗагрузитьОбъектXDTO(ТекЭлемент, Колонки);
	        КонецЦикла;
		КонецЕсли;
	КонецЕсли;
            
    ЧтениеXML.Закрыть();
    УдалитьФайлы(ИмяВременногоФайла);
    
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьОбъектXDTO(ОбъектXDTO, Колонки)
    
    ТекЭлемент = ОбъектXDTO;
	
	КлючеваяОперация = Справочники.КлючевыеОперации.НайтиПоРеквизиту("Имя", ТекЭлемент.Имя);
	Если КлючеваяОперация.Пустая() Тогда
		КлючеваяОперация = ОценкаПроизводительности.СоздатьКлючевуюОперацию(ТекЭлемент.Имя);
	КонецЕсли;
    ПараметрыОтбора = Новый Структура("КлючеваяОперация", КлючеваяОперация);
    НайденныеСтроки = Объект.КлючевыеОперацииПрофиля.НайтиСтроки(ПараметрыОтбора);
    
    Если НайденныеСтроки.Количество() = 0 Тогда
        
        НовСтрока = Объект.КлючевыеОперацииПрофиля.Добавить();
		НовСтрока.КлючеваяОперация = КлючеваяОперация;
        
		Для Каждого ТекКолонка Из Колонки Цикл
			ИмяКолонки = ?(ТекКолонка = "Важность", "Приоритет", ТекКолонка);
            Если НовСтрока.Свойство(ИмяКолонки) И ТекЭлемент.Свойства().Получить(ТекКолонка) <> Неопределено Тогда
                НовСтрока[ИмяКолонки] = ТекЭлемент[ТекКолонка];
            КонецЕсли;
        КонецЦикла;
        
        Если НЕ ЗначениеЗаполнено(НовСтрока.Приоритет) Тогда
            НовСтрока.Приоритет = 5;
        КонецЕсли;
    Иначе
        Для Каждого НовСтрока Из НайденныеСтроки Цикл
			Для Каждого ТекКолонка Из Колонки Цикл
				ИмяКолонки = ?(ТекКолонка = "Важность", "Приоритет", ТекКолонка);
                Если НовСтрока.Свойство(ИмяКолонки) И ТекЭлемент.Свойства().Получить(ТекКолонка) <> Неопределено Тогда
                    НовСтрока[ИмяКолонки] = ТекЭлемент[ТекКолонка];
                КонецЕсли;
            КонецЦикла;
        КонецЦикла;
    КонецЕсли;
    
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНаСервере()
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	КлючевыеОперации.Ссылка КАК КлючеваяОперация,
	                      |	КлючевыеОперации.ЦелевоеВремя КАК ЦелевоеВремя,
	                      |	ВЫБОР
	                      |		КОГДА КлючевыеОперации.Приоритет = 0
	                      |			ТОГДА 5
	                      |		ИНАЧЕ КлючевыеОперации.Приоритет
	                      |	КОНЕЦ КАК Приоритет
	                      |ИЗ
	                      |	Справочник.КлючевыеОперации КАК КлючевыеОперации
	                      |ГДЕ
	                      |	НЕ КлючевыеОперации.ПометкаУдаления
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	КлючевыеОперации.Наименование");
	Объект.КлючевыеОперацииПрофиля.Загрузить(Запрос.Выполнить().Выгрузить());
КонецПроцедуры

#КонецОбласти
