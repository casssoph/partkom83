﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьОрганизации();
КонецПроцедуры

&НаСервере 
Процедура ЗаполнитьОрганизации()
	Запрос = Новый Запрос;
	Запрос.Текст =  "ВЫБРАТЬ
	                |	Организации.Ссылка
	                |ИЗ
	                |	Справочник.Организации КАК Организации";
	СписокОрганизаций.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0));
КонецПроцедуры

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	Объект.НачалоПериода = Период.ДатаНачала;
	Объект.КонецПериода = Период.ДатаОкончания;	
КонецПроцедуры

&НаКлиенте 
Процедура УстановитьВидимостьДоступность()
	Элементы.СтараяОрганизация.Видимость = Объект.СтараяОрганизацияТребуется;
КонецПроцедуры

&НаКлиенте
Процедура РазослатьАктыСверок(Команда)
	ПеренестиДанныеИзФормыВОбъект();
	Если ПроверитьЗаполнение() Тогда 
		РазослатьАктыСверокНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура РазослатьАктыСверокНаСервере()
	РеквизитФормыВЗначение("Объект").ВыполнитьРассылку();
КонецПроцедуры

&НаКлиенте 
Процедура ПеренестиДанныеИзФормыВОбъект()
	Объект.Организации.Очистить();
	Для Каждого Стр Из СписокОрганизаций Цикл 
		Если Стр.Пометка Тогда 
			Объект.Организации.Добавить().Организация = Стр.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Объект.ВыгружатьЕслиНетДолгов = НаличиеДолга = 0;
	Объект.ТолькоПриостановленные = ВидДоговора = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура СтараяОрганизацияТребуетсяПриИзменении(Элемент)
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьДоступность();
КонецПроцедуры

