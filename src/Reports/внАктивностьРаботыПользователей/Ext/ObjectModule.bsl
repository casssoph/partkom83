﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Использование Тогда
		ДатаНачала = ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаНачала;
		ДатаОкончания = ЭтотОбъект.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы[0].Значение.ДатаОкончания;
	Иначе
		ДатаНачала = Дата(1, 1, 1);
		ДатаОкончания = Дата(2030, 1, 1);
	КонецЕсли;
	
	Если ДатаОкончания = Дата(1, 1, 1) Тогда
		ДатаОкончания = Дата(2030, 1, 1);
	КонецЕсли;
	
	ТЗ = внЖурналРегистрации.ПолучитьСтатистикуРаботыПользователей(ДатаНачала, ДатаОкончания);
	
	//Связь между таблицей значений и именами в СКД
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЗ", ТЗ);
	
	//Макет компоновки
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ЭтотОбъект.СхемаКомпоновкиДанных, ЭтотОбъект.КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
	
	//Компоновка данных
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	//Вывод результата
	ДокументРезультат.Очистить();
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры
