﻿Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если НачалоПериода > КонецПериода Тогда 
		Отказ = Истина;
		#Если Клиент Тогда 
			Предупреждение("Начало периода должно быть меньше конца периода", 2);
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры
