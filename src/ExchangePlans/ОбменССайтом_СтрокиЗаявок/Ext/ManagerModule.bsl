﻿#Область Выгрузка
Функция ВыгрузитьСообщениеОбмена(ИдентификаторУзлаОбмена, НомерПринятого, НеСжиматьСообщение = Ложь) Экспорт
	
	УзелСайт = ОбменДаннымиКлиентСервер.ПолучитьВходящийУзелОбмена(ПолучитьМетаданные(), ИдентификаторУзлаОбмена);
	Если НЕ ЗначениеЗаполнено(УзелСайт) тогда
		ВызватьИсключение "[ВыгрузитьСообщениеОбмена_ОбменССайтом_СтрокиЗаявок]: неправильный параметр номер 1(Узел 1С)";
	КонецЕсли;
	
	НомерОтправленного = УзелСайт.НомерОтправленного;
	Если НомерПринятого > НомерОтправленного Тогда
		//ВызватьИсключение "[ВыгрузитьСообщениеОбмена_ОбменССайтом_СтрокиЗаявок]: Сообщение №"+ НомерПринятого + " ещё не отправлялось(последнее №" + НомерОтправленного + ")";
		//Иногда разбегаются счетчики, номер принятого на 1 превышает номер отправленного, обычно ночью такое//
		ТекстОшибки = "Расхождение счетчиков, ReceivedNo:" + НомерПринятого + ", НомерОтправленного:" + НомерОтправленного;
		ЗаписьЖурналаРегистрации("Обмен данными.Выгрузка.ОбменССайтом_СтрокиЗаявок", УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
		НомерСообщения = НомерПринятого + 1;
		НомерПринятого = НомерОтправленного;
	Иначе
		НомерСообщения = НомерОтправленного + 1;
	КонецЕсли;
	
	ФиксацияПринятогоСообщения(УзелСайт, НомерПринятого);
	
	ТипОбъекты = ФабрикаXDTO.Тип(URIПространстваИмен(), "Объекты");
	ТипСообщениеОбмена = ФабрикаXDTO.Тип(URIПространстваИмен(), "СообщениеОбмена");
	
	Узел = УзелСайт.ПолучитьОбъект();
	Узел.НомерОтправленного = НомерСообщения;
	Узел.Записать();
	
	СообщениеОбмена = ФабрикаXDTO.Создать(ТипСообщениеОбмена);
	СообщениеОбмена.ПланОбмена = "motion";
	СообщениеОбмена.Отправитель = ЭтотУзел().ИдентификаторУзла;
	СообщениеОбмена.Получатель = ИдентификаторУзлаОбмена;
	СообщениеОбмена.НомерСообщения = НомерСообщения;
	СообщениеОбмена.НомерПринятого = 0; //Исходящих данных нет//
	
	Объекты = ФабрикаXDTO.Создать(ТипОбъекты);
	СписокОбъектов = Объекты.ПолучитьСписок("Объект");
	РегистрыСведений.СостояниеЗаявокПокупателя.ДобавитьДанныеСостояниеСтрокЗаявок(СписокОбъектов, НомерСообщения);
	РегистрыСведений.ИсторияЗаявокПокупателя.ДобавитьДанныеИсторияЗаявокПокупателя(СписокОбъектов, НомерСообщения);
	СообщениеОбмена.Объекты = Объекты;
	
	ЗаписьХМЛ = Новый ЗаписьXML;
	ЗаписьХМЛ.УстановитьСтроку("utf-8");
	ЗаписьХМЛ.ЗаписатьОбъявлениеXML();
	ФабрикаXDTO.ЗаписатьXML(ЗаписьХМЛ, СообщениеОбмена);

	НесжатоеСообщение = ЗаписьХМЛ.Закрыть();
	
	Если НеСжиматьСообщение Тогда
		Возврат НесжатоеСообщение;
	Иначе
		Возврат ОбщегоНазначенияВызовСервера.ЗапаковатьСообщение(НесжатоеСообщение);
	КонецЕсли;
	
КонецФункции
#КонецОбласти

#Область ОбщиеФункции
Функция ПолучитьМетаданные()
	
	Возврат Метаданные.ПланыОбмена.ОбменССайтом_СтрокиЗаявок;
	
КонецФункции
Функция URIПространстваИмен() 
	
	Возврат "http://ws-02.part-kom.ru/partkom83/hs/SiteExchange/XMLSchema";
	
КонецФункции
Функция ФиксацияПринятогоСообщения(УзелСайт, НомерПринятого)
	
	РегистрыСведений.СостояниеЗаявокПокупателя.ФиксацияПринятогоСообщения(НомерПринятого);
	РегистрыСведений.ИсторияЗаявокПокупателя.ФиксацияПринятогоСообщения(НомерПринятого);
	
КонецФункции
#КонецОбласти
