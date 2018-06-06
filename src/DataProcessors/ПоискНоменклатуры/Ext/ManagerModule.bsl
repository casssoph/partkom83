﻿
Процедура ВыполнитьПоискНоменклатуры(Параметры,АдресХранилища) Экспорт
	СписокВидовДокументов = параметры.МассивВидов; 
	
	ДокМетаданные  =  Метаданные.Документы;
	ТекстЗапросаОбщий = "";
		
	Для Каждого ВидДокумента из СписокВидовДокументов цикл
		мДок = ДокМетаданные.Найти(ВидДокумента);
		
		ТекстЗапроса = 	 "
						 |	ВЫБРАТЬ РАЗЛИЧНЫЕ
		               	 |	ТЧДокумента.Ссылка как Документ,						 
						 |	ТЧДокумента.Ссылка.Номер КАК Номер,
	          			 |	ТЧДокумента.Ссылка.Дата КАК Дата,
						 |	ТЧДокумента.Ссылка.Проведен КАК Проведен, 
						 |  %2 КАК Контрагент,
						 |  %3 КАК Организация,
						 |  %4 КАК СуммаДокумента,
						 |  %5 КАК СтатусДокумента
						 |ИЗ
		               	 |	Документ.%1.Товары КАК ТЧДокумента
		               	 |ГДЕ
						 |	ТЧДокумента.Номенклатура = &Номенклатура И
						 |	ТЧДокумента.Ссылка.Дата МЕЖДУ &НачалоПериода И &КонецПериода"  ;
						 
			ТекстЗапроса = 	 СтрШаблон(ТекстЗапроса,ВидДокумента,
						 ?(ОбщегоНазначения.ЕстьРеквизитДокумента("Контрагент", мДок),"ТЧДокумента.Ссылка.Контрагент","Значение(Справочник.Контрагенты.ПустаяСсылка)"),
						 ?(ОбщегоНазначения.ЕстьРеквизитДокумента("Организация", мДок),"ТЧДокумента.Ссылка.Организация","Значение(Справочник.Организации.ПустаяСсылка)"),
						 ?(ОбщегоНазначения.ЕстьРеквизитДокумента("СуммаДокумента", мДок),"ТЧДокумента.Ссылка.СуммаДокумента","0"),
						 ?(ОбщегоНазначения.ЕстьРеквизитДокумента("СтатусДокумента", мДок),"ТЧДокумента.Ссылка.СтатусДокумента","Значение(Справочник.СтатусыДокументов.ПустаяСсылка)")) ;
						 
						 Если ТекстЗапросаОбщий ="" тогда 
							 ТекстЗапросаОбщий  = ТекстЗапроса;
						 иначе 
						ТекстЗапросаОбщий = ТекстЗапросаОбщий + "
						|
						|ОБЪЕДИНИТЬ ВСЕ
						| "+
						ТекстЗапроса;
						
						КонецЕсли; 
						
							 
										 
	КонецЦикла;	
	
	Если ТекстЗапросаОбщий = "" тогда 
		 ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрано ниодного типа документа");
		 Возврат;
	 КонецЕсли;
	 
	 	
	Запрос = Новый Запрос;
	запрос.Текст = ТекстЗапросаОбщий;
	Запрос.УстановитьПараметр("Номенклатура", Параметры.Номенклатура);
	Запрос.УстановитьПараметр("НачалоПериода", Параметры.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", Параметры.ДатаОкончания);
	
	ПоместитьВоВременноеХранилище(Запрос.Выполнить().Выгрузить(), АдресХранилища);
	
	
	
КонецПроцедуры