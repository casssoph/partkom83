﻿
&НаСервере
Процедура ЗагрузитьИзMaxoptraНаСервере()
	ИДСессии = МегаЛогист_РаботаСМакоптра.Авторазация("Загрузка из");
	Если ИДСессии = Неопределено Тогда
		Возврат;
	КонецЕсли;
	МегаЛогист_РаботаСМакоптра.getAreaOfControls(ИДСессии);
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = "Загрузка складов успешно завершена. Настройте соответствие со складами 1С вручную.";
	Сообщение.Сообщить();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзMaxoptra(Команда)
	ЗагрузитьИзMaxoptraНаСервере();
	Элементы.Список.Обновить();
	ОбновитьОтображениеДанных();
КонецПроцедуры
