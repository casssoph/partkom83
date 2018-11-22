﻿#Область   Загрузка
Функция ЗагрузитьСообщениеОбмена() Экспорт
 ОбменССайтомСервер.ПолучитьДанныеССайта(ЭтотУзел(),"retail_orders");	
КонецФункции

Функция УзелПланаОбмена(Входящий = Истина) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОбменССайтом_Розница.Ссылка
	                      |ИЗ
	                      |	ПланОбмена.ОбменССайтом_Розница КАК ОбменССайтом_Розница
	                      |ГДЕ
	                      |	НЕ ОбменССайтом_Розница.ЭтотУзел
	                      |	И (&Входящий
	                      |				И ОбменССайтом_Розница.Входящий
	                      |			ИЛИ НЕ &Входящий
	                      |				И ОбменССайтом_Розница.Исходящий)");
	Запрос.УстановитьПараметр("Входящий", Входящий);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Ссылка, ЭтотУзел());
	
КонецФункции

#КонецОбласти

#Область Обработка
Процедура ОбработатьОбъекты() Экспорт
 ОбменССайтомСервер.ОбработатьОбъектыОбмена(ЭтотУзел());
		
КонецПроцедуры
#КонецОбласти

