﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВзаимосвязиВходящие.Параметры.УстановитьЗначениеПараметра("ТекущийСтатус", Объект.Ссылка);
	ВзаимосвязиИсходящие.Параметры.УстановитьЗначениеПараметра("ТекущийСтатус", Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВзаимосвязиИсходящиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элементы.ВзаимосвязиИсходящие.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ВзаимосвязиВходящиеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элементы.ВзаимосвязиВходящие.ТекущиеДанные.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьЗаголовкиСтраниц();
	
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьЗаголовкиСтраниц()
	
	Элементы.ГруппаАлгоритмы.Заголовок = "Алгоритмы ("+Объект.ТаблицаАлгоритмов.Количество()+")";
	Элементы.ГруппаКомандыПроцесса.Заголовок = "Команды ("+Объект.КомандыПроцесса.Количество()+")";
	
КонецПроцедуры


