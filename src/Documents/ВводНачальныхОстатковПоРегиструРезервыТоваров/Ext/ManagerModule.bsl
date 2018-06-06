﻿Функция РегистрыНакопления_РезервыТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Товары.Ссылка.Дата КАК Период,
	|	Товары.Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Товары.Ссылка.Склад КАК Склад,
	|	Товары.Номенклатура,
	|	Товары.Качество,
	|	Товары.СтрокаЗаявки,
	|	Товары.СтрокаПрихода,
	|	Товары.Количество
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоРегиструРезервыТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка"
	);
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "РезервыТоваров") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "РезервыТоваров",
		РегистрыНакопления_РезервыТоваров(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
КонецПроцедуры