﻿
////////////////////////////////////////////////////////////////////////////////
//  Методы, позволяющие начать и закончить замер времени выполнения ключевой операции
//  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Активизирует замер времени выполнения ключевой операции.
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция. 
//  При вызове с сервера аргумент игнорируется.
//
// Возвращаемое значение:
//  Дата или число - время начала с точностью до миллисекунд или секунд в зависимости от версии платформы.
//
Функция НачатьЗамерВремени(Знач КлючеваяОперация = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	Если ТипЗнч(КлючеваяОперация) = Тип("Строка") Тогда		
		КлючеваяОперацияСсылка = Справочники.КлючевыеОперации.НайтиПоНаименованию(КлючеваяОперация);
		Если НЕ ЗначениеЗаполнено(КлючеваяОперацияСсылка) Тогда
			КлючеваяОперацияСсылка = Справочники.КлючевыеОперации.СоздатьЭлемент();
			КлючеваяОперацияСсылка.Наименование = СокрЛП(КлючеваяОперация);
			КлючеваяОперацияСсылка.Использовать = Истина;
			КлючеваяОперацияСсылка.Записать();
			
			КлючеваяОперацияСсылка = КлючеваяОперацияСсылка.Ссылка;
		КонецЕсли;
		
		КлючеваяОперация = КлючеваяОперацияСсылка;
	КонецЕсли;	
	
	ВремяНачала = 0;
	ДатаНачала = 0;
	Если КлючеваяОперация.Использовать 
		И  ОценкаПроизводительностиПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		
		ДатаНачала = ЗначениеТаймера(Ложь);
		ВремяНачала = ЗначениеТаймера();
		#Если Клиент Тогда
			Если КлючеваяОперация = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Не указана ключевая операция.'");
			КонецЕсли;
			Если ОценкаПроизводительностиЗамерВремени = Неопределено Тогда
				ОценкаПроизводительностиЗамерВремени = Новый Структура;
				ОценкаПроизводительностиЗамерВремени.Вставить("Замеры", Новый Соответствие);
				
				ТекущийПериодЗаписи = ОценкаПроизводительностиВызовСервераПолныеПрава.ПериодЗаписи();
				ОценкаПроизводительностиЗамерВремени.Вставить("ПериодЗаписи", ТекущийПериодЗаписи);
				
				ДатаИВремяНаСервере = ОценкаПроизводительностиВызовСервераПолныеПрава.ДатаИВремяНаСервере();
				ДатаИВремяНаКлиенте = ТекущаяДата();
				ОценкаПроизводительностиЗамерВремени.Вставить(
					"СмещениеДатыКлиента", 
					ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
				
				ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", ТекущийПериодЗаписи, Истина);
			КонецЕсли;
			Замеры = ОценкаПроизводительностиЗамерВремени["Замеры"]; 
			
			БуферКлючевойОперации = Замеры.Получить(КлючеваяОперация);
			Если БуферКлючевойОперации = Неопределено Тогда
				БуферКлючевойОперации = Новый Соответствие;
				Замеры.Вставить(КлючеваяОперация, БуферКлючевойОперации);
			КонецЕсли;
			
			СмещениеДатыКлиента = ОценкаПроизводительностиЗамерВремени["СмещениеДатыКлиента"];
			ДатаНачала = ДатаНачала + СмещениеДатыКлиента;
			НачатыйЗамер = БуферКлючевойОперации.Получить(ДатаНачала);
			Если НачатыйЗамер = Неопределено Тогда
				БуферЗамера = Новый Соответствие;
				БуферЗамера.Вставить("ВремяНачала", ВремяНачала);
				Если НЕ ДополнительныеПараметры = Неопределено
					И ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
					
					Если ДополнительныеПараметры.Свойство("Исполнитель") Тогда
						БуферЗамера.Вставить("Исполнитель", ДополнительныеПараметры.Исполнитель);
					КонецЕсли;
					
					Если ДополнительныеПараметры.Свойство("Ссылка") Тогда
						БуферЗамера.Вставить("Ссылка", ДополнительныеПараметры.Ссылка);
					КонецЕсли;
					
					Если ДополнительныеПараметры.Свойство("Комментарий") Тогда
						БуферЗамера.Вставить("Комментарий", ДополнительныеПараметры.Комментарий);
					КонецЕсли;						
				КонецЕсли;
				
				
				БуферКлючевойОперации.Вставить(ДатаНачала, БуферЗамера);
			КонецЕсли;
			
			ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);		
		#КонецЕсли
	КонецЕсли;
	
	Возврат Новый Структура("ВремяНачала,ДатаНачала", ВремяНачала, ДатаНачала);
	
КонецФункции

// Процедура завершает замер времени на сервере и записывает результат на сервере
// Параметры:
//  КлючеваяОперацияСсылка - СправочникСсылка.КлючевыеОперации
//  ВремяНачала - Число или Дата
Процедура ЗакончитьЗамерВремени(КлючеваяОперацияСсылка, ВремяНачалаЗамера, ДатаНачалаЗамера, СтруктураДополнительныхПараметров = Неопределено) Экспорт
	Если ОценкаПроизводительностиЗамерВремени = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если ВремяНачалаЗамера = Неопределено
		ИЛИ ДатаНачалаЗамера = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	ВремяОкончания = ЗначениеТаймера(); ДатаОкончания = ЗначениеТаймера(Ложь);		
	Длительность = (ВремяОкончания - ВремяНачалаЗамера);
	Если НЕ СтруктураДополнительныхПараметров = Неопределено
		И СтруктураДополнительныхПараметров.Свойство("Делитель") Тогда
		
		Длительность = Длительность / СтруктураДополнительныхПараметров.Делитель;
	КонецЕсли;	
	
	Буфер = ОценкаПроизводительностиЗамерВремени["Замеры"];
	Данные = Буфер.Получить(КлючеваяОперацияСсылка);
	Если Данные = Неопределено тогда
		Возврат;
	КонецЕсли;
		
	ДанныеТекущегоЗамера = Данные.Получить(ДатаНачалаЗамера);
	Если ДанныеТекущегоЗамера = Неопределено тогда
		Возврат;		
	КонецЕсли;
	
	ДанныеТекущегоЗамера.Вставить("Длительность", Длительность);
	ДанныеТекущегоЗамера.Вставить("ДатаОкончания", ДатаОкончания);	
	
	Если НЕ СтруктураДополнительныхПараметров = Неопределено
		И ТипЗнч(СтруктураДополнительныхПараметров) = Тип("Структура") тогда
		
		Если СтруктураДополнительныхПараметров.Свойство("Комментарий") тогда
			ДанныеТекущегоЗамера.Вставить("Комментарий", СтруктураДополнительныхПараметров.Комментарий);
		КонецЕсли;
		
		Если СтруктураДополнительныхПараметров.Свойство("Исполнитель") тогда
			ДанныеТекущегоЗамера.Вставить("Исполнитель", СтруктураДополнительныхПараметров.Исполнитель);
		КонецЕсли;
		
		Если СтруктураДополнительныхПараметров.Свойство("Ссылка") тогда
			ДанныеТекущегоЗамера.Вставить("Ссылка", СтруктураДополнительныхПараметров.Ссылка);
		КонецЕсли;		
		
		Если СтруктураДополнительныхПараметров.Свойство("ДанныеЗапроса") Тогда
			ДанныеТекущегоЗамера.Вставить("ДанныеЗапроса", 		Новый ХранилищеЗначения(СтруктураДополнительныхПараметров.ДанныеЗапроса, Новый СжатиеДанных(9))); 
			ДанныеТекущегоЗамера.Вставить("ЕстьДанныеЗапроса", 	Истина); 
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтменитьЗамерВремени(КлючеваяОперацияСсылка, ДатаНачалаЗамера) Экспорт
	Если ОценкаПроизводительностиЗамерВремени = Неопределено тогда
		Возврат;
	КонецЕсли;
	
	Если ДатаНачалаЗамера = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	
	Буфер = ОценкаПроизводительностиЗамерВремени["Замеры"];
	Данные = Буфер.Получить(КлючеваяОперацияСсылка);
	Если Данные = Неопределено тогда
		Возврат;
	КонецЕсли;		
	
	Данные.Удалить(ДатаНачалаЗамера);	
КонецПроцедуры



// Функция вызывается при старте замера времени и его завершении.
// ТекущаяДата вместо ТекущаяДатаСеанса используется осмысленно.
// Но нужно помнить, что если время начала замера получено на клиенте, 
// то и время конца замера нужно вычислять на клиенте. Для сервера то же самое.
//
// Возвращаемое значение:
//  Дата - время начала замера.
Функция ЗначениеТаймера(ВысокаяТочность = Истина) Экспорт
	
	Перем ЗначениеТаймера;
	Если ВысокаяТочность Тогда
		
		ЗначениеТаймера = Вычислить("ТекущаяУниверсальнаяДатаВМиллисекундах()")/1000.0;
		Возврат ЗначениеТаймера;
		
	Иначе
		
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		//Возврат ТекущаяДатаСеанса(); // ЛНА
		Возврат ТекущаяДатаНаСервере();
#Иначе
		Возврат ТекущаяДата();
#КонецЕсли
		
	КонецЕсли;
	
КонецФункции

// Ключ параметра регламентного задания, соответствующий локальному каталогу экспорта
Функция ЛокальныйКаталогЭкспортаКлючЗадания() Экспорт
	Возврат "ЛокальныйКаталогЭкспорта";		
КонецФункции

// Ключ параметра регламентного задания, соответствующий ftp каталогу экспорта
Функция FTPКаталогЭкспортаКлючЗадания() Экспорт
	Возврат "FTPКаталогЭкспорта";		
КонецФункции

#Если Сервер Тогда
// Процедура записывает данные в журнал регистрации
//
// Параметры:
//  ИмяСобытия - Строка
//  Уровень - УровеньЖурналаРегистрации
//  ТекстСообщения - Строка
//
Процедура ЗаписатьВЖурналРегистрации(ИмяСобытия, Уровень, ТекстСообщения) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		Уровень,
		,
		"Оценка производительности",
		ТекстСообщения);
	
КонецПроцедуры
#КонецЕсли

// Получает имя дополнительного свойства не проверять приоритеты при записи ключевой операции
//
// Возвращаемое значение:
//  Строка - имя дополнительного свойства
//
Функция НеПроверятьПриоритет() Экспорт
	Возврат "НеПроверятьПриоритет";	
КонецФункции

// ЛНА
Процедура СообщитьПользователю(
		Знач ТекстСообщенияПользователю,
		Знач КлючДанных = Неопределено,
		Знач Поле = "",
		Знач ПутьКДанным = "",
		Отказ = Ложь) Экспорт
	
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = ТекстСообщенияПользователю;
	Сообщение.Поле = Поле;
	
	ЭтоОбъект = Ложь;
	
#Если НЕ (ТонкийКлиент ИЛИ ВебКлиент) Тогда
	Если КлючДанных <> Неопределено
	   И XMLТипЗнч(КлючДанных) <> Неопределено Тогда
		ТипЗначенияСтрокой = XMLТипЗнч(КлючДанных).ИмяТипа;
		ЭтоОбъект = Найти(ТипЗначенияСтрокой, "Object.") > 0;
	КонецЕсли;
#КонецЕсли
	
	Если ЭтоОбъект Тогда
		Сообщение.УстановитьДанные(КлючДанных);
	Иначе
		Сообщение.КлючДанных = КлючДанных;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(ПутьКДанным) Тогда
		Сообщение.ПутьКДанным = ПутьКДанным;
	КонецЕсли;
		
	Сообщение.Сообщить();
	
	Отказ = Истина;
	
КонецПроцедуры


