﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ПриСозданииНаСервере";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	НеОграничиватьПериодВФормахСписков = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),
	"НеОграничиватьПериодВФормахСписков");
	
	Если НеОграничиватьПериодВФормахСписков = Ложь Тогда
		ОбщегоНазначения.УстановитьПериодДинамическогоСпискаПоУмолчанию(Элементы.Список);
	КонецЕсли;
	
	МассивЗапрещенныхПолейГруппировки = Новый Массив;
	Для каждого ЭлГруппировки ИЗ Список.КомпоновщикНастроек.Настройки.ДоступныеПоляГруппировок.Элементы Цикл
		МассивЗапрещенныхПолейГруппировки.Добавить(Строка(ЭлГруппировки.Поле));
	КонецЦикла;
	Список.УстановитьОграниченияИспользованияВГруппировке(МассивЗапрещенныхПолейГруппировки);
	
	МассивЗапрещенныхПолейПорядка = Новый Массив;
	Для каждого ЭлПорядка ИЗ Список.КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.Элементы Цикл
		МассивЗапрещенныхПолейПорядка.Добавить(Строка(ЭлПорядка.Поле));
	КонецЦикла;
	Список.УстановитьОграниченияИспользованияВПорядке(МассивЗапрещенныхПолейПорядка);
	
КонецПроцедуры


&НаКлиенте
Процедура СтруктураПодчиненности(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_СтруктураПодчиненности";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		//РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Элементы.Список.ТекущаяСтрока));
		РаботаСДиалогами.ПоказатьСтруктуруПодчиненностиДокумента(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДвиженияДокумента(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ДвиженияДокумента";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ОткрытьФорму("Отчет.ОтчетПоДвижениямДокумента.Форма", Новый Структура("Документ,СпособВыводаОтчета", Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Элементы.Список.ТекущаяСтрока), "ПоВертикали"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияДокумента(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ИсторияДокумента";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ФормаСравненияКорректировок = Обработки.ИсторияДокумента.ПолучитьФорму("ФормаСравненияКорректировок");
		ФормаСравненияКорректировок.Документ = Элементы.Список.ТекущаяСтрока;
		ФормаСравненияКорректировок.ТолькоИзменения = Истина;
		ФормаСравненияКорректировок.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_РучнойВвод";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
форм=Документы.ПоступлениеТоваровУслуг.ПолучитьФорму("РучнойВвод");
	Форм.Открыть();
	// Вставить содержимое обработчика.
КонецПроцедуры

	
&НаКлиенте
Процедура ПоискПоНомеру(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ПоискПоНомеру";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Номер = "";
	Если Не ВвестиЗначение(Номер, "Введите номер поступления", Новый ОписаниеТипов("Строка",,,, Новый КвалификаторыСтроки(11, ДопустимаяДлина.Фиксированная))) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрДлина(Номер) < 11 Тогда 
		Номер=Лев(Номер,4)+"0"+Сред(Номер,5);
	КонецЕсли;	
	
	Если СтрДлина(Номер) < 11 Тогда 
		Предупреждение("Введите 11-значный номер", 5);
		Возврат;
	КонецЕсли;
	
	ИскомыйЭлементОтбора = Неопределено;
	   УстановитьСнятьОтборПоПолюФормы("Номер",Номер);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьОтборПоПолюФормы (ИмяПоля, Значение = Неопределено, Использование = истина)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_УстановитьСнятьОтборПоПолюФормы";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	Для Каждого ЭлтОтбора Из Список.КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл 
		Если ТипЗнч(ЭлтОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") И ЭлтОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля) Тогда
			ИскомыйЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Найти(ЭлтОтбора.ИдентификаторПользовательскойНастройки);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ИскомыйЭлементОтбора = Неопределено Тогда 
		ИскомыйЭлементОтбора = Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ИскомыйЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ИмяПоля);
	КонецЕсли;
	
	ИскомыйЭлементОтбора.ПравоеЗначение = Значение;
	ИскомыйЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ИскомыйЭлементОтбора.Использование = Использование;
	Для Каждого Стр Из Список.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Попытка
			Для Каждого СТРР Из Стр.Элементы Цикл
				СТРР.Использование=ЛОжь;
			КонецЦикла;
		Исключение
		КонецПопытки;	
	КонецЦикла;	
КонецПроцедуры
	



&НаКлиенте
Процедура ОтменитьПоискПоНомеру(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ОтменитьПоискПоНомеру";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	  УстановитьСнятьОтборПоПолюФормы("Номер",,Ложь);
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьВТопЛогНаСервере(ДокСсылка)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ВыгрузитьВТопЛогНаСервере";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	//мПолныеПрава = РольДоступна("ПолныеПрава");
	//
	//Если ДокСсылка <> Неопределено Тогда 
	//	
	//	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокСсылка, "СтатусДокумента,Проведен,ЭтоМФП,ВидОперацииПоступления,Склад,флНеВыгружатьВТопЛог,Склад.ОбменСTopLog");
	//	
	//	ОтказОтРегистрации = 
	//	
	//	Не Реквизиты.Проведен 
	//	Или Реквизиты.ЭтоМФП Или Реквизиты.ВидОперацииПоступления = Перечисления.ВидыПоступленияТоваров.ЗачетТовараVMI ИЛИ 
	//	Реквизиты.ВидОперацииПоступления = Перечисления.ВидыПоступленияТоваров.Прочее ИЛИ Не (Реквизиты.СтатусДокумента =  Справочники.СтатусыДокументов.ПоступлениеТоваровОтгружен Или
	//	Реквизиты.СтатусДокумента =  Справочники.СтатусыДокументов.ПоступлениеТоваровДоставлен Или (мПолныеПрава И Реквизиты.СтатусДокумента <> Справочники.СтатусыДокументов.ПоступлениеТоваровНовый)) ИЛИ 
	//	Реквизиты.флНеВыгружатьВТопЛог Или
	//	Реквизиты.СкладОбменСTopLog <> Истина;
	//	
	//	Если Не ОтказОтРегистрации Тогда  
	//		Узел = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_TopLog, 3);
	//		Если ЗначениеЗаполнено(Узел) Тогда 
	//			ПланыОбмена.ЗарегистрироватьИзменения(Узел, ДокСсылка);
	//			Сообщить("Документ зарегистрирован в обмене с Топ Лог");
	//		Иначе
	//			Сообщить("Не найден узел обмена для выгрузки в Топ Лог");
	//		КонецЕсли;
	//	Иначе
	//		Сообщить("Документ нельзя выгружать. Выгружаются только проведенные документы в статусе ""Отгружен"" или ""Доставлен на склад"", 
	//		|не МФП, не Зачет VMI, без галки не выгружать в ТопЛог, только для складов, которые обмениваются с ТопЛог");
	//		Если мПолныеПрава Тогда 
	//			Сообщить("Для полных прав нет проверки на статус документа (кроме статуса ""Новый"")");
	//		КонецЕсли;
	//	КонецЕсли;
	//КонецЕсли;
	
	Если ДокСсылка <> Неопределено Тогда 
		ПопыткаРегистрации = ДокСсылка.ПолучитьОбъект().ВыгрузитьВОбменТоплог();
		Сообщить(ПопыткаРегистрации.СообщениеДиагностики);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВТопЛог(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ВыгрузитьВТопЛог";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	
	Ответ = Вопрос("Хотите выгрузить этот документ в ТопЛог?", РежимДиалогаВопрос.ДаНет);
	Если Ответ = КодВозвратаДиалога.Да Тогда 	
		ВыгрузитьВТопЛогНаСервере(Элементы.Список.ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_ПриОткрытии";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////////////////////////////////////
	
	
	// ЛНА, Альтернатива проблемной форме
	//Если ЗначениеЗаполнено(ПараметрыСеанса.ТекущийПользователь) 
	//	И ПараметрыСеанса.ТекущийПользователь.ОтладкаФормы = Истина Тогда
	//	Отказ = Истина;
	//	
	//	ПолучитьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаСписка").Открыть();
	//КонецЕсли;
	
	// Вываливается ошибка
	
	//ХудинВВ 27032019 XX-2098
	ИспользоватьРасширенныеФормыСписков = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"),
	"ИспользоватьРасширенныеФормыСписков");
	Если ИспользоватьРасширенныеФормыСписков = Истина Тогда
		ОткрытьФорму("Документ.ПоступлениеТоваровУслуг.Форма.ФормаСпискаУпр");
		ЭтаФорма.Закрыть();
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура РеестрПТУ(Команда)
	лКлючАлгоритма = "Документ_ПоступлениеТоваровУслуг_ФормаСпискаУпрОграниченная_РеестрПТУ";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	///////////////////////////////////////////
	
	ОткрытьФорму("Отчет.РеестрПТУ.Форма");
	
КонецПроцедуры


#КонецОбласти

 