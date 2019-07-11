﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт
	
	ЗагрузитьКонтрагентов();
	ИзменитьЦеновыеГруппыКонтрагентов();
	
КонецПроцедуры

//Загрузка//
Процедура ЗагрузитьКонтрагентов()
	
	лКлючАлгоритма = "Обработка_Обмен1СЭлма_МодульОбъекта_ЗагрузитьКонтрагентов";
	лЗамена = АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена); 
		Возврат; 
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////"
	
	КаталогФайлов = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Папка загрузки контрагентов", "\\SRV1C-NN\1c_exchange\FromElmaTo1C\To1C83\");
	
	Для Каждого Файл Из НайтиФайлы(КаталогФайлов, "*newClient_*.xml") Цикл
		
		РаспакованноеСообщение = "";
		Текст = Новый ЧтениеТекста(Файл.ПолноеИмя, КодировкаТекста.ANSI);
		РаспакованноеСообщение = Текст.Прочитать();
		Текст.Закрыть();
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.ОткрытьФайл(Файл.ПолноеИмя);
		Тип = ФабрикаXDTO.Тип("1c2Elma", "ELMA");
		ДанныеКонтрагента = Новый Структура("Ошибка,ТекстОшибки, СсылкаНаОбъект", Ложь, "", "");
		
		Попытка
			ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, Тип);
			
			ДатаСообщения = ТекущаяДатаСеанса();  
			
			УзелОбмена = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена("ОбменЭлмаПартком83", 1);
			
			ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0, УзелОбмена, РаспакованноеСообщение,Ложь,,,ДатаСообщения,1);
			
			ОбменДаннымиКлиентСервер.НачатьЗаписьВИсториюОбменовПоОбъектам();

			УстановитьДанныеКонтрагента(ДанныеКонтрагента, ОбъектXDTO);
			КонтрольДанныхКонтрагента(ДанныеКонтрагента);
			ЗаписатьКонтрагента(ДанныеКонтрагента);
			
			ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(ДанныеКонтрагента.СсылкаНаОбъект, РаспакованноеСообщение,"Справочник.Контрагенты",ДанныеКонтрагента.Ошибка,ДанныеКонтрагента.ТекстОшибки);
			
			СтруктураЗаписи = Новый Структура;
			СтруктураЗаписи.Вставить("НомерСообщения", 0);
			СтруктураЗаписи.Вставить("Период", ДатаСообщения);
			СтруктураЗаписи.Вставить("Исходящее", Ложь);
			СтруктураЗаписи.Вставить("Узел", ПланыОбмена.ОбменЭлмаПартком83.ПустаяСсылка());
			СтруктураЗаписи.Вставить("ХранилищеСообщения", Новый ХранилищеЗначения(РаспакованноеСообщение));
			
			РегистрыСведений.ИсторияОбменовПоОбъектам.СоздатьЗаписиПоСообщению(СтруктураЗаписи, ОбменДаннымиКлиентСервер.ПолучитьТаблицуИсторииИзПараметраСеанса());
			
			ОбменДаннымиКлиентСервер.ИнициализироватьПараметрыДляХраненияТекущихДанных();
			
		Исключение
			ОписаниеОшибки = ОписаниеОшибки();
			ДанныеКонтрагента.Ошибка = Истина;
			ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, ОписаниеОшибки);
			ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0, ПланыОбмена.ОбменЭлмаПартком83.ПустаяСсылка(), РаспакованноеСообщение,Ложь,Истина,ОписаниеОшибки,ДатаСообщения);
		КонецПопытки;
		ЧтениеXML.Закрыть();
		ЗаписьЛогаЗагрузки(Файл, ДанныеКонтрагента);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьДанныеКонтрагента(Структура, ОбъектXDTO)
	
	//Структура = Новый Структура("Ошибка,ТекстОшибки", Ложь, "");
	CRM = ОбъектXDTO.CRM;
	
	//Реквизиты контрагента//
	УстановитьГруппуКонтрагента(Структура, CRM.Company.Industry.ID);
	УстановитьВидКонтрагента(Структура, CRM.Company.Type.Name);
	УстановитьОрганизациюКонтрагента(Структура, CRM.Company.Type.ID);
	УстановитьМенеджера(Структура, CRM.Company.AssignedTo.ID);
	УстановитьСегментКонтрагента(Структура, CRM.Company.CountEmployees);
	Структура.Вставить("Наименование",CRM.company.name.name);
	Структура.Вставить("НаименованиеПолное",CRM.Company.Industry.Name);
	Структура.Вставить("Телефон", CRM.Company.OtherPhone);
	Структура.Вставить("EMail", CRM.Company.Email);
	Структура.Вставить("ЮридическийАдрес", CRM.Company.BAdress.PostalAdress);
	Структура.Вставить("ФактическийАдрес", CRM.Company.PAdress.PostalAdress);
	Структура.Вставить("АдресДоставки", CRM.Company.PAdress.State);
	Структура.Вставить("ИНН", ОбъектXDTO.CRM.Company.INN);
	Структура.Вставить("КПП", ОбъектXDTO.CRM.Company.KPP);
	Структура.Вставить("ЮрФизЛицо", Перечисления.ЮрФизЛицо.ЮрЛицо);
	
	//Реквизиты расчетного счета//
	Структура.Вставить("BIK", ОбъектXDTO.CRM.Company.BIK);
	Структура.Вставить("RS", ОбъектXDTO.CRM.Company.RS);
	Структура.Вставить("KS", ОбъектXDTO.CRM.Company.KS);
	
	//Реквизиты договора//
	КоэффициентСуммыКредита = 1;
	КоэффициентСтрокой = "0" + CRM.Company.DelayOfPayment;
	Попытка
		Значение = Число(КоэффициентСтрокой);
		Если Значение = 0 Тогда
			КоэффициентСуммыКредита = 1;
		ИначеЕсли Значение > 10 Тогда
			КоэффициентСуммыКредита = 3;
		КонецЕсли;
	Исключение
		Структура.ТекстОшибки = "Неверный коэффициент суммы кредита(DelayOfPayment), <" + CRM.Company.DelayOfPaymen + ">";
		Структура.Ошибка = Истина;
	КонецПопытки;
	Структура.Вставить("КоэффициентСуммыКредита", КоэффициентСуммыКредита);
	
	
	ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные;
	Если ЗначениеЗаполнено(Структура.Организация) Тогда
		Если Структура.Организация.ТипОплаты = Справочники.ВидыОплатЧекаККМ.Безнал Тогда
			ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные;
		ИначеЕсли Структура.Организация.ТипОплаты = Справочники.ВидыОплатЧекаККМ.Наличные Тогда
			ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;
		ИначеЕсли ОбъектXDTO.CRM.Company.Fax = "наличный" Тогда
			ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;
		КонецЕсли;
	КонецЕсли;
	Структура.Вставить("ВидОплаты", ВидОплаты);		
	
	Попытка
		ДопустимаяСуммаЗадолженности = Число("0" + CRM.Company.Limit);
	Исключение
		ДопустимаяСуммаЗадолженности = 0;
		Структура.ТекстОшибки = "Неверная допустимая сумма задолженности(Limit), <" + CRM.Company.Limit + ">";
		Структура.Ошибка = Истина;
	КонецПопытки;
	Структура.Вставить("ДопустимаяСуммаЗадолженности", ДопустимаяСуммаЗадолженности);
	
	Структура.Вставить("ДопустимоеЧислоДнейЗадолженности", Константы.ЛимитыДнейЗадолженностиЮрЛицо.Получить());
	
	//Реквизиты торговой точки//
	УстановитьРегионКонтрагента(Структура, CRM.Company.Region.Name);
	Структура.Вставить("Логин", СокрЛП(CRM.Company.AssignedTo.Login));
	Структура.Вставить("Пароль", СокрЛП(CRM.Company.Site));
	
	//#XX-1024 Kalinin V.A. ( 2019-02-14 )
	Структура.Вставить("ЗапретРедактированияЛимита",?(нрег(CRM.Contact.Type.ID) = "true",истина,Ложь));
	
	Гуид  = CRM.Contact.Type.Name;
	Структура.Вставить("GUID",?(ЗначениеЗаполнено(Гуид),новый УникальныйИдентификатор(СокрЛП(Гуид)),Неопределено));
		
	//Реквизиты контактного лица контрагента//
	Структура.Вставить("Контакт_ФИО", CRM.Contact.AssignedTo.Login);
	Структура.Вставить("Контакт_Должность", CRM.Contact.Post);
	Структура.Вставить("Контакт_Сайт", CRM.Contact.Site);
	Структура.Вставить("Контакт_Email", CRM.Contact.Email);
	Структура.Вставить("Контакт_Телефон", CRM.Contact.PhoneOffice);
	
КонецПроцедуры
Процедура КонтрольДанныхКонтрагента(ДанныеКонтрагента)
	Если ТекущаяДата() < '20190101000000' Тогда
		РезультатПроверки = Справочники.УчетныеЗаписиСайта.ПроверитьЛогинКонтрагентаВБазеСПб(ДанныеКонтрагента.Логин);
		Если РезультатПроверки.Отказ Тогда
			ДанныеКонтрагента.Ошибка = Истина;
			ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Контрагент с логином <" + ДанныеКонтрагента.Логин + "> уже существует в базе СПб. " + РезультатПроверки.Ошибка);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	УчетнаяЗапись = Справочники.УчетныеЗаписиСайта.НайтиПоКоду(ДанныеКонтрагента.Логин);
	Если НЕ УчетнаяЗапись.Пустая() Тогда
		ДанныеКонтрагента.Ошибка = Истина;
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Контрагент с логином <" + ДанныеКонтрагента.Логин + "> уже существует(" + УчетнаяЗапись.Владелец.Владелец.Наименование + "/" + УчетнаяЗапись.Владелец.Владелец.Код + ")");
	КонецЕсли;
	
КонецПроцедуры
Процедура ЗаписатьКонтрагента(ДанныеКонтрагента)
	
	Если ДанныеКонтрагента.Ошибка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеКонтрагента.Покупатель Тогда
		Родитель = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Группа Покупатели", Справочники.Контрагенты.НайтиПоКоду("00000002"));
	Иначе
		Родитель = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Группа Поставщики", Справочники.Контрагенты.НайтиПоКоду("00000001"));
	КонецЕсли;
	
	если ЗначениеЗаполнено(ДанныеКонтрагента.GUID) тогда 
	КонтрагентСсылкаНового = Справочники.Контрагенты.ПолучитьСсылку(ДанныеКонтрагента.GUID);
	иначе 	
	КонтрагентСсылкаНового = Справочники.Контрагенты.ПолучитьСсылку();
	КонецЕсли;
	
	Контрагент = Справочники.Контрагенты.СоздатьЭлемент();
	Контрагент.УстановитьНовыйКод();
	Контрагент.УстановитьСсылкуНового(КонтрагентСсылкаНового);
	
	НачатьТранзакцию();
	
	ТорговаяТочка = Справочники.ТорговыеТочки.СоздатьЭлемент();
	ТорговаяТочка.Владелец = КонтрагентСсылкаНового;
	ТорговаяТочка.Регион = ДанныеКонтрагента.Регион;
	ТорговаяТочка.Город = ДанныеКонтрагента.Город;
	ТорговаяТочка.Наименование = ДанныеКонтрагента.Наименование;
	ТорговаяТочка.Код = Контрагент.Код;
	ТорговаяТочка.ДополнительныйКомментарий = ДанныеКонтрагента.Контакт_ФИО + "(" + ДанныеКонтрагента.Контакт_Должность+ "); тел." + ДанныеКонтрагента.Контакт_Телефон + "; EMail:" + ДанныеКонтрагента.Контакт_Телефон;
	Попытка
		ТорговаяТочка.ОбменДанными.Загрузка = Истина;
		ТорговаяТочка.Записать();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записана торговая точка: " + ТорговаяТочка.Код);
	Исключение
		ОтменитьТранзакцию();
		ДанныеКонтрагента.Ошибка = Истина;
		ОписаниеОшибки = ОписаниеОшибки();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не удалось записать торговую точку: " + ОписаниеОшибки);
		Возврат;
	КонецПопытки;
	
	УчетнаяЗапись = Справочники.УчетныеЗаписиСайта.СоздатьЭлемент();
	УчетнаяЗапись.Код = ДанныеКонтрагента.Логин;
	УчетнаяЗапись.Наименование = "С Элма";
	УчетнаяЗапись.Пароль = ДанныеКонтрагента.Пароль;
	УчетнаяЗапись.Владелец = ТорговаяТочка.Ссылка;
	Попытка
		УчетнаяЗапись.ОбменДанными.Загрузка = Истина;
		УчетнаяЗапись.Записать();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записана учетная запись: " + УчетнаяЗапись.Код);
	Исключение
		ОтменитьТранзакцию();
		ДанныеКонтрагента.Ошибка = Истина;
		ОписаниеОшибки = ОписаниеОшибки();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не удалось записать данные учетной записи: " + ОписаниеОшибки);
		Возврат;
	КонецПопытки;
	
	Договор = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
	Договор.УстановитьНовыйКод();
	Договор.ВидДоговора = ?(ДанныеКонтрагента.Покупатель, Перечисления.ВидыДоговоровКонтрагентов.СПокупателем, Перечисления.ВидыДоговоровКонтрагентов.Прочее);
	Договор.Владелец = КонтрагентСсылкаНового;
	Договор.Наименование = "Основной договор";
	Договор.Дата = ТекущаяДата();
	Договор.Организация = ДанныеКонтрагента.Организация;
	Договор.ДопустимаяСуммаЗадолженности = ДанныеКонтрагента.ДопустимаяСуммаЗадолженности;
	Договор.ДопустимоеЧислоДнейЗадолженности = ДанныеКонтрагента.ДопустимоеЧислоДнейЗадолженности;
	Договор.КоэффициентСуммыКредита = ДанныеКонтрагента.КоэффициентСуммыКредита;
	Договор.ВидОплаты = ДанныеКонтрагента.ВидОплаты;
	Договор.ДоговорНаОферту = Договор.ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные;
	Договор.НеКонтролироватьЛимит = Договор.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;
	Договор.ДоговорПодписан = Договор.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;
	Договор.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	договор.ЗапретРедактированияЛимита =  ДанныеКонтрагента.ЗапретРедактированияЛимита;
	Договор.Дата =  ДанныеКонтрагента.Организация.Договор_ОфертаПокупателя_Дата;
	Договор.Номер = ДанныеКонтрагента.Организация.Договор_ОфертаПокупателя_Номер;
	Договор.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	Договор.ВидРасчетаДней = Перечисления.ВидыРасчетаДней.ПоБанковскимДням;
	
	Попытка
		Договор.ОбменДанными.Загрузка = Истина;
		Договор.Записать();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записан договор: " + Договор.Код);
	Исключение
		ОтменитьТранзакцию();
		ДанныеКонтрагента.Ошибка = Истина;
		ОписаниеОшибки = ОписаниеОшибки();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не удалось записать договор контрагента: " + ОписаниеОшибки);
		Возврат;
	КонецПопытки;
	
	ОсновнойБанковскийСчет = Справочники.БанковскиеСчета.ПустаяСсылка();
	НуженБанковскийСчет = Договор.ВидОплаты <> Перечисления.ВидыДенежныхСредств.Наличные;
	Если НуженБанковскийСчет Тогда
		Если ЗначениеЗаполнено(ДанныеКонтрагента.BIK) И ЗначениеЗаполнено(ДанныеКонтрагента.RS) Тогда
			Банк = Справочники.Банки.НайтиПоКоду(ДанныеКонтрагента.BIK);
			Если ЗначениеЗаполнено(Банк) Тогда
				Счет = Справочники.БанковскиеСчета.СоздатьЭлемент();
				Счет.Банк = Банк;
				Счет.Владелец = КонтрагентСсылкаНового;
				Счет.НомерСчета = ДанныеКонтрагента.RS;
				Счет.ВидСчета = "Расчетный";
				Счет.ВалютаДенежныхСредств = Константы.ВалютаРубль.Получить();
				Счет.Наименование = "Основной";
				Счет.УстановитьНовыйКод();
				Попытка
					Счет.ОбменДанными.Загрузка = Истина;
					Счет.Записать();
					ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записан банковский счет: " + Счет.Код);
					ОсновнойБанковскийСчет = Счет.Ссылка;
				Исключение
					ОтменитьТранзакцию();
					ДанныеКонтрагента.Ошибка = Истина;
					ОписаниеОшибки = ОписаниеОшибки();
					ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не удалось записать банковский счет: " + ОписаниеОшибки);
					Возврат;
				КонецПопытки;			
			Иначе
				ДанныеКонтрагента.Ошибка = Истина;
				ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не определен банк БИК: " + ДанныеКонтрагента.BIK);
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Контрагент.Родитель = Родитель;
	Контрагент.ГоловнойКонтрагент = КонтрагентСсылкаНового;
	Контрагент.ДатаСоздания = ТекущаяДата();
	Контрагент.ИмеетТорговыеТочки = Ложь;
	Контрагент.ОсновнаяТорговаяТочка = ТорговаяТочка.Ссылка;
	Если НуженБанковскийСчет Тогда
		Контрагент.ОсновнойБанковскийСчет = ОсновнойБанковскийСчет;
	КонецЕсли;
	Контрагент.КоэффициентУвеличенияСуммыКредита = 1;
	Контрагент.ОсновнойДоговорКонтрагента = Договор.Ссылка;
	Контрагент.ЛогинДляСайта = ДанныеКонтрагента.Логин;
	Контрагент.ПарольДляСайта = ДанныеКонтрагента.Пароль;
	Контрагент.Регион = ДанныеКонтрагента.Регион;
	Контрагент.Комментарий = "Загружено из Элма: " + Формат(Контрагент.ДатаСоздания, "ДФ=dd.MM.yyyy");
	ЗаполнитьЗначенияСвойств(Контрагент, ДанныеКонтрагента, "Наименование,НаименованиеПолное,Покупатель,Поставщик,СайтГруппаКонтрагента,ИНН,КПП,ЮрФизЛицо,СегментКонтрагента");
	
	Попытка
		Контрагент.Записать();
		ДанныеКонтрагента.СсылкаНаОбъект = Контрагент.Ссылка;
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записан Контрагент: " + Контрагент.Код);
	Исключение
		ОтменитьТранзакцию();
		ДанныеКонтрагента.Ошибка = Истина;
		ОписаниеОшибки = ОписаниеОшибки();
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Не удалось записать контрагента: " + ОписаниеОшибки);
		Возврат;
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	//Записываем контактную информацию//
	ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление", 
												Контрагент.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.Адрес,
												Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента,
												ДанныеКонтрагента.ЮридическийАдрес));
	ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												Контрагент.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.Адрес,
												Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента,
												ДанныеКонтрагента.ФактическийАдрес));
	ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												Контрагент.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.Адрес,
												Справочники.ВидыКонтактнойИнформации.АдресДоставкиКонтрагента,
												ДанныеКонтрагента.АдресДоставки));
	ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												Контрагент.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.Телефон,
												Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента,
												ДанныеКонтрагента.Телефон));
	ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												Контрагент.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
												Справочники.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами,
												ДанныеКонтрагента.EMail));
												
	//Записываем контактную информацию//
	Если ЗначениеЗаполнено(ДанныеКонтрагента.Контакт_ФИО) Тогда
		КонтактноеЛицо = Справочники.КонтактныеЛица.СоздатьЭлемент();
		КонтактноеЛицо.Наименование = ДанныеКонтрагента.Контакт_ФИО;
		КонтактноеЛицо.Записать();
		
		КонтактноеЛицоКонтрагента = Справочники.КонтактныеЛицаКонтрагентов.СоздатьЭлемент();
		КонтактноеЛицоКонтрагента.Наименование = ДанныеКонтрагента.Контакт_ФИО;
		КонтактноеЛицоКонтрагента.Владелец = Контрагент.Ссылка;
		КонтактноеЛицоКонтрагента.Должность = ДанныеКонтрагента.Контакт_Должность;
		КонтактноеЛицоКонтрагента.Комментарий = "Загружено из Элма:" + ТекущаяДата();
		КонтактноеЛицоКонтрагента.КонтактноеЛицо = КонтактноеЛицо.Ссылка;
		КонтактноеЛицоКонтрагента.Записать();
		
		ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												КонтактноеЛицоКонтрагента.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,
												Справочники.ВидыКонтактнойИнформации.EmailПочтыКонтактногоЛицаКонтрагента,
												ДанныеКонтрагента.Контакт_Email));		
		
		ДобавитьКонтактнуюИнформацию(Новый Структура("Объект,Тип,Вид,Представление",
												КонтактноеЛицоКонтрагента.Ссылка,
												Перечисления.ТипыКонтактнойИнформации.Телефон,
												Справочники.ВидыКонтактнойИнформации.МобильныйТелефонКонтактногоЛицаКонтрагента,
												ДанныеКонтрагента.Контакт_Телефон));		
												
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записано контактное лицо контрагента: " + КонтактноеЛицоКонтрагента.Код);
		ДополнитьОшибку(ДанныеКонтрагента.ТекстОшибки, "Записано контактное лицо: " + КонтактноеЛицо.Код);
		
	КонецЕсли;
	
	//Записываем менеджера//
	Если ЗначениеЗаполнено(ДанныеКонтрагента.Менеджер) Тогда
		ВидМенеджера = ?(ДанныеКонтрагента.Покупатель, Перечисления.ВидыМенеджеров.Продажи, Перечисления.ВидыМенеджеров.Снабжения);
		Запись = РегистрыСведений.МенеджерыТорговыхТочек.СоздатьМенеджерЗаписи();
		Запись.Период = ТекущаяДата();
		Запись.Контрагент = Контрагент.Ссылка;
		Запись.ВидМенеджера = ВидМенеджера;
		Запись.ТорговаяТочка = Контрагент.ОсновнаяТорговаяТочка;
		Запись.Менеджер = ДанныеКонтрагента.Менеджер;
		Запись.Записать();
	КонецЕсли;
	
	//Регистрируем договор к обмену
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ОбменПартКом83_Сайт.Ссылка
	                      |ИЗ
	                      |	ПланОбмена.ОбменПартКом83_Сайт КАК ОбменПартКом83_Сайт
	                      |ГДЕ
	                      |	ОбменПартКом83_Сайт.Исходящий
	                      |	И НЕ ОбменПартКом83_Сайт.ЭтотУзел");
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Узел = Выборка.Ссылка;
		//Семенов И.П. 31.01.2019 XX-1768(
		//ПланыОбмена.ЗарегистрироватьИзменения(Узел, Договор.Ссылка);
		ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(Узел, Договор.Ссылка);
		//)Семенов И.П.
	КонецЕсли;
	
КонецПроцедуры
Процедура ЗаписьЛогаЗагрузки(Файл, ДанныеКонтрагента)
	
	ИмяФайла = СокрЛП(Файл.ИмяБезРасширения);
	Каталог = Файл.Путь;
	НовыйКаталог = Каталог + "Loaded";
	НовоеИмя = ИмяФайла + ?(ДанныеКонтрагента.Ошибка, "-err", "-ok"); 
	
	Каталог = Новый Файл(НовыйКаталог);
	Если НЕ Каталог.Существует() Тогда
		СоздатьКаталог(НовыйКаталог);
	КонецЕсли;
	
	ПереместитьФайл(Файл.ПолноеИмя, НовыйКаталог + "/" + НовоеИмя + ".xml");
	
	ИмяФайлаЛога = НовыйКаталог + "/" + ИмяФайла + ".log";
	Текст = Новый ТекстовыйДокумент;
	Текст.УстановитьТекст(ДанныеКонтрагента.ТекстОшибки);
	Текст.Записать(ИмяФайлаЛога);
	
	Если ДанныеКонтрагента.Ошибка Тогда
		ТекстПисьма =	"Загрузка файла: " + НовоеИмя + ".xml" + Символы.ПС;
		Если ДанныеКонтрагента.Свойство("Наименование") Тогда
			ТекстПисьма = ТекстПисьма + "Контрагент: " + ДанныеКонтрагента.Наименование + Символы.ПС;
		КонецЕсли;
		Если ДанныеКонтрагента.Свойство("Наименование") Тогда
			ТекстПисьма = ТекстПисьма + "ИНН: " + ДанныеКонтрагента.ИНН + Символы.ПС + Символы.ПС;
		КонецЕсли;
		ТекстПисьма = ТекстПисьма + ДанныеКонтрагента.ТекстОшибки;
		Событие = Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаЗагрузкиКонтрагентовИзЭлма;
		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Событие, ТекстПисьма, "Ошибка загрузки контрагента из Элма");
	КонецЕсли;
	
КонецПроцедуры
Процедура УстановитьГруппуКонтрагента(Структура, Код)
	
	Значение = Справочники.ГруппыКонтрагентов.НайтиПоКоду(Код);
	Если Значение.Пустая() Тогда
		Структура.Ошибка = Истина;
		ДополнитьОшибку(Структура.ТекстОшибки, "Не найдена группа контрагента по наименованию <" + Код + ">");
	КонецЕсли;
	
	Структура.Вставить("СайтГруппаКонтрагента", Значение);
	
КонецПроцедуры
Процедура УстановитьРегионКонтрагента(Структура, Наименование)
	
	Значение = Справочники.Регионы.НайтиПоНаименованию(Наименование);
	Если Значение.Пустая() Тогда
		Структура.Ошибка = Истина;
		ДополнитьОшибку(Структура.ТекстОшибки, "Не найден регион контрагента по наименованию <" + Наименование + ">");
	КонецЕсли;
	Структура.Вставить("Регион", Значение);
	//
	// 10.07.19 Строганов Роман > 
	//Значение = Справочники.Города.НайтиПоНаименованию(Наименование);
	//Если Значение.Пустая() Тогда
	//	Структура.Ошибка = Истина;
	//	ДополнитьОшибку(Структура.ТекстОшибки, "Не найден город контрагента по наименованию <" + Наименование + ">");
	//КонецЕсли;
	//Структура.Вставить("Город", Значение);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Города.Ссылка
	|ИЗ
	|	Справочник.Города КАК Города
	|ГДЕ
	|	Города.Наименование = &Наименование
	|	И НЕ Города.ЭтоГруппа");
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Структура.Ошибка = Истина;
		ДополнитьОшибку(Структура.ТекстОшибки, "Не найден город контрагента по наименованию <" + Наименование + ">");
	Иначе
		Выборка = Запрос.Выполнить().Выбрать();
		Выборка.Следующий();
		Структура.Вставить("Город", Выборка.Ссылка);
	КонецЕсли;
	// 10.07.19 Строганов Роман <
			
КонецПроцедуры
Процедура УстановитьВидКонтрагента(Структура, ВидКонтрагента)
	
	Структура.Вставить("Покупатель", Ложь);
	Структура.Вставить("Поставщик", Ложь);
	
	Если ВидКонтрагента = "" ИЛИ ВидКонтрагента = "Покупатель" Тогда
		Структура.Покупатель = Истина;
	ИначеЕсли ВидКонтрагента = "Поставщик" Тогда
		Структура.Поставщик = Истина;
	Иначе
		Структура.Ошибка = Истина;
		ДополнитьОшибку(Структура.ТекстОшибки, "Не определен вид контрагента <" + ВидКонтрагента + ">");
	КонецЕсли;
	
КонецПроцедуры
Процедура УстановитьОрганизациюКонтрагента(Структура, Код)
	
	Значение = Справочники.Организации.НайтиПоКоду(Формат(Число(Код), "ЧЦ=9; ЧВН=; ЧГ="));
	Если Значение.Пустая() Тогда
		Структура.Ошибка = Истина;
		ДополнитьОшибку(Структура.ТекстОшибки, "Не найдена организация по коду  <" + Код + ">");
	КонецЕсли;
	
	Структура.Вставить("Организация", Значение);
	
КонецПроцедуры
Процедура УстановитьМенеджера(Структура, ЛогинЭЛМА)
	
	Менеджер = Справочники.Менеджеры.ПустаяСсылка();
	Если ЗначениеЗаполнено(ЛогинЭЛМА) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		                      |	Менеджеры.Ссылка
		                      |ИЗ
		                      |	Справочник.Менеджеры КАК Менеджеры
		                      |ГДЕ
		                      |	Менеджеры.Пользователь.ЛогинЭЛМА = &ЛогинЭЛМА");
		Запрос.УстановитьПараметр("ЛогинЭЛМА", ЛогинЭЛМА);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Менеджер = Выборка.Ссылка;
		Иначе
			Структура.Ошибка = Истина;
			ДополнитьОшибку(Структура.ТекстОшибки, "Не найден менеджер по логину Элма:  <" + ЛогинЭЛМА + ">");
		КонецЕсли;
		
	КонецЕсли;
	
	Структура.Вставить("Менеджер", Менеджер);
	
КонецПроцедуры
Процедура УстановитьСегментКонтрагента(Структура, Код)
	
	Если Не ЗначениеЗаполнено(Код) Тогда
		Сегмент = Справочники.СегментыКонтрагентов.ПустаяСсылка();
	Иначе
		Сегмент = Справочники.СегментыКонтрагентов.НайтиПоКоду(Код);
		Если Сегмент.Пустая() Тогда
			Структура.Ошибка = Истина;
			ДополнитьОшибку(Структура.ТекстОшибки, "Не определен сегмент контрагента по коду <" + Код + ">");
		КонецЕсли;
	КонецЕсли;
	
	Структура.Вставить("СегментКонтрагента", Сегмент);
	
КонецПроцедуры
	
//Смена ценовой группы//
Процедура ИзменитьЦеновыеГруппыКонтрагентов()
	
	КаталогФайлов = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Папка смены ценовой группы", "\\10.0.0.30\1c_exch\Change_Client\");
	Для Каждого Файл Из НайтиФайлы(КаталогФайлов, "opt_*.txt") Цикл
		Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
		СтрокаФайла = Чтение.Прочитать();
		Чтение.Закрыть();
		Если ЗначениеЗаполнено(СтрокаФайла) Тогда
			СтруктураДанных = Новый Структура("Отказ,ТекстОшибки", Ложь, "");
			МногострочнаяСтрока = СтрЗаменить(СтрокаФайла, ";", Символы.ПС);
			Если СтрЧислоСтрок(МногострочнаяСтрока) > 4 Тогда
				ПрочитатьДанныеФайла(СтруктураДанных, МногострочнаяСтрока);
				ТипизацияСтруктурыСменыГруппы(СтруктураДанных);
				СменитьЦеновуюГруппу(СтруктураДанных);
			Иначе
				СтруктураДанных.Отказ = Истина;
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Неверное количество параметров в строке");
			КонецЕсли;
			ОтметитьЗагрузкуФайла(Файл, СтруктураДанных);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
Процедура ПрочитатьДанныеФайла(СтруктураДанных, Строка)
	
	СтруктураДанных.Вставить("МаркерФайла",			СтрПолучитьСтроку(Строка, 1));
	СтруктураДанных.Вставить("КодКонтрагента",		СтрПолучитьСтроку(Строка, 2));
	СтруктураДанных.Вставить("НовыйКодГруппы",		СтрПолучитьСтроку(Строка, 3));
	СтруктураДанных.Вставить("НоваяДата",			СтрПолучитьСтроку(Строка, 4));
	СтруктураДанных.Вставить("EMail",				СтрПолучитьСтроку(Строка, 5));
	СтруктураДанных.Вставить("ОбработкаВсейГруппы",	СтрПолучитьСтроку(Строка, 6) = "True");
	
КонецПроцедуры
Процедура ТипизацияСтруктурыСменыГруппы(СтруктураДанных)
	
	ПроверитьТипФайла(СтруктураДанных);
	УстановитьНовуюГруппу(СтруктураДанных);
	УстановитьДату(СтруктураДанных);
	УстановитьКонтрагентов(СтруктураДанных);
	
КонецПроцедуры
Процедура ПроверитьТипФайла(СтруктураДанных)
	
	Если СтруктураДанных.МаркерФайла <> "это_выгрузка_из_Элмы" Тогда
		СтруктураДанных.Отказ = Истина;
		ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Файл неверного формата, нет прификса Элмы");
	КонецЕсли;
	
КонецПроцедуры
Процедура УстановитьНовуюГруппу(СтруктураДанных)
	
	СтруктураДанных.Вставить("СайтГруппаКонтрагента", Справочники.ГруппыКонтрагентов.ПустаяСсылка());
	
	Попытка
		КодЧислом = Число(СтруктураДанных.НовыйКодГруппы);
		Группа = Справочники.ГруппыКонтрагентов.НайтиПоКоду(КодЧислом);
		Если Группа.Пустая() Тогда
			СтруктураДанных.Отказ = Истина;
			ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Неверный код ценовой группы(не найдена): <" + СтруктураДанных.НовыйКодГруппы + ">");
		Иначе
			СтруктураДанных.СайтГруппаКонтрагента = Группа;
		КонецЕсли;
	Исключение
		СтруктураДанных.Отказ = Истина;
		ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Неверный код ценовой группы(ошибка формата): <" + СтруктураДанных.НовыйКодГруппы + ">");
	КонецПопытки;
	
КонецПроцедуры
Процедура УстановитьДату(СтруктураДанных)
	
	СтруктураДанных.Вставить("СайтГруппаКонтрагентаЗаблокированоДо", '00010101');
	Попытка
		Строка = СтруктураДанных.НоваяДата;
		Дата = Дата(Прав(Строка,4) + Сред(Строка,4,2) + Лев(Строка,2));
		Если Год(Дата) < 2000 ИЛИ Год(Дата) > 3000 Тогда
			СтруктураДанных.Отказ = Истина;
			ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Неверная дата: <" + СтруктураДанных.НоваяДата + ">");
		Иначе
			СтруктураДанных.СайтГруппаКонтрагентаЗаблокированоДо = Дата;
		КонецЕсли;
	Исключение
		СтруктураДанных.Отказ = Истина;
		ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Неверный формат даты: <" + СтруктураДанных.НоваяДата + ">");
	КонецПопытки;
	
КонецПроцедуры
Процедура УстановитьКонтрагентов(СтруктураДанных)
	
	ГруппаПокупатели = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Группа Покупатели", Справочники.Контрагенты.НайтиПоКоду("00000002"));
	СтруктураДанных.Вставить("МассивКонтрагентов", Новый Массив);
	ВыбранныйКонтрагент = Справочники.Контрагенты.НайтиПоКоду(СтруктураДанных.КодКонтрагента);
	
	Если ВыбранныйКонтрагент.Пустая() Тогда
		СтруктураДанных.Отказ = Истина;
		ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Отсутствует контрагент с кодом: <" + СтруктураДанных.КодКонтрагента + ">");
	Иначе
		ОбработкаПоГруппе = СтруктураДанных.ОбработкаВсейГруппы И ЗначениеЗаполнено(ВыбранныйКонтрагент.Родитель) И ЗначениеЗаполнено(ВыбранныйКонтрагент.Родитель.Родитель) И ВыбранныйКонтрагент.Родитель.Родитель = ГруппаПокупатели;
		Если ОбработкаПоГруппе Тогда
			Запрос = Новый Запрос("ВЫБРАТЬ
			                      |	Контрагенты.Ссылка
			                      |ИЗ
			                      |	Справочник.Контрагенты КАК Контрагенты
			                      |ГДЕ
			                      |	Контрагенты.Родитель = &Родитель
			                      |	И Контрагенты.ЮрФизЛицо <> ЗНАЧЕНИЕ(Перечисление.ЮрФизЛицо.ФизЛицо)
			                      |	И Контрагенты.СайтГруппаКонтрагента <> &СайтГруппаКонтрагента
			                      |	И НЕ Контрагенты.СайтГруппаКонтрагентаЗаблокировано");
			Запрос.УстановитьПараметр("Родитель", ВыбранныйКонтрагент.Родитель);
			Запрос.УстановитьПараметр("СайтГруппаКонтрагента", СтруктураДанных.СайтГруппаКонтрагента);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				СтруктураДанных.МассивКонтрагентов.Добавить(Выборка.Ссылка);
			КонецЦикла;
			Если СтруктураДанных.МассивКонтрагентов.Количество() = 0 Тогда
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Нет подходящих контрагентов в холдинге: <" + ВыбранныйКонтрагент.Родитель.Код + ">");
			КонецЕсли;
		Иначе
			Если ВыбранныйКонтрагент.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
				СтруктураДанных.Отказ = Истина;
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Контрагент является физ. лицом: <" + ВыбранныйКонтрагент + "/" + СтруктураДанных.КодКонтрагента + ">");
			ИначеЕсли ВыбранныйКонтрагент.СайтГруппаКонтрагентаЗаблокировано Тогда
				СтруктураДанных.Отказ = Истина;
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "У контрагента заблокирована ценовая группа: <" + ВыбранныйКонтрагент + "/" + СтруктураДанных.КодКонтрагента + ">");
			ИначеЕсли ВыбранныйКонтрагент.СайтГруппаКонтрагента <> СтруктураДанных.СайтГруппаКонтрагента Тогда
				СтруктураДанных.МассивКонтрагентов.Добавить(ВыбранныйКонтрагент);
			Иначе
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, "Контрагент уже имеет указанную ценовую группу: <" + ВыбранныйКонтрагент + "/" + СтруктураДанных.КодКонтрагента + ">");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
Процедура СменитьЦеновуюГруппу(СтруктураДанных)
	
	Если НЕ СтруктураДанных.Отказ Тогда
		Для Каждого Контрагент Из СтруктураДанных.МассивКонтрагентов Цикл
			Попытка
				обКонтрагент = Контрагент.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(обКонтрагент, СтруктураДанных, "СайтГруппаКонтрагента,СайтГруппаКонтрагентаЗаблокированоДо");
				обКонтрагент.Записать();
			Исключение
				ОписаниеОшибки = ОписаниеОшибки();
				СтруктураДанных.Отказ = Истина;
				ДополнитьОшибку(СтруктураДанных.ТекстОшибки, ОписаниеОшибки);
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
Процедура ОтметитьЗагрузкуФайла(Файл, СтруктураДанных)
	
	ИмяФайла = СокрЛП(Файл.ИмяБезРасширения);
	Каталог = Файл.Путь;
	НовыйКаталог = Каталог + "Loaded";
	НовоеИмя = ИмяФайла + ?(СтруктураДанных.Отказ, "-err", "-ok"); 
	
	Каталог = Новый Файл(НовыйКаталог);
	Если НЕ Каталог.Существует() Тогда
		СоздатьКаталог(НовыйКаталог);
	КонецЕсли;
	
	ПереместитьФайл(Файл.ПолноеИмя, НовыйКаталог + "/" + НовоеИмя + ".txt");
	
	Если СтруктураДанных.ТекстОшибки <> "" Тогда
		ИмяФайлаЛога = НовыйКаталог + "/" + ИмяФайла + ".log";
		Текст = Новый ТекстовыйДокумент;
		Текст.УстановитьТекст(СтруктураДанных.ТекстОшибки);
		Текст.Записать(ИмяФайлаЛога);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураДанных.EMail) И Найти(СтруктураДанных.EMail, "@") <> 0 Тогда
		ТемаПисьма = "Изменение уровня цен";
		ТекстПисьма =	"Загрузка файла: " + НовоеИмя + ".txt" + Символы.ПС;
		Если СтруктураДанных.Отказ Тогда
			ТекстПисьма = ТекстПисьма + СтруктураДанных.ТекстОшибки;
		Иначе
			ТекстПисьма = ТекстПисьма + "Установка новой ценовой группы: " + СтруктураДанных.СайтГруппаКонтрагента + Символы.ПС;
			Если СтруктураДанных.МассивКонтрагентов.Количество() > 0 Тогда
				ТекстПисьма = ТекстПисьма + "Изменена ценовая группа для следующих контрагентов:" + Символы.ПС;
				Для Каждого Контрагент Из СтруктураДанных.МассивКонтрагентов Цикл
					ТекстПисьма = ТекстПисьма + Контрагент + "(" + Контрагент.Код + ")" + Символы.ПС;
				КонецЦикла;
			КонецЕсли;
			Если СтруктураДанных.ТекстОшибки <> "" Тогда
				ТекстПисьма = ТекстПисьма + СтруктураДанных.ТекстОшибки;
			КонецЕсли;
		КонецЕсли;
		Событие = Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаЗагрузкиКонтрагентовИзЭлма;
		Email = СтруктураДанных.EMail;
		Попытка
			РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Событие, ТекстПисьма, ТемаПисьма, Email);
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

//Общее//
Процедура ДополнитьОшибку(Строка, Дополнение)
	
	Строка = Строка + ?(Строка = "", "", Символы.ПС) + Дополнение + Символы.ПС;
	
КонецПроцедуры
Процедура ДобавитьКонтактнуюИнформацию(Структура)
	
	Если ЗначениеЗаполнено(Структура.Представление) Тогда
		Запись = РегистрыСведений.КонтактнаяИнформация.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Запись, Структура);
		Запись.Записать();
	КонецЕсли;
	
КонецПроцедуры

