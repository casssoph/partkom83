﻿
Процедура ПроверитьКонтрагентовПоГоловным(Отказ = Неопределено, УдалитьСтроки = Ложь) Экспорт 
	ТЗ = Контрагенты.Выгрузить(,"Контрагент,НомерСтроки");
	
	Если Тз.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", ТЗ);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗ.НомерСтроки,
	|	ВЫРАЗИТЬ(ТЗ.Контрагент КАК Справочник.Контрагенты) КАК Контрагент
	|ПОМЕСТИТЬ втКонтрагенты2
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втКонтрагенты2.НомерСтроки,
	|	втКонтрагенты2.Контрагент,
	|	втКонтрагенты2.Контрагент.ГоловнойКонтрагент КАК ГоловнойКонтрагент
	|ПОМЕСТИТЬ втКонтрагенты
	|ИЗ
	|	втКонтрагенты2 КАК втКонтрагенты2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втКонтрагенты.Контрагент КАК ГоловнойКонтрагент
	|ПОМЕСТИТЬ втГолКА
	|ИЗ
	|	втКонтрагенты КАК втКонтрагенты
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втКонтрагенты.ГоловнойКонтрагент
	|ИЗ
	|	втКонтрагенты КАК втКонтрагенты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	втГолКА.ГоловнойКонтрагент,
	|	Контрагенты.Ссылка КАК Контрагент
	|ПОМЕСТИТЬ втВсеПодчиненные
	|ИЗ
	|	втГолКА КАК втГолКА
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
	|		ПО втГолКА.ГоловнойКонтрагент = Контрагенты.ГоловнойКонтрагент
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втВсеПодчиненные.ГоловнойКонтрагент,
	|	втВсеПодчиненные.Контрагент
	|ПОМЕСТИТЬ втНетВСписке
	|ИЗ
	|	втВсеПодчиненные КАК втВсеПодчиненные
	|		ЛЕВОЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	|		ПО (втКонтрагенты.Контрагент = втВсеПодчиненные.Контрагент)
	|ГДЕ
	|	втКонтрагенты.Контрагент ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втКонтрагенты.НомерСтроки КАК НомерСтроки,
	|	втНетВСписке.ГоловнойКонтрагент,
	|	втНетВСписке.Контрагент,
	|	0 КАК НомерПакета,
	|	втНетВСписке.ГоловнойКонтрагент.Код,
	|	втНетВСписке.Контрагент.Код,
	|	втКонтрагенты.Контрагент КАК КонтрагентВСтроке,
	|	втКонтрагенты.Контрагент.Код КАК КонтрагентВСтрокеКод
	|ИЗ
	|	втНетВСписке КАК втНетВСписке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	|		ПО втНетВСписке.ГоловнойКонтрагент = втКонтрагенты.Контрагент
	|ГДЕ
	|	втКонтрагенты.Контрагент = втКонтрагенты.ГоловнойКонтрагент
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	втКонтрагенты.НомерСтроки,
	|	втНетВСписке.ГоловнойКонтрагент,
	|	втНетВСписке.Контрагент,
	|	1,
	|	втНетВСписке.ГоловнойКонтрагент.Код,
	|	втНетВСписке.Контрагент.Код,
	|	втКонтрагенты.Контрагент,
	|	втКонтрагенты.Контрагент.Код
	|ИЗ
	|	втНетВСписке КАК втНетВСписке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	|		ПО втНетВСписке.ГоловнойКонтрагент = втКонтрагенты.ГоловнойКонтрагент
	|ГДЕ
	|	втНетВСписке.Контрагент = втНетВСписке.ГоловнойКонтрагент
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	втКонтрагенты.НомерСтроки,
	|	втНетВСписке.ГоловнойКонтрагент,
	|	втНетВСписке.Контрагент,
	|	2,
	|	втНетВСписке.ГоловнойКонтрагент.Код,
	|	втНетВСписке.Контрагент.Код,
	|	втКонтрагенты.Контрагент,
	|	втКонтрагенты.Контрагент.Код
	|ИЗ
	|	втНетВСписке КАК втНетВСписке
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	|		ПО втНетВСписке.ГоловнойКонтрагент = втКонтрагенты.ГоловнойКонтрагент
	|ГДЕ
	|	втНетВСписке.Контрагент <> втНетВСписке.ГоловнойКонтрагент
	|	И втКонтрагенты.Контрагент <> втКонтрагенты.ГоловнойКонтрагент
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Шаблон = "Строка # %1
	| Код Контрагента: %2
	| Наименование Контрагента: %3
	| Отсутвует %4 контрагент %6 в списке с кодом: %5";
	Массив = Новый Массив;
	Массив.Добавить("подчиненный");
	Массив.Добавить("головной");
	Массив.Добавить("связанный по головному");
	Пока Выборка.Следующий() Цикл 
		Отказ = Истина;
		
		Сообщение = СтрШаблон(Шаблон, Выборка.НомерСтроки, Выборка.КонтрагентВСтрокеКод, Выборка.КонтрагентВСтроке, Массив.Получить(Выборка.НомерПакета), Выборка.КонтрагентКод, Выборка.Контрагент);
		
		Сообщить(Сообщение);
		
		Если УдалитьСтроки Тогда 
			Строки = Контрагенты.НайтиСтроки(Новый Структура("Контрагент", Выборка.КонтрагентВСтроке));
			Для Каждого Стр Из Строки Цикл 
				Контрагенты.Удалить(Стр);
			КонецЦикла;
			Сообщить("Проблемные строки удалены");
		КонецЕсли;

	КонецЦикла;
	
	Если Результат.Пустой() Тогда 
		Сообщить("Проверка на головных и подчиненных контрагентов. Все строки корректны");
	КонецЕсли;
	
	//"ВЫБРАТЬ
	//               |	ТЗ.НомерСтроки,
	//               |	ВЫРАЗИТЬ(ТЗ.Контрагент КАК Справочник.Контрагенты) КАК Контрагент
	//               |ПОМЕСТИТЬ втКонтрагенты1
	//               |ИЗ
	//               |	&ТЗ КАК ТЗ
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	//               |	втКонтрагенты1.Контрагент,
	//               |	втКонтрагенты1.Контрагент.ГоловнойКонтрагент КАК ГоловнойКонтрагент,
	//               |	втКонтрагенты1.НомерСтроки
	//               |ПОМЕСТИТЬ втКонтрагенты
	//               |ИЗ
	//               |	втКонтрагенты1 КАК втКонтрагенты1
	//               |ГДЕ
	//               |	втКонтрагенты1.Контрагент <> втКонтрагенты1.Контрагент.ГоловнойКонтрагент
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	//               |	Спр.Ссылка КАК СпрКонтрагент,
	//               |	Спр.Ссылка.ГоловнойКонтрагент КАК СпрГоловнойКонтрагент
	//               |ПОМЕСТИТЬ Спр
	//               |ИЗ
	//               |	Справочник.Контрагенты КАК Спр
	//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	//               |		ПО (втКонтрагенты.ГоловнойКонтрагент = Спр.Ссылка.ГоловнойКонтрагент)
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	Спр.СпрКонтрагент,
	//               |	Спр.СпрКонтрагент.Код КАК СпрКонтрагентКод,
	//               |	Спр.СпрГоловнойКонтрагент,
	//               |	втКонтрагенты.Контрагент,
	//               |	втКонтрагенты.ГоловнойКонтрагент
	//               |ПОМЕСТИТЬ вт2
	//               |ИЗ
	//               |	Спр КАК Спр
	//               |		ЛЕВОЕ СОЕДИНЕНИЕ втКонтрагенты КАК втКонтрагенты
	//               |		ПО Спр.СпрГоловнойКонтрагент = втКонтрагенты.ГоловнойКонтрагент
	//               |			И Спр.СпрКонтрагент = втКонтрагенты.Контрагент
	//               |ГДЕ
	//               |	втКонтрагенты.Контрагент ЕСТЬ NULL
	//               |;
	//               |
	//               |////////////////////////////////////////////////////////////////////////////////
	//               |ВЫБРАТЬ
	//               |	втКонтрагенты1.НомерСтроки КАК НомерСтроки,
	//               |	втКонтрагенты1.Контрагент КАК Контрагент,
	//               |	вт2.СпрГоловнойКонтрагент КАК ГоловнойКонтрагент,
	//               |	вт2.СпрКонтрагентКод,
	//               |	вт2.СпрКонтрагент КАК КонтрагентСвязанный
	//               |ИЗ
	//               |	вт2 КАК вт2
	//               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втКонтрагенты1 КАК втКонтрагенты1
	//               |		ПО вт2.СпрГоловнойКонтрагент = втКонтрагенты1.Контрагент.ГоловнойКонтрагент
	//               |ИТОГИ
	//               |	МАКСИМУМ(НомерСтроки)
	//               |ПО
	//               |	Контрагент";	
	//
	//Резт = Запрос.Выполнить();
	//Выборка = Резт.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Контрагент");
	//Если Резт.Пустой() Тогда 
	//	Сообщить("Все ок");
	//КонецЕсли;
	//Пока Выборка.Следующий() Цикл 
	//	Сообщить("В строке № " + Выборка.НомерСтроки + " с  контрагентом " + Выборка.Контрагент);
	//	ВыборкаПоСтрокам = Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	//	Пока ВыборкаПоСтрокам.Следующий() Цикл 
	//		Сообщить("Не указан связанный контрагент " + ВыборкаПоСтрокам.КонтрагентСвязанный + " с кодом " + ВыборкаПоСтрокам.СпрКонтрагентКод);
	//	КонецЦикла;
	//	
	//	Если УдалитьСтроки Тогда 
	//		Строки = Контрагенты.НайтиСтроки(Новый Структура("Контрагент", Выборка.Контрагент));
	//		Для Каждого Стр Из Строки Цикл 
	//			Контрагенты.Удалить(Стр);
	//		КонецЦикла;
	//		Сообщить("Проблемные строки удалены");
	//	КонецЕсли;
	//	
	//	Отказ = Истина;

	//КонецЦикла;
	//ТЗ = Запрос.Выполнить().Выгрузить();
	//Если ТЗ.Количество() > 0 Тогда
	//	
	//	Сообщить("В списке отсутсвуют следующие контрагенты головных контрагентов:");
	//	
	//	Для каждого СтрокаТЗ Из ТЗ Цикл
	//		Сообщить("Контрагент: """+ СтрокаТЗ.СпрКонтрагент+""", код: "+СтрокаТЗ.СпрКонтрагентКод+", Головной: """+СтрокаТЗ.СпрГоловнойКонтрагент+"""");
	//	КонецЦикла;
	//	
	//	Отказ = Истина;
	//	
	//Иначе
	//	Сообщить("В списке указаны все контрагенты головных");
	//	Отказ = Ложь;
	//КонецЕсли;
	
		
	
КонецПроцедуры

Функция ОбработатьСтроки(СоздаватьДоговоры = Ложь, ИзменятьЗаявки = Ложь, СоздаватьКорректировки = Ложь) Экспорт
	
	лКлючАлгоритма = "Обработка_ПереводНаНовыеДоговоры_МодульОбъекта_ОбработатьСтроки";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	
	Отказ = Ложь;
	
	ПроверитьКонтрагентовПоГоловным(Отказ);
	
	Если Отказ Тогда 
		Возврат Неопределено;
	КонецЕсли;
	
	Для каждого СтрокаТЧ Из Контрагенты Цикл
		
		Если Не СтрокаТЧ.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		Если нЕ ЗначениеЗаполнено(СтрокаТЧ.Контрагент)
			ИЛИ Не ЗначениеЗаполнено(СтрокаТЧ.Организация) Тогда
			Сообщить("В строке "+(Контрагенты.Индекс(СтрокаТЧ)+1)+" не указан контрагент или организация");
			Продолжить;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(СтрокаТЧ.Организация.Договор_ОфертаПокупателя_Дата) 
			Или Не ЗначениеЗаполнено(СтрокаТЧ.Организация.Договор_ОфертаПокупателя_Номер) Тогда 
			Сообщить("В строке " + СтрокаТЧ.НомерСтроки + " в организации не указаны Номер и Дата оферты");
			Продолжить;
		КонецЕсли;
		УспешноДоговоры = Истина;
		УспешноЗаявки = Истина;
		//УспешноКорр = Истина;
		Если  СоздаватьДоговоры Тогда
			УспешноДоговоры = СоздатьНовыеДоговоры(СтрокаТЧ.Контрагент, СтрокаТЧ.Организация);
		КонецЕсли;
		Если  ИзменятьЗаявки Тогда
			УспешноЗаявки = ИзменитьЗаявки(СтрокаТЧ.Контрагент, СтрокаТЧ.Организация);
		КонецЕсли;
		//Если СоздаватьКорректировки Тогда 
		//	УспешноКорр = СоздатьКорректировкиДолга(СтрокаТЧ);
		//КонецЕсли;
		Если УспешноДоговоры И УспешноЗаявки  Тогда
			 СтрокаТЧ.Выбрать = Ложь;
		КонецЕсли;
		#Если Клиент Тогда 
			ОбработкаПрерыванияПользователя();
		#КонецЕсли
	КонецЦикла;
	
	Если СоздаватьКорректировки Тогда 
		СоздатьКорректировкиДолга();		
	КонецЕсли;
КонецФункции

Функция СоздатьНовыеДоговоры(Контрагент, ОрганизацияНовая) Экспорт
	
	лКлючАлгоритма = "Обработка_ПереводНаНовыеДоговоры_МодульОбъекта_СоздатьНовыеДоговоры";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	АлгоритмыЗначениеВозврата = Неопределено;		
	 	Выполнить(лЗамена);		
	 	Возврат АлгоритмыЗначениеВозврата;		
	 КонецЕсли;	
	 
	//Узел = ПланыОбмена.ОбменПартКом83_БитФинанс.НайтиПоКоду("002"); // не регистрируем в БитФинанс
	
	Успешно = Истина;

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Контрагенты.Ссылка КАК Контрагент,
		|	Контрагенты.ОсновнойДоговорКонтрагента,
		|	Контрагенты.ОсновнойДоговорКонтрагента.ВидОплаты КАК ВидОплаты
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка
		|	И НЕ Контрагенты.ОсновнойДоговорКонтрагента.Организация = &ОрганизацияНовая";
	
	Запрос.УстановитьПараметр("Ссылка", Контрагент);
	Запрос.УстановитьПараметр("ОрганизацияНовая", ОрганизацияНовая);
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	Всего = Выборка.Количество();
	сч =1;
	СозданоДоговоров = 0;
	Пока Выборка.Следующий() Цикл
		
		Состояние("Обработка "+сч+" из "+Всего);
		
		НачатьТранзакцию();
		
		Попытка
			
			//Приостановим старый
			Если НЕ Выборка.ОсновнойДоговорКонтрагента.ДоговорПриостановлен Тогда
				СтарыйДоговорОбъект = Выборка.ОсновнойДоговорКонтрагента.ПолучитьОбъект();
				СтарыйДоговорОбъект.ДоговорПриостановлен = Истина;
				СтарыйДоговорОбъект.Записать();
			КонецЕсли;
			
			//Новый договор
			НовыйДоговор = Справочники.ДоговорыКонтрагентов.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(НовыйДоговор, Выборка.ОсновнойДоговорКонтрагента,,"НомерЗаявкиОферты, ДатаДоговораОферты, ДатаСоздания, ДоговорПриостановлен, ДоговорПодписан, Код, Организация");
			НовыйДоговор.Организация = ОрганизацияНовая;
			НовыйДоговор.ДоговорПриостановлен = Ложь;
			Если НовыйДоговор.Владелец.ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо 
				И Выборка.ВидОплаты = Перечисления.ВидыДенежныхСредств.Безналичные Тогда
				НовыйДоговор.ДоговорНаОферту = Истина;
				НовыйДоговор.Номер = НовыйДоговор.Организация.Договор_ОфертаПокупателя_Номер;
				НовыйДоговор.Дата = НовыйДоговор.Организация.Договор_ОфертаПокупателя_Дата;
			ИначеЕсли Выборка.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные Тогда 
				НовыйДоговор.ДоговорПодписан = Истина;
				НовыйДоговор.ДоговорНаОферту = Ложь;
				НовыйДоговор.Номер = "";
				НовыйДоговор.Дата = Дата(1,1,1);
			Иначе
				НовыйДоговор.ДоговорНаОферту = Ложь;
				НовыйДоговор.Номер = "";
				НовыйДоговор.Дата = Дата(1,1,1);
			КонецЕсли;
			
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОрганизацияНовая, "ТипОплаты") <> Справочники.ВидыОплатЧекаККМ.Любой Тогда
				НовыйДоговор.ВидОплаты = Неопределено;	
			КонецЕсли;
			
			//Изменить расчетный счет
			НовыйДоговор.БанковскийСчет = НовыйДоговор.Организация.ОсновнойБанковскийСчет;
			НовыйДоговор.Записать();
			
			//Меняем основной на новый
			КонтрагентОбъект = Выборка.Контрагент.ПолучитьОбъект();
			КонтрагентОбъект.ОсновнойДоговорКонтрагента = НовыйДоговор.Ссылка;
			//В обмен с сайтом и БИТ не попадет, что ок, т.к. передача реквизита основного договора не ведется при выгрузке
			КонтрагентОбъект.ОбменДанными.Загрузка = Истина;
			КонтрагентОбъект.Записать();
			
			//Попытка
			//	ПланыОбмена.УдалитьРегистрациюИзменений(Узел, НовыйДоговор.Ссылка);
			//Исключение
			//КонецПопытки;
			//Попытка
			//	ПланыОбмена.УдалитьРегистрациюИзменений(Узел, КонтрагентОбъект.Ссылка);
			//Исключение
			//КонецПопытки;
			//
			ЗафиксироватьТранзакцию();
			СозданоДоговоров = СозданоДоговоров+1;
			
		Исключение
			ОтменитьТранзакцию();
			Сообщить("Ошибка при обработке контрагента: "+Выборка.Контрагент+": "+ОписаниеОшибки());
			Успешно = Ложь;
		КонецПопытки;
		
		ОбработкаПрерыванияПользователя();
		сч =сч+1;
	КонецЦикла;
	
	Сообщить("По контрагенту : "+Контрагент+" создано новых договоров "+СозданоДоговоров );
	
	Возврат Успешно;
	
КонецФункции

Функция ПоменятьБС(Контрагент, ОрганизацияНовая, БСК) Экспорт
	
	Успешно = Истина;

	
	Всего = 1;
	сч =1;
	СозданоДоговоров = 0;
		
	Состояние("Обработка "+сч+" из "+Всего);
	
	НачатьТранзакцию();
	
	Попытка
		
		СтарыйДоговорОбъект = Контрагент.ОсновнойДоговорКонтрагента.ПолучитьОбъект();
		СтарыйДоговорОбъект.БанковскийСчет = БСК;
		СтарыйДоговорОбъект.Записать();
		
		ЗафиксироватьТранзакцию();
		СозданоДоговоров = СозданоДоговоров+1;
		
	Исключение
		ОтменитьТранзакцию();
		Сообщить("Ошибка при обработке контрагента: "+Контрагент+": "+ОписаниеОшибки());
		Успешно = Ложь;
	КонецПопытки;
	
	ОбработкаПрерыванияПользователя();
	сч =сч+1;
	
	Сообщить("По контрагенту : "+Контрагент+" заменено банковских счетов "+СозданоДоговоров );
	
	Возврат Успешно;
	
КонецФункции

Функция ИзменитьЗаявки(Контрагент, ОрганизацияНовая) Экспорт
	
	Успешно = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЗаявкиПокупателейОстатки.СтрокаЗаявки.Заявка КАК Заявка
		|ИЗ
		|	РегистрНакопления.ЗаявкиПокупателей.Остатки(
		|			&ДатаОстатков,
		|			ДоговорКонтрагента.Владелец = &Контрагент
		|				И ДоговорКонтрагента <> ДоговорКонтрагента.Владелец.ОсновнойДоговорКонтрагента
		|				И ДоговорКонтрагента.Владелец.ОсновнойДоговорКонтрагента.Организация = &НоваяОрганизация) КАК ЗаявкиПокупателейОстатки
		|ГДЕ
		|	ЗаявкиПокупателейОстатки.КоличествоОстаток > 0";
	
	Запрос.УстановитьПараметр("ДатаОстатков", ДатаОстатковЗаявок);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("НоваяОрганизация", ОрганизацияНовая);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Всего = Выборка.Количество();
	
	Если Всего = 0 Тогда
		Сообщить("По контрагенту : "+Контрагент+" нет заявок для обработки");
	КонецЕсли;
	
	
	сч =1;
	СозданоЗаявок = 0;
	Пока Выборка.Следующий() Цикл
		
		Состояние("Обработка "+сч+" из "+Всего);
		
		//НачатьТранзакцию();
		
		Попытка
			
			ПоследняяКорректировка = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Выборка.Заявка);
			Если ПоследняяКорректировка.Организация =  ОрганизацияНовая Тогда
				Продолжить;
			КонецЕсли;
			ДокументКорректировка = Документы.КорректировкаЗаявкиПокупателя.СоздатьДокумент();
			ЗаполнитьЗначенияСвойств(ДокументКорректировка, ПоследняяКорректировка,,"Номер,Ответственный,СозданВ77");
			ДокументКорректировка.Дата = ТекущаяДата();
			ДокументКорректировка.Товары.Загрузить(ПоследняяКорректировка.Товары.Выгрузить());
			ДокументКорректировка.Услуги.Загрузить(ПоследняяКорректировка.Услуги.Выгрузить());
			ДокументКорректировка.ПричиныОтказов.Загрузить(ПоследняяКорректировка.ПричиныОтказов.Выгрузить());
			ДокументКорректировка.ДокументОснование = Выборка.Заявка;
			ДокументКорректировка.Организация = ОрганизацияНовая;
			ДокументКорректировка.ДоговорКонтрагента = ДокументКорректировка.Контрагент.ОсновнойДоговорКонтрагента;
			ДокументКорректировка.БанковскийСчет = ДокументКорректировка.Контрагент.ОсновнойДоговорКонтрагента.БанковскийСчет;
			
			ДокументКорректировка.мПроверкаПередПроведением = истина;
			ДокументКорректировка.Записать(РежимЗаписиДокумента.Проведение);
			
			Сообщить(""+ДокументКорректировка.Контрагент+" создана "+ДокументКорректировка);
			//ЗафиксироватьТранзакцию();
			СозданоЗаявок = СозданоЗаявок+1;
			
		Исключение
			Сообщить("Ошибка при обработке контрагента: "+Контрагент+", заявка: "+Выборка.Заявка+": "+ОписаниеОшибки());
			//ОтменитьТранзакцию(); 
			Успешно = Ложь;
		КонецПопытки;
		
		ОбработкаПрерыванияПользователя();
		сч =сч+1;
	КонецЦикла;
	
	Сообщить("По контрагенту (с подчиненными): "+Контрагент+" создано корректировок заявок " + СозданоЗаявок );
	
	Возврат Успешно;
	
КонецФункции

Функция ОбработатьСтрокиПоДоговорам(СоздаватьДоговоры = Ложь, ИзменятьЗаявки = Ложь, БСК) Экспорт
	
	Для каждого СтрокаТЧ Из Контрагенты Цикл
		
		Если Не СтрокаТЧ.Выбрать Тогда
			Продолжить;
		КонецЕсли;
		
		Если нЕ ЗначениеЗаполнено(СтрокаТЧ.Контрагент)
			ИЛИ Не ЗначениеЗаполнено(СтрокаТЧ.Организация) Тогда
			Сообщить("В строке "+(Контрагенты.Индекс(СтрокаТЧ)+1)+" не указан контрагент или организация");
			Продолжить;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(БСК) Тогда
			Продолжить;
		КонецЕсли;
		
		УспешноБС = ПоменятьБС(СтрокаТЧ.Контрагент, СтрокаТЧ.Организация,БСК);
		
	КонецЦикла;
	
	
КонецФункции

Процедура СоздатьКорректировкиДолга(текСтрока = Неопределено) Экспорт 
	Если текСтрока = Неопределено Тогда 
		Строки = Контрагенты.НайтиСтроки(Новый Структура("СоздатьКорректировкиДолга", Истина));
		
		_Таблица = Контрагенты.Выгрузить(Строки);
	Иначе
		Строки = Новый Массив;
		Строки.Добавить(текСтрока);
		_Таблица = Контрагенты.Выгрузить(Строки);
	КонецЕсли;
	
	//проверить везде ли заполнена организация 
	Строки = _Таблица.НайтиСтроки(Новый Структура("Организация", Справочники.Организации.ПустаяСсылка()));
	Если Строки.Количество() > 0 Тогда 
		ВызватьИсключение "Есть незаполненные организации";
	КонецЕсли;
	Строки = _Таблица.НайтиСтроки(Новый Структура("Контрагент", Справочники.Контрагенты.ПустаяСсылка()));
	Если Строки.Количество() > 0 Тогда 
		ВызватьИсключение "Есть незаполненные контрагент";
	КонецЕсли;
	Строки = _Таблица.НайтиСтроки(Новый Структура("ТекущаяОрганизация", Справочники.Организации.ПустаяСсылка()));
	Если Строки.Количество() > 0 Тогда 
		ВызватьИсключение "Есть незаполненные текущие организации";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	_Таблица.ТекущаяОрганизация,
	               |	_Таблица.Организация,
	               |	ВЫРАЗИТЬ(_Таблица.Контрагент КАК Справочник.Контрагенты) КАК Контрагент
	               |ПОМЕСТИТЬ _Таблица
	               |ИЗ
	               |	&_Таблица КАК _Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	_Таблица.ТекущаяОрганизация,
	               |	_Таблица.Организация,
	               |	_Таблица.Контрагент,
	               |	_Таблица.Контрагент.ОсновнойДоговорКонтрагента.Организация = _Таблица.Организация КАК СозданДоговор,
	               |	_Таблица.Контрагент.ОсновнойДоговорКонтрагента КАК ОсновнойДоговорКонтрагента
	               |ПОМЕСТИТЬ вт
	               |ИЗ
	               |	_Таблица КАК _Таблица
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВзаиморасчетыОстатки.ДоговорКонтрагента,
	               |	ВзаиморасчетыОстатки.ДоговорКонтрагента.Владелец КАК Контрагент,
	               |	ВзаиморасчетыОстатки.СуммаУпрОстаток КАК Сумма,
	               |	ВзаиморасчетыОстатки.СуммаРеглОстаток КАК СуммаРегл
	               |ПОМЕСТИТЬ вт2
	               |ИЗ
	               |	РегистрНакопления.Взаиморасчеты.Остатки(
	               |			,
	               |			(ДоговорКонтрагента.Владелец, ДоговорКонтрагента.Организация) В
	               |				(ВЫБРАТЬ
	               |					вт.Контрагент,
	               |					вт.ТекущаяОрганизация
	               |				ИЗ
	               |					вт)) КАК ВзаиморасчетыОстатки
	               |ГДЕ
	               |	(ВзаиморасчетыОстатки.СуммаУпрОстаток <> 0
	               |			ИЛИ ВзаиморасчетыОстатки.СуммаРеглОстаток <> 0)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт.Контрагент КАК Контрагент,
	               |	вт.ТекущаяОрганизация КАК ТекущаяОрганизация,
	               |	вт.Организация КАК Организация,
	               |	вт.СозданДоговор,
	               |	вт.ОсновнойДоговорКонтрагента КАК ОсновнойДоговорКонтрагента,
	               |	вт2.ДоговорКонтрагента,
	               |	вт2.Сумма КАК Сумма,
	               |	вт2.СуммаРегл КАК СуммаРегл
	               |ИЗ
	               |	вт КАК вт
	               |		ЛЕВОЕ СОЕДИНЕНИЕ вт2 КАК вт2
	               |		ПО вт.Контрагент = вт2.Контрагент
	               |ГДЕ
	               |	вт.СозданДоговор
	               |ИТОГИ
	               |	МАКСИМУМ(ТекущаяОрганизация),
	               |	МАКСИМУМ(Организация),
	               |	МАКСИМУМ(ОсновнойДоговорКонтрагента)
	               |ПО
	               |	Контрагент
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	вт.Контрагент
	               |ИЗ
	               |	вт КАК вт
	               |ГДЕ
	               |	НЕ вт.СозданДоговор";
	Запрос.УстановитьПараметр("_Таблица", _Таблица);
	
	Результаты = Запрос.ВыполнитьПакет();
	ВыборкаНеСозданДоговор = Результаты.Получить(Результаты.ВГраница()).Выбрать();
	Пока ВыборкаНеСозданДоговор.Следующий() Цикл 
		Сообщить("Для контрагента " + ВыборкаНеСозданДоговор.Контрагент + " не создан договор с новой организацией");
	КонецЦикла;
	
	Колво = 0;
	ВыборкаПоКАГСоздатьКорр = Результаты.Получить(Результаты.ВГраница() - 1).Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Контрагент");

	Пока ВыборкаПоКАГСоздатьКорр.Следующий() Цикл 
		Успешно = Истина;

		ВыборкаСоздатьКорр = ВыборкаПоКАГСоздатьКорр.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		//Сообщить("Создание корректировок долга для контрагента " + ВыборкаПоКАГСоздатьКорр.Контрагент);
		
		//Сумма = 0;
		//СуммаРегл = 0;
		Сообщить("Контрагент " + ВыборкаПоКАГСоздатьКорр.Контрагент);
		НачатьТранзакцию(РежимУправленияБлокировкойДанных.Автоматический);
		Попытка
			Пока ВыборкаСоздатьКорр.Следующий() Цикл 
				
				Если ВыборкаСоздатьКорр.Сумма = NULL Тогда 
					Продолжить;
				КонецЕсли;
				
				//Сумма = Сумма + ВыборкаСоздатьКорр.Сумма;
				//СуммаРегл = СуммаРегл + ВыборкаСоздатьКорр.СуммаРегл;
				
				Док = СоздатьКорректировкуДолга(ВыборкаПоКАГСоздатьКорр.Контрагент, 
												ВыборкаСоздатьКорр.ДоговорКонтрагента, 
												ВыборкаСоздатьКорр.ТекущаяОрганизация, 
												ВыборкаСоздатьКорр.Сумма, 
												ВыборкаСоздатьКорр.СуммаРегл,
												ВыборкаСоздатьКорр.ОсновнойДоговорКонтрагента);
				Док.Записать(РежимЗаписиДокумента.Проведение);
				Сообщить("Создан документ " + Док.Ссылка);
				Колво = Колво + 1;
			КонецЦикла;
			
			//Если Сумма <> 0 Тогда 
			//	Док = СоздатьКорректировкуДолга(ВыборкаПоКАГСоздатьКорр.Контрагент, ВыборкаПоКАГСоздатьКорр.ОсновнойДоговорКонтрагента, ВыборкаПоКАГСоздатьКорр.Организация, -Сумма, -СуммаРегл);
			//	Док.Записать(РежимЗаписиДокумента.Проведение);
			//	Сообщить("Создан документ " + Док.Ссылка);
			//	Колво = Колво + 1;
			//КонецЕсли;
			
			Строки = Контрагенты.НайтиСтроки(Новый Структура("Контрагент", ВыборкаПоКАГСоздатьКорр.Контрагент));
			Для Каждого Стр Из Строки Цикл 
				Стр.СоздатьКорректировкиДолга = Ложь;
			КонецЦикла;
			ЗафиксироватьТранзакцию();
		Исключение
			Сообщить("Откат транзакции");
			ОтменитьТранзакцию();
		КонецПопытки;
		//Сообщить("Создано корректировок долга: " + Колво);
	КонецЦикла;
	
	
	Сообщить("Создано " + Колво + " документов");
КонецПроцедуры

Функция СоздатьКорректировкуДолга (Контрагент, ДоговорКонтрагента, Организация, Сумма, СуммаРегл, ОсновнойДоговорКонтрагента)
	
	Док = Документы.КорректировкаДолга.СоздатьДокумент();
	Док.Ответственный = ПолныеПрава.ТекущийПользователь();
	Док.ВалютаДокумента = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	Док.КурсДокумента = 1;
	Док.КратностьДокумента = 1;
	
	Док.КонтрагентДебитор = Контрагент;
	Док.КонтрагентКредитор = Контрагент;
	
	Док.ДоговорКонтрагента = ОсновнойДоговорКонтрагента;
	
	Док.ВидКорректировки = Справочники.ВидыКорректировок.СменаОрганизации;
	//Док.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.СписаниеЗадолженности;
	Док.ВидОперации = Перечисления.ВидыОперацийКорректировкаДолга.ПереносЗадолженности;
	
	Док.Организация = Организация;
	
	НоваяСтрока = Док.СуммыДолга.Добавить();
	Если Сумма > 0  Тогда 
		НоваяСтрока.ВидЗадолженности = Перечисления.ВидыЗадолженности.Дебиторская;
		НоваяСтрока.Сумма = Сумма;
		НоваяСтрока.СуммаРегл = СуммаРегл;
	Иначе
		НоваяСтрока.ВидЗадолженности = Перечисления.ВидыЗадолженности.Кредиторская;
		НоваяСтрока.Сумма = - Сумма;
		НоваяСтрока.СуммаРегл = - СуммаРегл;
	КонецЕсли;
	НоваяСтрока.ДоговорКонтрагента = ДоговорКонтрагента;
	НоваяСтрока.КурсВзаиморасчетов = 1;
	НоваяСтрока.КратностьВзаиморасчетов = 1;
	НоваяСтрока.Контрагент = Контрагент;
	
	Док.Дата = ТекущаяДата();
	Возврат Док;
КонецФункции

