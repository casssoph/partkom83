﻿
#Область  СостояниеЗаявокЗаказов

Функция СтрокаЗаявкиЗакрыта(СтрокаЗаявки,МоментВремемени = Неопределено) Экспорт 
Остаток = РегистрыНакопления.ЗаявкиПокупателей.Остатки(МоментВремемени,Новый Структура("СтрокаЗаявки",СтрокаЗаявки),"СтрокаЗаявки","Количество");
Если Остаток.Количество() тогда 
	Возврат Ложь;
иначе 
	Возврат Истина;
КонецЕсли;

КонецФункции	
	
#КонецОбласти