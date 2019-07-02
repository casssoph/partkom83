﻿Функция ПолучитьСистемнуюУчетнуюЗапись() Экспорт
	// + 20171110 Пушкин
	
	//Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоКоду("000000002");
	
	ИскомаяСцылка = Справочники.УчетныеЗаписиЭлектроннойПочты.НайтиПоКоду("000000002");
	Если НЕ ЗначениеЗаполнено(ИскомаяСцылка) тогда
		ИскомаяСцылка = Справочники.УчетныеЗаписиЭлектроннойПочты.ТехПоддержка;
	КонецЕсли;
	
	Возврат ИскомаяСцылка;
	
	// - 20171110 Пушкин
КонецФункции

//функция возвращает список адресов электронной почты по переданному событию для отправки
//по списку организаций, если список организаций не указан - то по всем
//Событие - перечисление, событие для отправки электрического письма
Функция ПолучитьСписокАдресатовДляОтправкиОшибки(Событие, СписокОрганизаций = Неопределено) Экспорт
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкиОтправкиСообщенийОбОшибках.Пользователь.Наименование КАК Наименование,
	|	НастройкиОтправкиСообщенийОбОшибках.АдресЭлПочты
	|ИЗ
	|	РегистрСведений.НастройкиОтправкиСообщенийОбОшибках КАК НастройкиОтправкиСообщенийОбОшибках
	|ГДЕ
	|	НастройкиОтправкиСообщенийОбОшибках.Событие = &Событие"
	);
	Запрос.УстановитьПараметр("Событие", Событие);
	Если СписокОрганизаций <> Неопределено Тогда
		Запрос.Текст = Запрос.Текст + " И НастройкиОтправкиСообщенийОбОшибках.Организация В(&СписокОрганизаций)";
		Запрос.УстановитьПараметр("СписокОрганизаций", СписокОрганизаций);
	КонецЕсли;
	
	// 02.07.19 Строганов Роман > 
	//Запрос.Текст = Запрос.Текст + " И НастройкиОтправкиСообщенийОбОшибках.Настройка";
	// 02.07.19 Строганов Роман <
	
	СписокАдресов = Новый СписокЗначений;
	Для Каждого Стр Из Запрос.Выполнить().Выгрузить() Цикл
		СписокАдресов.Добавить(Стр.АдресЭлПочты, Стр.Наименование);
	КонецЦикла;
	
	Возврат СписокАдресов;
		
КонецФункции

//процедура отправляет сообщение с адреса системной учетной записи без сохранения в системе документа "ЭлектронноеПисьмо"
//ТекстПисьма - собственно строка с текстом письма
//ТемаПисьма - тема, строка
//СписокАдресатов - список значений, содержащий строки с адресами получателей электрической почты
//КодировкаПисьма - строка с типом кодировки (по умолчанию "UTF8")
//ТипТекста - перечисление типа токстов почтового сообщения, по умолчанию - простой текст
Процедура ОтправитьЭлектронноеСообщениеБезСохранения(Событие, ТекстПисьма = "Не опознанное Событие", ТемаПисьма = "Сообщение об ошибке из 1С8", 
					СписокАдресатов = Неопределено, КодировкаПисьма = "UTF8", ТипТекста = Неопределено, 
					лАдресФайлаВложения = "", лОтправитель = Неопределено, ВрКаталог = Неопределено) Экспорт
					
	лКлючАлгоритма = "ОбщийМодуль_РассылкаСообщенийОбОшибках_ОтправитьЭлектронноеСообщениеБезСохранения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
					
	Если СписокАдресатов = Неопределено Тогда
		СписокАдресатов = ПолучитьСписокАдресатовДляОтправкиОшибки(Событие);
	КонецЕсли;
	
	Если ТипЗнч(СписокАдресатов) = Тип("Строка") Тогда
		//предполагаем, что разделитель только один ";"
		СписокАдресатов = СокрЛП(СписокАдресатов);
		СписокАдресатов = СтрЗаменить(СписокАдресатов, ",", ";");
		
		МассивАдресов = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СписокАдресатов, ";");
		СписокАдресатов = Новый СписокЗначений;
		Для А = 0 По МассивАдресов.Количество() - 1 Цикл
			текАдрес = СокрЛП(МассивАдресов[А]);
			Если НЕ ПустаяСтрока(текАдрес) Тогда
				Если СписокАдресатов.НайтиПоЗначению(текАдрес) = Неопределено Тогда
					Если СтрНайти(текАдрес, "@") > 0 Тогда
						СписокАдресатов.Добавить(текАдрес);
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;			
			
		КонецЦикла;
	Иначе
		// 12.04.19 Строганов Роман > 
		СписокАдресатовОбработано = Новый СписокЗначений;
		Для Каждого Адрес Из СписокАдресатов Цикл
			Если СтрЧислоВхождений(Адрес.Значение, "@") > 1 Тогда
				СтрокаАдресатов = СокрЛП(Адрес.Значение);
				СтрокаАдресатов = СтрЗаменить(Адрес.Значение, ",", ";");
				МассивАдресов = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(СтрокаАдресатов, ";");
				Для А = 0 По МассивАдресов.Количество() - 1 Цикл
					текАдрес = СокрЛП(МассивАдресов[А]);
					Если НЕ ПустаяСтрока(текАдрес) Тогда
						Если СписокАдресатовОбработано.НайтиПоЗначению(текАдрес) = Неопределено Тогда
							Если СтрНайти(текАдрес, "@") > 0 Тогда
								СписокАдресатовОбработано.Добавить(текАдрес);
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			Иначе
				СписокАдресатовОбработано.Добавить(Адрес.Значение);
			КонецЕсли;
		КонецЦикла;
		СписокАдресатов = СписокАдресатовОбработано;
		// 12.04.19 Строганов Роман <
	КонецЕсли;
	
	// + 20171110 Пушкин
	
	//Если ТипЗнч(СписокАдресатов) = Тип("СписокЗначений") Тогда
	//	Если СписокАдресатов.Количество() = 0 Тогда
	//		Возврат;
	//	КонецЕсли;
	//ИначеЕсли СписокАдресатов = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если НЕ ТипЗнч(СписокАдресатов) = Тип("СписокЗначений") Тогда
		СписокАдресатов = Новый СписокЗначений;
	КонецЕсли;
	Если СписокАдресатов.Количество() = 0 Тогда
		//СписокАдресатов.Добавить("Gorohov-PE@Part-kom.ru", "Горохов Петр");
		//СписокАдресатов.Добавить("sumv1@mail.ru", "Сумин Владимир");
		СписокАдресатов.Добавить("Pushkin-DS@Part-kom.ru", "Пушкин Денис");
		СписокАдресатов.Добавить("Golubev-SV@Part-kom.ru", "Голубев Сергей");
		//СписокАдресатов.Добавить("Valiakmetov-AA@Part-kom.ru", "Валиахметов Артур");
	КонецЕсли;
		
	// - 20171110 Пушкин
	
	Если ЗначениеЗаполнено(лОтправитель) Тогда
		УчетнаяЗапись = лОтправитель;
	Иначе
		УчетнаяЗапись = ПолучитьСистемнуюУчетнуюЗапись();
	КонецЕсли;
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Профиль.АдресСервераPOP3 = УчетнаяЗапись.POP3Сервер;
	Профиль.АдресСервераSMTP = УчетнаяЗапись.SMTPСервер;
	Если УчетнаяЗапись.ВремяОжиданияСервера > 0 Тогда
		Профиль.ВремяОжидания = УчетнаяЗапись.ВремяОжиданияСервера;
	КонецЕсли; 
	Профиль.Пароль           = УчетнаяЗапись.Пароль;
	Профиль.Пользователь     = УчетнаяЗапись.Логин;
	Профиль.ПортPOP3         = УчетнаяЗапись.ПортPOP3;
	Профиль.ПортSMTP         = УчетнаяЗапись.ПортSMTP;
	Если УчетнаяЗапись.ТребуетсяSMTPАутентификация Тогда
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.ПоУмолчанию;
		Профиль.ПарольSMTP         = УчетнаяЗапись.ПарольSMTP;
		Профиль.ПользовательSMTP   = УчетнаяЗапись.ЛогинSMTP;
	Иначе
		Профиль.АутентификацияSMTP = СпособSMTPАутентификации.БезАутентификации;
		Профиль.ПарольSMTP         = "";
		Профиль.ПользовательSMTP   = "";
	КонецЕсли; 
	ИнтернетПочта = Новый ИнтернетПочта;
	ИнтернетПочта.Подключиться(Профиль);
	ПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	ПочтовоеСообщение.Кодировка 		= КодировкаПисьма;
	ПочтовоеСообщение.ИмяОтправителя  	= УчетнаяЗапись.Наименование;
	ПочтовоеСообщение.Отправитель    	= УчетнаяЗапись.АдресЭлектроннойПочты;
	ПочтовоеСообщение.Тема            	= ТемаПисьма;
	Для каждого Кому Из СписокАдресатов Цикл
		Получатель = ПочтовоеСообщение.Получатели.Добавить();
		Получатель.Адрес           = Кому.Значение;
		Получатель.ОтображаемоеИмя = Кому.Представление;
		Получатель.Кодировка       = КодировкаПисьма;		
	КонецЦикла;
	ТекстСообщения = ПочтовоеСообщение.Тексты.Добавить();
	ТекстСообщения.Кодировка = КодировкаПисьма;
	
	Если ТипТекста = Неопределено Тогда
		ТекстСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст;
	Иначе
		ТекстСообщения.ТипТекста = ТипТекста;
	КонецЕсли;
	
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(Событие, "СлужебноеСобытие") Тогда
		// + 20180109 Пушкин	
		ТекстПисьма = "Источник: "  
					 + СтрокаСоединенияИнформационнойБазы()
					 + Символы.ПС
					 + "Это рабочая БД: "  
				 	+ Строка(ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза())
				 	+ Символы.ПС
				 	+ "Отправитель: "  
				 	+ Строка(ПараметрыСеанса.ТекущийПользователь.Код)
				 	+ Символы.ПС
				 	+ "Время отправки: " 
				 	+ Строка(ТекущаяДата())
				 	+ Символы.ПС
				 	+ ТекстПисьма;
		// - 20180109 Пушкин
	Иначе
		//если текст письма не был заполнен, тогда нужно его очистить
		ТекстПисьма = ?(ТекстПисьма = "Не опознанное Событие", "", ТекстПисьма);
		
	КонецЕсли;
	
	ТекстСообщения.Текст     = ТекстПисьма;
	
	Если ТипЗнч(лАдресФайлаВложения) = Тип("СписокЗначений") Тогда
		Для Каждого КлючИЗначение Из лАдресФайлаВложения Цикл 
			СтруктураВложения = КлючИЗначение.Значение;
			Если ТипЗнч(СтруктураВложения) = Тип("Структура") Тогда
				// 12.04.19 Строганов Роман > 
				Если ВрКаталог = Неопределено Тогда
					ВрКаталог = КаталогВременныхФайлов();
				КонецЕсли;
				// 12.04.19 Строганов Роман <
				
				ВрКаталог = ?(Прав(ВрКаталог,1) = "\", ВрКаталог, ВрКаталог + "\");
				тИмяФайла = ВрКаталог + СтруктураВложения.ИмяФайла;
				Если СтруктураВложения.Свойство("Хранилище") Тогда
					Если СтруктураВложения.Хранилище = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					СтруктураВложения.Хранилище.Записать(тИмяФайла);
					//#PK83-573 Kalinin V.A. ( 2018-05-25 )
					//Поправил немного, т.к не вставлялись вложения
					ПочтовоеСообщение.Вложения.Добавить(СтруктураВложения.Хранилище, СтруктураВложения.ИмяФайла);
					Продолжить;

				Иначе
					Продолжить;
					
				КонецЕсли;
				ПолученныйФайл = Новый Файл(тИмяФайла);
				Если ПолученныйФайл.Существует() Тогда
					ПочтовоеСообщение.Вложения.Добавить(ПолученныйФайл.ПолноеИмя, СтруктураВложения.Наименование);
				
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	ИначеЕсли ТипЗнч(лАдресФайлаВложения) = Тип("Строка") Тогда
		Если НЕ ПустаяСтрока(лАдресФайлаВложения) Тогда
			ПолученныйФайл = Новый Файл(лАдресФайлаВложения);
			Если ПолученныйФайл.Существует() Тогда
				ФайлВложения = ПочтовоеСообщение.Вложения.Добавить(ПолученныйФайл.ПолноеИмя);			
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	Попытка
		
		ИнтернетПочта.Послать(ПочтовоеСообщение);
		
	Исключение
		
		//ХудинВВ XX-2408 30042019 {{
		ТекстОшибкиОтправки = 
		"Ошибка отправки: 
		|"+ОписаниеОшибки()+"
		|
		|Тема: "+ПочтовоеСообщение.Тема+"
		|Адреса получателей:
		|";
		
		Для каждого Получатель Из ПочтовоеСообщение.Получатели Цикл
			ТекстОшибкиОтправки = ТекстОшибкиОтправки + Получатель.Адрес+Символы.ПС;
		КонецЦикла;

		КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(Неопределено, 
		Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаОтправкиЭлектронногоСообщения,
		ТекстОшибкиОтправки,
		, 
		Истина,
		,
		"ОбщийМодуль.РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения");	
		//}}
		
		ЗаписьЖурналаРегистрации("Отправка электронного сообщения", УровеньЖурналаРегистрации.Ошибка, , , ТекстОшибкиОтправки);
		
	КонецПопытки;
	
	ИнтернетПочта.Отключиться();	

КонецПроцедуры

