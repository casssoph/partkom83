﻿
Функция ПолучитьОтчетПолучить(Запрос)
	
	лКлючАлгоритма = "HTTPсервис_DocumentsStatus_ПолучитьОтчетПолучить";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	НачалоПериода = Запрос.ПараметрыURL("НачалоПериода");
	ОкончаниеПериода = Запрос.ПараметрыURL("ОкончаниеПериода");
	СкладОтправитель = Запрос.ПараметрыURL("СкладОтправитель");
	СкладПолучатель = Запрос.ПараметрыURL("СкладПолучатель");
	
	Если Не ЗначениеЗаполнено(НачалоПериода) Тогда
		СтрокаОшибки = "Не заполнен параметр «НачалоПериода»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		СтрокаОшибки = "Не заполнен параметр «ОкончаниеПериода»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СкладОтправитель) Тогда
		СтрокаОшибки = "Не заполнен параметр «СкладОтправитель»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(СкладПолучатель) Тогда
		СтрокаОшибки = "Не заполнен параметр «СкладПолучатель»";
		Отказ = Истина;
	КонецЕсли;
	
	Если Отказ Тогда
		Ответ = Новый HTTPСервисОтвет(400);	
		Ответ.Заголовки.Вставить("Content-Type", "application/xml");	
		Ответ.УстановитьТелоИзСтроки(СтрокаОшибки, "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
		Возврат Ответ;
	КонецЕсли;
	
	ПараметрыЗапроса = Новый Структура("НачалоПериода, ОкончаниеПериода, СкладОтправитель, СкладПолучатель",  НачалоПериода, ОкончаниеПериода, СкладОтправитель, СкладПолучатель);
	
	Ответ = Новый HTTPСервисОтвет(200);	
	Ответ.Заголовки.Вставить("Content-Type", "application/xml");	
	Ответ.УстановитьТелоИзСтроки(ЗаписатьВJSON(ПараметрыЗапроса), "utf-8", ИспользованиеByteOrderMark.НеИспользовать);
	Возврат Ответ;
	
КонецФункции

Функция ЗаписатьВJSON(ПараметрыЗапроса)
	
	лКлючАлгоритма = "HTTPсервис_DocumentsStatus_ЗаписатьВJSON";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;
		Выполнить(лЗамена);
		Возврат АлгоритмыЗначениеВозврата;
	КонецЕсли;	
	////////////////////////////////////////////////////////////////////////////
	
	тЗапись = Новый ЗаписьJSON;
	тЗапись.УстановитьСтроку();
	
	тДанные = Новый Структура();

	ЗаписатьJSON(тЗапись, тДанные);
	
	Возврат тЗапись.Закрыть();
	
КонецФункции

