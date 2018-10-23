﻿
&НаСервере
Процедура ЗагрузитьИзMaxoptraНаСервере()
	ИДСессии = МегаЛогист_РаботаСМакоптра.Авторазация();
	Если ИДСессии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	МегаЛогист_РаботаСМакоптра.getSchedulingZones(ИДСессии);
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Загрузка гео-зон успешно завершена";
	Сообщение.Сообщить();

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзMaxoptra(Команда)
	ЗагрузитьИзMaxoptraНаСервере();
КонецПроцедуры
