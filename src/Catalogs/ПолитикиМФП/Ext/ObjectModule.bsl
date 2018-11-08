﻿
Процедура ПередЗаписью(Отказ)
	
	Если Не ПометкаУдаления И Не Справочники.ПолитикиМФП.ПолитикаУникальна(Ссылка, Владелец, ПериодДействия) Тогда
		Отказ = Истина;
		Сообщить("Уже есть политика МФП для этой организации от "+Формат(ПериодДействия,"ДФ=dd.MM.yyyy"));
	КонецЕсли;
	
	Если Не ПометкаУдаления Тогда
		ПередЗаписьюПроверитьЗаполненностьРеквизитов(Отказ);
	КонецЕсли;
	
	КолОрганизаций = СобственныеОрганизацииРазрешенаПокупка.Количество();
	СобственныеОрганизацииРазрешенаПокупкаСтрокой = ?(КолОрганизаций = 0 ИЛИ НЕ РазрешенаПокупкаУСобственныхОрганизаций, "", "Разрешена покупка у "+КолОрганизаций+" организаций");
	
	ПроверитьОрганизацииПокупки(Отказ);
	
КонецПроцедуры

Процедура ПроверитьОрганизацииПокупки(Отказ)
	
	Если  РазрешенаПокупкаУСобственныхОрганизаций И СобственныеОрганизацииРазрешенаПокупка.Количество() = 0 Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Добавьте организации, либо уберите разрешение", Отказ,"Не указано ни одной собственной организации для покупки!", СтатусСообщения.Важное);
	КонецЕсли;
	
	Если СобственныеОрганизацииРазрешенаПокупка.Найти(Перечисления.СпособыПередачиТоваров.ПустаяСсылка(), "СпособПередачиТоваров") <> Неопределено Тогда
		Сообщить("Необходимо указать способ передачи товаров!");
		Отказ = Истина;
	КонецЕсли;
	
	Если СобственныеОрганизацииРазрешенаПокупка.Найти(Справочники.Организации.ПустаяСсылка(), "Организация") <> Неопределено Тогда
		Сообщить("Нельзя указывать в качестве организации покупки пустую организацию!");
		Отказ = Истина;
	КонецЕсли;
	
	Если СобственныеОрганизацииРазрешенаПокупка.Найти(Владелец, "Организация") <> Неопределено Тогда
		Сообщить("Нельзя указывать в качестве организации покупки, организацию-владельца политики!");
		Отказ = Истина;
	КонецЕсли;
	
	ТЗ = СобственныеОрганизацииРазрешенаПокупка.Выгрузить();
	ТЗ.Свернуть("Организация", "ПроцентНаценки");
	
	Если ТЗ.Количество() <>  СобственныеОрганизацииРазрешенаПокупка.Количество() Тогда
		Сообщить("Проверьте дубли строк в организациях покупки");
		Отказ = Истина;
	КонецЕсли;
	
	Если РазрешенаЦепочкаЗакупок И СобственныеОрганизацииРазрешенаПокупка.Количество() > 1 Тогда
		Сообщить("Нельзя указывать более одной организации закупки, если разрешена цепочка закупок!");
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура 	ПередЗаписьюПроверитьЗаполненностьРеквизитов(Отказ)

	Если Не ЗначениеЗаполнено(ПериодДействия) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан период действия!", Отказ,, СтатусСообщения.Важное);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Контрагент) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Не указан собственный контрагент!", Отказ,, СтатусСообщения.Важное);
	КонецЕсли;

КонецПроцедуры

