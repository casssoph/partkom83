﻿Перем мЗарегистрироватьИзмененияДляСайта;

Процедура ПередЗаписью(Отказ)
	Если СОКРЛП(Код77) = "" Тогда
		Код77 = СтрЗаменить(Наименование," ","_");
	КонецЕсли;
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Менеджеры", Ложь) И НЕ  ОбменДанными.Загрузка Тогда
		мЗарегистрироватьИзмененияДляСайта = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если мЗарегистрироватьИзмененияДляСайта Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Менеджеры", Ложь) Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры

мЗарегистрироватьИзмененияДляСайта = Ложь;