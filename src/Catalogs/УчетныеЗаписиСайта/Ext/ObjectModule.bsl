﻿
Процедура ПриЗаписи(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Контрагенты", Ложь) Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъектВУзлах(Ссылка.Владелец.Владелец, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры
