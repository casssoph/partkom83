﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	лКлючАлгоритма = "РегистрСведений_ЗначенияСвойствОбъектов_МодульНабораЗаписей_ПередЗаписью";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	лКлючАлгоритма = "РегистрСведений_ЗначенияСвойствОбъектов_МодульНабораЗаписей_ПриЗаписи";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
КонецПроцедуры
