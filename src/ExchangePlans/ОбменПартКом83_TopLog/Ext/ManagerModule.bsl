﻿
Функция ПолучитьМетаданные() Экспорт	
	Возврат Метаданные.ПланыОбмена.ОбменПартКом83_TopLog;
КонецФункции

Функция URIПространстваИмен() Экспорт 
	Возврат "http://partkom83-TopLogExchangeScheme.ru";
КонецФункции

Функция ИмяТипаПоОбъектуМетаданных(вхОбъектМетаданных) Экспорт  
	Возврат	ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(вхОбъектМетаданных) + "." + вхОбъектМетаданных.Имя;
КонецФункции

Функция ИмяТипаПоСсылке(вхСсылкаНаОбъект) Экспорт 
	
	Результат = "";
	лОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(вхСсылкаНаОбъект));
	Если (лОбъектМетаданных <> Неопределено) тогда
		Результат = ИмяТипаПоОбъектуМетаданных(лОбъектМетаданных);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Функция ТипПоСсылке(вхСсылкаНаОбъект) Экспорт
	
	Результат = Неопределено;
	лИмяТипа = ИмяТипаПоСсылке(вхСсылкаНаОбъект);
	Если НЕ ПустаяСтрока(лИмяТипа) тогда
		Результат = ФабрикаXDTO.Тип(URIПространстваИмен(), лИмяТипа);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Функция ТипПоОбъектуМетаданных(вхОбъектМетаданных) Экспорт
	
	Результат = Неопределено;
	лИмяТипа = ИмяТипаПоОбъектуМетаданных(вхОбъектМетаданных);
	Если НЕ ПустаяСтрока(лИмяТипа) тогда
		Результат = ФабрикаXDTO.Тип(URIПространстваИмен(), лИмяТипа);
	КонецЕсли;
	Возврат Результат;
	
КонецФункции

Функция МенеджерОбъектаПоИмениТипа(вхИмяТипа, вхОбъект) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_МенеджерОбъектаПоИмениТипа";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если вхИмяТипа = "РезультатПриемки" Тогда 
		Если ПустаяСтрока(вхОбъект.ЗаказВидДокумента) Тогда 
			ВызватьИсключение "Не указан реквизит ""Вид документа""";
		КонецЕсли;
		
		Возврат Вычислить("Документы." + СокрЛП(вхОбъект.ЗаказВидДокумента));
	ИначеЕсли вхИмяТипа = "РезультатРазмещения" Тогда 
		Возврат Документы.ПеремещениеТоваров;
	ИначеЕсли вхИмяТипа = "РезультатСборки" Тогда 
		Если ПустаяСтрока(вхОбъект.ЗаказВидДокумента) Тогда 
			ВызватьИсключение "Не указан реквизит ""Вид документа""";
		КонецЕсли;
		
		Если вхОбъект.ЗаказВидДокумента = "ВозвратТоваровКлиентаПоставщику"	Тогда 
			//ХудинВВ 27022019 XX-1982
			Возврат Документы.ВозвратТоваровПоставщику;
		Иначе
			Возврат Вычислить("Документы." + СокрЛП(вхОбъект.ЗаказВидДокумента));
		КонецЕсли;
		
	ИначеЕсли вхИмяТипа = "ТранзитнаяОтгрузка"	Или вхИмяТипа = "ЗаказНаОтгрузкуСтатус" Тогда 
		Возврат Документы.РеализацияТоваровУслуг;
	ИначеЕсли вхИмяТипа = "СменаВодителяСЗ"	Тогда 
		Возврат Документы.СлужебноеЗадание;
	ИначеЕсли вхИмяТипа = "ОтменаПТУ"	Тогда
		//ХудинВВ 27022019 XX-1868
		Возврат Документы.ВозвратТоваровОтПокупателя;
		//ХудинВВ XX-2123
	ИначеЕсли вхИмяТипа = "МаршрутныйЛист"	Тогда
		Возврат Документы.МегаЛогист_МаршрутныйЛист;
	КонецЕсли;
	
	Возврат Вычислить(вхИмяТипа);
	
КонецФункции

Функция ВыгрузитьУдаленияЭлементов(вхМассивСсылок, вхОбъектМетаданных) Экспорт
	
	лИмяТипа = ИмяТипаПоОбъектуМетаданных(вхОбъектМетаданных);
	лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен(), "УдалениеОбъекта");
	
	Результат = Новый Массив;
	
	Для Каждого лСсылкаНаОбъект Из вхМассивСсылок цикл
		
		лОбъект = ФабрикаXDTO.Создать(лТипУдалениеОбъекта);
		лОбъект.ТипОбъекта = лИмяТипа;
		лОбъект.Ссылка = XMLСтрока(лСсылкаНаОбъект);
		Результат.Добавить(лОбъект);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ДобавитьСтрокуИсторииПоОбъекту(лСсылкаНаОбъект, лОбъект);
		//)Семенов И.П.
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьУдалениеЭлемента(вхОбъектXDTO, вхОтправитель) Экспорт 
	
	//лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(вхОбъектXDTO.ТипОбъекта, вхОбъектXDTO);
	//
	//лСсылкаНаОбъект = лМенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Ссылка));
	//лОбъект = Новый УдалениеОбъекта(лСсылкаНаОбъект);
	//лОбъект.ОбменДанными.Загрузка = Истина;
	//лОбъект.ОбменДанными.Отправитель = вхОтправитель;
	//лОбъект.Записать();
	
КонецПроцедуры

Процедура ЗагрузитьСообщениеОбмена(вхСообщениеОбмена) Экспорт
	лНомерПотока = ?(ПолучитьМетаданные() = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1);	
	
	// 29.11.18 Строганов Роман > XX-953 Добавить проверку XML при получении с сайта 
	Если Константы.УдалятьНедопустимыеСимволыФайлаОбмена.Получить() = Истина Тогда
		вхСообщениеОбмена = ОбменДаннымиСервер.ЗаменитьНедопустимыеСимволыXML(вхСообщениеОбмена);
	КонецЕсли;
	// 29.11.18 Строганов Роман < XX-953 Добавить проверку XML при получении с сайта
	
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен(), "УдалениеОбъекта");
	лЧтениеХМЛ = Новый ЧтениеXML;
	лЧтениеХМЛ.УстановитьСтроку(вхСообщениеОбмена);
	
	лДанныеХДТО = ФабрикаXDTO.ПрочитатьXML(лЧтениеХМЛ, лТипСообщениеОбмена);
	лИмяПланаОбмена = лДанныеХДТО.ПланОбмена;
	
	Если (лИмяПланаОбмена <> ПолучитьМетаданные().Имя) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""ПланОбмена"".");
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""ПланОбмена"".";
	КонецЕсли;
	
	лПолучатель = ЭтотУзел();
	лИдентификаторОтправителя = лДанныеХДТО.Отправитель;
	лИдентификаторПолучателя = лДанныеХДТО.Получатель;
	Если (лИдентификаторПолучателя <> лПолучатель.ИдентификаторУзла) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""Получатель"".");
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""Получатель"".";
	КонецЕсли;
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Не найден отправитель сообщения в списке узлов.");
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: не найден отправитель сообщения в списке узлов.";	
	КонецЕсли;                                                                      		
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	//Если ЗначениеЗаполнено(лИсходящий) тогда
	//	лНомерОтправленного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лИсходящий, "НомерОтправленного");		
	//	Если (лДанныеХДТО.НомерПринятого > лНомерОтправленного) тогда
	//		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""НомерПринятого"": сообщение с таким номером не отправлялось.";
	//	КонецЕсли;
	//	// фиксируем номер принятого
	//	ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, лДанныеХДТО.НомерПринятого);	
	//КонецЕсли;
	
	лТекстШаблона = ПолучитьОбщийМакет("ЗаголовокСообщенияОбмена").ПолучитьТекст();
	лТекстПустышки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	лТекстШаблона, ПолучитьМетаданные().Имя, лПолучатель.Код,
	лВходящий.Код, Формат(лДанныеХДТО.НомерСообщения, "ЧГ="), "0");
	
	лПустышка = Новый ЧтениеXML;
	лПустышка.УстановитьСтроку(лТекстПустышки);
	
	лЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	лЧтениеСообщения.НачатьЧтение(лПустышка, ДопустимыйНомерСообщения.Больший);
	Попытка
		

		лСписокОбъектов = лДанныеХДТО.Объекты.ПолучитьСписок("Объект");
		
		Если лСписокОбъектов.Количество() > 0 Тогда 
			//Семенов И.П. 06.02.2019 XX-1768(
			ОбменДаннымиКлиентСервер.НачатьЗаписьВИсториюОбменовПоОбъектам();
			//)Семенов И.П.
			НаборЗаписей = РегистрыСведений.ИсторияОбменаСТопЛог.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.НомерСообщения.Установить(лДанныеХДТО.НомерСообщения);
			НаборЗаписей.Отбор.Исходящее.Установить(Ложь);
			НаборЗаписей.Отбор.НомерПотока.Установить(лНомерПотока);
			
			Стр = НаборЗаписей.Добавить();
			Стр.НомерСообщения = лДанныеХДТО.НомерСообщения;
			Стр.Сообщение = вхСообщениеОбмена;
			Стр.ДатаЗагрузкиСообщения = ТекущаяДата();
			Стр.НомерПотока = лНомерПотока;
			
			НаборЗаписей.Записать(Истина);
		КонецЕсли;
		
		Для Каждого лОбъект Из лСписокОбъектов цикл
			Попытка
				лТипОбъекта = лОбъект.Тип();
				Если (лТипОбъекта = лТипУдалениеОбъекта) тогда
	      			ЗагрузитьУдалениеЭлемента(лОбъект, лИсходящий);
				Иначе
					лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(лТипОбъекта.Имя, лОбъект);
					Отказ = Ложь;
					лПараметры = Новый Структура;
					лПараметры.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);  
					лПараметры.Вставить("НомерПотока", лНомерПотока);
					лМенеджерОбъекта.ЗагрузитьЭлемент(лОбъект, лИсходящий, Отказ, лПараметры);
				КонецЕсли;
			Исключение
				СтруктураОшибки = Новый Структура;
				СтруктураОшибки.Вставить("ОбъектXDTO", лОбъект.Тип().Имя);
				СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
				СтруктураОшибки.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);
				СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
				ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
			КонецПопытки;
		КонецЦикла;
		лЧтениеСообщения.ЗакончитьЧтение();
		
	Исключение
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ОбъектXDTO", "СообщениеОбмена");
		СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
		СтруктураОшибки.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);
		СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
		ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
		
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лВходящий, вхСообщениеОбмена,,Истина,СтруктураОшибки.СообщениеОбОшибке);
		//)Семенов И.П.
		
		лЧтениеСообщения.ПрерватьЧтение();
		ВызватьИсключение;
	КонецПопытки;
	
	//Семенов И.П. 06.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лВходящий, вхСообщениеОбмена);
	//)Семенов И.П.
	
	//Попытка
	//	//Проводим размещения, которые не смогли провестить ранее
	//	Документы.ПеремещениеТоваров.ОтложенноеПроведениеРазмещений();
	//Исключение
	//	СтруктураОшибки = Новый Структура;
	//	СтруктураОшибки.Вставить("ОбъектXDTO", "ОтложенноеПроведениеРазмещений");
	//	СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
	//	СтруктураОшибки.Вставить("НомерСообщения", "");
	//	СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
	//	ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
	//КонецПопытки;
	
	//Попытка
	//	//Изменяем ПТУ после загрузки размещений, СЗ после загрузки реализаций
	//	ОбменДаннымиКлиентСервер.ПостОбработкаОбъектовПриОбменеСТопЛог();
	//Исключение
	//	СтруктураОшибки = Новый Структура;
	//	СтруктураОшибки.Вставить("ОбъектXDTO", "ПостОбработкаОбъектовПриОбменеСТопЛог");
	//	СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
	//	СтруктураОшибки.Вставить("НомерСообщения", "");
	//	СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
	//	ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
	//КонецПопытки;

КонецПроцедуры

// 26.03.19 Строганов Роман > 
Процедура ЗагрузитьОбъектОбменаТопЛог(Выборка, СтруктураОтчета, Исходящий, НомерСообщения) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_ЗагрузитьОбъектОбменаТопЛог";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;	
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	НомерПотока = 1;
	
	Попытка
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(Выборка.Данные);
		Тип = ОпределитьТип(Выборка.Данные);
		ТипОбъекта = ФабрикаXDTO.Тип(ПланыОбмена.ОбменПартКом83_TopLog.URIПространстваИмен(), Тип);

		ОбъектXDTO = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ТипОбъекта);
		МенеджерОбъекта = МенеджерОбъектаПоИмениТипа(Тип, ОбъектXDTO);
		Отказ = Ложь;
		Параметры = Новый Структура;
		Параметры.Вставить("НомерСообщения", НомерСообщения);
		Параметры.Вставить("НомерПотока", НомерПотока);
		Параметры.Вставить("Исходящий", Ложь);
		Параметры.Вставить("Тип", Тип);
		
		Если ТипЗнч(МенеджерОбъекта) = Тип("ДокументМенеджер.ПоступлениеТоваровУслуг") Тогда
			МенеджерОбъекта.ЗагрузитьЭлемент(ОбъектXDTO, ПланыОбмена.ОбменПартКом83_TopLog, Отказ, Параметры, , СтруктураОтчета);
		Иначе
			МенеджерОбъекта.ЗагрузитьЭлемент(ОбъектXDTO, ПланыОбмена.ОбменПартКом83_TopLog, Отказ, Параметры, СтруктураОтчета);
		КонецЕсли;
		
	Исключение
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ОбъектXDTO", ТипОбъекта.Имя);
		СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
		СтруктураОшибки.Вставить("НомерСообщения", НомерСообщения);
		СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
		ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
	КонецПопытки;
		
КонецПроцедуры

// 05.04.19 Строганов Роман > 
Процедура ЗагрузитьСообщениеОбменаСправочники(вхСообщениеОбмена, ДатаСообщения = Неопределено) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_ЗагрузитьСообщениеОбменаСправочники";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;	
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	лНомерПотока = ?(ПолучитьМетаданные() = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1);	
	
	// 29.11.18 Строганов Роман > XX-953 Добавить проверку XML при получении с сайта 
	Если Константы.УдалятьНедопустимыеСимволыФайлаОбмена.Получить() = Истина Тогда
		вхСообщениеОбмена = ОбменДаннымиСервер.ЗаменитьНедопустимыеСимволыXML(вхСообщениеОбмена);
	КонецЕсли;
	// 29.11.18 Строганов Роман < XX-953 Добавить проверку XML при получении с сайта
	
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен(), "УдалениеОбъекта");
	лЧтениеХМЛ = Новый ЧтениеXML;
	лЧтениеХМЛ.УстановитьСтроку(вхСообщениеОбмена);
	
	лДанныеХДТО = ФабрикаXDTO.ПрочитатьXML(лЧтениеХМЛ, лТипСообщениеОбмена);
	лИмяПланаОбмена = лДанныеХДТО.ПланОбмена;
	
	Если (лИмяПланаОбмена <> ПолучитьМетаданные().Имя) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""ПланОбмена"".", ДатаСообщения);
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""ПланОбмена"".";
	КонецЕсли;
	
	лПолучатель = ЭтотУзел();
	лИдентификаторОтправителя = лДанныеХДТО.Отправитель;
	лИдентификаторПолучателя = лДанныеХДТО.Получатель;
	Если (лИдентификаторПолучателя <> лПолучатель.ИдентификаторУзла) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""Получатель"".", ДатаСообщения);
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""Получатель"".";
	КонецЕсли;
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Не найден отправитель сообщения в списке узлов.", ДатаСообщения);
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: не найден отправитель сообщения в списке узлов.";	
	КонецЕсли;                                                                      		
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	//Если ЗначениеЗаполнено(лИсходящий) тогда
	//	лНомерОтправленного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лИсходящий, "НомерОтправленного");		
	//	Если (лДанныеХДТО.НомерПринятого > лНомерОтправленного) тогда
	//		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""НомерПринятого"": сообщение с таким номером не отправлялось.";
	//	КонецЕсли;
	//	// фиксируем номер принятого
	//	ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, лДанныеХДТО.НомерПринятого);	
	//КонецЕсли;
	
	лТекстШаблона = ПолучитьОбщийМакет("ЗаголовокСообщенияОбмена").ПолучитьТекст();
	лТекстПустышки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	лТекстШаблона, ПолучитьМетаданные().Имя, лПолучатель.Код,
	лВходящий.Код, Формат(лДанныеХДТО.НомерСообщения, "ЧГ="), "0");
	
	лПустышка = Новый ЧтениеXML;
	лПустышка.УстановитьСтроку(лТекстПустышки);
	
	лЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	лЧтениеСообщения.НачатьЧтение(лПустышка, ДопустимыйНомерСообщения.Больший);
	Попытка
		
		лСписокОбъектов = лДанныеХДТО.Объекты.ПолучитьСписок("Объект");
		
		Если лСписокОбъектов.Количество() > 0 Тогда 
			//Семенов И.П. 06.02.2019 XX-1768(
			ОбменДаннымиКлиентСервер.НачатьЗаписьВИсториюОбменовПоОбъектам();
			//)Семенов И.П.
			НаборЗаписей = РегистрыСведений.ИсторияОбменаСТопЛог.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.НомерСообщения.Установить(лДанныеХДТО.НомерСообщения);
			НаборЗаписей.Отбор.Исходящее.Установить(Ложь);
			НаборЗаписей.Отбор.НомерПотока.Установить(лНомерПотока);
			
			Стр = НаборЗаписей.Добавить();
			Стр.НомерСообщения = лДанныеХДТО.НомерСообщения;
			Стр.Сообщение = вхСообщениеОбмена;
			Стр.ДатаЗагрузкиСообщения = ТекущаяДата();
			Стр.НомерПотока = лНомерПотока;
			
			НаборЗаписей.Записать(Истина);
		КонецЕсли;
		
		ОбрабатываемыеОбъекты = Новый Соответствие;
		ОбрабатываемыеОбъекты.Вставить("Справочники.Водители", Истина);
		ОбрабатываемыеОбъекты.Вставить("Справочники.Изготовители", Истина);
		ОбрабатываемыеОбъекты.Вставить("Справочники.Номенклатура", Истина);
		
		Для Каждого лОбъект Из лСписокОбъектов цикл
			Попытка
				лТипОбъекта = лОбъект.Тип();
				Если (лТипОбъекта = лТипУдалениеОбъекта) тогда
					ЗагрузитьУдалениеЭлемента(лОбъект, лИсходящий);
				Иначе
					Если ОбрабатываемыеОбъекты[лТипОбъекта.Имя] = Истина Тогда
						лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(лТипОбъекта.Имя, лОбъект);
						Отказ = Ложь;
						лПараметры = Новый Структура;
						лПараметры.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);  
						лПараметры.Вставить("НомерПотока", лНомерПотока);
						лМенеджерОбъекта.ЗагрузитьЭлемент(лОбъект, лИсходящий, Отказ, лПараметры);
					КонецЕсли;
				КонецЕсли;
			Исключение
				СтруктураОшибки = Новый Структура;
				СтруктураОшибки.Вставить("ОбъектXDTO", лОбъект.Тип().Имя);
				СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
				СтруктураОшибки.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);
				СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
				ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
			КонецПопытки;
		КонецЦикла;
		лЧтениеСообщения.ЗакончитьЧтение();
		
	Исключение
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ОбъектXDTO", "СообщениеОбмена");
		СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
		СтруктураОшибки.Вставить("НомерСообщения", лДанныеХДТО.НомерСообщения);
		СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
		ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
		
		//Семенов И.П. 06.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лВходящий, вхСообщениеОбмена,,Истина,СтруктураОшибки.СообщениеОбОшибке, ДатаСообщения, лСписокОбъектов.Количество());
		//)Семенов И.П.
		
		лЧтениеСообщения.ПрерватьЧтение();
		ВызватьИсключение;
	КонецПопытки;
	
	//Семенов И.П. 06.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лВходящий, вхСообщениеОбмена,,,,ДатаСообщения, лСписокОбъектов.Количество());
	//)Семенов И.П.
	
	//Попытка
	//	//Проводим размещения, которые не смогли провестить ранее
	//	Документы.ПеремещениеТоваров.ОтложенноеПроведениеРазмещений();
	//Исключение
	//	СтруктураОшибки = Новый Структура;
	//	СтруктураОшибки.Вставить("ОбъектXDTO", "ОтложенноеПроведениеРазмещений");
	//	СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
	//	СтруктураОшибки.Вставить("НомерСообщения", "");
	//	СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
	//	ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
	//КонецПопытки;
	
	//Попытка
	//	//Изменяем ПТУ после загрузки размещений, СЗ после загрузки реализаций
	//	ОбменДаннымиКлиентСервер.ПостОбработкаОбъектовПриОбменеСТопЛог();
	//Исключение
	//	СтруктураОшибки = Новый Структура;
	//	СтруктураОшибки.Вставить("ОбъектXDTO", "ПостОбработкаОбъектовПриОбменеСТопЛог");
	//	СтруктураОшибки.Вставить("СообщениеОбОшибке", ОписаниеОшибки());
	//	СтруктураОшибки.Вставить("НомерСообщения", "");
	//	СтруктураОшибки.Вставить("ДатаЗагрузкиСообщения", ТекущаяДата());
	//	ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
	//КонецПопытки;

КонецПроцедуры

Функция ВыгрузитьСообщениеОбмена(вхИдентификаторУзлаОбмена, вхНомерПринятого) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_ВыгрузитьСообщениеОбмена";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	лНомерПотока = ?(ПолучитьМетаданные() = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 0, 1);
	
	лОтправитель = ЭтотУзел();
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(лИсходящий) тогда
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,ПустаяСсылка(),"",Истина,Истина,"Неправильный параметр номер 1.");
		//)Семенов И.П.
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,ПустаяСсылка(),"",Истина,Истина,"Неправильный параметр номер 1.");
		//)Семенов И.П.
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	лНомерПринятого = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лВходящий, "НомерПринятого");
	
	лНомерОтправленного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лИсходящий, "НомерОтправленного");		
	Если вхНомерПринятого > лНомерОтправленного Тогда
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,лИсходящий,"",Истина,Истина,"Неправильное значение элемента ""НомерПринятого"": сообщение с таким номером не отправлялось.");
		//)Семенов И.П.
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильное значение элемента ""НомерПринятого"": сообщение с таким номером не отправлялось.";
	КонецЕсли;
	
	//ХудинВВ XX-2442 28052019 Временно ((
	Если ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2442) Тогда
		 СохранитьИнформациюОбУдаляемойРегистрации(лИсходящий, вхНомерПринятого)
	КонецЕсли;
	// ))
	
	// фиксируем номер принятого
	ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, вхНомерПринятого);
	// возвращаем сообщение обмена
	
	//Перерегистрируем объекты у которых номер сообщения не NULL. Если их регистрация не затерлась выше, значит до ТопЛога данные объекты не доходили и у них нужно сбросить номер сообщения
	ПеререгистрироватьОбъектыВОбменеТопЛог(лИсходящий);
	
	лТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	//Семенов И.П. 07.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.НачатьЗаписьВИсториюОбменовПоОбъектам();
	//)Семенов И.П.
	
	лПустышка = Новый ЗаписьXML;
	лПустышка.УстановитьСтроку("utf-8");
	лЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	лЗаписьСообщения.НачатьЗапись(лПустышка, лИсходящий);
	//Семенов И.П. 08.02.2019 XX-1768(
	НомерСообщения = лЗаписьСообщения.НомерСообщения;
	//)Семенов И.П.
	Попытка
		
		лСообщениеОбмена = ФабрикаXDTO.Создать(лТипСообщениеОбмена);
		лСообщениеОбмена.ПланОбмена = "ОбменПартКом83_TopLog";
		лСообщениеОбмена.Отправитель = лОтправитель.ИдентификаторУзла;
		лСообщениеОбмена.Получатель = вхИдентификаторУзлаОбмена;
		лСообщениеОбмена.НомерСообщения = лЗаписьСообщения.НомерСообщения;
		лСообщениеОбмена.НомерПринятого = лНомерПринятого;
		
		лОбъекты = ФабрикаXDTO.Создать(лТипОбъекты);
		лСписокОбъектов = лОбъекты.ПолучитьСписок("Объект");
		
		Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда 
			КоличествоВыбираемыхОбъектов = Справочники.НастройкиРеквизитовДляОбменов.КоличествоВыбираемыхОбъектовТопЛог.ЧислоДляРабочейБазы;
		Иначе
			КоличествоВыбираемыхОбъектов = Справочники.НастройкиРеквизитовДляОбменов.КоличествоВыбираемыхОбъектовТопЛог.ЧислоДляТестовойБазы;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(КоличествоВыбираемыхОбъектов) Тогда 
			КоличествоВыбираемыхОбъектов = 1000;
		КонецЕсли;
		
		лВыгружаемыеОбъекты = ОбменДаннымиКлиентСервер.ВыбратьПакетИзмененийДляУзлаОбменаНовое(лИсходящий, лСообщениеОбмена.НомерСообщения, КоличествоВыбираемыхОбъектов);
		Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты цикл
			лМенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лЭлементСоответствия.Ключ);
			лВыгруженныеОбъекты = лМенеджерОбъекта.ВыгрузитьЭлементы(лЭлементСоответствия.Значение, ПолучитьМетаданные());
			Для Каждого лВыгруженныйОбъект Из лВыгруженныеОбъекты цикл
				лСписокОбъектов.Добавить(лВыгруженныйОбъект);
			КонецЦикла;
		КонецЦикла;
		
		лСообщениеОбмена.Объекты = лОбъекты;
		лЗаписьСообщения.ЗакончитьЗапись();
		
	Исключение
		лЗаписьСообщения.ПрерватьЗапись();
		
		//Запись об ошибке выгрузки в историю обмена по объектам
		ТекстОшибки = "Ошибка при создании сообщения обмена: "+ОписаниеОшибки();
		ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, лЗаписьСообщения.НомерСообщения, Истина, ТекстОшибки);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(НомерСообщения,лИсходящий,"",Истина,Истина,ТекстОшибки);
		//)Семенов И.П.
		ВызватьИсключение ОписаниеОшибки();
	КонецПопытки;
	
	//Добавлено Валиахметов А.А. 19.04.2018
	Попытка
		лСообщениеОбмена.Проверить();	
	Исключение
		РассылкаСообщенийОбОшибках.ОтправитьЭлектронноеСообщениеБезСохранения(Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаОбменаСТопЛог, ОписаниеОшибки(), "8.3 -> ТопЛог. Сообщение обмена не соответствует схеме XDTO. База: " + СтрокаСоединенияИнформационнойБазы());
	КонецПопытки;
	//Конец Добавлено Валиахметов А.А. 19.04.2018
	
	лЗаписьХМЛ = Новый ЗаписьXML;
	лЗаписьХМЛ.УстановитьСтроку("utf-8");
	лЗаписьХМЛ.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(лЗаписьХМЛ, лСообщениеОбмена);
	ТекстСообщения = лЗаписьХМЛ.Закрыть();	
	
	Если лСписокОбъектов.Количество() > 0 Тогда 	
		НаборЗаписей = РегистрыСведений.ИсторияОбменаСТопЛог.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.НомерСообщения.Установить(лСообщениеОбмена.НомерСообщения);
		НаборЗаписей.Отбор.Исходящее.Установить(Истина);
		НаборЗаписей.Отбор.НомерПотока.Установить(лНомерПотока);

		Стр = НаборЗаписей.Добавить();
		Стр.НомерСообщения = лСообщениеОбмена.НомерСообщения;
		Стр.Сообщение = ТекстСообщения;
		Стр.ДатаЗагрузкиСообщения = ТекущаяДата();
		Стр.Исходящее = Истина;
		Стр.НомерПотока = лНомерПотока;
		НаборЗаписей.Записать(Истина);
		
		//Запись об успешной выгрузке в историю обмена по объектам
		ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, лСообщениеОбмена.НомерСообщения);
		
	КонецЕсли;
	
	//Семенов И.П. 07.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(НомерСообщения, лИсходящий, ТекстСообщения, Истина);
	//)Семенов И.П.
		
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, НомерСообщения, ЕстьОшибки = Ложь, ТекстОшибки = "", Период = Неопределено, Исходящее = Истина) Экспорт 
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_ЗаписатьИсториюОбменаПоОбъектам";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Если НЕ ТипЗнч(лВыгружаемыеОбъекты) = Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты Цикл
		
		ПолноеИмяМД = лЭлементСоответствия.Ключ.ПолноеИмя();
		
		Если СтрНайти(ПолноеИмяМД, "ПоступлениеТоваровУслуг") > 0 
			ИЛИ СтрНайти(ПолноеИмяМД, "РеализацияТоваровУслуг") > 0 
			Или СтрНайти(ПолноеИмяМД, "ПеремещениеТоваров") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "ВозвратТоваровОтПокупателя") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "ПерестикеровкаПереоценка") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "СписаниеТоваров") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "ВозвратТоваровПоставщику") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "МегаЛогист_МаршрутныйЛист") > 0
			ИЛИ СтрНайти(ПолноеИмяМД, "Экспертиза") > 0 Тогда
			
			// "ВыгружаемыйОбъект" это ТЗ с колонкой "Ссылка"
			Для каждого ВыгружаемыйОбъект Из лЭлементСоответствия.Значение Цикл
				РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ВыгружаемыйОбъект.Ссылка, НомерСообщения, ЕстьОшибки, ТекстОшибки, Период, Исходящее);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

//Любезно предоставлено Карпычевым И.
Процедура ПеререгистрироватьОбъектыВОбменеТопЛог(УзелОбмена) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_ПеререгистрироватьОбъектыВОбменеТопЛог";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	МассивСсылок = Новый Массив;
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Узел", УзелОбмена);
	МетаданныеПланаОбмена = УзелОбмена.Метаданные();
	
	Для Каждого ТекМета Из МетаданныеПланаОбмена.Состав Цикл
		Запрос.Текст = "ВЫБРАТЬ
		|	ИзмененияОбъекта.Ссылка КАК Ссылка
		|ИЗ
		|" + ТекМета.Метаданные.ПолноеИмя() + ".Изменения КАК ИзмененияОбъекта
		|ГДЕ
		|	НЕ ИзмененияОбъекта.НомерСообщения ЕСТЬ NULL
		|И
		|	ИзмененияОбъекта.Узел = &Узел";
		Выб = Запрос.Выполнить().Выбрать();
		Пока Выб.Следующий() Цикл
			МассивСсылок.Добавить(Выб.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Для Каждого ЭлементМассива Из МассивСсылок Цикл
		//Семенов И.П. 31.01.2019 XX-1768(
		//ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена, ЭлементМассива);
		ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(УзелОбмена, ЭлементМассива);
		//)Семенов И.П.
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьСоответствиеОбъектовОбменаТопЛог() Экспорт
	
	Результат = Новый Соответствие;
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.РезультатПриемки")		, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.ОтменаПТУ")			, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.РезультатСборки")		, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.РезультатРазмещения")	, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.ЗаказНаПриемку")		, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.СменаВодителяСЗ")		, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.Водители")				, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.Изготовители")			, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.Номенклатура")			, Истина);
	Результат.Вставить(ПредопределенноеЗначение("Перечисление.ВидыОбъектовОбмена.ЗаказНаОтгрузкуСтатус"), Истина);

	Возврат Результат;
		
КонецФункции

Процедура ОбработатьОбъекты(НомерПотока = Неопределено, ИдентификаторУзлаОбмена) Экспорт
	
	ИмяПланаОбмена =  ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(ЭтотУзел());
	Отправитель = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ИмяПланаОбмена, ИдентификаторУзлаОбмена);
	ОбменССайтомСервер.ОбработатьОбъектыОбмена(Отправитель, НомерПотока);
		
КонецПроцедуры

Функция ОпределитьТип(Сообщение) Экспорт
	
	ПозицияПробела = СтрНайти(Сообщение, " ");
	Возврат Сред(Сообщение,2, ПозицияПробела - 2);
	
КонецФункции

//ХудинВВ XX-2442 28052019 Временно ((
Процедура СохранитьИнформациюОбУдаляемойРегистрации(вхУзел, вхНомерПринятого)
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_СохранитьИнформациюОбУдаляемойРегистрации";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратТоваровОтПокупателяИзменения.Ссылка,
		|	ВозвратТоваровОтПокупателяИзменения.НомерСообщения
		|ИЗ
		|	Документ.ВозвратТоваровОтПокупателя.Изменения КАК ВозвратТоваровОтПокупателяИзменения
		|ГДЕ
		|	ВозвратТоваровОтПокупателяИзменения.Узел = &Узел
		|	И ВозвратТоваровОтПокупателяИзменения.НомерСообщения <= &НомерСообщения";
	
	Запрос.УстановитьПараметр("НомерСообщения", вхНомерПринятого);
	Запрос.УстановитьПараметр("Узел", вхУзел);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = "Удаление регистрации, обмен с топлог, номер принятого "+вхНомерПринятого+Символы.ПС;
		ТекстОшибки = ТекстОшибки + Выборка.Ссылка+", номер сообщения "+Выборка.НомерСообщения+Символы.ПС;
		
		КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(
		Выборка.Ссылка, 
		Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаОбменаСТопЛогВозвраты,
		"Удаление регистрации, обмен с топлог (не ошибка)",
		,
		Истина,
		ТекстОшибки,
		"ПланОбмена_ОбменПартКом83_TopLog_МодульМенеджера_СохранитьИнформациюОбУдаляемойРегистрации");
	КонецЦикла;

КонецПроцедуры
//))