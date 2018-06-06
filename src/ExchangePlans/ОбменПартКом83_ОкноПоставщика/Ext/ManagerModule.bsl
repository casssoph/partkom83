﻿Функция ПолучитьМетаданные()
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
Процедура ЗагрузитьСообщениеОбмена(СписокОбъектов, ИдентификаторОтправителя, ИдентификаторПолучателя, НомерСообщения) Экспорт
	
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
	ЧтениеСообщения = ПланыОбмена.СоздатьЧтениеСообщения();
	ЧтениеСообщения.НачатьЧтение(Пустышка, ДопустимыйНомерСообщения.Больший);
	
	Для Каждого Объект Из СписокОбъектов цикл
		ТипОбъекта = Объект.Тип();
		МенеджерОбъекта = МенеджерОбъектаПоИмениТипа(ТипОбъекта.Имя);
		МенеджерОбъекта.ЗагрузитьЭлемент(Объект, Исходящий, Отказ);
	КонецЦикла;
	
	ЧтениеСообщения.ЗакончитьЧтение();// Записывает номер принятого сообщения
	
КонецПроцедуры

Функция ВыгрузитьСообщениеОбмена(вхИдентификаторУзлаОбмена, НомерПринятого) Экспорт
	
	Отправитель = ЭтотУзел();
	Исходящий = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(Исходящий) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	
	Входящий = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), вхИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(Входящий) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена]: неправильный параметр номер 1.";	
	КонецЕсли;
	НомерПринятого = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Входящий, "НомерПринятого");
	
	ТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	ТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	Пустышка = Новый ЗаписьXML;
	Пустышка.УстановитьСтроку("utf-8");
	ЗаписьСообщения = ПланыОбмена.СоздатьЗаписьСообщения();
	ЗаписьСообщения.НачатьЗапись(Пустышка, Исходящий);
	Попытка
		
		СообщениеОбмена = ФабрикаXDTO.Создать(ТипСообщениеОбмена);
		СообщениеОбмена.ПланОбмена = "ОбменПартКом83_ОкноПоставщика";
		СообщениеОбмена.Отправитель = Отправитель.ИдентификаторУзла;
		СообщениеОбмена.Получатель = вхИдентификаторУзлаОбмена;
		СообщениеОбмена.НомерСообщения = ЗаписьСообщения.НомерСообщения;
		СообщениеОбмена.НомерПринятого = НомерПринятого;
		
		Объекты = ФабрикаXDTO.Создать(ТипОбъекты);
		СписокОбъектов = Объекты.ПолучитьСписок("Объект");
		
		ВыгружаемыеОбъекты = ОбменДаннымиКлиентСервер.ВыбратьПакетИзмененийДляУзлаОбмена(Исходящий, СообщениеОбмена.НомерСообщения, 1000);
		Для Каждого ЭлементСоответствия Из ВыгружаемыеОбъекты цикл
			МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоМетаданным(ЭлементСоответствия.Ключ);
			ВыгруженныеОбъекты = МенеджерОбъекта.ВыгрузитьЭлементы(ЭлементСоответствия.Значение, ПолучитьМетаданные());
			Для Каждого ВыгруженныйОбъект Из ВыгруженныеОбъекты цикл
				СписокОбъектов.Добавить(ВыгруженныйОбъект);
			КонецЦикла;
		КонецЦикла;
	
		СообщениеОбмена.Объекты = Объекты;
		ЗаписьСообщения.ЗакончитьЗапись();
		
	Исключение
		ЗаписьСообщения.ПрерватьЗапись();
		ВызватьИсключение ;
	КонецПопытки;
	
	ЗаписьХМЛ = Новый ЗаписьXML;
	ЗаписьХМЛ.УстановитьСтроку("utf-8");
	ЗаписьХМЛ.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьХМЛ, СообщениеОбмена);
	Возврат ЗаписьХМЛ.Закрыть();	
	
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
