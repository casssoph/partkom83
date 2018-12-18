﻿Перем ЗарегистрироватьВОбменеБИТ;
Перем ЗарегистрироватьВОбменеСайт;
Перем ЗарегистрироватьВОбмене_ОбменПартКом83_77;

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, существуют ли ссылки на договор в движениях регистров накопления.
// Если есть - нельзя менять:
//  - Валюту взаиморасчетов
//  - Ведение взаиморасчетов.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина - если есть движения, Ложь - если нет.
//
Функция СуществуютСсылки() Экспорт
	
	Возврат ПолныеПрава.ПроверитьНаличиеСсылокНаДоговорКонтрагента(Ссылка);
	
КонецФункции //  СуществуютСсылки()

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью элемента справочника.
//
Процедура ПередЗаписью(Отказ)
	
	Если ЭтоНовый() тогда 
		ДатаСоздания = ТекущаяДата();
		Если НЕ ЗначениеЗаполнено(ВидОплаты) Тогда 
			Если ЗначениеЗаполнено(Организация) Тогда 
				Если Организация.ТипОплаты = Справочники.ВидыОплатЧекаККМ.Наличные Тогда 
					ВидОплаты=Перечисления.ВидыДенежныхСредств.Наличные;
				ИначеЕсли Организация.ТипОплаты = Справочники.ВидыОплатЧекаККМ.Безнал Тогда	
					ВидОплаты=Перечисления.ВидыДенежныхСредств.Безналичные;
				Иначе	
					ВидОплаты=Перечисления.ВидыДенежныхСредств.Наличные;
				КонецЕсли;
			КонецЕсли;	
		КонецЕсли;	
		Если  Владелец.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
			КоэффициентСуммыКредита=0;
			//ДопустимаяСуммаЗадолженности=0;  //Валиахметов. В рамках задачи. Лимит должен сохраняться  http://jira.part-kom.ru/browse/XX-1404
			ЗапретРедактированияЛимита=Истина;
			Если Организация.ТипОплаты=Справочники.ВидыОплатЧекаККМ.Наличные Тогда 
				ДопустимоеЧислоДнейЗадолженности=5;
				НеКонтролироватьЛимит=Истина;
			ИначеЕсли Организация.ТипОплаты=Справочники.ВидыОплатЧекаККМ.Безнал Тогда  	
				ДопустимоеЧислоДнейЗадолженности=0;
				НеКонтролироватьЛимит=ЛОжь;
			Иначе	
				ДопустимоеЧислоДнейЗадолженности=5;
				НеКонтролироватьЛимит=Истина;
			КонецЕсли;	
		КонецЕсли;	
	КонецЕсли;	
	
	//Рудаков. Проверим есть ли другие рабочие договоры по текущему контрагенту
	Запрос = Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Владелец = &Владелец";
	Если НЕ ЭтоНовый() Тогда
		Запрос.Текст=Запрос.Текст+"
		|   И ДоговорыКонтрагентов.Ссылка <> &Ссылка";
	КонецЕсли;	
	Запрос.Текст=Запрос.Текст+"
	|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";
	Запрос.Текст=Запрос.Текст+"
	|	И НЕ ДоговорыКонтрагентов.СлужебныйДоговор
	|	И НЕ ДоговорыКонтрагентов.ДоговорПриостановлен
	|	И НЕ ДоговорыКонтрагентов.ПометкаУдаления";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ВидДоговора", ВидДоговора);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Если НЕ РольДоступна("ПолныеПрава") И НЕ ПометкаУдаления И ВидДоговора=Перечисления.ВидыДоговоровКонтрагентов.ОтветХранение И НЕ ОбменДанными.Загрузка Тогда 
		Результат = Запрос.Выполнить().Выгрузить();
		Если Не Результат.Количество()=0 Тогда 
			Сообщить("Нельзя вводить новый договор Ответ.хранения (снимать с удаления), если в системе уже есть один рабочий!");
			отказ=Истина;
			Возврат
		КонецЕсли;
	КонецЕсли;	
	//Рудаков конец
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: ДоговорыКонтрагентов", Ложь) И НЕ  ОбменДанными.Загрузка Тогда
		ЗарегистрироватьВОбменеСайт = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	КонецЕсли;
	
	ЗарегистрироватьВОбменеБИТ = Ложь;
	Если ЭтоНовый() Тогда
		ЗарегистрироватьВОбменеБИТ = Истина;
		//#PK83-702 Kalinin V.A. ( 2018-05-24 )
		Если Не ЗначениеЗаполнено(ВидРасчетаДней) тогда 
			ВидРасчетаДней = перечисления.ВидыРасчетаДней.ПоБанковскимДням;
		КонецЕсли;	
			
	Иначе
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДоговорыКонтрагентов.Владелец,
		|	ДоговорыКонтрагентов.Организация,
		|	ДоговорыКонтрагентов.ВидДоговора,
		|	ДоговорыКонтрагентов.ВалютаВзаиморасчетов,
		|	ДоговорыКонтрагентов.Наименование,
		|	ДоговорыКонтрагентов.ДоговорНаОферту
		|ИЗ
		|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|ГДЕ
		|	ДоговорыКонтрагентов.Ссылка = &Ссылка"
		);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Результат = Запрос.Выполнить().Выбрать();
		Пока Результат.Следующий() Цикл
			Если Результат.Владелец <> Владелец
				ИЛИ Результат.Организация <> Организация
				ИЛИ Результат.ВидДоговора <> ВидДоговора
				ИЛИ Результат.ВалютаВзаиморасчетов <> ВалютаВзаиморасчетов 
				ИЛИ ВРЕГ(СокрЛП(Результат.Наименование)) <> ВРЕГ(СокрЛП(Наименование)) 
				ИЛИ Результат.ДоговорНаОферту <> ДоговорНаОферту Тогда
				ЗарегистрироватьВОбменеБИТ = Истина;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	// Проверим можно ли изменять реквизиты договора.
	// Проверка осуществляется только если записывается уже существующий договор
	Если НЕ ОбменДанными.Загрузка И НЕ ЭтоНовый() Тогда
		Если НЕ РольДоступна("ПолныеПрава") Тогда
			Если ЭтоГруппа Тогда
				// Для группы владельца менять нельзя
				Если Владелец <> Ссылка.Владелец Тогда
					Сообщить("Нельзя изменять контрагента для группы договоров.", СтатусСообщения.Важное);
					Отказ = Истина;
				КонецЕсли; 
			Иначе
				// Проверим возможность смены владельца для договора
				Если Владелец <> Ссылка.Владелец Тогда
					
					Запрос = Новый Запрос;
					Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
					|	ДокументыПоДоговоруКонтрагента.Ссылка
					|ИЗ
					|	КритерийОтбора.ДокументыПоДоговоруКонтрагента(&Договор) КАК ДокументыПоДоговоруКонтрагента";
					
					Запрос.УстановитьПараметр("Договор", Ссылка);
					
					Результат = Запрос.Выполнить();
					ЕстьДокументыПоДоговору = НЕ Результат.Пустой();
					
					Если ЕстьДокументыПоДоговору Тогда
						Сообщить("Существуют документы, оформленные по договору """ + Наименование + """.
						|Контрагент договора не может быть изменен, элемент не записан.", 
						СтатусСообщения.Важное);
						Отказ = Истина;
					КонецЕсли; 
					
				КонецЕсли; 
				
				// Проверим возможность смены способа ведения взаиморасчетов и валюты взаиморасчетов
				Если  НЕ РольДоступна("ПолныеПрава") И 
					(ВалютаВзаиморасчетов <> Ссылка.ВалютаВзаиморасчетов 
					ИЛИ ВидДоговора <> Ссылка.ВидДоговора
					ИЛИ Организация <> Ссылка.Организация
					ИЛИ ВидУсловийДоговора <> Ссылка.ВидУсловийДоговора
					ИЛИ ДоговорНаОферту <> Ссылка.ДоговорНаОферту
					ИЛИ ДоговорНаКросс <> Ссылка.ДоговорНаКросс
					ИЛИ ДоговорНаСток <> Ссылка.ДоговорНаСток
					ИЛИ ДоговорПрочие <> Ссылка.ДоговорПрочие) Тогда
					
					Если ЭтотОбъект.СуществуютСсылки() Тогда
						
						Сообщить("Существуют документы, проведенные по договору """ + Наименование + """.
						|Реквизиты ""Организация"", ""Валюта взаиморасчетов"", ""Вид договора"", 
						|""Условия выполнения договора"", 
						|""Флажки: Оферта, Сток, Кросс, Пополнение, Прочие"", не могут быть изменены, элемент не записан.", 
						СтатусСообщения.Важное);
						Отказ = Истина;
						
					КонецЕсли;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	
	Если НЕ ОбменДанными.Загрузка И Не ЭтоГруппа Тогда 
		// Проверим заполнение и очистим неиспользуемые реквизиты элемента договора.
		ПроверкаРеквизитов(Отказ);
		ПроверкаНаСлужебныйДоговор(Отказ);			
	КонецЕсли;
КонецПроцедуры

Процедура ПроверкаРеквизитов(Отказ)
	
	Если НЕ ЗначениеЗаполнено(ВалютаВзаиморасчетов) Тогда
		Сообщить("Не указана валюта договора.", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить("Не указана организация, от которой заключен договор.", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВидДоговора) Тогда
		Сообщить("Не указан вид договора.", СтатусСообщения.Важное);
		Отказ = Истина;
	Иначе
		// Проверим, правильно ли заполнен вид договора
		// Отработаем вариант, когда договор создается автоматически при создании нового контрагента и владелец в этом случае еще не записан
		// Проверка вида договора в этом случае не требуется, т.к. он установлен априори правильно
		Если  НЕ РольДоступна("ПолныеПрава") И (ЗначениеЗаполнено(Владелец) И ОбщегоНазначения.СсылкаСуществует(Владелец)) Тогда
			Если (ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем ИЛИ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.НаЭкспорт) Тогда
				Если Не Владелец.Покупатель Тогда
					Сообщить("Вид договора ""С покупателем"" может устанавливаться только когда у контрагента указано что он является покупателем.", СтатусСообщения.Важное);
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
			Если (ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком ИЛИ ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.ОтветХранение) Тогда
				Если Не Владелец.Поставщик Тогда
					Сообщить("Вид договора ""С поставщиком"" может устанавливаться только когда у контрагента указано что он является поставщиком.", СтатусСообщения.Важное);
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СлужебныйДоговор = Ложь;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ЭтоНовый() Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	_ДляПереносаДанных.Объект
		|ИЗ
		|	РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
		|ГДЕ
		|	_ДляПереносаДанных.Объект = &Объект"
		);
		Запрос.УстановитьПараметр("Объект", Ссылка);
		Результат = Запрос.Выполнить();
		
		Если Результат.Пустой() Тогда
			ЗаписьРегистра = РегистрыСведений._ДляПереносаДанных.СоздатьМенеджерЗаписи();
			ЗаписьРегистра.Объект = Ссылка;
			ЗаписьРегистра.Число77 = 0;
			ЗаписьРегистра.Строка77 = Ссылка.УникальныйИдентификатор();
			ЗаписьРегистра.Записать(Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗарегистрироватьВОбменеБИТ Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьКОбменуБИТ(Ссылка, ОбменДанными.Отправитель);
	КонецЕсли;
	
	Если ЗарегистрироватьВОбменеСайт И ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: ДоговорыКонтрагентов", Ложь) Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
	//Если ЗарегистрироватьВОбмене_ОбменПартКом83_77 Тогда
	//	ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_77);
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПроверкаНаСлужебныйДоговор(Отказ)
	ПрошелПроверку = Истина;
	СообщениеОбОшибке = "";
	Если ЭтоНовый() И СлужебныйДоговор Тогда 
		ПрошелПроверку = Ложь;
		СообщениеОбОшибке = "Запрещено создавать новые служебные договора"
	ИначеЕсли Не ЭтоНовый() И СлужебныйДоговор И Не ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "СлужебныйДоговор") Тогда 
		Если ЭтотОбъект.СуществуютСсылки() Тогда 
			ПрошелПроверку = Ложь;
			СообщениеОбОшибке = "Запрещено ставить галку служебный, если есть документы с этим договором"
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПрошелПроверку Тогда 
		Отказ = Истина;
		#Если Клиент Тогда 
			Сообщить(СообщениеОбОшибке);
		#Иначе 
			ВызватьИсключение СообщениеОбОшибке;
		#КонецЕсли
	КонецЕсли;
КонецПроцедуры
ЗарегистрироватьВОбменеСайт = Ложь;
ЗарегистрироватьВОбмене_ОбменПартКом83_77 = Ложь;
