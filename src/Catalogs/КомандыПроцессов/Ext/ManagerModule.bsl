﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьМассивОбработчиков(пКоманда) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КомандыПроцессовОбработчики.Обработчик
	               |ИЗ
	               |	Справочник.КомандыПроцессов.Обработчики КАК КомандыПроцессовОбработчики
	               |ГДЕ
	               |	КомандыПроцессовОбработчики.Ссылка = &Команда
	               |	И КомандыПроцессовОбработчики.Обработчик.ПометкаУдаления = ЛОЖЬ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КомандыПроцессовОбработчики.НомерСтроки";
	
	Запрос.УстановитьПараметр("Команда", пКоманда );
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции	//ПолучитьМассивОбработчиков

Функция ПолучитьМассивТекстовОбработчиков(пКоманда) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	КомандыПроцессовОбработчики.Обработчик.Алгоритм КАК Алгоритм 
	               |ИЗ
	               |	Справочник.КомандыПроцессов.Обработчики КАК КомандыПроцессовОбработчики
	               |ГДЕ
	               |	КомандыПроцессовОбработчики.Ссылка = &Команда
	               |	И КомандыПроцессовОбработчики.Обработчик.ПометкаУдаления = ЛОЖЬ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	КомандыПроцессовОбработчики.НомерСтроки";
	
	Запрос.УстановитьПараметр("Команда", пКоманда );
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	
КонецФункции	//ПолучитьМассивОбработчиков

#КонецЕсли