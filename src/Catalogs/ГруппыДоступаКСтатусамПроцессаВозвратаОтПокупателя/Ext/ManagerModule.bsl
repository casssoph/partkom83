﻿
Функция ДоступныеСтатусыТекущегоПользователя() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Статус
		|ИЗ
		|	Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.Статусы КАК ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы
		|		Внутреннее СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Ссылка = Пользователи.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя
		|ГДЕ
		|	Пользователи.Ссылка = &Ссылка
		|	И НЕ ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Ссылка.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрыСеанса.ТекущийПользователь);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Статус");
		
КонецФункции

Функция СтатусДоступенТекущемуПользователю(Статус) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Статус
		|ИЗ
		|	Справочник.ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателя.Статусы КАК ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
		|		ПО ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Ссылка = Пользователи.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя
		|ГДЕ
		|	Пользователи.Ссылка = &Ссылка
		|	И ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Статус = &Статус
		|	И НЕ ГруппыДоступаКСтатусамПроцессаВозвратаОтПокупателяСтатусы.Ссылка.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Ссылка", ПараметрыСеанса.ТекущийПользователь);
	Запрос.УстановитьПараметр("Статус", Статус);
	
	Возврат НЕ Запрос.Выполнить().Пустой();
		
КонецФункции