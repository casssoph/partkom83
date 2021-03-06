﻿Функция СкладРазмещенияПоОснованию(ДокументОснование) Экспорт
	
	СкладРазмещенияПоОснованию = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РазмещениеТоваров.Склад.СкладВозвратов КАК Склад
	|ИЗ
	|	РегистрНакопления.РазмещениеТоваров КАК РазмещениеТоваров
	|ГДЕ
	|	РазмещениеТоваров.ДокументОснование = &ДокументОснование
	|	И РазмещениеТоваров.Активность";
	
	Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		СкладРазмещенияПоОснованию = Выборка.Склад;
	КонецЕсли;
	
	Возврат СкладРазмещенияПоОснованию;

	
КонецФункции