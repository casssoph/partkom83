﻿

Процедура ПередЗаписью(Отказ)
	
	// ЛНА, Замер  APDEX ++(
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ИдентификаторыСтрокЗаявок_Запись");
	//)--
	
	//Если ОбменДанными.Загрузка Тогда
	//	Если ЦенаЗакупки = 0 Тогда
	//		ЦенаЗакупки = Цена;
	//	КонецЕсли;
	//	
	//	Если НЕ ЗначениеЗаполнено(ПрайсПоставщика) Тогда
	//		Склад = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Заявка, "Склад");
	//		Если Склад = Справочники.Склады.НайтиПоКоду("000000132") Тогда
	//			ПрайсПоставщика = Справочники.ПрайсыПоставщиков.НайтиПоКоду(8555);
	//		Иначе
	//			ПрайсПоставщика = Справочники.ПрайсыПоставщиков.НайтиПоКоду(16);
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ЦенаЗакупки = 0 Тогда
		//Сергеев
		//Если Цена > 0 Тогда
		//	ЦенаЗакупки = Цена;
			
		//Иначе
			Запрос = Новый Запрос(
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ЗаявкаПокупателяТовары.ЦенаЗакупки
			|ИЗ
			|	Документ.ЗаявкаПокупателя.Товары КАК ЗаявкаПокупателяТовары
			|ГДЕ
			|	ЗаявкаПокупателяТовары.Ссылка = &Ссылка
			|	И ЗаявкаПокупателяТовары.IDSite = &IDSite"
			);
			Запрос.УстановитьПараметр("Ссылка", Заявка);
			Запрос.УстановитьПараметр("IDSite", IDSite);
			Результат = Запрос.Выполнить();
			Если НЕ Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				ЦенаЗакупки = Выборка.ЦенаЗакупки;
			КонецЕсли;
			
			// + 20181012 Пушкин XX-831
			Если ЦенаЗакупки = 0 Тогда
				Если НЕ Виртуальная Тогда
					Попытка
						лКА = ОбщегоНазначения.ПолучитьЗначениеРеквизита(?(ЗначениеЗаполнено(ПоследняяКорректировка),ПоследняяКорректировка,Заявка),"Контрагент");
						Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(лКА,"ПокупательИзДрБазы") ИЛИ
							 Заявка.ВидОперации = Перечисления.ВидыОперацийЗаявкаПокупателя.ПополнениеСклада тогда
							ЦенаЗакупки = Цена;
						КонецЕсли;
					исключение
						//нездоровая хуйня какая-то
					КонецПопытки;
					
				КонецЕсли;
			КонецЕсли;
			// - 20181012 Пушкин XX-831
			
		//КонецЕсли;
									
	КонецЕсли;
		
	Если НЕ ЗначениеЗаполнено(ПрайсПоставщика) Тогда
		Если НЕ Виртуальная Тогда
			Попытка
				СкладЗаказа = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Заявка, "Склад");
				Если СкладЗаказа = Справочники.Склады.НайтиПоКоду("000000132") Тогда
					ПрайсПоставщика = Справочники.ПрайсыПоставщиков.ПолучитьСсылку(Новый УникальныйИдентификатор("0c0c75b3-7d41-4801-b163-8a1eada10048"));
				Иначе
					ПрайсПоставщика = Справочники.ПрайсыПоставщиков.ПолучитьСсылку(Новый УникальныйИдентификатор("f2469899-e682-11e5-80df-005056817b9c"));
				КонецЕсли;
			исключение
				//нездоровая хуйня какая-то
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) И НЕ ПустаяСтрока(IDSite) Тогда
		Наименование = IDSite;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И Количество = 0 Тогда
		Если Ссылка.Количество > 0 Тогда
			Количество = Ссылка.Количество;
		КонецЕсли;
	КонецЕсли;
	
	// ЛНА http://jira.part-kom.ru/browse/XX-1641 --( 	
	//УстановитьТипПоставки();
	Если Не ЗначениеЗаполнено(ТипПоставки) Тогда
		
		ТипПоставки = Справочники.ИдентификаторыСтрокЗаявок.ПолучитьТипПоставки(ЭтотОбъект, Заявка, ПрайсПоставщика); 
		
	КонецЕсли;
	// )--
	
	ПроверятьПрайсПоставщика = Константы.КонтрольЗаполненияПрайсаПоставщикаВСтрокеЗаявки.Получить();
	Если ПроверятьПрайсПоставщика И ЗначениеЗаполнено(ПрайсПоставщика) Тогда
		
		ТекстОшибки = "";
		
		Если Не ОбщегоНазначения.СсылкаСуществует(ПрайсПоставщика) Тогда
			ТекстОшибки = "[КонтрольПрайсаПоставщика] Ошибка записи строки заявки, битая ссылка в прайсе поставщика. Строка заявки: "+ЭтотОбъект+", прайс поставщика: "+ПрайсПоставщика+ ", новая строка "+ЭтоНовый();
		КонецЕсли;
		
		КодПрайса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПрайсПоставщика, "Код"); 
		Если КодПрайса = 0 Тогда
			ТекстОшибки = "[КонтрольПрайсаПоставщика] Ошибка записи строки заявки, не заполнен код в прайсе поставщика. Строка заявки: "+ЭтотОбъект+ ", новая строка "+ЭтоНовый();
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстОшибки) Тогда
			//ВызватьИсключение ТекстОшибки;
			ЗаписьЖурналаРегистрации("[КонтрольПрайсаПоставщика]", УровеньЖурналаРегистрации.Ошибка,,Ссылка, ТекстОшибки);
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

//Процедура УстановитьТипПоставки() http://jira.part-kom.ru/browse/XX-1641 --(
//	
//	Если ТипПоставки.Пустая() Тогда
//		Если ЗначениеЗаполнено(Заявка) И ЗначениеЗаполнено(Заявка.Контрагент) И ЗначениеЗаполнено(Заявка.Контрагент.Родитель) = Заявка.Контрагент.Родитель = "00005396" Тогда
//			ТипПоставки = Перечисления.ТипПоставки.ПополнениеСклада;
//		ИначеЕсли ПрайсПоставщика.Пустая() Тогда
//			ТипПоставки = Перечисления.ТипПоставки.Сток;
//		ИначеЕсли ПрайсПоставщика.Склад.Пустая() Тогда
//			ТипПоставки = Перечисления.ТипПоставки.Кросс;
//		ИначеЕсли ПрайсПоставщика.Склад.СкладVMI Тогда
//			ТипПоставки = Перечисления.ТипПоставки.VMI;
//		Иначе
//			ТипПоставки = Перечисления.ТипПоставки.Кросс;			
//		КонецЕсли;
//	КонецЕсли;
//	
//КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	// ЛНА, Замер  APDEX ++(
	Попытка		
		APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("ИдентификаторыСтрокЗаявок_Запись", СокрЛП(Ссылка), , Ссылка);
	Исключение
	КонецПопытки;
	//)--	
КонецПроцедуры
