﻿	
// Процедура подключает обработчик ожидания КонтрольРежимаЗавершенияРаботыПользователей
// 
Процедура УстановитьКонтрольРежимаЗавершенияРаботыПользователей()  Экспорт
		
	РежимБлокировки = УправлениеСоединениямиИБ.ПараметрыБлокировкиСеансов();
	ТекущееВремя = РежимБлокировки.ТекущаяДатаСеанса;
	Если РежимБлокировки.Установлена 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Начало) ИЛИ ТекущееВремя >= РежимБлокировки.Начало) 
		 И (НЕ ЗначениеЗаполнено(РежимБлокировки.Конец) ИЛИ ТекущееВремя <= РежимБлокировки.Конец) Тогда
		// Если пользователь зашел в базу, в которой установлена режим блокировки, значит использовался ключ /UC.
		// Завершать работу такого пользователя не следует
		Возврат;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("КонтрольРежимаЗавершенияРаботыПользователей", 60);	
	
КонецПроцедуры  
