﻿Перем мСвойствоЗагруженИз77СПБ;

Функция ЗагрузитьИз77НаСервере() Экспорт
	
	 ДокументСсылка = ОбменДаннымиВызовСервера.ПолучитьДокументИз77(
	 Новый Структура("Номер77,Дата77,ПерезаполнятьШапку,ПерезаполнятьТЧТовары,РеализацияТоваров_НН",
	 Номер77,Дата77,ПерезаполнятьШапку,ПерезаполнятьТЧТовары,РеализацияТоваров_НН));
	 
	 Возврат ДокументСсылка;
	
КонецФункции


Функция ЗагрузитьИз77() Экспорт
	
	Если ЗначениеЗаполнено(РеализацияТоваров_НН) Тогда
		Возврат ЗагрузитьИз77_НН();
	ИначеЕсли ЗначениеЗаполнено(Номер77) Тогда
		Возврат ЗагрузитьИз77_СПБ();
	КонецЕсли;  	
	
КонецФункции

Функция ЗагрузитьИз77_СПБ() Экспорт
	
	ДокументСсылка = Неопределено;
	
	Если Не ЗначениеЗаполнено(Номер77) Тогда
		Возврат ДокументСсылка;
	КонецЕсли;
	
	Если СтрДлина(Номер77) < 11 Тогда 
		НомерРТУ = Лев(Номер77,4)+"0"+Сред(Номер77,5);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Дата77) Тогда
		Дата77 = Дата(2018,1,1);
	КонецЕсли;
	
	Если Год(Дата77) = 2019 Тогда
		Сообщить("Можно загрузить документ до 2019 года!");
		Возврат ДокументСсылка;
	КонецЕсли;
	
	ТекстОшибки = "";
	Попытка
		ДокументСсылка = ЗагрузитьШаблонДокументаИз77(ТекстОшибки);		
	Исключение
		ТекстОшибки = "Ошибка загрузки документа из базы 7.7. Номер: "+Номер77+", дата: "+Дата77+": "+ОписаниеОшибки();
	КонецПопытки;
	
	Возврат ДокументСсылка;
	
КонецФункции

Функция ЗагрузитьИз77_НН() Экспорт
	
	ДокументСсылка = Неопределено;
	
	Если Не ЗначениеЗаполнено(РеализацияТоваров_НН) Тогда
		Возврат ДокументСсылка;
	КонецЕсли;
	
	//Не надо затирать движения, если они уже есть
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ первые 1
		|	ПартииТоваров.Регистратор
		|ИЗ
		|	РегистрНакопления.ПартииТоваров КАК ПартииТоваров
		|ГДЕ
		|	ПартииТоваров.Регистратор = &Регистратор
		|	И ПартииТоваров.Активность";
	
	Запрос.УстановитьПараметр("Регистратор", РеализацияТоваров_НН);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;

	
	ТекстОшибки = "";
	Попытка
		ЗаполнитьПартииПоДанным77_НН(РеализацияТоваров_НН);		
	Исключение
		ТекстОшибки = "Ошибка загрузки документа из базы 7.7. Документ: "+РеализацияТоваров_НН+": "+ОписаниеОшибки();
		Сообщить(ТекстОшибки);
	КонецПопытки;
	
	Возврат ДокументСсылка;
	
КонецФункции

//Заполнение из 77 НН
Процедура ЗаполнитьПартииПоДанным77_НН(вхДокументСсылка)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(вхДокументСсылка, "Номер, Дата, Склад, Склад.СкладVMI");
	
	ПерваяБуква = Лев(Реквизиты.Номер, 1);
	Если НЕ (ПерваяБуква = "N" ИЛИ ПерваяБуква = "O" ИЛИ ПерваяБуква = "D") Тогда
		Сообщить("Выбрана реализация не из базы 7.7 НН");
		Возврат;
	КонецЕсли;
	
	НомерДокумента77 = Лев(Реквизиты.Номер,3)+Прав(Реквизиты.Номер,7);
	
	Connection = ИнициализироватьСоединение(Connection, "нн");
	
	RSПартии = Новый COMОбъект("ADODB.Recordset");
	Структура = Новый Структура("DOCNO,Дата", НомерДокумента77, Реквизиты.Дата);
	RSПартии.Open(СформироватьТекстЗапросаПартии(Структура, "нн"), Connection);
	
	КурсДоллара = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаДоллар, Реквизиты.Дата);
	КурсЕвро = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаЕвро, Реквизиты.Дата);

	ТекстОшибки = "";
	КачествоНовый = Справочники.Качество.Новый;
	НЗ = РегистрыНакопления.ПартииТоваров.СоздатьНаборЗаписей();
	НЗ.Отбор.Регистратор.Установить(вхДокументСсылка);
	Пока RSПартии.EOF() = 0 Цикл
		
		НоваяСтрока = НЗ.Добавить();
		НоваяСтрока.Период = Реквизиты.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
		НоваяСтрока.Активность = Ложь;
		НоваяСтрока.Качество = КачествоНовый;
		НоваяСтрока.Организация = ПолучитьОрганизацию(RSПартии.Fields("firm").Value, "нн");
		НоваяСтрока.Количество = RSПартии.Fields("Kolvo").Value;
		НоваяСтрока.СуммаРубли = RSПартии.Fields("SummaRUB").Value;
		НоваяСтрока.СуммаБезНДС = RSПартии.Fields("SummaBesNDS").Value;
		
		НоваяСтрока.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
		ПараметрыСеанса.ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
		НоваяСтрока.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
		ПараметрыСеанса.ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
		
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(RSПартии.Fields("NomenklaturaID").Value));
		НоваяСтрока.Склад = Реквизиты.Склад;
		Если ЗначениеЗаполнено(Реквизиты.Склад) Тогда 
			НоваяСтрока.СтатусПартии = ?(Реквизиты.СкладСкладVMI, Перечисления.СтатусыПартии.ПринятыйНаОтветХранение, Перечисления.СтатусыПартии.Собственный);
		КонецЕсли;
		
		ИДСтрокиПрихода77 = RSПартии.Fields("StrokaPrihoda1c8").Value;
		
		Если Не ЗначениеЗаполнено(ИДСтрокиПрихода77) Тогда
			ТекстОшибки = "Не найдено соответствия для строки прихода из 7.7 НН в таблице adoURBD_Guids. "+"SC214.ID """+RSПартии.Fields("SprPartyID").Value+"""";
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		ИДСтрокиПрихода77 = СтрЗаменить(ИДСтрокиПрихода77, "}", "");
		ИДСтрокиПрихода77 = СтрЗаменить(ИДСтрокиПрихода77, "{", "");
		
		СтрокаПрихода = Справочники.ИдентификаторыСтрокПриходов.ПолучитьСсылку(Новый УникальныйИдентификатор(ИДСтрокиПрихода77));
		Если Не ОбщегоНазначения.СсылкаСуществует(СтрокаПрихода) Тогда
			ТекстОшибки = "Не найдено строки прихода по ссылке из adoURBD_Guids: "+ИДСтрокиПрихода77;
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
		
		////Создаем строку прихода
		//ИДСтрокиПрихода77 = RSПартии.Fields("PartyID").Value;
		//СтрокаПрихода = СтрокаПриходаПоИдентификатору77(ИДСтрокиПрихода77);
		//Если Не ЗначениеЗаполнено(СтрокаПрихода) Тогда
		//	
		//	СтрокаПриходаОбъект = Справочники.ИдентификаторыСтрокПриходов.СоздатьЭлемент();
		//	СсылкаНаЭлемент = Справочники.ИдентификаторыСтрокПриходов.ПолучитьСсылку();
		//	СтрокаПриходаОбъект.УстановитьСсылкуНового(СсылкаНаЭлемент);
		//	СтрокаПриходаОбъект.Наименование = Строка(СсылкаНаЭлемент.УникальныйИдентификатор());
		//	
		//	//Страна
		//	СтранаНаименование = СокрЛП(RSПартии.Fields("StranaDESCR").Value);
		//	Если ЗначениеЗаполнено(СтранаНаименование) Тогда
		//		СтрокаПриходаОбъект.СтранаПроисхождения = Справочники.СтраныМира.НайтиПоНаименованию(СтранаНаименование);
		//	КонецЕсли;
		//	
		//	//ГТД
		//	НомерГТДКод  = СокрЛП(RSПартии.Fields("GTDName").Value);
		//	Если ЗначениеЗаполнено(НомерГТДКод) Тогда
		//		НомерГТД = Справочники.НомераГТД.НайтиПоКоду(НомерГТДКод);
		//		Если Не ЗначениеЗаполнено(НомерГТД) Тогда
		//			НомерГТДОбъект = Справочники.НомераГТД.СоздатьЭлемент();
		//			НомерГТДОбъект.Код = НомерГТДКод;
		//			НомерГТДОбъект.ОбменДанными.Загрузка = Истина;
		//			НомерГТДОбъект.Записать();
		//			НомерГТД = НомерГТДОбъект.Ссылка;
		//		КонецЕсли;
		//		СтрокаПриходаОбъект.НомерГТД = НомерГТД;
		//	КонецЕсли;
		//	
		//	СтрокаПриходаОбъект.ИдентификаторПартии77 = ИДСтрокиПрихода77;
		//	
		//	//ТТ
		//	УИДКонтрагента = RSПартии.Fields("PostavshikUID").Value;
		//	Если ЗначениеЗаполнено(УИДКонтрагента) Тогда
		//		Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("GUID_СПБ", УИДКонтрагента);
		//		Если ЗначениеЗаполнено(Контрагент) Тогда
		//			 СтрокаПриходаОбъект.ТорговаяТочка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ОсновнаяТорговаяТочка");					
		//		КонецЕсли;				
		//	КонецЕсли;
		//	
		//	СтрокаПриходаОбъект.Записать();
		//	СтрокаПрихода = СтрокаПриходаОбъект.Ссылка;
		//	//ДобавитьСвойствоЗагруженИз77(СтрокаПрихода);
		//	
		//	//МЗ_ДляПереносаДанных = РегистрыСведений._ДляПереносаДанных.СоздатьМенеджерЗаписи();
		//	//МЗ_ДляПереносаДанных.Объект = СтрокаПрихода;
		//	//МЗ_ДляПереносаДанных.Строка77 = "SPB_SC214_"+ИДСтрокиПрихода77;
		//	//МЗ_ДляПереносаДанных.Записать();
		//	
		//КонецЕсли;
		
		НоваяСтрока.СтрокаПрихода = СтрокаПрихода;
		
		RSПартии.MoveNext();
	КонецЦикла;
	НЗ.ОбменДанными.Загрузка = Истина;
	НЗ.ДополнительныеСвойства.Вставить("СнятьОграничениеПоДатеЗапрета");
	НЗ.Записать();
	
	RSПартии.Close();
	
КонецПроцедуры


//Заполнение из 77 СПБ
Функция ЗагрузитьШаблонДокументаИз77(ТекстОшибки = "")
	
	ДокСсылка = Неопределено;
	
	Connection = ИнициализироватьСоединение(Connection);
	
	RS = Новый COMОбъект("ADODB.Recordset");
	Структура = Новый Структура("DOCNO,IDDOCDEF", Номер77, "1611");
	RS.Open(СформироватьТекстЗапросаШапка(Структура), Connection);
	Пока RS.EOF() = 0 Цикл
		ДокОбъект = СоздатьДокументПоДанным77(Структура, RS);
		ДокСсылка = ЗаполнитьТоварыПоДанным77(ДокОбъект, RS, Connection);
		Если ЗначениеЗаполнено(ДокСсылка) Тогда
			ЗаполнитьПартииПоДанным77(ДокСсылка, RS, Connection);
		КонецЕсли;
		RS.MoveNext();
	КонецЦикла;
	RS.Close();
	Connection.Close(); 
	
	Если НЕ ЗначениеЗаполнено(ДокСсылка) Тогда
		ТекстОшибки = ТекстОшибки + Символы.ПС + "Документ не найден в базе 77, проверьте номер и дату";
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
	Возврат ДокСсылка;
	
КонецФункции

//Заполнение партий
Процедура ЗаполнитьПартииПоДанным77(ДокСсылка, RS, Connection = Неопределено)
	
	Connection = ИнициализироватьСоединение(Connection);
	
	RSПартии = Новый COMОбъект("ADODB.Recordset");
	Структура = Новый Структура("DOCNO,RS", Номер77, RS);
	RSПартии.Open(СформироватьТекстЗапросаПартии(Структура), Connection);
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокСсылка, "Склад, Склад.СкладVMI, Дата");
	КурсДоллара = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаДоллар, Реквизиты.Дата);
	КурсЕвро = МодульВалютногоУчета.ПолучитьКурсВалюты(ПараметрыСеанса.ВалютаЕвро, Реквизиты.Дата);

	КачествоНовый = Справочники.Качество.Новый;
	НЗ = РегистрыНакопления.ПартииТоваров.СоздатьНаборЗаписей();
	НЗ.Отбор.Регистратор.Установить(ДокСсылка);
	Пока RSПартии.EOF() = 0 Цикл
		
		НоваяСтрока = НЗ.Добавить();
		НоваяСтрока.Период = Реквизиты.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
		НоваяСтрока.Активность = Ложь;
		НоваяСтрока.Качество = КачествоНовый;
		НоваяСтрока.Организация = ПолучитьОрганизацию(RSПартии.Fields("firm").Value);
		НоваяСтрока.Количество = RSПартии.Fields("Kolvo").Value;
		НоваяСтрока.СуммаРубли = RSПартии.Fields("SummaRUB").Value;
		НоваяСтрока.СуммаБезНДС = RSПартии.Fields("SummaBesNDS").Value;
		
		НоваяСтрока.СуммаДоллары = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
		ПараметрыСеанса.ВалютаДоллар, 1, КурсДоллара.Курс, 1, КурсДоллара.Кратность);
		НоваяСтрока.СуммаЕвро = МодульВалютногоУчета.ПересчитатьИзВалютыВВалюту(НоваяСтрока.СуммаРубли, ПараметрыСеанса.ВалютаРубль,
		ПараметрыСеанса.ВалютаЕвро, 1, КурсЕвро.Курс, 1, КурсЕвро.Кратность);
		
		НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(RSПартии.Fields("NomenklaturaID").Value));
		НоваяСтрока.Склад = Реквизиты.Склад;
		Если ЗначениеЗаполнено(Реквизиты.Склад) Тогда 
			НоваяСтрока.СтатусПартии = ?(Реквизиты.СкладСкладVMI, Перечисления.СтатусыПартии.ПринятыйНаОтветХранение, Перечисления.СтатусыПартии.Собственный);
		КонецЕсли;
		
		//Создаем строку прихода
		ИДСтрокиПрихода77 = RSПартии.Fields("PartyID").Value;
		СтрокаПрихода = СтрокаПриходаПоИдентификатору77(ИДСтрокиПрихода77);
		Если Не ЗначениеЗаполнено(СтрокаПрихода) Тогда
			
			СтрокаПриходаОбъект = Справочники.ИдентификаторыСтрокПриходов.СоздатьЭлемент();
			СсылкаНаЭлемент = Справочники.ИдентификаторыСтрокПриходов.ПолучитьСсылку();
			СтрокаПриходаОбъект.УстановитьСсылкуНового(СсылкаНаЭлемент);
			СтрокаПриходаОбъект.Наименование = Строка(СсылкаНаЭлемент.УникальныйИдентификатор());
			
			//Страна
			СтранаНаименование = СокрЛП(RSПартии.Fields("StranaDESCR").Value);
			Если ЗначениеЗаполнено(СтранаНаименование) Тогда
				СтрокаПриходаОбъект.СтранаПроисхождения = Справочники.СтраныМира.НайтиПоНаименованию(СтранаНаименование);
			КонецЕсли;
			
			//ГТД
			НомерГТДКод  = СокрЛП(RSПартии.Fields("GTDName").Value);
			Если ЗначениеЗаполнено(НомерГТДКод) Тогда
				НомерГТД = Справочники.НомераГТД.НайтиПоКоду(НомерГТДКод);
				Если Не ЗначениеЗаполнено(НомерГТД) Тогда
					НомерГТДОбъект = Справочники.НомераГТД.СоздатьЭлемент();
					НомерГТДОбъект.Код = НомерГТДКод;
					НомерГТДОбъект.ОбменДанными.Загрузка = Истина;
					НомерГТДОбъект.Записать();
					НомерГТД = НомерГТДОбъект.Ссылка;
				КонецЕсли;
				СтрокаПриходаОбъект.НомерГТД = НомерГТД;
			КонецЕсли;
			
			СтрокаПриходаОбъект.ИдентификаторПартии77 = ИДСтрокиПрихода77;
			
			//ТТ
			УИДКонтрагента = RSПартии.Fields("PostavshikUID").Value;
			Если ЗначениеЗаполнено(УИДКонтрагента) Тогда
				Контрагент = Справочники.Контрагенты.НайтиПоРеквизиту("GUID_СПБ", УИДКонтрагента);
				Если ЗначениеЗаполнено(Контрагент) Тогда
					 СтрокаПриходаОбъект.ТорговаяТочка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контрагент, "ОсновнаяТорговаяТочка");					
				КонецЕсли;				
			КонецЕсли;
			
			СтрокаПриходаОбъект.Записать();
			СтрокаПрихода = СтрокаПриходаОбъект.Ссылка;
			ДобавитьСвойствоЗагруженИз77(СтрокаПрихода);
			
			МЗ_ДляПереносаДанных = РегистрыСведений._ДляПереносаДанных.СоздатьМенеджерЗаписи();
			МЗ_ДляПереносаДанных.Объект = СтрокаПрихода;
			МЗ_ДляПереносаДанных.Строка77 = "SPB_SC214_"+ИДСтрокиПрихода77;
			МЗ_ДляПереносаДанных.Записать();
			
		КонецЕсли;
		
		НоваяСтрока.СтрокаПрихода = СтрокаПрихода;
		
		RSПартии.MoveNext();
	КонецЦикла;
	НЗ.ОбменДанными.Загрузка = Истина;
	НЗ.ДополнительныеСвойства.Вставить("СнятьОграничениеПоДатеЗапрета");
	НЗ.Записать();
	
	RSПартии.Close();
	
КонецПроцедуры

//Заполнение ТЧ товары
Функция ЗаполнитьТоварыПоДанным77(ДокОбъект, RS, Connection = Неопределено)
	
	Если ПерезаполнятьТЧТовары ИЛИ ДокОбъект.Товары.Количество() = 0 Тогда
		
		Connection = ИнициализироватьСоединение(Connection);
		
		RSТЧ = Новый COMОбъект("ADODB.Recordset");
		Структура = Новый Структура("DOCNO,RS", Номер77, RS);
		RSТЧ.Open(СформироватьТекстЗапросаТЧ(Структура), Connection);
		ДокОбъект.Товары.Очистить();
		Пока RSТЧ.EOF() = 0 Цикл
			НоваяСтрока = ДокОбъект.Товары.Добавить();
			НоваяСтрока.Номенклатура = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(RSТЧ.Fields("NomenklaturaID").Value));
			НоваяСтрока.Количество = RSТЧ.Fields("Kolvo").Value;
			НоваяСтрока.КоличествоПлан = НоваяСтрока.Количество;
			НоваяСтрока.Цена = RSТЧ.Fields("Price").Value;
			НоваяСтрока.Сумма = RSТЧ.Fields("Summa").Value;
			НоваяСтрока.СуммаНДС = RSТЧ.Fields("SummaNDS").Value;
			Если ОбщегоНазначения.СсылкаСуществует(НоваяСтрока.Номенклатура) Тогда
				Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоваяСтрока.Номенклатура, "СтавкаНДС,ЕдиницаХраненияОстатков,ЕдиницаХраненияОстатков.Коэффициент");	
				НоваяСтрока.СтавкаНДС = Реквизиты.СтавкаНДС;	
				НоваяСтрока.ЕдиницаИзмерения = Реквизиты.ЕдиницаХраненияОстатков;
				НоваяСтрока.Коэффициент = Реквизиты.ЕдиницаХраненияОстатковКоэффициент;
				
				Если ДокОбъект.Дата < Дата(2019,1,1) Тогда
					Если НоваяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС20 Тогда
						НоваяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС18;
					ИначеЕсли НоваяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС20_120 Тогда
						НоваяСтрока.СтавкаНДС = Перечисления.СтавкиНДС.НДС18_118;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			//Строка заявки
			IDSite = СокрЛП(RSТЧ.Fields("IDSite").Value);
			Если ЗначениеЗаполнено(IDSite) Тогда
				
				СтрокаЗаявки = Справочники.ИдентификаторыСтрокЗаявок.НайтиПоРеквизиту("IDSite",IDSite);
				Если Не ЗначениеЗаполнено(СтрокаЗаявки) Тогда
					СтрокаЗаявкиОбъект = Справочники.ИдентификаторыСтрокЗаявок.СоздатьЭлемент();
					СтрокаЗаявкиОбъект.IDSite = IDSite;
					СтрокаЗаявкиОбъект.Наименование = IDSite;
					СтрокаЗаявкиОбъект.Виртуальная = Истина;
					СтрокаЗаявкиОбъект.ОбменДанными.Загрузка = Истина;
					СтрокаЗаявкиОбъект.Записать();
					СтрокаЗаявки = СтрокаЗаявкиОбъект.Ссылка;
					ДобавитьСвойствоЗагруженИз77(СтрокаЗаявки);
				КонецЕсли;	
				
				НоваяСтрока.СтрокаЗаявки = СтрокаЗаявки;				
				
			КонецЕсли; 			
			
			RSТЧ.MoveNext();
		КонецЦикла;
		RSТЧ.Close();
		
	КонецЕсли;
	
	
	//Если Не ЭтоТест Тогда 
	ДокОбъект.ОбменДанными.Загрузка = Истина;
	ДокОбъект.Источник = Перечисления.ИсточникиРеализаций.База77;
	МетаданныеДокумента = ДокОбъект.Метаданные();
	РежимУправленияБД = ?(Строка(МетаданныеДокумента.РежимУправленияБлокировкойДанных) = "Управляемый", РежимУправленияБлокировкойДанных.Управляемый, РежимУправленияБлокировкойДанных.Автоматический);
	
	НачатьТранзакцию(РежимУправленияБД);
	Попытка;
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокОбъект);
		//Об.Записать();
		Набор = РегистрыСведений._ДляПереносаДанных.СоздатьНаборЗаписей();
		Набор.Отбор.Объект.Установить(ДокОбъект.Ссылка);
		Набор.Прочитать();
		Для Каждого Стр Из Набор Цикл 
			Стр.Число77 = 0;
		КонецЦикла;
		Набор.Записать();
		ЗафиксироватьТранзакцию();
		Сообщить("Создан/обновлен документ "+ДокОбъект.Ссылка);
		ДобавитьСвойствоЗагруженИз77(ДокОбъект.Ссылка);
	Исключение
		ТекстОшибки = "Не удалось записать документ, ошибка: "+ОписаниеОшибки();
		Сообщить(ТекстОшибки);
		ОтменитьТранзакцию();
	КонецПопытки;
	//КонецЕсли;
	
	Возврат ДокОбъект.Ссылка;
	
КонецФункции

//Заполнение шапки
Функция СоздатьДокументПоДанным77(СтрокаТЧ, RS)
	
	Если СтрДлина(Номер77) < 11 Тогда 
		НомерРТУ = Лев(Номер77,4)+"0"+Сред(Номер77,5);
	КонецЕсли;
	
	ДокументСсылка =  Документы.РеализацияТоваровУслуг.НайтиПоНомеру(НомерРТУ, Дата77);
	
	Если Не ЗначениеЗаполнено(ДокументСсылка) Тогда 
		Об = Документы.РеализацияТоваровУслуг.СоздатьДокумент();
	Иначе
		Об = ДокументСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если Об.ЭтоНовый() ИЛИ ПерезаполнятьШапку Тогда 
		
		МетаданныеДокумента = Об.Метаданные();
		ПрисвоитьЗначениеРеквизита(Об, "СуммаДокумента", RS, "sum");
		ПрисвоитьЗначениеРеквизита(Об, "ДатаОплаты", RS, "datepay");
		
		Номер = ОбщегоНазначения.ПреобразоватьНомер(СокрЛП(RS.Fields("DOCNO").Value));
		Если Об.Номер <> Номер Тогда 
			Сообщить("Параметры поиска: Номер в 8ке "  + Номер + ", Номер из 7ки " + RS.Fields("DOCNO").Value);
			Об.Номер = Номер;
		КонецЕсли;	
		
		//ПрисвоитьЗначениеРеквизита(Об, "Контрагент", RS, "client");
		Контрагент = ПолучитьКонтрагента(RS.Fields("client").Value);
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("Контрагент", МетаданныеДокумента) Тогда 
			Об.Контрагент = Контрагент;
		ИначеЕсли ОбщегоНазначения.ЕстьРеквизитДокумента("КонтрагентДебитор", МетаданныеДокумента) Тогда  
			Об.КонтрагентДебитор = Контрагент;
		КонецЕсли;
		
		Об.ДоговорКонтрагента = ПолучитьДоговор(RS.Fields("contract").Value, Контрагент);
		
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("ВалютаДокумента", МетаданныеДокумента) Тогда 
			Об.ВалютаДокумента = глЗначениеПеременной("ВалютаРегламентированногоУчета");
		КонецЕсли;
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КратностьВзаиморасчетов", МетаданныеДокумента) Тогда 
			Об.КратностьВзаиморасчетов = 1;
		КонецЕсли;
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КурсВзаиморасчетов", МетаданныеДокумента) Тогда 
			Об.КурсВзаиморасчетов = 1;
		КонецЕсли;
		
		Если МетаданныеДокумента = Метаданные.Документы.КорректировкаДолга Тогда 
			Об.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности;
			Об.СуммыДолга.Очистить();
			
			НоваяСтрока = Об.СуммыДолга.Добавить();
			НоваяСтрока.ДоговорКонтрагента = Об.ДоговорКонтрагента;
			НоваяСтрока.Контрагент = Контрагент;
			Если RS.Fields("sum").Value > 0 Тогда 
				Сумма = RS.Fields("sum").Value;
				НоваяСтрока.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская;
			Иначе
				Сумма = - RS.Fields("sum").Value;
				НоваяСтрока.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская;
			КонецЕсли;
			//Об.СуммаДокумента = Сумма;		
			НоваяСтрока.СуммаРегл = Сумма;
			НоваяСтрока.Сумма = Сумма;
			НоваяСтрока.КурсВзаиморасчетов = 1;
			НоваяСтрока.КратностьВзаиморасчетов = 1;
		ИначеЕсли МетаданныеДокумента = Метаданные.Документы.ВозвратТоваровОтПокупателя 
			Или МетаданныеДокумента = Метаданные.Документы.РеализацияТоваровУслуг 
			Или МетаданныеДокумента = Метаданные.Документы.ВозвратТоваровПоставщику 
			Или МетаданныеДокумента = Метаданные.Документы.ПоступлениеТоваровУслуг Тогда 
			Об.Товары.Очистить();
			НоваяСтрока = Об.Товары.Добавить();
			НоваяСтрока.Сумма = Об.СуммаДокумента;
		ИначеЕсли МетаданныеДокумента = Метаданные.Документы.ПриходныйКассовыйОрдер 
			Или МетаданныеДокумента = Метаданные.Документы.ПлатежноеПоручениеВходящее 
			Или МетаданныеДокумента = Метаданные.Документы.РасходныйКассовыйОрдер Или
			МетаданныеДокумента = Метаданные.Документы.ПлатежноеПоручениеИсходящее Тогда 
			Об.РасшифровкаПлатежа.Очистить();
			НоваяСтрока = Об.РасшифровкаПлатежа.Добавить();
			НоваяСтрока.СуммаПлатежа = RS.Fields("sum").Value;
			НоваяСтрока.ДоговорКонтрагента = Об.ДоговорКонтрагента;
			НоваяСтрока.СуммаВзаиморасчетов = НоваяСтрока.СуммаПлатежа;
			НоваяСтрока.КратностьВзаиморасчетов = 1;
			НоваяСтрока.КурсВзаиморасчетов = 1;
		КонецЕсли;
		
		Об.Организация = ПолучитьОрганизацию(RS.Fields("firm").Value);
		Об.Дата = Дата(RS.Fields("date").Value + "000000");
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("Склад", МетаданныеДокумента) И RS.Fields("warehouse").Value <> NULL Тогда 
			Об.Склад = ПолучитьСклад(RS.Fields("warehouse").Value);
		КонецЕсли;
		
		Об.Источник = Перечисления.ИсточникиРеализаций.База77;
		Об.Комментарий = "загружен из sql 77";
		
	КонецЕсли;
	
	
	Возврат Об;
	
КонецФункции

//Тексты запросов
Функция СформироватьТекстЗапросаТЧ(Структура)
	
	ТекстЗапроса = "SELECT 
	|DT.LINENO_ AS LINENO_,
	|SprNom.SP11426 AS NomenklaturaID,
	|DT.SP1599 AS SP1599, 
	|DT.SP1600 AS Kolvo, 
	|DT.SP1603 AS Price,  
	|DT.SP1604 AS Summa,
	|DT.SP1605 As SummaNDS,
	|DT.SP1607 As Partia,
	|DocTrebovanieTab.SP9769,
	|DocTrebovanieTab.IDDoc,
	|DocZayavkaTab.SP10514 As IDSite
	|from DT1611 AS DT
	|LEFT JOIN DH1611 AS DH on DH.IDDoc = DT.IDDoc
	|LEFT JOIN SC84 AS SprNom on SprNom.ID = DT.SP1599
	|LEFT JOIN DT7638 AS DocTrebovanieTab on DocTrebovanieTab.IDDoc = right(DH.SP1587, 9) AND  DocTrebovanieTab.SP7621 = DT.SP1599
	|LEFT JOIN DT2457 AS DocZayavkaTab on DocZayavkaTab.IDDoc = DocTrebovanieTab.SP9769 AND  DocZayavkaTab.SP2446 = DT.SP1599
	|WHERE DT.IDDOC = %1";
	
	ТекстЗапроса = СтрШаблон(ТекстЗапроса, "'" + Структура.RS.Fields("IDDOC").Value + "'" );
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СформироватьТекстЗапросаШапка(Структура)
	
	ТекстЗапроса =  "SELECT left(j.DATE_TIME_IDDOC,8) AS date, 
	|j.DOCNO AS DOCNO,
	|j.IDDOC,
	|C.SP11899 AS client, 
	|d.Code AS contract,  
	|skl.Code AS warehouse,
	|dh.SP1604 As sum,
	|dh.SP1588 As datepay, 
	|f.Code As firm  from DH1611 AS dh 
	|INNER JOIN _1SJOURN as j on dh.IDDOC = j.IDDOC 
	|LEFT JOIN SC172 AS C on C.ID = dh.SP1583
	|LEFT JOIN SC204 AS d on d.ID = dh.SP1584
	|LEFT JOIN SC55 AS skl on skl.id = dh.SP1593
	|LEFT JOIN SC4014 AS f on f.ID = j.SP4056
	|WHERE j.DOCNO = %1 and j.IDDOCDEF = %2 and left(j.DATE_TIME_IDDOC,4) = %3";   // отбор по дате
	
	ТекстЗапроса = СтрШаблон(ТекстЗапроса, "'" + Структура.DOCNO + "'", Структура.IDDOCDEF, Формат(Дата77,"ДФ=yyyy"));
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СформироватьТекстЗапросаПартии(Структура,база = "спб")
	
	Если база = "нн" Тогда
		
		ТекстЗапроса =  "SELECT 
		|RA.LINENO_ AS LINENO_,
		|SprNom.SP13121 AS NomenklaturaID,
		|RA.SP331 AS SP331, 
		|f.Code As firm, 
		|RA.SP341 AS PartyID,
		|SprParty.SP586 AS StranaID,
		|SprStrany.CODE AS StranaCODE,
		|SprStrany.DESCR AS StranaDESCR,
		|SprStrany.SP12401 AS StranaAlpha2,
		|SprStrany.SP12717 AS StranaFullName,	
		|SprParty.SP585 AS GTDID,
		|SprGTD.DESCR AS GTDName,
		|SprParty.ID AS SprPartyID,
		|SprParty.SP436 AS PostavshikID,
		|SprKontr.SP13668 AS PostavshikUID, 
		|SprKontr.DESCR AS PostavshikDESCR,
		|SprParty.SP2796 AS ZakupPrice,
		|TabSootvet._Id AS StrokaPrihoda1c8,
		|RA.SP343 AS SummaRUB,  
		|RA.SP344 As SummaBesNDS,
		|RA.SP342 As Kolvo
		|from RA328 AS RA
		|INNER JOIN _1SJOURN as j on RA.IDDOC = j.IDDOC and j.IDDOCDEF = 1611 and j.DOCNO = %1 and left(j.DATE_TIME_IDDOC,4) = %2
		|LEFT JOIN SC84 AS SprNom on SprNom.ID = RA.SP331
		|LEFT JOIN SC4014 AS f on f.ID = RA.SP4061
		|LEFT JOIN SC214 AS SprParty on SprParty.ID = RA.SP341
		|LEFT JOIN SC568 AS SprGTD on SprGTD.ID = SprParty.SP585
		|LEFT JOIN SC566 AS SprStrany on SprStrany.ID = SprParty.SP586
		|LEFT JOIN SC172 AS SprKontr on SprKontr.ID = SprParty.SP436
		|LEFT JOIN adoURBD_Guids AS TabSootvet on SprParty.ID = TabSootvet._Object and TabSootvet._MetaType = 11 and TabSootvet._MetaId = 214";
		//|WHERE j.DOCNO = %1 and left(j.DATE_TIME_IDDOC,4) = %2";
		ТекстЗапроса = СтрШаблон(ТекстЗапроса, "'" + Структура.DOCNO + "'", Формат(Структура.Дата,"ДФ=yyyy") );
		
	Иначе
		
		ТекстЗапроса =  "SELECT 
		|RA.LINENO_ AS LINENO_,
		|SprNom.SP11426 AS NomenklaturaID,
		|RA.SP331 AS SP331, 
		|f.Code As firm, 
		|RA.SP341 AS PartyID,
		|SprParty.SP586 AS StranaID,
		|SprStrany.CODE AS StranaCODE,
		|SprStrany.DESCR AS StranaDESCR,
		|SprStrany.SP11211 AS StranaAlpha2,
		|SprStrany.SP11212 AS StranaFullName,	
		|SprParty.SP585 AS GTDID,
		|SprGTD.DESCR AS GTDName,
		|SprParty.SP436 AS PostavshikID,
		|SprKontr.SP11899 AS PostavshikUID,
		|SprKontr.DESCR AS PostavshikDESCR,
		|SprParty.SP2796 AS ZakupPrice,	
		|RA.SP343 AS SummaRUB,  
		|RA.SP344 As SummaBesNDS,
		|RA.SP342 As Kolvo
		|from RA328 AS RA
		|LEFT JOIN SC84 AS SprNom on SprNom.ID = RA.SP331
		|LEFT JOIN SC4014 AS f on f.ID = RA.SP4061
		|LEFT JOIN SC214 AS SprParty on SprParty.ID = RA.SP341
		|LEFT JOIN SC568 AS SprGTD on SprGTD.ID = SprParty.SP585
		|LEFT JOIN SC566 AS SprStrany on SprStrany.ID = SprParty.SP586
		|LEFT JOIN SC172 AS SprKontr on SprKontr.ID = SprParty.SP436
		|WHERE RA.IDDOC = %1";
		ТекстЗапроса = СтрШаблон(ТекстЗапроса, "'" + Структура.RS.Fields("IDDOC").Value + "'" );
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СтрокаПодключения(база = "спб")
	
	Если база = "спб" Тогда
		стрПодключения = "Provider=SQLOLEDB;Data Source=NNG9-V-SPB-01;Initial Catalog=SPB_Trade;Integrated Security=SSPI";
	Иначе  //НН
		стрПодключения = "Provider=SQLOLEDB;Data Source=1CSQL01-G9;Initial Catalog=Work_P1C;Integrated Security=SSPI";
	КонецЕсли;
	
	Возврат  стрПодключения;
	
КонецФункции

Функция ИнициализироватьСоединение(Connection = Неопределено, база = "спб")
	
	
	Если Connection <> Неопределено Тогда
		Возврат Connection;
	КонецЕсли;
	
	стрПодключения = СтрокаПодключения(база);
	
	Попытка
		Connection = Новый COMОбъект("ADODB.Connection");
		Connection.ConnectionString = стрПодключения;
		Connection.ConnectionTimeOut = 15;
		Connection.Open(Connection.ConnectionString);
		Возврат Connection;
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	
КонецФункции

Функция ПрисвоитьЗначениеРеквизита(Объект, ИмяРеквизитаОбъекта, RS, ИмяПоля)
	МетаданныеДокумента = Объект.Метаданные();
	Если ОбщегоНазначения.ЕстьРеквизитДокумента(ИмяРеквизитаОбъекта, МетаданныеДокумента) Тогда  
		Попытка
			Объект[ИмяРеквизитаОбъекта] = RS.Fields(ИмяПоля).Value;
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПолучитьКонтрагента(УИД)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ первые 1
	               |	Контрагенты.Ссылка
	               |ИЗ
	               |	Справочник.Контрагенты КАК Контрагенты
	               |ГДЕ
	               |	Контрагенты.GUID_СПБ = &GUID_СПБ";
	Запрос.УстановитьПараметр("GUID_СПБ", СокрЛП(УИД));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция ПолучитьДоговор(Код, Контрагент);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ДоговорыКонтрагентов.Ссылка
	               |ИЗ
	               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	               |ГДЕ
	               |	ДоговорыКонтрагентов.Владелец = &Владелец
	               |	И ДоговорыКонтрагентов.КодСПБ = &КодСПБ";
	Запрос.УстановитьПараметр("КодСПБ", СокрЛП(Код));
	Запрос.УстановитьПараметр("Владелец", Контрагент);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ПолучитьОрганизацию(Код, база = "спб")
	
	Если база = "спб" Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	Организации.Ссылка
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.КодСПБ = &КодСПБ";
		Запрос.УстановитьПараметр("КодСПБ", СокрЛП(Код));
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			Возврат Выборка.Ссылка;
		КонецЕсли;
	Иначе
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	_ДляПереносаДанных.Объект КАК Ссылка
		               |ИЗ
		               |	РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
		               |ГДЕ
		               |	_ДляПереносаДанных.Строка77 = &Строка77
		               |	И _ДляПереносаДанных.Объект ССЫЛКА Справочник.Организации";
		Запрос.УстановитьПараметр("Строка77", СокрЛП(Код));
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда 
			Возврат Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ПолучитьСклад(Код)
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	Склады.Ссылка
	               |ИЗ
	               |	Справочник.Склады КАК Склады
	               |ГДЕ
	               |	Склады.КодСПБ = &КодСПБ";
	Запрос.УстановитьПараметр("КодСПБ", СокрЛП(Код));
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда 
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция СтрокаПриходаПоИдентификатору77(ИДСтрокиПрихода77)
	
	СтрокаПрихода = Неопределено;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	_ДляПереносаДанных.Объект
		|ИЗ
		|	РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
		|ГДЕ
		|	_ДляПереносаДанных.Строка77 = &Строка77
		|	И _ДляПереносаДанных.Объект ССЫЛКА Справочник.ИдентификаторыСтрокПриходов";
	
	Запрос.УстановитьПараметр("Строка77", "SPB_SC214_"+ИДСтрокиПрихода77);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		СтрокаПрихода = Выборка.Объект;
	КонецЕсли;
	
	Возврат СтрокаПрихода;
	
КонецФункции

Процедура ДобавитьСвойствоЗагруженИз77(Объект)
	
	Если Не ЗначениеЗаполнено(мСвойствоЗагруженИз77СПБ) Тогда
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Объект) Тогда
		Возврат;
	КонецЕсли;
	
	МЗ = РегистрыСведений.ЗначенияСвойствОбъектов.СоздатьМенеджерЗаписи();
	МЗ.Объект 	= Объект;
	МЗ.Свойство = мСвойствоЗагруженИз77СПБ;
	МЗ.Значение = Истина;
	МЗ.Записать();	
	
КонецПроцедуры

мСвойствоЗагруженИз77СПБ = ПланыВидовХарактеристик.СвойстваОбъектов.НайтиПоНаименованию("Загружен из базы СПБ");

