﻿
&НаКлиенте
Процедура ИспользованиеВСтатусахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьЗначение(Элемент.ТекущиеДанные.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользованиеВСтатусах.Параметры.УстановитьЗначениеПараметра("Команда", Объект.Ссылка);
	
КонецПроцедуры
