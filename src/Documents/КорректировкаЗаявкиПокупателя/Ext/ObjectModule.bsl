﻿Перем мПроверкаПередПроведением Экспорт;

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, Режим)
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_ОбработкаПроведения";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
	
	//Перем вхПараметры;
	 ПроведениеДокументовКлиентСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	 
	 //ДополнительныеСвойства.Свойство("вхПараметры", вхПараметры);
	Документы.КорректировкаЗаявкиПокупателя.ВыполнитьПроведение(Ссылка, Отказ);
	РегистрыСведений.ДокументыКорректировок.УстановитьКорректировку(Движения.ДокументыКорректировок, Ссылка.ДокументОснование, Ссылка);
	
	СформироватьСписокРегистровДляКонтроля();	
	ПроведениеДокументовКлиентСервер.ВыполнитьКонтрольРезультатовПроведения(ЭтотОбъект,Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_ОбработкаУдаленияПроведения";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
	
	РазрешенаОтменаПроведения = (Дата < глЗначениеПеременной("ДатаЗаявкиСоздаютсяВ83"))
								ИЛИ ДополнительныеСвойства.Свойство("ВыполнитьУдалениеПроведения"); //Семенов И.П. 28.12.2018
								
	Если РазрешенаОтменаПроведения ИЛИ Ссылка = Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка) 
		Или СтатусДокумента <> Справочники.СтатусыДокументов.ЗаявкаПокупателяПодтвержден Тогда 
		Документы.КорректировкаЗаявкиПокупателя.ВыполнитьОтменуПроведения(Ссылка, Отказ);
	Иначе
		ВызватьИсключение "Распроведение данной корректировки заявки запрещено";
	КонецЕсли;

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_ПередЗаписью";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
	
	Если ЭтотОбъект.ДополнительныеСвойства.Свойство("мЗаписьБезОбработки") Тогда 
		Возврат;
	КонецЕсли;

	ОбщегоНазначения.УдалитьДвиженияПриПометкеУдаления(ЭтотОбъект, РежимЗаписи);
	
	Документы.КорректировкаЗаявкиПокупателя.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);	
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоНовый() и  не РольДоступна("ПолныеПрава") Тогда 
		Если РежимЗаписи=РежимЗаписиДокумента.Проведение Или  РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения Тогда 
			Если Ссылка <> Документы.ЗаявкаПокупателя.ПолучитьПоследнийДокументКорректировки(Ссылка) Тогда  
				Сообщить("Нельзя изменять состояние проведения промежуточных корректировок!");
				Отказ=Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_ПриКопировании";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
	//ВызватьИсключение "Корректировка не является самостоятельным документом и не может быть скопирована";
	СозданВ77 = Ложь;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_ПриЗаписи";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
	Документы.КорректировкаЗаявкиПокупателя.ПриЗаписи(ЭтотОбъект, Отказ);
КонецПроцедуры

#КонецОбласти


#Область Контроль

Процедура СформироватьСписокРегистровДляКонтроля()
	 лКлючАлгоритма = "Документ_КорректировкаЗаявкиПокупателя_МодульОбъекта_СформироватьСписокРегистровДляКонтроля";
	 лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	 Если Не лЗамена = Неопределено Тогда
	 	Выполнить(лЗамена);
	 	Возврат;
	 КонецЕсли;
	 //////////////////////////////////////////////////////////////////////////
//# Kalinin V.A. ( 2019-01-23 )
// Если какой нибуть хороший человек перепишет весь этот говнокод в проведении и сделает БСП-ое , 
//я его расцелую и пожму героически руку, тогда этот код можно будет снести  и заменить БСП-м 
	СтуктураКОнтроля = Новый Структура;
	
	Если Не ДополнительныеСвойства.ЭтоНовый Тогда
			СтуктураКОнтроля.Вставить("РезервыТоваров",Движения.РезервыТоваров);
	КонецЕсли;
		
	ДополнительныеСвойства.ДляПроведения.Вставить("РегистрыДляКонтроля", СтуктураКонтроля);
КонецПроцедуры


#КонецОбласти


мПроверкаПередПроведением = Ложь;
 