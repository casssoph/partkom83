﻿
Функция ТекстСообщенияДляСайта(АктСсылка) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	АктРассмотренияВозвратаТовары.Номенклатура,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Наименование,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Изготовитель КАК Изготовитель,
	|	АктРассмотренияВозвратаТовары.Номенклатура.Артикул КАК Артикул,
	|	АктРассмотренияВозвратаТовары.ЕдиницаИзмерения,
	|	АктРассмотренияВозвратаТовары.Количество,
	|	АктРассмотренияВозвратаТовары.Цена,
	|	АктРассмотренияВозвратаТовары.СтавкаНДС,
	|	АктРассмотренияВозвратаТовары.СуммаНДС,
	|	АктРассмотренияВозвратаТовары.Сумма,
	|	АктРассмотренияВозвратаТовары.ПроцентУценки,
	|	АктРассмотренияВозвратаТовары.ЦенаПослеУценки,
	|	АктРассмотренияВозвратаТовары.ВидУценки,
	|	АктРассмотренияВозвратаТовары.СуммаКомпенсации,
	|	АктРассмотренияВозвратаТовары.ПричинаВозврата,
	|	АктРассмотренияВозвратаТовары.ЦелостностьУпаковки,
	|	АктРассмотренияВозвратаТовары.ОтсутствуютСледыУстановки
	|ИЗ
	|	Документ.АктРассмотренияВозврата.Товары КАК АктРассмотренияВозвратаТовары
	|ГДЕ
	|	АктРассмотренияВозвратаТовары.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", АктСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ИнфДок = "";
	ИнфТовар = "";
	
	Наличные = АктСсылка.ДоговорКонтрагента.ВидОплаты = Перечисления.ВидыДенежныхСредств.Наличные;	
	
	Пока Выборка.Следующий() Цикл
		
		Если Наличные Тогда
			
			Если Выборка.ПроцентУценки = 0 Тогда
				
				Сумма = Выборка.Сумма + Выборка.СуммаКомпенсации;
				//И пересчет НДС от новой суммы.
				
				ИнфТовар = Выборка.НоменклатураНаименование + ", " + Выборка.Изготовитель + ", " + АктСсылка.Артикул + ", в кол-ве " + Выборка.Количество + "шт., " + "по цене - " + Выборка.ЦенаПослеУценки + " на общую сумму-" + Сумма + " руб."
				
			Иначе //«Процент уценки» > 0
				
				ИнфТовар = Выборка.НоменклатураНаименование + ", " + Выборка.Изготовитель+ ", " + Выборка.Артикул + ", в кол-ве " + Выборка.Количество + "шт., " + "по цене с учётом уценки " + Выборка.ПроцентУценки + "% - " + Выборка.ЦенаДеталиПослеУценки  + " на общую сумму-" + Выборка.Сумма + " руб.";
				
			КонецЕсли;
			
		Иначе //(товар приобретался за безналичные)
			
			ИнфДок = "Оформить пакет документов: накладная ТОРГ-12, счет-фактура с НДС 18%, оформленные в 2-х экземплярах на " + АктСсылка.Организация + ".";
			
			Если  Выборка.ПроцентУценки = 0 Тогда
				
				Сумма = Выборка.Сумма + Выборка.СуммаКомпенсации;
				СуммаНДС = Выборка.СуммаНДС;//И пересчет НДС от новой суммы.
				
				ИнфТовар = Выборка.НоменклатураНаименование + ", " + Выборка.Изготовитель+ ", " + Выборка.Артикул + ", в кол-ве " + Выборка.Количество + "шт., " + "по цене - " + Выборка.ЦенаПослеУценки + " руб. на общую сумму - " + Сумма + " руб." + " в том числе НДС - " + СуммаНДС + " руб."
				
			Иначе //(т.е. «Возврат с уценкой»=Истина)
				
				ИнфТовар = Выборка.НоменклатураНаименование + ", "+Выборка.Изготовитель+", "+Выборка.Артикул+", в кол-ве " + Выборка.Количество + "шт., " + "по цене с учётом уценки " + Выборка.ПроцентУценки + "% – "+ Выборка.ЦенаПослеУценки+ " руб. на общую сумму- " + Выборка.Сумма + " руб." + " в том числе НДС- " + Выборка.СуммаНДС + " руб. ";
				
				Если Выборка.ВидУценки = Перечисления.ВидыУценки.ОбработкаОднойДетали Тогда //«Вид уценки» = "Обработка одной детали"
					
					ИнфТовар = ИнфТовар + " Стоимость обработки 1 детали составила " + "Что тут(??)" + " руб.";
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли; //(товар приобретался за безналичные)
		
		Если Выборка.ПричинаВозврата = Перечисления.ПричиныВозврата.Брак Тогда //"«Причина возврата» = «брак, СТО»"
			ИнфДок = ИнфДок + ", акт рекламации СТО, Заказ-наряд СТО с подтверждением оплаты работ";
		КонецЕсли;
		
		Если Выборка.ЦелостностьУпаковки Тогда
			Упаковка = "- Сохранена упаковка и её товарный вид.";
		Иначе
			Упаковка = "- Упаковка отсутствует или потерян её товарный вид.";
		КонецЕсли;
		
		Если Выборка.ОтсутствуютСледыУстановки Тогда
			СледыУст = "- Товар не имеет признаков использования, отсутствуют следы установки, сохранен товарный вид.";
		Иначе
			СледыУст = "- Товар имеет следы установки.";
		КонецЕсли;
		
		
		
	КонецЦикла;
	
	
	
	
	
КонецФункции