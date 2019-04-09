﻿Процедура ЗагрузитьСообщениеОбмена(СписокОбъектов, ИдентификаторОтправителя, ИдентификаторПолучателя, НомерСообщения) Экспорт
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_ОкноПоставщика_ЗагрузитьСообщениеОбмена";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	
	МетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика;
	
	Получатель = ПланыОбмена.ОбменПартКом83_ОкноПоставщика.ЭтотУзел();
	Входящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(МетаданныеПланаОбмена, ИдентификаторОтправителя);
	Исходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(МетаданныеПланаОбмена, ИдентификаторОтправителя);

	ТекстШаблона = ПолучитьОбщийМакет("ЗаголовокСообщенияОбмена").ПолучитьТекст();
	ТекстПустышки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстШаблона, МетаданныеПланаОбмена.Имя, Получатель.Код,
																			Входящий.Код, Формат(НомерСообщения, "ЧГ="), "0");
	
	Пустышка = Новый ЧтениеXML;
	Пустышка.УстановитьСтроку(ТекстПустышки);
	
	Отказ = Ложь;
	МассивДокументов = Новый Массив;
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	ЧтениеСообщения.НачатьЧтение(Пустышка, ДопустимыйНомерСообщения.Больший);
	
	Для Каждого Объект Из СписокОбъектов цикл
		ТипОбъекта = Объект.Тип();
		МенеджерОбъекта = МенеджерОбъектаПоИмениТипа(ТипОбъекта.Имя);
		МенеджерОбъекта.ЗагрузитьЭлемент(Объект, Исходящий, Отказ, МассивДокументов, НомерСообщения);
	КонецЦикла;
	
	ЧтениеСообщения.ЗакончитьЧтение();// Записывает номер принятого сообщения
	
	DataExchangeModule.ОтметитьОтправкуОбъектов(МассивДокументов, Перечисления.ВидыОбменов.ОбменОП_1С, НомерСообщения);
	
КонецПроцедуры

Процедура ЗагрузитьСообщениеОбмена_Новое() Экспорт
	ОбменССайтомСервер.ПолучитьДанныеССайта(ЭтотУзел(),"ОбменПартКом83_ОкноПоставщика");	
	
КонецПроцедуры

#Область Обработка
Процедура ОбработатьОбъекты() Экспорт
 ОбменССайтомСервер.ОбработатьОбъектыОбмена(ЭтотУзел());
		
КонецПроцедуры
#КонецОбласти




Функция ПолучитьМетаданные()
	Возврат Метаданные.ПланыОбмена.ОбменПартКом83_ОкноПоставщика;
КонецФункции
Функция URIПространстваИмен() Экспорт
	Возврат "http://ws-02.part-kom.ru/partkom83/hs/SiteExchange/XMLSchema";	
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
Функция МенеджерОбъектаПоИмениТипа(ИмяТипа)
	
	МенеджерОбъекта = Вычислить(ИмяТипа);
	Возврат МенеджерОбъекта;
	
КонецФункции


Процедура ЗагрузитьУдалениеЭлемента(вхОбъектXDTO, вхОтправитель)
	
	лМенеджерОбъекта = МенеджерОбъектаПоИмениТипа(вхОбъектXDTO.ТипОбъекта);
	
	лСсылкаНаОбъект = лМенеджерОбъекта.ПолучитьСсылку(Новый УникальныйИдентификатор(вхОбъектXDTO.Ссылка));
	лОбъект = Новый УдалениеОбъекта(лСсылкаНаОбъект);
	лОбъект.ОбменДанными.Загрузка = Истина;
	лОбъект.ОбменДанными.Отправитель = вхОтправитель;
	лОбъект.Записать();
	
КонецПроцедуры

Функция ВыгрузитьСообщениеОбмена(вхИдентификаторУзлаОбмена, НомерПринятого, НеСжиматьСообщение = Ложь) Экспорт
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_ОкноПоставщика_ВыгрузитьСообщениеОбмена";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Отправитель = ЭтотУзел();
	Исходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(Исходящий) тогда
		//Семенов И.П. 04.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,ПланыОбмена.ОбменПартКом83_ОкноПоставщика.ПустаяСсылка(),"",Истина,Истина,"[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.");
		//)Семенов И.П.
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	Входящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(Входящий) тогда
		//Семенов И.П. 04.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,ПланыОбмена.ОбменПартКом83_ОкноПоставщика.ПустаяСсылка(),"",Истина,Истина,"[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.");
		//)Семенов И.П.
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	НомерПринятого = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Входящий, "НомерПринятого");
	
	РегистрироватьВыгрузкуОбъектов = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-ОП","Регистрировать выгрузку объектов", Ложь);
	
	ТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	ТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	Пустышка = Новый ЗаписьXML;
	Пустышка.УстановитьСтроку("utf-8");
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьСообщения.НачатьЗапись(Пустышка, Исходящий);
	ЕстьОбъектыОбмена = Ложь;
	//Семенов И.П. 04.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.НачатьЗаписьВИсториюОбменовПоОбъектам();
	//)Семенов И.П.
	Попытка
		
		СообщениеОбмена = ФабрикаXDTO.Создать(ТипСообщениеОбмена);
		СообщениеОбмена.ПланОбмена = "ОбменПартКом83_ОкноПоставщика";
		СообщениеОбмена.Отправитель = Отправитель.ИдентификаторУзла;
		СообщениеОбмена.Получатель = вхИдентификаторУзлаОбмена;
		СообщениеОбмена.НомерСообщения = ЗаписьСообщения.НомерСообщения;
		СообщениеОбмена.НомерПринятого = НомерПринятого;
				
		Объекты = ФабрикаXDTO.Создать(ТипОбъекты);
		СписокОбъектов = Объекты.ПолучитьСписок("Объект");
		ОбъектыРегистрации = Новый Массив;
		
		ВыгружаемыеОбъекты = ОбменДаннымиКлиентСервер.ВыбратьПакетИзмененийДляУзлаОбмена(Исходящий, СообщениеОбмена.НомерСообщения, 1000);
		Для Каждого ЭлементСоответствия Из ВыгружаемыеОбъекты цикл
			
			//ХудинВВ XX-896
			УдалитьНевыгружаемыеОбъекты(Исходящий, ЭлементСоответствия);
			
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(ЭлементСоответствия.Ключ);
			ВыгруженныеОбъекты = МенеджерОбъекта.ВыгрузитьЭлементы(ЭлементСоответствия.Значение, ПолучитьМетаданные());
			Для Каждого ВыгруженныйОбъект Из ВыгруженныеОбъекты цикл
				СписокОбъектов.Добавить(ВыгруженныйОбъект);
			КонецЦикла;
			
			Если РегистрироватьВыгрузкуОбъектов Тогда
				ДобавитьЗарегистрированныеОбъекты(ОбъектыРегистрации, ЭлементСоответствия.Значение);
			КонецЕсли;
		КонецЦикла;
		
		Если РегистрироватьВыгрузкуОбъектов Тогда
			DataExchangeModule.ОтметитьОтправкуОбъектов(ОбъектыРегистрации, Перечисления.ВидыОбменов.Обмен1C_ОП, ЗаписьСообщения.НомерСообщения);
		КонецЕсли;
		
		ЕстьОбъектыОбмена = СписокОбъектов.Количество() > 0;
		
		СообщениеОбмена.Объекты = Объекты;
		ЗаписьСообщения.ЗакончитьЗапись();
		
	Исключение
		ЗаписьСообщения.ПрерватьЗапись();
		//Семенов И.П. 04.02.2019 XX-1768(
		ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(ЗаписьСообщения.НомерСообщения,Исходящий,"",Истина,Истина,ОписаниеОшибки());
		//)Семенов И.П.
		ВызватьИсключение ;
	КонецПопытки;
	
	ЗаписьХМЛ = Новый ЗаписьXML;
	ЗаписьХМЛ.УстановитьСтроку("utf-8");
	ЗаписьХМЛ.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьХМЛ, СообщениеОбмена);
	
	НесжатоеСообщение = ЗаписьХМЛ.Закрыть();
	УпакованноеСообщение = ОбщегоНазначенияВызовСервера.ЗапаковатьСообщение(НесжатоеСообщение);
	Если ЕстьОбъектыОбмена Тогда
		ОбменДаннымиВызовСервера.ЗарегистрироватьСообщениеВИсторииОбменаССайтом(ПланыОбмена.ОбменПартКом83_ОкноПоставщика.ЭтотУзел().ИдентификаторУзла, вхИдентификаторУзлаОбмена, УпакованноеСообщение, НомерПринятого); 
	КонецЕсли;
	
	//Семенов И.П. 04.02.2019 XX-1768(
	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(СообщениеОбмена.НомерСообщения,Исходящий,НесжатоеСообщение,Истина);
	//)Семенов И.П.
	
	Возврат ?(НеСжиматьСообщение, НесжатоеСообщение, УпакованноеСообщение);
	
КонецФункции
Функция ВыгрузитьУдаленияЭлементов(вхМассивСсылок, вхОбъектМетаданных) Экспорт
	
	лИмяТипа = ИмяТипаПоОбъектуМетаданных(вхОбъектМетаданных);
	лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен(), "УдалениеОбъекта");
	
	Результат = Новый Массив;
	
	Для Каждого лСсылкаНаОбъект Из вхМассивСсылок цикл
		
		лОбъект = ФабрикаXDTO.Создать(лТипУдалениеОбъекта);
		лОбъект.ТипОбъекта = лИмяТипа;
		лОбъект.Ссылка = лСсылкаНаОбъект.УникальныйИдентификатор();
		Результат.Добавить(лОбъект);
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
Процедура ДобавитьЗарегистрированныеОбъекты(Массив, ТаблицаОбъектов)
	
	Если ТаблицаОбъектов.Количество() > 0 И ТаблицаОбъектов.Колонки.Найти("Ссылка") <> Неопределено Тогда
		Для Каждого Строка Из ТаблицаОбъектов Цикл
			Массив.Добавить(Строка.Ссылка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

//ХудинВВ XX-896 костыль от 22032019
//Происходит лишняя регистрация к обмену Заказов поставщику 
//Исключим такие документы
Процедура УдалитьНевыгружаемыеОбъекты(УзелОбмена, ЭлементСоответствия)
	
	лКлючАлгоритма = "ПланОбмена_ОбменПартКом83_ОкноПоставщика_УдалитьНевыгружаемыеОбъекты";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если НЕ ЭлементСоответствия.Ключ = Метаданные.Документы.ЗаказПоставщику Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(УзелОбмена) ТОгда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Данные.Ссылка
	               |ПОМЕСТИТЬ втСсылки
	               |ИЗ
	               |	&Данные КАК Данные
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЗаказПоставщику.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ втЗаказы
	               |ИЗ
	               |	Документ.ЗаказПоставщику КАК ЗаказПоставщику
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втСсылки КАК втСсылки
	               |		ПО ЗаказПоставщику.Ссылка = втСсылки.Ссылка
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ЗаказПоставщику.Ссылка КАК Ссылка,
	               |	ЕСТЬNULL(КорректировкаЗаказаПоставщику.Ссылка.Контрагент.РаботатьСОкномПоставщика, ЗаказПоставщику.Ссылка.Контрагент.РаботатьСОкномПоставщика) КАК РаботатьСОкномПоставщика
	               |ПОМЕСТИТЬ втЗаказыСПризнаком
	               |ИЗ
	               |	втЗаказы КАК ЗаказПоставщику
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаЗаказаПоставщику КАК КорректировкаЗаказаПоставщику
	               |		ПО ЗаказПоставщику.Ссылка = КорректировкаЗаказаПоставщику.ДокументОснование
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	втЗаказыСПризнаком.Ссылка
	               |ИЗ
	               |	втЗаказыСПризнаком КАК втЗаказыСПризнаком
	               |ГДЕ
	               |	втЗаказыСПризнаком.РаботатьСОкномПоставщика
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	втЗаказыСПризнаком.Ссылка,
	               |	втЗаказыСПризнаком.Ссылка.Представление КАК Представление
	               |ИЗ
	               |	втЗаказыСПризнаком КАК втЗаказыСПризнаком
	               |ГДЕ
	               |	НЕ втЗаказыСПризнаком.РаботатьСОкномПоставщика";
	
	Запрос.УстановитьПараметр("Данные", ЭлементСоответствия.Значение);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ОбъектыВыгружать 	= Результаты[Результаты.Количество() - 2].Выгрузить();
	ОбъектыНЕВыгружать 	= Результаты[Результаты.Количество() - 1].Выгрузить();

	//Оставляем только разрешенные к выгрузке объекты
	ЭлементСоответствия.Значение.Очистить();
	Для каждого СтрокаВыгружать ИЗ ОбъектыВыгружать Цикл
		  ЗаполнитьЗначенияСвойств(ЭлементСоответствия.Значение.Добавить(), СтрокаВыгружать)
	КонецЦикла;
	
	//У остальных снимаем регистрацию	
	СтрокаСообщения = "Снята регистрация у документов:";
	Для каждого СтрокаНеВыгружать ИЗ ОбъектыНЕВыгружать Цикл
		
		СтрокаСообщения = СтрокаСообщения +Символы.ПС+СтрокаНеВыгружать.Представление;
		
		ПланыОбмена.УдалитьРегистрациюИзменений(УзелОбмена, СтрокаНеВыгружать.Ссылка);
		
	КонецЦикла;
	
	Если ОбъектыНЕВыгружать.Количество() > 0 Тогда
		
		КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(
		, 
		Справочники.СобытияДляОтправкиЭлектронныхПисем.СнятиеРегистрацииЗаказовДляОП,
		"Снята регистрация у документов зарегистрированных, но не подлежащих выгрузке в ОП",
		,
		Истина,
		СтрокаСообщения,
		"ПланОбмена_ОбменПартКом83_ОкноПоставщика_УдалитьНевыгружаемыеОбъекты");
		
	КонецЕсли;
	
КонецПроцедуры
