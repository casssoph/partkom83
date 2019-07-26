﻿Процедура ЗафиксироватьДопСвойство(Объект, Свойство, Значение) Экспорт
	
	лКлючАлгоритма = "РегистрСведений_ДокументЗаявкаПокупателя_ДополнительныеРеквизиты_ЗафиксироватьДопСвойство";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	////////////////////////////////////////////////////////////////////////////////////////////////////
	
	Попытка
		МенеджерЗаписи = РегистрыСведений.Документ_ЗаявкаПокупателя_ДополнительныеРеквизиты.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Объект = Объект;
		МенеджерЗаписи.Свойство = ПланыВидовХарактеристик.СвойстваОбъектов[Свойство];
		МенеджерЗаписи.Значение = Значение;
		МенеджерЗаписи.Записать();
	Исключение
		КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(Объект, 
		Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаОпределенияДопСвойстваЗаявки, 
		ОписаниеОшибки(),,,,
		"РегистрСведений.ДокументЗаявкаПокупателя_ДополнительныеРеквизиты_ЗафиксироватьДопСвойство");
	КонецПопытки;
	
	
КонецПроцедуры