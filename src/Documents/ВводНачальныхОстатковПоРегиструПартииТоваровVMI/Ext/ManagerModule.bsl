﻿Функция РегистрыНакопления_ПартииТоваровVMI(вхСсылкаНаДокумент, вхОтказ, вхПараметры)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Док.Ссылка.Дата КАК Период,
	|	Док.Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	Док.ТорговаяТочка,
	|	Док.Ссылка.Склад КАК Склад,
	|	Док.Номенклатура,
	|	Док.ЕдиницаИзмерения,
	|	Док.СтрокаПрихода,
	|	Док.СостояниеПартии,
	|	Док.Количество,
	|	Док.СуммаРубли,
	|	Док.СуммаДоллары,
	|	Док.СуммаЕвро
	|ИЗ
	|	Документ.ВводНачальныхОстатковПоРегиструПартииТоваровVMI.Товары КАК Док
	|ГДЕ
	|	Док.Ссылка = &Ссылка"
	);
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	
	Если ПроведениеДокументовКлиентСервер.ПроводитсяПо(вхПараметры, "ПартииТоваровVMI") тогда
		ОбщегоНазначения.ЗаписатьДвиженияДокумента(вхСсылкаНаДокумент, "ПартииТоваровVMI",
		РегистрыНакопления_ПартииТоваровVMI(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	КонецЕсли;
	
КонецПроцедуры