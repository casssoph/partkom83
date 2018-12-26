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
	
	ОтправлятьСМС=Истина;
	Для Каждого СтрокаРеализации из МаршрутноеЗадание.ДокументыРеализации цикл
		Документ = СтрокаРеализации.ДокументСсылка.ПолучитьОбъект();
		Если НЕ Документ.флНеВыгружатьВТопЛог тогда
			ОтправлятьСМС=Ложь;
			Продолжить;
		КонецЕсли;		
		Документ.ПометкаУдаления = Истина;
		Документ.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	КонецЦикла;	
	
	Если ОтправлятьСМС тогда
		ОтправитьСМСОтмена(МаршрутноеЗадание);
	КонецЕсли;	
	
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
	    МаршрутноеЗадание=СтрокаЗадания.ДокументСсылка;
		ОтправитьСМССборка(МаршрутноеЗадание);
		Для Каждого СтрокаРеализации из МаршрутноеЗадание.ДокументыРеализации цикл
			МассивРеализаций.Добавить(СтрокаРеализации.ДокументСсылка);
		КонецЦикла;			
	КонецЦикла;
	
	// + Пушкин 20181220
	ПланыОбмена.ОбменПартКом83_Сайт.ExpressDelivery1cConfirm(МассивРеализаций);
	// - Пушкин 20181220
	
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
			ПровестиДокументРеализацииКакПодтвержденный(ВыборкаПоРеализациям.ДокументРеализации, УстановитьСтоимостьДоставки, МаршрутноеЗадание);
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

Функция ПолучитьМаршрутДоставки(ДокументРеализации)
	
	МаршрутДоставки=Неопределено;
	
	Регион=	ДокументРеализации.Контрагент.ОсновнаяТорговаяТочка.Регион;
	Если НЕ ЗначениеЗаполнено(Регион) тогда
		Сообщить("Не определен регион для контрагента:" +ДокументРеализации.Контрагент);
		Возврат МаршрутДоставки;
	КонецЕсли;
	ГруппаМаршрутов=Регион.ГруппаМаршрутов;
	Если НЕ ЗначениеЗаполнено(ГруппаМаршрутов) тогда
		Сообщить("Не определена группа маршрутов для региона:" +Регион);
		Возврат МаршрутДоставки;
	КонецЕсли;
	
	Если НЕ ГруппаМаршрутов.ЭтоГруппа тогда
		Возврат ГруппаМаршрутов;
	КонецЕсли;
	
	Запрос=Новый Запрос;
	Запрос.УстановитьПараметр("Родитель",ГруппаМаршрутов);
	
	Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
	             |	МаршрутыДоставки.Ссылка
	             |ИЗ
	             |	Справочник.МаршрутыДоставки КАК МаршрутыДоставки
	             |ГДЕ
	             |	МаршрутыДоставки.Ссылка В ИЕРАРХИИ(&Родитель)
	             |	И НЕ МаршрутыДоставки.ПометкаУдаления
	             |	И НЕ МаршрутыДоставки.ЭтоГруппа
	             |	И МаршрутыДоставки.флЭД";
	Результат=Запрос.Выполнить().Выбрать();
	Если Результат.Следующий()тогда
		Возврат Результат.Ссылка;
	КонецЕсли;
	
	Возврат МаршрутДоставки
	
КонецФункции

Процедура ПровестиДокументРеализацииКакПодтвержденный(ДокументРеализации, УстановитьСтоимостьДоставки, МаршрутноеЗадание)
	
	Документ = ДокументРеализации.ПолучитьОбъект();
	Документ.Статус = Перечисления.СтатусыРеализацииЭкспрессДоставки.ВыписанаРеализация;
	Документ.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугСборка;
	Документ.МаршрутДоставки = ПолучитьМаршрутДоставки(ДокументРеализации);
	Документ.флНеВыгружатьВТопЛог = Ложь;
			
	Попытка
		Документ.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		Документ.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;	
	
КонецПроцедуры

#КонецОбласти

Функция ПолучитьМассивФилиалов()
	
	МассивФилиалов=Новый Массив;
	
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ
	             |	МегаЛогист_ФилиалыВыписки.Филиал
	             |ИЗ
	             |	РегистрСведений.МегаЛогист_ФилиалыВыписки КАК МегаЛогист_ФилиалыВыписки";
				 
	МассивФилиалов=Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Филиал");
	
	Возврат МассивФилиалов
	
КонецФункции

Функция ПолучитьМЗ()
	
	ТекДата=ТекущаяДата();
	ТекВремя=Дата('00010101') + (ТекДата-НачалоДня(ТекДата));
	
	//Временное ограничение только на Карпова М. Г. (рег.развитие)
	//N0021506
	ТекКонтрагент=Справочники.Контрагенты.НайтиПоКоду("N0021506");
	//Ограничение по филиалам
	МассивФилиалов=ПолучитьМассивФилиалов();
	
	Запрос=Новый Запрос();
	Запрос.Текст="ВЫБРАТЬ РАЗЛИЧНЫЕ
	             |	МегаЛогист_МаршрутноеЗадание.Ссылка
	             |ИЗ
	             |	Документ.МегаЛогист_МаршрутноеЗадание КАК МегаЛогист_МаршрутноеЗадание
	             |ГДЕ
	             |	МегаЛогист_МаршрутноеЗадание.ЭкспрессДоставка
	             |	И МегаЛогист_МаршрутноеЗадание.ДатаДоставки = &ДатаДоставки
	             |	И МегаЛогист_МаршрутноеЗадание.Статус = &КРаспределению
	             |	И ДОБАВИТЬКДАТЕ(МегаЛогист_МаршрутноеЗадание.ВремяДоставкиС, МИНУТА, &ГраницаВыписки) < &ТекВремя
	             |	И МегаЛогист_МаршрутноеЗадание.Контрагент = &ТекКонтрагент";
	
	Запрос.УстановитьПараметр("ТекВремя",ТекВремя);
	Запрос.УстановитьПараметр("ДатаДоставки",НачалоДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("КРаспределению",Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.КРаспределению);
	Запрос.УстановитьПараметр("ГраницаВыписки",Константы.МегаЛогист_ГраницаВыписки.Получить());
	Запрос.УстановитьПараметр("ТекКонтрагент",ТекКонтрагент);
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	Возврат Таблица;
	
КонецФункции

Функция ПолучитьРасписаниеЭД(ТекДата) 
	
	ДН = ДеньНедели(ТекДата);
		
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
	              |	ПараметрыФормированияСлужебныхЗаданий.Ссылка,
	              |	ПараметрыФормированияСлужебныхЗаданий.ВремОкончанияДовыписки1 КАК ВремяВыписки,
	              |	ПараметрыФормированияСлужебныхЗаданий.Склад
	              |ИЗ
	              |	Справочник.ПараметрыФормированияСлужебныхЗаданий КАК ПараметрыФормированияСлужебныхЗаданий
	              |ГДЕ
	              |	ПараметрыФормированияСлужебныхЗаданий.ТипДоставки = &ТипДоставки
	              |	И ПараметрыФормированияСлужебныхЗаданий.ДниНедели1";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ДниНедели1", "ДниНедели" + Строка(ДН));
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "ВремОкончанияДовыписки1", "ВремОкончанияДовыписки" + Строка(Дн));
	
	Запрос.УстановитьПараметр("ТипДоставки", Справочники.ТипыДоставки.ЭкспрессДоставка);
	
	Таблица = Запрос.Выполнить().Выгрузить();
		
	Возврат Таблица;
	
КонецФункции

Процедура КонтрольВыписки() Экспорт
		
	ТаблицаЗаданий=ПолучитьМЗ();
	Для Каждого СтрокаЗадания из ТаблицаЗаданий цикл
		МЗ=СтрокаЗадания.Ссылка.ПолучитьОбъект();
		МЗ.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.НеОбработан;
		ЭкспрессДоставка_cancel(МЗ);
		МЗ.Записать();
	КонецЦикла;			
		
КонецПроцедуры	