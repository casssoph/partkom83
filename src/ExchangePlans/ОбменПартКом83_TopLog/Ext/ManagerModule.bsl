﻿
Функция ПолучитьМетаданные() Экспорт	
	Возврат Метаданные.ПланыОбмена.ОбменПартКом83_TopLog;
КонецФункции

Функция URIПространстваИмен() Экспорт 
	Возврат "http://partkom83-TopLogExchangeScheme.ru";
КонецФункции

Функция ИмяТипаПоОбъектуМетаданных(вхОбъектМетаданных) 
	Возврат	ОбщегоНазначения.ИмяБазовогоТипаПоОбъектуМетаданных(вхОбъектМетаданных) + "." + вхОбъектМетаданных.Имя;
КонецФункции

Функция ИмяТипаПоСсылке(вхСсылкаНаОбъект)
	
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
		
		Возврат Вычислить("Документы." + СокрЛП(вхОбъект.ЗаказВидДокумента));
	ИначеЕсли вхИмяТипа = "ТранзитнаяОтгрузка"	Тогда 
		Возврат Документы.РеализацияТоваровУслуг;
	ИначеЕсли вхИмяТипа = "СменаВодителяСЗ"	Тогда 
		Возврат Документы.СлужебноеЗадание;
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
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьУдалениеЭлемента(вхОбъектXDTO, вхОтправитель)
	
	//лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(вхОбъектXDTO.ТипОбъекта, вхОбъектXDTO);
	//
	//лСсылкаНаОбъект = лМенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Ссылка));
	//лОбъект = Новый УдалениеОбъекта(лСсылкаНаОбъект);
	//лОбъект.ОбменДанными.Загрузка = Истина;
	//лОбъект.ОбменДанными.Отправитель = вхОтправитель;
	//лОбъект.Записать();
	
КонецПроцедуры

Процедура ЗагрузитьСообщениеОбмена(вхСообщениеОбмена) Экспорт
	
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен(), "УдалениеОбъекта");
	лЧтениеХМЛ = Новый ЧтениеXML;
	лЧтениеХМЛ.УстановитьСтроку(вхСообщениеОбмена);
	
	лДанныеХДТО = ФабрикаXDTO.ПрочитатьXML(лЧтениеХМЛ, лТипСообщениеОбмена);
	лИмяПланаОбмена = лДанныеХДТО.ПланОбмена;
	
	Если (лИмяПланаОбмена <> ПолучитьМетаданные().Имя) тогда
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""ПланОбмена"".";
	КонецЕсли;
	
	лПолучатель = ЭтотУзел();
	лИдентификаторОтправителя = лДанныеХДТО.Отправитель;
	лИдентификаторПолучателя = лДанныеХДТО.Получатель;
	Если (лИдентификаторПолучателя <> лПолучатель.ИдентификаторУзла) тогда
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""Получатель"".";
	КонецЕсли;
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: не найден отправитель сообщения в списке узлов.";	
	КонецЕсли;                                                                      		
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	Если ЗначениеЗаполнено(лИсходящий) тогда
		лНомерОтправленного = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лИсходящий, "НомерОтправленного");		
		Если (лДанныеХДТО.НомерПринятого > лНомерОтправленного) тогда
			ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""НомерПринятого"": сообщение с таким номером не отправлялось.";
		КонецЕсли;
		// фиксируем номер принятого
		ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, лДанныеХДТО.НомерПринятого);	
	КонецЕсли;
	
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
			
			НаборЗаписей = РегистрыСведений.ИсторияОбменаСТопЛог.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.НомерСообщения.Установить(лДанныеХДТО.НомерСообщения);
			НаборЗаписей.Отбор.Исходящее.Установить(Ложь);
			
			Стр = НаборЗаписей.Добавить();
			Стр.НомерСообщения = лДанныеХДТО.НомерСообщения;
			Стр.Сообщение = вхСообщениеОбмена;
			Стр.ДатаЗагрузкиСообщения = ТекущаяДата();
			
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
		
		лЧтениеСообщения.ПрерватьЧтение();
		ВызватьИсключение;
	КонецПопытки;
	
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

Функция ВыгрузитьСообщениеОбмена(вхИдентификаторУзлаОбмена) Экспорт

	лОтправитель = ЭтотУзел();
	лИсходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(лИсходящий) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	лНомерПринятого = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лВходящий, "НомерПринятого");
	
	лТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	лПустышка = Новый ЗаписьXML;
	лПустышка.УстановитьСтроку("utf-8");
	лЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	лЗаписьСообщения.НачатьЗапись(лПустышка, лИсходящий);
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
		
		Стр = НаборЗаписей.Добавить();
		Стр.НомерСообщения = лСообщениеОбмена.НомерСообщения;
		Стр.Сообщение = ТекстСообщения;
		Стр.ДатаЗагрузкиСообщения = ТекущаяДата();
		Стр.Исходящее = Истина;
		НаборЗаписей.Записать(Истина);
		
		//Запись об успешной выгрузке в историю обмена по объектам
		ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, лСообщениеОбмена.НомерСообщения);
		
	КонецЕсли;
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, НомерСообщения, ЕстьОшибки = Ложь, ТекстОшибки = "", Период = Неопределено, Исходящее = Истина)
	
	Если НЕ ТипЗнч(лВыгружаемыеОбъекты) = Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты Цикл
		
		ПолноеИмяМД = лЭлементСоответствия.Ключ.ПолноеИмя();
		
		Если СтрНайти(ПолноеИмяМД, "ПоступлениеТоваровУслуг") > 0 
			ИЛИ СтрНайти(ПолноеИмяМД, "РеализацияТоваровУслуг") > 0 
			Или СтрНайти(ПолноеИмяМД, "ПеремещениеТоваров") > 0 Тогда
			
			// "ВыгружаемыйОбъект" это ТЗ с колонкой "Ссылка"
			Для каждого ВыгружаемыйОбъект Из лЭлементСоответствия.Значение Цикл
				РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ВыгружаемыйОбъект.Ссылка, НомерСообщения, ЕстьОшибки, ТекстОшибки, Период, Исходящее);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
