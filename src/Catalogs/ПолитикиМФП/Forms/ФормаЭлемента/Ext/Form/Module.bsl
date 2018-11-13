﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВнешнийВидФормы()
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры

&НаКлиенте
Процедура ПериодДействияПриИзменении(Элемент)
	СформироватьНаименование();
КонецПроцедуры


//Прочее

&НаКлиенте
Процедура УстановитьВнешнийВидФормы()
	
	Элементы.ГруппаПокупка.Видимость 			= Объект.РазрешенаПокупкаУСобственныхОрганизаций;
	Элементы.РазрешенаЦепочкаЗакупок.Видимость 	= Объект.РазрешенаПокупкаУСобственныхОрганизаций;
	//Элементы.РазрешенВозврат.Видимость 			= Объект.РазрешенаПокупкаУСобственныхОрганизаций;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименование()
	
	Объект.Наименование = ""+Объект.Владелец+" от "+Формат(Объект.ПериодДействия, "ДФ=dd.MM.yyyy")+"г.";	
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешенаПокупкаУСобственныхОрганизацийПриИзменении(Элемент)
	УстановитьВнешнийВидФормы();
КонецПроцедуры

&НаКлиенте
Процедура СобственныеОрганизацииРазрешенаПокупкаДоговорКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	текСтрока = Элементы.СобственныеОрганизацииРазрешенаПокупка.ТекущиеДанные;
	
	ОрганизацияПродавец = текСтрока.Организация;
	
	Если Не ЗначениеЗаполнено(ОрганизацияПродавец) Тогда
		Возврат;		
	КонецЕсли;
	
	ФормаВыбораДоговора = Справочники.ДоговорыКонтрагентов.ПолучитьФормуВыбора();
	
	ОтборВладелец = ФормаВыбораДоговора.ЭлементыФормы.СправочникСписок.Значение.Отбор.Владелец;	
	ОтборВладелец.Значение = Объект.Контрагент;	
	ОтборВладелец.Использование = Истина;
	
	ОтборОрганизация = ФормаВыбораДоговора.ЭлементыФормы.СправочникСписок.Значение.Отбор.Организация;	
	ОтборОрганизация.Значение = ОрганизацияПродавец;	
	ОтборОрганизация.Использование = Истина;
	
	ОтборВидДоговора = ФормаВыбораДоговора.ЭлементыФормы.СправочникСписок.Значение.Отбор.ВидДоговора;	
	ОтборВидДоговора.Значение = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем");	
	ОтборВидДоговора.Использование = Истина;
	
	ВыбранноеЗначение = ФормаВыбораДоговора.ОткрытьМодально();
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		текСтрока.ДоговорКонтрагента = ВыбранноеЗначение;		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция КонтрагентОрганизации(вхОрганизация, вхДатаДействия)
	
	Возврат Справочники.ПолитикиМФП.КонтрагентОрганизации(вхОрганизация, вхДатаДействия);
	
КонецФункции

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Текст = "Изменение существующей политики МФП может повлиять на формирование документов! Вы уверены что хотите изменить существующую политику, а не создать новую? Если уверены, можете записать.";
	
	Если Не РазрешитьЗапись Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(,Текст);
		РазрешитьЗапись = Истина;
	КонецЕсли;

КонецПроцедуры



