﻿
Процедура ПередЗаписью(Отказ)
	
	СтароеЗначение = Константы.ПоступленияВыгружаютсяИз77.Получить();
	Если Значение <> СтароеЗначение Тогда 
		Значение = Ложь;
		Сообщить("Константу " + ЭтотОбъект.Метаданные().Синоним + " менять нельзя");
	КонецЕсли;

КонецПроцедуры
