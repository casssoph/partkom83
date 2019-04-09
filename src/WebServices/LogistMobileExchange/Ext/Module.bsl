﻿
Функция GetData(date, User) Экспорт 
	
	// Получить типы объектов XDTO
    ТипСписокЗаданий = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "ShuttleMissions");
    ТипЗаданиеНаДоставку = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "ShuttleMission"); 
	
	 Запрос = Новый Запрос;
	 СписокЗаданий = ФабрикаXDTO.Создать(ТипСписокЗаданий);
	
	//Пользователь
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(User);
	Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запрос.УстановитьПараметр("Курьер", Пользователь.ФизЛицо);
	Иначе
		Возврат СписокЗаданий;	
	КонецЕсли;
	
    Запрос.Текст =
        "ВЫБРАТЬ
        |	МаршрутныйЛистМаршрутныеЗадания.ДокументСсылка КАК МаршрутноеЗадание,
        |	МИНИМУМ(МаршрутныйЛистМаршрутныеЗадания.НомерСтроки) КАК НомерСтроки
        |ПОМЕСТИТЬ ВТМааршрутныеЛисты
        |ИЗ
        |	Документ.МегаЛогист_МаршрутныйЛист.МаршрутныеЗадания КАК МаршрутныйЛистМаршрутныеЗадания
        |
        |СГРУППИРОВАТЬ ПО
        |	МаршрутныйЛистМаршрутныеЗадания.ДокументСсылка
        |;
        |
        |////////////////////////////////////////////////////////////////////////////////
        |ВЫБРАТЬ
        |	МаршрутноеЗадание_Док.Номер КАК Number,
        |	МаршрутноеЗадание_Док.ДатаДоставки КАК Date,
        |	МаршрутноеЗадание_Док.АдресДоставки КАК Address,
        |	МаршрутноеЗадание_Док.ВремяДоставкиС,
        |	МаршрутноеЗадание_Док.ВремяДоставкиПо,
        |	ПРЕДСТАВЛЕНИЕ(МаршрутноеЗадание_Док.ТипДоставки) КАК JobType,
        |	ПРЕДСТАВЛЕНИЕ(МаршрутноеЗадание_Док.Статус) КАК Status,
        |	ПРЕДСТАВЛЕНИЕ(МаршрутноеЗадание_Док.Контрагент) КАК Customer,
        |	МаршрутноеЗадание_Док.КонтактноеЛицоКонтрагента КАК Contact,
		|	МаршрутноеЗадание_Док.Телефон КАК Телефон,
        |	МаршрутноеЗадание_Док.ЗаказПокупателя КАК ДокументОснование,
        |	ПРЕДСТАВЛЕНИЕ(МаршрутноеЗадание_Док.Комментарий) КАК Comment,
        |	ЕСТЬNULL(ВТМааршрутныеЛисты.НомерСтроки, 0) КАК RowNumber,
        |	"""" КАК SuplierOrderNumber,
		|	ЕСТЬNULL(МаршрутноеЗадание_Док.ЗаказПокупателя.Номер, """") КАК CustomerOrderNumber,
		|	МаршрутноеЗадание_Док.Ссылка КАК Ссылка,
		|	МаршрутноеЗадание_Док.ОплаченоНал КАК PayedCash,
		|	МаршрутноеЗадание_Док.ОплаченоБезНал КАК PayedCard
        |ИЗ
        |	Документ.МегаЛогист_МаршрутноеЗадание КАК МаршрутноеЗадание_Док
        |		ЛЕВОЕ СОЕДИНЕНИЕ ВТМааршрутныеЛисты КАК ВТМааршрутныеЛисты
        |		ПО МаршрутноеЗадание_Док.Ссылка = ВТМааршрутныеЛисты.МаршрутноеЗадание
        |ГДЕ
        |	МаршрутноеЗадание_Док.ПометкаУдаления = ЛОЖЬ
        |	И МаршрутноеЗадание_Док.Проведен = ИСТИНА
        |	И МаршрутноеЗадание_Док.Статус В(&Статусы)
        |	И МаршрутноеЗадание_Док.ДатаДоставки МЕЖДУ &НачалоПериода И &КонецПериода
        |	И МаршрутноеЗадание_Док.Курьер.ФизЛицо = &Курьер";
		
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполнен);
	МассивСтатусов.Добавить(Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполняется);
	МассивСтатусов.Добавить(Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.НеВыполнено);
	МассивСтатусов.Добавить(Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Отменен);
    Запрос.УстановитьПараметр("Статусы", МассивСтатусов);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(date));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(date));
    РезультатЗапроса = Запрос.Выполнить();  
            
    Выборка = РезультатЗапроса.Выбрать();
    Пока Выборка.Следующий() Цикл
		
		// Создать объект XDTO заявки
		ЗаданиеНаДоставку = ФабрикаXDTO.Создать(ТипЗаданиеНаДоставку);
		ЗаполнитьЗначенияСвойств(ЗаданиеНаДоставку, Выборка,,"Contact");
		ЗаданиеНаДоставку.Contact = XMLСтрока(" " + Выборка.Contact+" "+Выборка.Телефон);
		ЗаданиеНаДоставку.DeliveryTime = "" + Формат(Выборка.ВремяДоставкиС, "ДФ=HH:mm") + " - " + Формат(Выборка.ВремяДоставкиПо, "ДФ=HH:mm");
		
		//Передача формы оплаты
		Попытка
			ЗаданиеНаДоставку.PaymentType = Строка(Выборка.ДокументОснование.ФормаОплаты);
		Исключение
		КонецПопытки;
		
		//Вывод номеров заказов
		
		ЗаданиеНаДоставку.Number = Прав(ЗаданиеНаДоставку.Number, 9);
		//Обработка статуса
		Если ЗаданиеНаДоставку.Status = "Выполняется" Тогда
			
			ЗаданиеНаДоставку.Status = "Выполняется";
			
		ИначеЕсли ЗаданиеНаДоставку.Status = "Выполнен" Тогда
			
			ЗаданиеНаДоставку.Status = "Выполнено";
			
		ИначеЕсли ЗаданиеНаДоставку.Status = "НеВыполнено" Тогда
			
			ЗаданиеНаДоставку.Status = "НеВыполнено";
			
		ИначеЕсли ЗаданиеНаДоставку.Status = "Отменен" Тогда
			
			ЗаданиеНаДоставку.Status = "Отменено";
			
		КонецЕсли;
		
		//Заполнение товаров
		КЧ_15_3 = Новый КвалификаторыЧисла(15,3);
		КЧ_15_2 = Новый КвалификаторыЧисла(15,2);
		КЧ_4_0 = Новый КвалификаторыЧисла(4,0);
		Массив = Новый Массив;
		Массив.Добавить(Тип("Число"));
		ОписаниеТиповЧ_15_3 = Новый ОписаниеТипов(Массив, , ,КЧ_15_3);
		ОписаниеТиповЧ_15_2 = Новый ОписаниеТипов(Массив, , ,КЧ_15_2);
		ОписаниеТиповЧ_4_0 = Новый ОписаниеТипов(Массив, , ,КЧ_4_0);
		ТаблицаТоваров = Новый ТаблицаЗначений;
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(Тип("СправочникСсылка.Номенклатура"));
		ТаблицаТоваров.Колонки.Добавить("Номенклатура", 	Новый ОписаниеТипов(МассивТипов));
		ТаблицаТоваров.Колонки.Добавить("Количество", 		ОписаниеТиповЧ_15_3);
		МассивТипов.Очистить();
		//МассивТипов.Добавить(Тип("СправочникСсылка.ХарактеристикиНоменклатуры"));
		ТаблицаТоваров.Колонки.Добавить("ХарактеристикаНоменклатуры", 	Новый ОписаниеТипов("Строка"));
		МассивТипов.Очистить();
		МассивТипов.Добавить(Тип("СправочникСсылка.ЕдиницыИзмерения"));
		ТаблицаТоваров.Колонки.Добавить("ЕдиницаИзмерения", 		Новый ОписаниеТипов(МассивТипов));
		ТаблицаТоваров.Колонки.Добавить("Цена", 			ОписаниеТиповЧ_15_2);
		ТаблицаТоваров.Колонки.Добавить("Сумма", 			ОписаниеТиповЧ_15_2);
		ТаблицаТоваров.Колонки.Добавить("НомерСтроки", 		ОписаниеТиповЧ_4_0);
		ТаблицаТоваров.Колонки.Добавить("Вес", 				ОписаниеТиповЧ_15_3);
		ТаблицаТоваров.Колонки.Добавить("Объем", 			ОписаниеТиповЧ_15_3);
		ТаблицаТоваров.Колонки.Добавить("КоличествоФакт", 	ОписаниеТиповЧ_15_3);
		ТаблицаТоваров.Колонки.Добавить("СуммаФакт", 		ОписаниеТиповЧ_15_2);
		
		МегаЛогист_УправлениеДоставкой.ПолучитьТоварыДляМаршрутногоЗадания(Выборка.Ссылка, ТаблицаТоваров);
		
		Попытка
			ВидОплаты=Выборка.Ссылка.ДокументыРеализации[0].ДокументСсылка.ДоговорКонтрагента.ВидОплаты;
			Если ВидОплаты=Перечисления.ВидыДенежныхСредств.Наличные тогда
				ЗаданиеНаДоставку.Sum = ТаблицаТоваров.Итог("Сумма");
			иначе
				ЗаданиеНаДоставку.Sum = 0;
			КонецЕсли;	
		Исключение
			ЗаданиеНаДоставку.Sum = 0;
		КонецПопытки;
				
		//ЗаполнятьТовары = Истина;
		//Если НЕ ЗначениеЗаполнено(Выборка.ДокументОснование) тогда
		//	ЗаполнятьТовары = Ложь;
		//КонецЕсли;
		//
		//Если ЗаполнятьТовары И НЕ Выборка.ДокументОснование.Проведен тогда
		//	ЗаполнятьТовары = Ложь;
		//КонецЕсли;	
		
		ТипТовары = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "Goods");
		ТипТовар = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "Good");
		СписокТоваров = ФабрикаXDTO.Создать(ТипТовары);
		//Если ЗаполнятьТовары Тогда
		//	ТаблицаТоваров = Выборка.ДокументОснование.Товары.Выгрузить();
		//	Если Не ЗначениеЗаполнено(Выборка.ДокументОснование) Тогда
		//		Продолжить;
		//	Иначе
		//		ТаблицаТоваров.Свернуть("Номенклатура, ЕдиницаИзмерения, Цена", "Количество, Сумма");
		//	КонецЕсли;
			Для Каждого СтрокаТЧ из ТаблицаТоваров цикл
				Товар = ФабрикаXDTO.Создать(ТипТовар);
				Товар.GoodID		= XMLСтрока(СтрокаТЧ.Номенклатура.Код);
				Товар.GoodName 	= XMLСтрока(СтрокаТЧ.Номенклатура.Наименование+" ("+СтрокаТЧ.ХарактеристикаНоменклатуры+")");
				Товар.Qnty 		= СтрокаТЧ.Количество;
				Товар.Pack 		= XMLСтрока(" " + СтрокаТЧ.ЕдиницаИзмерения);
				Если ВидОплаты=Перечисления.ВидыДенежныхСредств.Наличные тогда
					Товар.Price 	= СтрокаТЧ.Цена;
				иначе	
					Товар.Price 	= 0;
				КонецЕсли;	
				Товар.CharID		= "";
				Товар.CharName 		= XMLСтрока(СтрокаТЧ.ХарактеристикаНоменклатуры);
				Товар.QntyActual 	= СтрокаТЧ.КоличествоФакт;
				Товар.SummActual 	= СтрокаТЧ.СуммаФакт;
				
				СписокТоваров.Good.Добавить(Товар);
			КонецЦикла;	
		//КонецЕсли;
		ЗаданиеНаДоставку.Goods = СписокТоваров; 
		СписокЗаданий.ShuttleMission.Добавить(ЗаданиеНаДоставку);
	КонецЦикла;              
	
	//Добавление данных о GCM
	СписокЗаданий.GCMId = Константы.МегаЛогист_ProjectID.Получить();
	//СписокЗаданий.GCMId = "140392214548";
	//140392214548
	
     // Вернуть заявку
	 Возврат СписокЗаданий;
	 
КонецФункции

Функция GetReasons()
	
	// Получить типы объектов XDTO
    ТипПричины = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "Reasons");
	
	СписокПричин = ФабрикаXDTO.Создать(ТипПричины);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МегаЛогист_ПричиныНевыполнения.Наименование
	|ИЗ
	|	Справочник.МегаЛогист_ПричиныНевыполнения КАК МегаЛогист_ПричиныНевыполнения";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
	
		СписокПричин.Name.Добавить(Выборка.Наименование);
	
	КонецЦикла;
	
	// Вернуть заявку
	Возврат СписокПричин;
	
КонецФункции

Процедура УстановитьСтатусВыполнения(МЗ)
	
	//1. Найдем МЛ
	МЛ = МегаЛогист_УправлениеДоставкой.ПолучитьМаршрутныйЛистПоЗаданию(МЗ.Ссылка);
		
	Если МЛ.Статус <> Перечисления.МегаЛогист_СтатусыМаршрутныхЛистов.Выполняется Тогда
		Возврат;
	КонецЕсли;
	
	//2. Проверим
	мМаршрутныеЗадания = Новый Массив;
	Для Каждого тСтрока Из МЛ.МаршрутныеЗадания Цикл
		мМаршрутныеЗадания.Добавить(тСтрока.ДокументСсылка);
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	МегаЛогист_МаршрутноеЗадание.Ссылка
	               |ИЗ
	               |	Документ.МегаЛогист_МаршрутноеЗадание КАК МегаЛогист_МаршрутноеЗадание
	               |ГДЕ
	               |	МегаЛогист_МаршрутноеЗадание.Ссылка В(&тбзМаршрутныеЗадания)
	               |	И МегаЛогист_МаршрутноеЗадание.Статус = ЗНАЧЕНИЕ(Перечисление.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполняется)";
	Запрос.УстановитьПараметр("тбзМаршрутныеЗадания"	, мМаршрутныеЗадания);
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		МЛ=МЛ.ПолучитьОбъект();
		МЛ.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЛистов.Выполнен;
		МЛ.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
КонецПроцедуры

Функция LoadStatuses(СтрокаХМЛ)
	
	Попытка
	
		ЧтениеХМЛ = Новый ЧтениеXML;
		ЧтениеХМЛ.УстановитьСтроку(СтрокаХМЛ);
		
		ТипСписокЗаданий = ФабрикаXDTO.Тип("http://megalogist.ru/logist", "Statuses");
		
		СписокСтатусов = ФабрикаXDTO.ПрочитатьXML(ЧтениеХМЛ, ТипСписокЗаданий);
		
		//Для каждого Статус Из СписокСтатусов.Status Цикл
		//	
		//	ЗаданиеНаДоставку = Документы.МегаЛогист_МаршрутноеЗадание.НайтиПоНомеру(Статус.Number, ТекущаяДата()).ПолучитьОбъект();
		//	Если Статус.Type= "Комментари" Тогда
		//		ЗаданиеНаДоставку.КомментарийКурьера = Статус.Comment;
		//	Иначе
		//		ЗаданиеНаДоставку.Статус = Перечисления.МегаЛогист_СтатусыМаршрутногоЗадания[Статус.CurrStatus];
		//		ЗаданиеНаДоставку.ВремяДоставкиФакт 	= Статус.Time;
		//		Если Статус.Reason <> "" Тогда
		//			НайденныйЭлемент = Справочники.МегаЛогист_ПричиныНевыполнения.НайтиПоНаименованию(Статус.Reason);
		//			ЗаданиеНаДоставку.ПричинаНевыполнения 	= НайденныйЭлемент;
		//		КонецЕсли;
		//		ЗаданиеНаДоставку.КомментарийКПричине 	= Статус.Comment;
		//	КонецЕсли;
		//				
		//	ЗаданиеНаДоставку.Записать();
		//	
		//КонецЦикла;
		
		Для каждого Статус Из СписокСтатусов.Status Цикл
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	МегаЛогист_МаршрутноеЗадание.Ссылка
			               |ИЗ
			               |	Документ.МегаЛогист_МаршрутноеЗадание КАК МегаЛогист_МаршрутноеЗадание
			               |ГДЕ
			               |	МегаЛогист_МаршрутноеЗадание.Номер ПОДОБНО ""%"" + &Номер
			               |	И МегаЛогист_МаршрутноеЗадание.Дата >= &НачалоГода";
			
			Запрос.УстановитьПараметр("Номер", Статус.Number);
			Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ТекущаяДата()));

			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Если Выборка.Следующий() Тогда
				ЗаданиеНаДоставку = Выборка.Ссылка.ПолучитьОбъект();
			Иначе 
				Продолжить;
			КонецЕсли;
			
			//ЗаданиеНаДоставку = Документы.МаршрутноеЗадание.НайтиПоНомеру(Статус.Number, ТекущаяДата()).ПолучитьОбъект();
			Если Статус.Type= "Комментари" Тогда
				ЗаданиеНаДоставку.КомментарийКурьера = Статус.Comment;
			Иначе
				Если Статус.CurrStatus = "Выполняется" Тогда
					
					ЗаданиеНаДоставку.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполняется;
					
				ИначеЕсли Статус.CurrStatus = "Выполнено" Тогда
					
					ЗаданиеНаДоставку.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Выполнен;
					
				ИначеЕсли Статус.CurrStatus = "НеВыполнено" Тогда
					
					ЗаданиеНаДоставку.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.НеВыполнено;
					
				ИначеЕсли Статус.CurrStatus = "Отменено" Тогда
					
					ЗаданиеНаДоставку.Статус = Перечисления.МегаЛогист_СтатусыМаршрутныхЗаданий.Отменен;
					
				КонецЕсли;
				ЗаданиеНаДоставку.ВремяДоставкиФакт 	= Статус.Time;
				Если Статус.Reason <> "" Тогда
					НайденныйЭлемент = Справочники.МегаЛогист_ПричиныНевыполнения.НайтиПоНаименованию(Статус.Reason);
					ЗаданиеНаДоставку.ПричинаНевыполнения 	= НайденныйЭлемент;
				КонецЕсли;
				//НайденныйЭлемент = Справочники.МегаЛогист_ПричиныНевыполнения.НайтиПоНаименованию(Статус.Reason);
				//ЗаданиеНаДоставку.ПричинаНевыполнения 	= НайденныйЭлемент;
				ЗаданиеНаДоставку.КомментарийКПричине 	= Статус.Comment;
			КонецЕсли;
			ЗаданиеНаДоставку.ОбменДанными.Загрузка = Истина;
			ЗаданиеНаДоставку.Записать();
			
			УстановитьСтатусВыполнения(ЗаданиеНаДоставку);
						
		КонецЦикла;
		
		Возврат Истина
	
	Исключение
		
		Возврат Ложь;
	
	КонецПопытки;
	
	
КонецФункции

Функция ПолучитьКоординаты(Широта, Долгота, Скорость, Время, Курьер, Направление, ИмяПровайдера, НомерПровайдера)
	
	//Пользователь
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(Курьер);
	Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Пользователь) Тогда
		Запись = РегистрыСведений.МегаЛогист_ПеремещенияКурьеров.СоздатьМенеджерЗаписи();
		Запись.Долгота 			= Долгота;
		Запись.Широта 			= Широта;
		Запись.Скорость 		= Скорость;
		///////////////////////////////////////////
		//Мироненко Д.С 19.05.2016 10:56:44 НАЧАЛО
		//Комментарий: Используется время сервера
		//Запись.Период 			= Время;
		Запись.Период 			= ТекущаяДата();
		//Мироненко Д.С 19.05.2016 10:56:55 КОНЕЦ
		///////////////////////////////////////////
		Запись.Курьер 			= Пользователь.ФизическоеЛицо;
		Запись.Направление 		= Направление;
		Запись.ИмяПровайдера 	= ИмяПровайдера;
		Запись.НомерПровайдера 	= НомерПровайдера;
		Попытка
			Запись.Записать();
			Возврат Истина;
		Исключение
		    Возврат Ложь;
		КонецПопытки;
	КонецЕсли;
	Возврат Истина;
	
КонецФункции

Функция SetAppNumber(User, Number)
	
	//Пользователь
	ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(User);
	Пользователь = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ПользовательИБ.УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Пользователь) Тогда
		НаборЗаписей = РегистрыСведений.МегаЛогист_НомераПриложенийКурьеров.СоздатьНаборЗаписей();
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.Физлицо 		= Пользователь.ФизЛицо;
		НоваяСтрока.НомерПриложения = Number;
		НаборЗаписей.Записать(Истина);
		Возврат Истина;	
	Иначе
		Возврат Ложь;	
	КонецЕсли;
	
КонецФункции

Функция GetVersion()
	
	СтруктураВозврата = МегаЛогист_Служебный.ПолучитьНомерВерсии();
	
	ЧислоВозврата = "" + СтруктураВозврата.Версия;
	
	МассивВерсий = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтруктураВозврата.Релиз, ".", Истина);
	
	//Множитель = 1000000;//100 * 100 * 100;
	
	Для й = 0 По МассивВерсий.Количество() - 1 Цикл
	
		ЧислоВозврата = ЧислоВозврата + МассивВерсий[й] * 100;
		//Множитель = Множитель / 100;
	
	КонецЦикла;
	
	Возврат ЧислоВозврата;
	
КонецФункции

Функция LoadPayments(СтрокаJSON)
	
	Попытка
	
		ЧтениеJSON = Новый ЧтениеJSON;
		ЧтениеJSON.УстановитьСтроку(СтрокаJSON);
		
		МассивОтвета = ПрочитатьJSON(ЧтениеJSON);
		
		Для каждого Элемент Из МассивОтвета Цикл
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			               |	МегаЛогист_МаршрутноеЗадание.Ссылка
			               |ИЗ
			               |	Документ.МегаЛогист_МаршрутноеЗадание КАК МегаЛогист_МаршрутноеЗадание
			               |ГДЕ
			               |	МегаЛогист_МаршрутноеЗадание.Номер ПОДОБНО ""%"" + &Номер
			               |	И МегаЛогист_МаршрутноеЗадание.Дата >= &НачалоГода";
			
			Запрос.УстановитьПараметр("Номер", Элемент.Number);
			Запрос.УстановитьПараметр("НачалоГода", НачалоГода(ТекущаяДата()));

			
			Результат = Запрос.Выполнить();
			Выборка = Результат.Выбрать();
			
			Если Выборка.Следующий() Тогда
				ЗаданиеНаДоставку = Выборка.Ссылка.ПолучитьОбъект();
			Иначе 
				Продолжить;
			КонецЕсли;
			
			//ЗаданиеНаДоставку = Документы.МегаЛогист_МаршрутноеЗадание.НайтиПоНомеру(Элемент.Number, ТекущаяДата()).ПолучитьОбъект();
			
			ЗаданиеНаДоставку.ОплаченоНал	 = Элемент.Cash;
			ЗаданиеНаДоставку.ОплаченоБезНал = Элемент.Card;
			
			Для каждого Товар Из Элемент.Goods Цикл
				
				Номенклатура 	= Справочники.Номенклатура.НайтиПоКоду(Товар.id);
				//Характеристика 	= получитьСправочники.ХарактеристикиНоменклатуры.НайтиПоКоду(Товар.CharId);
				ГУИДХарактеристики = Новый УникальныйИдентификатор(Товар.CharId);
				Характеристика = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(ГУИДХарактеристики);
				СтруктураПоиска = Новый Структура("Номенклатура, ХарактеристикаНоменклатуры", Номенклатура, Характеристика);
				НайденныеСтроки = ЗаданиеНаДоставку.ТоварыФакт.НайтиСтроки(СтруктураПоиска);
				Если НайденныеСтроки.Количество() > 0 Тогда
					НоваяСтрока = НайденныеСтроки[0];
				Иначе
					НоваяСтрока = ЗаданиеНаДоставку.ТоварыФакт.Добавить();
					НоваяСтрока.Номенклатура 	= Номенклатура;
					НоваяСтрока.ХарактеристикаНоменклатуры 	= Характеристика;
				КонецЕсли;
				
				НоваяСтрока.Количество 		= Товар.count;
			
			КонецЦикла;
						
			ЗаданиеНаДоставку.Записать();
			
		КонецЦикла;
		
		Возврат Истина
	
	Исключение
		
		ЗаписьЖурналаРегистрации("Ошибка загрузки платежа",,,,ОписаниеОшибки()); 
		Возврат Ложь;
	
	КонецПопытки;
	
КонецФункции



