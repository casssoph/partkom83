﻿
Перем мЗарегистрироватьИзмененияДляСайта;

Процедура ПриЗаписи(Отказ)
	Если мЗарегистрироватьИзмененияДляСайта тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
	// + 20170522 Пушкин
	Справочники.Изготовители.ПроверкаИзготовителейПоНаименованию(ОбщегоНазначения.ПолучитьЗначениеРеквизита(ЭтотОбъект.Ссылка,"Наименование"));
	// - 20170522 Пушкин
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если Не ВыведенИзОбращения Тогда
		 Замена = Справочники.Изготовители.ПустаяСсылка();
	КонецЕсли;
	
	мЗарегистрироватьИзмененияДляСайта = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	ЗаполнитьЗначенияКонтроля();
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Замена) Тогда
		РеквизитыЗамены = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Замена, "ВыведенИзОбращения, Замена");
		Если РеквизитыЗамены.ВыведенИзОбращения И ЗначениеЗаполнено(Замена) Тогда
			Сообщить("Нельзя в качестве замены использовать выведенного из обращения изготовителя!");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
КонецПроцедуры

Процедура ЗаполнитьЗначенияКонтроля()
	
	лРеквизитыКонтроля = Справочники.Изготовители.ПолучитьРеквизитыКонтроля(Метаданные.ПланыОбмена.ОбменПартКом83_TopLog);
	лШапка = Неопределено;
	Результат = Новый Структура;
	Если лРеквизитыКонтроля.Свойство("Шапка", лШапка) тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, лШапка);
		Результат.Вставить("Шапка", ЗначенияРеквизитов);	
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("СтарыеЗначения", Результат);
	
КонецПроцедуры


// + 20170301 Пушкин
мЗарегистрироватьИзмененияДляСайта = Ложь;
// - 20170301 Пушкин