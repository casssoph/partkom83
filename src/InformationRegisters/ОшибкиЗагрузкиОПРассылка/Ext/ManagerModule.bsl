﻿Функция ПолучитьМетаданные()
	Возврат Метаданные.РегистрыСведений.ОшибкиЗагрузкиОП;
КонецФункции

Функция ВыгрузитьЭлементы(вхМассивНомеровДокументов, вхПланОбмена) Экспорт
	
	Результат = Новый Массив;
	
	лМетаданныеПланаОбмена = Неопределено;
	лТип = ТипЗнч(вхПланОбмена);
	Если (лТип = Тип("Строка")) тогда
		лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.Найти(вхПланОбмена);
	ИначеЕсли (лТип = Тип("ОбъектМетаданных")) И Метаданные.ПланыОбмена.Содержит(вхПланОбмена) тогда
		лМетаданныеПланаОбмена = вхПланОбмена;
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = Неопределено) тогда
		ВызватьИсключение "[ВыгрузитьЭлементы]: неправильный параметр номер 2.";
	КонецЕсли;
	
	Если (лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика) тогда
		
		лМенеджерПланаОбмена = ПланыОбмена[лМетаданныеПланаОбмена.Имя];
		
		Запрос = Новый Запрос("ВЫБРАТЬ
		                      |	КлючиЗаписей.Период,
		                      |	КлючиЗаписей.НомерДокумента,
		                      |	КлючиЗаписей.КлючСвязи
		                      |ПОМЕСТИТЬ КлючиЗарегистрированныхЗаписейЗаписей
		                      |ИЗ
		                      |	&Ключи КАК КлючиЗаписей
		                      |;
		                      |
		                      |////////////////////////////////////////////////////////////////////////////////
		                      |ВЫБРАТЬ
		                      |	ОшибкиЗагрузкиОП.НомерДокумента КАК invoice_id,
		                      |	ОшибкиЗагрузкиОП.КлючСвязи КАК order_no,
		                      |	ОшибкиЗагрузкиОП.ОписаниеОшибкиДляСайта КАК error,
		                      |	ОшибкиЗагрузкиОП.document_date,
		                      |	ОшибкиЗагрузкиОП.number,
		                      |	ВЫБОР
		                      |		КОГДА (ВЫРАЗИТЬ(ОшибкиЗагрузкиОП.ОписаниеОшибкиДляСайта КАК СТРОКА(17))) = ""Документ загружен""
		                      |			ТОГДА ""accepted""
		                      |		ИНАЧЕ ""error""
		                      |	КОНЕЦ КАК status
		                      |ИЗ
		                      |	КлючиЗарегистрированныхЗаписейЗаписей КАК КлючиЗарегистрированныхЗаписейЗаписей
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОшибкиЗагрузкиОП КАК ОшибкиЗагрузкиОП
		                      |		ПО КлючиЗарегистрированныхЗаписейЗаписей.Период = ОшибкиЗагрузкиОП.Период
		                      |			И КлючиЗарегистрированныхЗаписейЗаписей.НомерДокумента = ОшибкиЗагрузкиОП.НомерДокумента
		                      |			И КлючиЗарегистрированныхЗаписейЗаписей.КлючСвязи = ОшибкиЗагрузкиОП.КлючСвязи
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	order_no
		                      |ИТОГИ ПО
		                      |	invoice_id");
		Запрос.УстановитьПараметр("Ключи", вхМассивНомеровДокументов);
		
		ВыборкаПоНомерамДокументов = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		лТипОбъектаXDTO = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ПоступлениеТоваровУслуг_Ошибка");
		
		Пока ВыборкаПоНомерамДокументов.Следующий() Цикл
			
			лОбъект = ФабрикаXDTO.Создать(лТипОбъектаXDTO);
			
			лОбъект.invoice_id = ВыборкаПоНомерамДокументов.invoice_id;
			
			лТипОшибкиСтроки = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ПоступлениеТоваровУслуг_Ошибка_Строки");
			лОбъектОшибкиСтроки = ФабрикаXDTO.Создать(лТипОшибкиСтроки);
			лСписокОбъектов = лОбъектОшибкиСтроки.ПолучитьСписок("item");
			
			лТипОшибкиСтрока = ФабрикаXDTO.Тип(лМенеджерПланаОбмена.URIПространстваИмен(), "Документы.ПоступлениеТоваровУслуг_Ошибка_Строка");
			
			Выборка = ВыборкаПоНомерамДокументов.Выбрать();
			
			ПервыйПроход = Истина;
			
			Пока Выборка.Следующий() Цикл
				
				Если ПервыйПроход Тогда
					ПервыйПроход = Ложь;
					ЗаполнитьЗначенияСвойств(лОбъект, Выборка);
					лОбъект.doc_date = Формат(Выборка.document_date, "ДФ=yyyy-MM-dd");
					лОбъект.doc_time = Формат(Выборка.document_date, "ДФ=hh:mm");
					Если Не ЗначениеЗаполнено(лОбъект.error) Тогда
						лОбъект.error = "Во время обработки СФ обнаружены ошибки";
					КонецЕсли;
					Продолжить;
				КонецЕсли;
				
				лОбъектОшибкиСтрока = ФабрикаXDTO.Создать(лТипОшибкиСтрока);
				ЗаполнитьЗначенияСвойств(лОбъектОшибкиСтрока, Выборка);
				лОбъектОшибкиСтрока.invoice_number = лОбъект.number;
				
				лСписокОбъектов.Добавить(лОбъектОшибкиСтрока);
				
			КонецЦикла;
			
			лОбъект.items = лОбъектОшибкиСтроки;
			
			Результат.Добавить(лОбъект);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции
