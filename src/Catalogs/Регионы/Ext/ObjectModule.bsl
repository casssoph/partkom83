﻿Перем мЗарегистрироватьИзмененияДляСайта;

Процедура ПередУдалением(Отказ)

	Если НЕ ЭтоГруппа И РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Регионы", Ложь) Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если мЗарегистрироватьИзмененияДляСайта И НЕ ЭтоГруппа Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Регионы", Ложь) И НЕ  ОбменДанными.Загрузка Тогда
		мЗарегистрироватьИзмененияДляСайта = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	КонецЕсли;

КонецПроцедуры

мЗарегистрироватьИзмененияДляСайта = Ложь;
