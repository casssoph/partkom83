﻿Функция РегистрыСведений_ЦеныНоменклатурыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено)
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	&вхПериод КАК Период,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Ссылка КАК Регистратор,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Ссылка.ПрайсПоставщика,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Номенклатура,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.ЕдиницаИзмерения,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Валюта,
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Цена
	|ИЗ
	|	Документ.УстановкаЦенНоменклатурыКонтрагентов.Товары КАК УстановкаЦенНоменклатурыКонтрагентовТовары
	|ГДЕ
	|	УстановкаЦенНоменклатурыКонтрагентовТовары.Ссылка = &Ссылка";
	
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "НеПроводитьНулевыеЗначения") Тогда
		Запрос.Текст = Запрос.Текст + "	И УстановкаЦенНоменклатурыКонтрагентовТовары.Цена > 0";
	КонецЕсли;
	
	Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНаДокумент, "ПрайсVMI") Тогда
		//Запрос.УстановитьПараметр("вхПериод", КонецДня(вхСсылкаНаДокумент.МоментВремени().Дата) + 1);
		Запрос.УстановитьПараметр("вхПериод", НачалоДня(ОбщегоНазначения.ПолучитьЗначениеРеквизита(вхСсылкаНадокумент, "ДатаНачала")));
	Иначе
		Запрос.УстановитьПараметр("вхПериод", вхСсылкаНаДокумент.МоментВремени().Дата);
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", вхСсылкаНаДокумент);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Процедура ВыполнитьПроведение(вхСсылкаНаДокумент, вхОтказ, вхПараметры = Неопределено) Экспорт
	Движения = РегистрыСведений.ЦеныНоменклатурыКонтрагентов.СоздатьНаборЗаписей();
	Движения.Отбор.Регистратор.Установить(вхСсылкаНаДокумент);
	Движения.Загрузить(РегистрыСведений_ЦеныНоменклатурыКонтрагентов(вхСсылкаНаДокумент, вхОтказ, вхПараметры));
	Движения.Записать(Истина);
	
КонецПроцедуры