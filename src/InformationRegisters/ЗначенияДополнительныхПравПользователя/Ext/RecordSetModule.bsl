﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	лКлючАлгоритма = "РегистрСведений_ЗначенияДополнительныхПравПользователя_МодульНабораЗаписей_ПередЗаписью";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	// 04.07.19 Строганов Роман > 
	ЗафиксироватьИсториюИзмененийПрав();
	// 04.07.19 Строганов Роман <

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;

	Для каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.Право.ИмяПредопределенныхДанных="РазрешитьНестандартнуюСкидку" Тогда 
			Если Запись.Значение>50 Тогда 
				Запись.Значение=50;
			КонецЕсли;
		КонецЕсли;	
		Если Запись.Значение <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		// приводим запись к нужному типу
		Запись.Значение = Запись.Право.ТипЗначения.ПривестиЗначение(Запись.Значение);

	КонецЦикла;

КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Перем ОбновлятьЗначениеГлПеременной;
	
	КэшДополнительныхПрав = глЗначениеПеременной("ЗначенияДополнительныхПравПользователя");
	УправлениеПользователями.ИнформироватьОИзмененииНастроекПравАктивныхПользователей(ЭтотОбъект, 
																					  КэшДополнительныхПрав, 
																					  "Право",
																					  глЗначениеПеременной("глТекущийПользователь"), 
																					  "значения дополнительных прав",
																					  ОбновлятьЗначениеГлПеременной,
																					  Ложь);
																					  
	Если ОбновлятьЗначениеГлПеременной Тогда
		глЗначениеПеременнойУстановить("ЗначенияДополнительныхПравПользователя", КэшДополнительныхПрав, Истина);
	КонецЕсли;																						  

КонецПроцедуры

Процедура ЗафиксироватьИсториюИзмененийПрав()
	
	СоответствиеЗначений = Новый Соответствие;

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗначенияДополнительныхПравПользователя.Значение,
	|	ЗначенияДополнительныхПравПользователя.Право
	|ИЗ
	|	РегистрСведений.ЗначенияДополнительныхПравПользователя КАК ЗначенияДополнительныхПравПользователя
	|ГДЕ
	|	ЗначенияДополнительныхПравПользователя.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", ЭтотОбъект.Отбор.Пользователь.Значение);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СоответствиеЗначений.Вставить(Выборка.Право, Выборка.Значение);
	КонецЦикла;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		СтароеЗначение = СоответствиеЗначений[Запись.Право];
		
		Если СтароеЗначение = Неопределено И (Не ЗначениеЗаполнено(Запись.Значение) Или Запись.Значение = Ложь) Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтароеЗначение <> Запись.Значение Тогда
			МенеджерЗаписи = РегистрыСведений.ИсторияИзмененийНастроекПользователей.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.Период = ТекущаяДата();
			МенеджерЗаписи.Пользователь = Запись.Пользователь;
			МенеджерЗаписи.Показатель = Запись.Право;
			МенеджерЗаписи.ЗначениеДо = СтароеЗначение;
			МенеджерЗаписи.ЗначениеПосле = Запись.Значение;
			МенеджерЗаписи.Ответственный = ПараметрыСеанса.ТекущийПользователь;
			МенеджерЗаписи.Записать(Истина);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
