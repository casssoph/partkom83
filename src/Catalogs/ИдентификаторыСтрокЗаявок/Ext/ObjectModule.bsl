﻿

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Если НЕ ЗначениеЗаполнено(ПрайсПоставщика) Тогда
			ПрайсПоставщика = Справочники.ПрайсыПоставщиков.НайтиПоКоду(16);
	
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПустаяСтрока(Наименование) И НЕ ПустаяСтрока(IDSite) Тогда
		Наименование = IDSite;
		
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И Количество = 0 Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	С.Количество
		|ИЗ
		|	Справочник.ИдентификаторыСтрокЗаявок КАК С
		|ГДЕ
		|	С.Ссылка = &Ссылка"
		);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Р = Запрос.Выполнить().Выбрать();
		Р.Следующий();
		КоличествоНачальное = Р.Количество;
		Если КоличествоНачальное > 0 Тогда
			Количество = КоличествоНачальное;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

