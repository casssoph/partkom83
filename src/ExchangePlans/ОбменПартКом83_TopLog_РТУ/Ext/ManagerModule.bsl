﻿
Функция ПолучитьМетаданные() Экспорт	
	Возврат Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ; 
КонецФункции

Функция URIПространстваИмен() Экспорт 
	Возврат ПланыОбмена.ОбменПартКом83_TopLog.URIПространстваИмен();
КонецФункции

Функция ВыгрузитьСообщениеОбмена(вхИдентификаторУзлаОбмена, вхНомерПринятого) Экспорт
	
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
	
	// фиксируем номер принятого
	ПланыОбмена.УдалитьРегистрациюИзменений(лИсходящий, вхНомерПринятого);
	// возвращаем сообщение обмена
	
	//Перерегистрируем объекты у которых номер сообщения не NULL. Если их регистрация не затерлась выше, значит до ТопЛога данные объекты не доходили и у них нужно сбросить номер сообщения
	ПланыОбмена.ОбменПартКом83_TopLog.ПеререгистрироватьОбъектыВОбменеТопЛог(лИсходящий);
	
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
		лСообщениеОбмена.ПланОбмена = "ОбменПартКом83_TopLog_РТУ";
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
		
		МассивВыгруженныхСсылок = Новый Массив;
		
		Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты цикл
			лМенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лЭлементСоответствия.Ключ);
			лВыгруженныеОбъекты = лМенеджерОбъекта.ВыгрузитьЭлементы(лЭлементСоответствия.Значение, ПолучитьМетаданные(), МассивВыгруженныхСсылок);
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
		ЗаписатьИсториюОбменаПоОбъектам(МассивВыгруженныхСсылок, лЗаписьСообщения.НомерСообщения, Истина, ТекстОшибки);
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
		ЗаписатьИсториюОбменаПоОбъектам(МассивВыгруженныхСсылок, лСообщениеОбмена.НомерСообщения);
		
	КонецЕсли;
	
	//Семенов И.П. 07.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(НомерСообщения, лИсходящий, ТекстСообщения, Истина);
	//)Семенов И.П.
	
	Возврат ТекстСообщения;
	
КонецФункции

Процедура ЗаписатьИсториюОбменаПоОбъектам(лВыгружаемыеОбъекты, НомерСообщения, ЕстьОшибки = Ложь, ТекстОшибки = "", Период = Неопределено, Исходящее = Истина)
	
	лКлючАлгоритма = "Обработка_ОбменПартКом83_TopLog_РТУ_МодульМенеджера_ЗаписатьИсториюОбменаПоОбъектам";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);		
		Возврат;		
	КонецЕсли;	
	
	Если  ТипЗнч(лВыгружаемыеОбъекты) = Тип("Соответствие") Тогда
		
		Для Каждого лЭлементСоответствия Из лВыгружаемыеОбъекты Цикл
			
			ПолноеИмяМД = лЭлементСоответствия.Ключ.ПолноеИмя();
			
			Если СтрНайти(ПолноеИмяМД, "ПоступлениеТоваровУслуг") > 0 
				ИЛИ СтрНайти(ПолноеИмяМД, "РеализацияТоваровУслуг") > 0 
				Или СтрНайти(ПолноеИмяМД, "ПеремещениеТоваров") > 0 Тогда
				
				// "ВыгружаемыйОбъект" это ТЗ с колонкой "Ссылка"
				Для каждого ВыгружаемыйОбъект Из лЭлементСоответствия.Значение Цикл
					РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(ВыгружаемыйОбъект.Ссылка, НомерСообщения, ЕстьОшибки, ТекстОшибки, Период, Исходящее, 1);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
	//Валиахметов http://jira.part-kom.ru/browse/XX-2929 17.07.2019	
	ИначеЕсли ТипЗнч(лВыгружаемыеОбъекты) = Тип("Массив") Тогда 
		Для Каждого Ссылка Из лВыгружаемыеОбъекты Цикл 
			ПолноеИмяМД = Ссылка.Метаданные().ПолноеИмя();
			Если ОбъектФиксируетсяВИстории(ПолноеИмяМД) Тогда
				РегистрыСведений.ИсторияОбменаСТопЛогПоОбъектам.Добавить(Ссылка, НомерСообщения, ЕстьОшибки, ТекстОшибки, Период, Исходящее);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	//Конец Валиахметов http://jira.part-kom.ru/browse/XX-2929 17.07.2019	
КонецПроцедуры

//Валиахметов http://jira.part-kom.ru/browse/XX-2929 17.07.2019	
Функция ОбъектФиксируетсяВИстории(ПолноеИмяМД) Экспорт
	
	Фиксируется = Ложь;
	
	Если СтрНайти(ПолноеИмяМД, "ПоступлениеТоваровУслуг") > 0 
		ИЛИ СтрНайти(ПолноеИмяМД, "РеализацияТоваровУслуг") > 0 
		Или СтрНайти(ПолноеИмяМД, "ПеремещениеТоваров") > 0 Тогда
		Фиксируется = Истина;
	КонецЕсли;
	
	Возврат Фиксируется;
	
КонецФункции
//Конец Валиахметов http://jira.part-kom.ru/browse/XX-2929 17.07.2019	

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
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""ПланОбмена"".");
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""ПланОбмена"".";
	КонецЕсли;
	
	лПолучатель = ЭтотУзел();
	лИдентификаторОтправителя = лДанныеХДТО.Отправитель;
	лИдентификаторПолучателя = лДанныеХДТО.Получатель;
	Если (лИдентификаторПолучателя <> лПолучатель.ИдентификаторУзла) тогда
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, ПустаяСсылка(), вхСообщениеОбмена,,Истина,"Неправильное значение элемента ""Получатель"".");
		//)Семенов И.П.
		ВызватьИсключение "[ЗагрузитьСообщениеОбмена]: неправильное значение элемента ""Получатель"".";
	КонецЕсли;
	лВходящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), лИдентификаторОтправителя);
	Если НЕ ЗначениеЗаполнено(лВходящий) тогда
		//Семенов И.П. 07.02.2019 XX-1768(
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
			//Семенов И.П. 07.02.2019 XX-1768(
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
					лМенеджерОбъекта = ПланыОбмена.ОбменПартКом83_TopLog.МенеджерОбъектаПоИмениТипа(лТипОбъекта.Имя, лОбъект);
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
				СтруктураОшибки.Вставить("НомерПотока", лНомерПотока);
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
		СтруктураОшибки.Вставить("НомерПотока", лНомерПотока);
		ОбменДаннымиКлиентСервер.ЗаписатьОшибкиПриОбменеСТопЛог(СтруктураОшибки);
		//Семенов И.П. 07.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лВходящий, вхСообщениеОбмена,,Истина,СтруктураОшибки.СообщениеОбОшибке);
		//)Семенов И.П.
		лЧтениеСообщения.ПрерватьЧтение();
		ВызватьИсключение;
	КонецПопытки;
	//Семенов И.П. 07.02.2019 XX-1768(
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

Процедура ЗагрузитьУдалениеЭлемента(вхОбъектXDTO, вхОтправитель) Экспорт 
	
	//лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(вхОбъектXDTO.ТипОбъекта, вхОбъектXDTO);
	//
	//лСсылкаНаОбъект = лМенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Ссылка));
	//лОбъект = Новый УдалениеОбъекта(лСсылкаНаОбъект);
	//лОбъект.ОбменДанными.Загрузка = Истина;
	//лОбъект.ОбменДанными.Отправитель = вхОтправитель;
	//лОбъект.Записать();
	
КонецПроцедуры

Функция ТипПоОбъектуМетаданных(вхОбъектМетаданных) Экспорт
	
	Возврат ПланыОбмена.ОбменПартКом83_TopLog.ТипПоОбъектуМетаданных(вхОбъектМетаданных);
	
КонецФункции

Функция ВыгрузитьУдаленияЭлементов(вхМассивСсылок, вхОбъектМетаданных) Экспорт
	Возврат ПланыОбмена.ОбменПартКом83_TopLog.ВыгрузитьУдаленияЭлементов(вхМассивСсылок, вхОбъектМетаданных);	
КонецФункции