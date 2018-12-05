﻿Функция ВремяОтгрузкиПоМаршруту(МаршрутДоставки, ДатаОтгрузки)
	
	Если ЗначениеЗаполнено(МаршрутДоставки) Тогда
		ДеньНедели = ДеньНедели(ДатаОтгрузки);
		Если ДеньНедели = 6 Тогда
			ВремяОтгрузки = МаршрутДоставки.ВремяОтгрузкиСуббота;
		ИначеЕсли ДеньНедели = 7 Тогда
			ВремяОтгрузки = МаршрутДоставки.ВремяОтгрузкиВоскресенье;
		Иначе
			ВремяОтгрузки = МаршрутДоставки.ВремяОтгрузкиБудни;
		КонецЕсли;
	Иначе
		ВремяОтгрузки = Неопределено;
	КонецЕсли;
	
	Возврат ВремяОтгрузки;
	
КонецФункции

Функция ДатаСдачиЗадания(ВремяОтгрузки, МаршрутДоставки)
	
	Если ЗначениеЗаполнено(МаршрутДоставки) Тогда
		ДатаСдачиЗадания = ВремяОтгрузки + МаршрутДоставки.КоличествоДнейДоставки*60*60*24;
	Иначе
		ДатаСдачиЗадания = ВремяОтгрузки + 1;
	КонецЕсли;
	
	Возврат ДатаСдачиЗадания;
	
КонецФункции

#Область cancel
Процедура ОтправитьСМСОтмена(МаршрутноеЗадание)
	
	пар_Триггер = Справочники.НастройкаSMSоповещения.Триггер_10;
	пар_Источник = Новый Массив;
	пар_Источник.Добавить(МаршрутноеЗадание);
	
	SMSоповещение.ЛаунчерSMS(Новый Структура("Триггер,Источник",пар_Триггер,пар_Источник));

КонецПроцедуры

Процедура ЭкспрессДоставка_cancel(МаршрутноеЗадание) Экспорт
	
	Документ = МаршрутноеЗадание.ЗаказПокупателя.ПолучитьОбъект();
	Документ.ПометкаУдаления = Истина;
	Документ.Записать(РежимЗаписиДокумента.ОтменаПроведения);		
	
	ОтправитьСМСОтмена(МаршрутноеЗадание);
	
КонецПроцедуры

Функция ЗагружаемыеОбъекты_cancel(МаршрутноеЗадание)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РеализацияТоваровУслуг.Ссылка КАК Документ
	                      |ИЗ
	                      |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	                      |ГДЕ
	                      |	НЕ РеализацияТоваровУслуг.ПометкаУдаления
	                      |	И РеализацияТоваровУслуг.express_delivery_request_id = &RequestID
	                      |	И РеализацияТоваровУслуг.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыРеализацииЭкспрессДоставки.ВыписанаРеализация)");
	Запрос.УстановитьПараметр("RequestID", МаршрутноеЗадание.express_delivery_request_id);
	Результат = Запрос.Выполнить();
	 			
	Возврат Результат.Выбрать();
	
КонецФункции
#КонецОбласти

#Область add
Процедура ОтправитьСМСВРаботе(МаршрутноеЗадание)
	
	пар_Триггер = Справочники.НастройкаSMSоповещения.Триггер_11;
	пар_Источник = Новый Массив;
	пар_Источник.Добавить(МаршрутноеЗадание);
	
	SMSоповещение.ЛаунчерSMS(Новый Структура("Триггер,Источник",пар_Триггер,пар_Источник));

КонецПроцедуры	

Процедура ЭкспрессДоставка_add(МаршрутноеЗадание) Экспорт
		
	ОтправитьСМСВРаботе(МаршрутноеЗадание);
	
КонецПроцедуры
#КонецОбласти

#Область confirm
Процедура ОтправитьСМССборка(МаршрутноеЗадание)
	
	пар_Триггер = Справочники.НастройкаSMSоповещения.Триггер_12;
	пар_Источник = Новый Массив;
	пар_Источник.Добавить(МаршрутноеЗадание);
	
	SMSоповещение.ЛаунчерSMS(Новый Структура("Триггер,Источник",пар_Триггер,пар_Источник));

КонецПроцедуры	

Процедура ЭкспрессДоставка_logist_confirm(МаршрутныйЛист) Экспорт
	
	УстановитьСтоимостьДоставки = Истина;
	Error=Ложь;
	
	МассивРеализаций = Новый Массив();
	Для Каждого СтрокаЗадания из МаршрутныйЛист.МаршрутныеЗадания цикл
		Если ЗначениеЗаполнено(СтрокаЗадания.ДокументСсылка.ЗаказПокупателя) тогда
			ОтправитьСМССборка(СтрокаЗадания.ДокументСсылка);
			МассивРеализаций.Добавить(СтрокаЗадания.ДокументСсылка.ЗаказПокупателя);
		КонецЕсли;
	КонецЦикла;
	
	ВыборкаПоСкладам = ЗагружаемыеОбъекты_confirm(МассивРеализаций);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Пока ВыборкаПоСкладам.Следующий() Цикл
		Документ = Документы.СлужебноеЗадание.СоздатьДокумент();
		ЗаполнитьДокументСлужебноеЗадание(МаршрутныйЛист, Документ, ВыборкаПоСкладам);
	    ВыборкаПоРеализациям = ВыборкаПоСкладам.Выбрать();
		Пока ВыборкаПоРеализациям.Следующий() Цикл
			НоваяСтрока = Документ.Покупатели.Добавить();
			НоваяСтрока.Реализация = ВыборкаПоРеализациям.ДокументРеализации;
			НоваяСтрока.ОрганизацияОплаты = НоваяСтрока.Реализация.Организация;
			НоваяСтрока.ТорговаяТочка = НоваяСтрока.Реализация.ТорговаяТочка;
			НоваяСтрока.Регион = НоваяСтрока.ТорговаяТочка.Регион;
			//ПровестиДокументРеализацииКакПодтвержденный(МаршрутноеЗадание.ЗаказПокупателя, УстановитьСтоимостьДоставки, МаршрутноеЗадание);
		КонецЦикла;	
	
		Документ.Записать();
		
	КонецЦикла;	
	
	Если Error Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;

КонецПроцедуры

Функция ЗагружаемыеОбъекты_confirm(МассивРеализаций)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	РеализацияТоваровУслуг.Склад КАК Склад,
	                      |	РеализацияТоваровУслуг.Ссылка КАК ДокументРеализации,
	                      |	РеализацияТоваровУслуг.Организация КАК Организация,
	                      |	РеализацияТоваровУслуг.Контрагент КАК Контрагент,
	                      |	РеализацияТоваровУслуг.ТорговаяТочка КАК ТорговаяТочка,
	                      |	РеализацияТоваровУслуг.Филиал КАК Филиал,
	                      |	РеализацияТоваровУслуг.Дата КАК ДатаОтгрузки
	                      |ИЗ
	                      |	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	                      |ГДЕ
	                      |	НЕ РеализацияТоваровУслуг.ПометкаУдаления
	                      |	И РеализацияТоваровУслуг.Ссылка В(&МассивРеализаций)
	                      |ИТОГИ
	                      |	МАКСИМУМ(ДокументРеализации),
	                      |	МАКСИМУМ(Организация),
	                      |	МАКСИМУМ(Контрагент),
	                      |	МАКСИМУМ(ТорговаяТочка),
	                      |	МАКСИМУМ(Филиал),
	                      |	МИНИМУМ(ДатаОтгрузки)
	                      |ПО
	                      |	Склад");
	Запрос.УстановитьПараметр("МассивРеализаций", МассивРеализаций);
	Результат = Запрос.Выполнить();
		
	Возврат Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
КонецФункции

Процедура ЗаполнитьДокументСлужебноеЗадание(МаршрутныйЛист, Документ, ВыборкаПоСкладам)
	
	Документ.Дата = ТекущаяДата();
	Документ.Авто = Истина;
	Документ.express_delivery_request_id = ВыборкаПоСкладам.ДокументРеализации.express_delivery_request_id;
	Документ.Организация = ВыборкаПоСкладам.Организация;
	Документ.Филиал = ВыборкаПоСкладам.Филиал;
	Документ.Склад = ВыборкаПоСкладам.Склад;
	//Документ.МаршрутДоставки = МаршрутноеЗадание.МаршрутДоставки;
	Документ.Водитель = МаршрутныйЛист.Курьер;
	//Документ.ТранспортнаяКомпания = Документ.Водитель.ТранспортнаяКомпания;
	Документ.ТипДоставки = Справочники.ТипыДоставки.ЭкспрессДоставка;
	Документ.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	Документ.ДатаОтгрузки = ВыборкаПоСкладам.ДатаОтгрузки;
	Документ.ВремяОтгрузки =  ВремяОтгрузкиПоМаршруту(Документ.МаршрутДоставки, Документ.ДатаОтгрузки);
	Документ.ДатаСдачиЗадания = ДатаСдачиЗадания(Документ.ДатаОтгрузки, Документ.МаршрутДоставки);
	
КонецПроцедуры

Процедура ПровестиДокументРеализацииКакПодтвержденный(ДокументРеализации, УстановитьСтоимостьДоставки, МаршрутноеЗадание)
	
	Документ = ДокументРеализации.ПолучитьОбъект();
	Документ.Статус = Перечисления.СтатусыРеализацииЭкспрессДоставки.ВыписанаРеализация;
	Документ.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугСборка;
	Документ.МаршрутДоставки = МаршрутноеЗадание.МаршрутДоставки;
	Документ.флНеВыгружатьВТопЛог = Ложь;
			
	Попытка
		Документ.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Документ.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

Процедура КонтрольВыписки() Экспорт
	
	//ПараметрыФормированияСЗ = ПараметрыФормированияСЗ();
	//Для Каждого СтрокаП Из ПараметрыФормированияСЗ Цикл 
	//	Параметры = ЗаполнитьПараметрыОбработкиСогласноОснованию(СтрокаП.ПараметрФормированияСЗ, СтрокаП);	
	//	Если Не Параметры.Запускать Тогда 
	//		Возврат;
	//	КонецЕсли;
	//	
	//	ЗаполнитьТаблицы(Параметры);
	//	СоздатьДокументыСЗ(Параметры);
	//КонецЦикла;
	
КонецПроцедуры	