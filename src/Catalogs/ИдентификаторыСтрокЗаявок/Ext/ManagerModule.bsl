﻿// ЛНА
Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("ТипПоставки");
	Поля.Добавить("Наименование");
	Поля.Добавить("IDSite");
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)	
	СтандартнаяОбработка = Ложь;
	
	СтрокаТипПоставки = "";
	Если ЗначениеЗаполнено(Данные.ТипПоставки) Тогда
		
		лСоответствие = Новый Соответствие;
		лСоответствие.Вставить(Перечисления.ТипПоставки.Сток,	"[C] ");
		лСоответствие.Вставить(Перечисления.ТипПоставки.Кросс,	"[К] ");
		лСоответствие.Вставить(Перечисления.ТипПоставки.VMI,	"[V] ");
		лСоответствие.Вставить(Перечисления.ТипПоставки.ПополнениеСклада, "[П] ");
		
		СтрокаТипПоставки = лСоответствие.Получить(Данные.ТипПоставки);		
	КонецЕсли;
	
	СтрокаНаименование = Данные.Наименование;
	Если ЗначениеЗаполнено(Данные.IDSite) 
		И СтрДлина(СокрЛП(Данные.IDSite)) < 20 Тогда
		
		СтрокаНаименование = Данные.IDSite;
	КонецЕсли;	
	
	Представление = СтрокаТипПоставки + СтрокаНаименование;
КонецПроцедуры

// ЛНА http://jira.part-kom.ru/browse/XX-1641
// Функция получает тип поставки для Идентификатора строки заявки
//
// Параметры:
//  <ИдентификаторСтрокиЗаявки>  - Ссылка или Объект Справочник.ИдентификаторыСтрокЗаявок
//  <Заявка>  - Ссылка или Объект Документ.ЗаявкаПокупаетля или Корректировка
//  <Прайс>  - Ссылка  ПрайсыПоставщиков
// 	<КэшДанных> - РеквизитыПоставщика при вызове из КорректировкаЗаявкиПокупателя модуль менеджера
Функция ПолучитьТипПоставки(ИдентификаторСтрокиЗаявки, Заявка, Прайс, КэшДанных = Неопределено) Экспорт	

	//Если Не КэшДанных = Неопределено Тогда		
	//	ЗначениеРеквизитов = КэшДанных[ИдентификаторСтрокиЗаявки.IDSite];
	//	Возврат  ЗначениеРеквизитов.ТипПоставки;		
	//КонецЕсли;
	
	Если ЗначениеЗаполнено(ИдентификаторСтрокиЗаявки.ТипПоставки) Тогда
		Возврат ИдентификаторСтрокиЗаявки.ТипПоставки;
	КонецЕсли;
	
	Результат = Неопределено;
	
	Если //ЗначениеЗаполнено(Заявка) И 
		ЗначениеЗаполнено(Заявка.Контрагент) И  
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Заявка.Контрагент,"Родитель") = ПредопределенноеЗначение("Справочник.Контрагенты.ПополнениеМинимальныхОстатков")  тогда 
		
		//ЗначениеЗаполнено(Заявка.Контрагент.Родитель) = Заявка.Контрагент.Родитель = "00005396" Тогда		
		//Папка "Пополнение мин.остатков"
		Результат = Перечисления.ТипПоставки.ПополнениеСклада;
	ИначеЕсли Прайс.Пустая() Тогда
		Результат = Перечисления.ТипПоставки.Сток;
	ИначеЕсли Прайс.Склад.Пустая() Тогда
		Результат = Перечисления.ТипПоставки.Кросс;
	ИначеЕсли Прайс.Склад.СкладVMI Тогда
		Результат = Перечисления.ТипПоставки.VMI;
	Иначе
		Результат = Перечисления.ТипПоставки.Сток;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

