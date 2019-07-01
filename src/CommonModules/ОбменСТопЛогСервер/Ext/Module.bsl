﻿//Валиахметов http://jira.part-kom.ru/browse/XX-2790 01.01.2019 
Процедура ИницилизироватьДействияНадОбъектом(вхПараметры) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ОбменСТопЛогСервер_ИницилизироватьДействияНадОбъектом";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;

	Если ВключеноОтслеживаниеДействийНадОбъектами() Тогда 
		Если вхПараметры = Неопределено Тогда 
			вхПараметры = Новый Структура;
		КонецЕсли;
		
		Если Не вхПараметры.Свойство("ДействияНадОбъектом") Тогда 
			ДействияНадОбъектом = Новый Структура("БылоПроведение, Успешно", Ложь, Ложь);
			вхПараметры.Вставить("ДействияНадОбъектом", ДействияНадОбъектом);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьПризнакНаличияПроведения(вхПараметры) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ОбменСТопЛогСервер_УстановитьПризнакНаличияПроведения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	Если ВключеноОтслеживаниеДействийНадОбъектами() Тогда 
		ИницилизироватьДействияНадОбъектом(вхПараметры);

		вхПараметры.ДействияНадОбъектом.Вставить("БылоПроведение", Истина);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьПризнакУспешногоПроведения(вхПараметры) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ОбменСТопЛогСервер_УстановитьПризнакУспешногоПроведения";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;

	Если ВключеноОтслеживаниеДействийНадОбъектами() Тогда 
		ИницилизироватьДействияНадОбъектом(вхПараметры);

		вхПараметры.ДействияНадОбъектом.Вставить("Успешно", Истина);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьДействияНадОбъектом(вхПараметры, ДокументСсылка, ОписаниеОшибки, ПроцедураВызова) Экспорт 
	лКлючАлгоритма = "ОбщийМодуль_ОбменСТопЛогСервер_ОбработатьДействияНадОбъектом";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;
	
	Если ВключеноОтслеживаниеДействийНадОбъектами() Тогда 
		БылоПроведение = Неопределено;
		Успешно = Неопределено;
		
		ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДействияНадОбъектом.БылоПроведение", БылоПроведение);
		ПроведениеДокументовКлиентСервер.ПрочитатьЗначение(вхПараметры, "ДействияНадОбъектом.Успешно", Успешно);
		
		Если БылоПроведение = Истина И Успешно = Ложь Тогда 
			МестоВозникновения = "Документ." + ДокументСсылка.Метаданные().Имя + ".МодульМенеджера." + ПроцедураВызова;
			КритическиеСобытияСервер.ЗарегистрироватьКритическоеСобытие(
			ДокументСсылка, 
			Справочники.СобытияДляОтправкиЭлектронныхПисем.ОшибкаПроведенияПриЗагрузкеИзТопЛог,
			ОписаниеОшибки,
			,
			Истина,
			ОписаниеОшибки, 
			МестоВозникновения
			);
		КонецЕсли; 
	КонецЕсли;	
КонецПроцедуры

Функция ВключеноОтслеживаниеДействийНадОбъектами() 
	Возврат ЭтоАктивнаяЗадачаJirа(Справочники.ЗадачиJira.XX2790);
КонецФункции
				
//Конец Валиахметов http://jira.part-kom.ru/browse/XX-2790 01.01.2019 
	