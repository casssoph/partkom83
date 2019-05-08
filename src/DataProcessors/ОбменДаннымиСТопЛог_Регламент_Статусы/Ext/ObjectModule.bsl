﻿
//#Если Сервер тогда
	
	Перем мАдресВебСервиса;
	
	Процедура ВыполнитьРегламентноеЗадание() Экспорт
		
		//Если НЕ ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() тогда
			//ВызватьИсключение "Данная операция выполняется только в рабочей информационной базе.";		
		//КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ИдентификаторУзлаОбмена) тогда
			ВызватьИсключение "Не заполнен реквизит ""Узел обмена"".";		
		КонецЕсли;
		
		// 21.03.19 Строганов Роман > 
		URIПространстваИмен = ПланыОбмена.ОбменПартКом83_TopLog_РТУ.URIПространстваИмен();
		// 21.03.19 Строганов Роман <
		
		//Семенов И.П. 07.02.2019 XX-1768(
		Попытка
		//)Семенов И.П.
			лМетаданныеПланаОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ;
			лМенеджерПланаОбмена = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(лМетаданныеПланаОбмена);
			
			лПолучатель = лМенеджерПланаОбмена.ЭтотУзел();
			лКодПолучателя = Число(лПолучатель.ИдентификаторУзла);
			
			лОтправитель = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(лМетаданныеПланаОбмена, ИдентификаторУзлаОбмена);
			лКодОтправителя = лОтправитель.ИдентификаторУзла;
			лНомерПринятого = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(лОтправитель, "НомерПринятого");
			
			
			лОпределения = Новый WSОпределения(мАдресВебСервиса);
			лПрокси = Новый WSПрокси(лОпределения, лОпределения.Сервисы[0].URIПространстваИмен,
			лОпределения.Сервисы[0].Имя, лОпределения.Сервисы[0].ТочкиПодключения[0].Имя);
			
			лОтветСервера = лПрокси.GetExchangeMessage(лМетаданныеПланаОбмена.Имя, лКодПолучателя, лНомерПринятого);
			
			лСообщениеОбмена = лОтветСервера;
			ТекстСообщения = лОтветСервера;
			
			// без этого на сервере не работает почему то
			лТекстовыйДокумент = Новый ТекстовыйДокумент;
			лТекстовыйДокумент.УстановитьТекст(лСообщениеОбмена);
			лСообщениеОбмена = лТекстовыйДокумент.ПолучитьТекст();
		//Семенов И.П. 07.02.2019 XX-1768(
		Исключение
		    ТекстОшибки = ОписаниеОшибки();
		   	ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(0,ПланыОбмена.ОбменПартКом83_TopLog_РТУ.ПустаяСсылка(),"",,Истина,ТекстОшибки);
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
		//)Семенов И.П.
		
		// 06.05.19 Строганов Роман > 
		НоваяСхемаОбмена = РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен (Общее)", "Новая схема обмена с ТопЛог (РТУ)");
		
		Если НоваяСхемаОбмена = Истина Тогда
			
			лТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен, "СообщениеОбмена");
			лТипУдалениеОбъекта = ФабрикаXDTO.Тип(URIПространстваИмен, "УдалениеОбъекта");
			лЧтениеХМЛ = Новый ЧтениеXML;
			лЧтениеХМЛ.УстановитьСтроку(лСообщениеОбмена);
			
			лДанныеХДТО = ФабрикаXDTO.ПрочитатьXML(лЧтениеХМЛ, лТипСообщениеОбмена);
			ОбъектыXDTO = лДанныеХДТО.Объекты.ПолучитьСписок("Объект");
			
			ДатаСообщения = Неопределено; 
			НомерСообщения = лДанныеХДТО.НомерСообщения;
			
			ОбменССайтомСервер.РазобратьПолученныеОбъекты(ОбъектыXDTO, НомерСообщения, "ОбменПартКом83_TopLog", ЧислоПотоков, ДатаСообщения);
			
			лОтправитель = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена("ОбменПартКом83_TopLog", ИдентификаторУзлаОбмена);
			ОбменДаннымиКлиентСервер.ЗафиксироватьСообщениеВИсторииОбмена(лДанныеХДТО.НомерСообщения, лОтправитель, лСообщениеОбмена,,,,ДатаСообщения, ОбъектыXDTO.Количество());
		Иначе
			лМенеджерПланаОбмена.ЗагрузитьСообщениеОбмена(лСообщениеОбмена);
		КонецЕсли;
		// 06.05.19 Строганов Роман <
		
		лУпаковщик = Неопределено;
		
	КонецПроцедуры
	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда 
		мАдресВебСервиса = Справочники.НастройкиРеквизитовДляОбменов.Обмен_1С_ТопЛог.СтрокаДляРабочейБазы;
	Иначе
		мАдресВебСервиса = Справочники.НастройкиРеквизитовДляОбменов.Обмен_1С_ТопЛог.СтрокаДляТестовойБазы;
	КонецЕсли;
	
//#КонецЕсли
