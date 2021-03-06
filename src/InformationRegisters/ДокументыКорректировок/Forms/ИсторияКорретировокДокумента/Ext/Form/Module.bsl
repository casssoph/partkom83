﻿
&НаКлиенте
Процедура ДействиеКнопки(Команда,ДокументСсылка = Неопределено)
	  лКлючАлгоритма = "РегистрСведений_ДокументыКорректировок_Форма_ИсторияКорретировокДокумента_ДействиеКнопки";
	  лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	  Если Не лЗамена = Неопределено Тогда
	  	Выполнить(лЗамена);
	  	Возврат;
	  КонецЕсли;
	  ///////////////////////////////////////////////////////////////////////////
	  
	  
 	ТекущиеДанные = Элементы.КорректировкиДокумента.ТекущиеДанные;
	Если ТекущиеДанные.Свойство("ДокументКорректировки") тогда 
		ДокументСсылка = ТекущиеДанные.ДокументКорректировки;		 
	ИначеЕсли ТекущиеДанные.Свойство("Документ") тогда 
		ДокументСсылка = ТекущиеДанные.Документ;	
	КонецЕсли; 
	
	Если ЗначениеЗаполнено(ДокументСсылка) тогда 
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ДействиеКнопкиЗавершение", ЭтаФорма,Новый Структура("Команда,ДокументСсылка",Команда,ДокументСсылка)),
		"Выполнение операции " +Команда.Имя +" для документа " +СокрЛП(ДокументСсылка)+" ,будет выполнено на всех последующих документов",РежимДиалогаВопрос.ДаНет);		 
	КонецЕсли;
	

КонецПроцедуры

&НаКлиенте
Процедура ДействиеКнопкиЗавершение(РезультатВопроса, ПараметрыОбработки) Экспорт
	  лКлючАлгоритма = "РегистрСведений_ДокументыКорректировок_Форма_ИсторияКорретировокДокумента_ДействиеКнопкиЗавершение";
	  лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	  Если Не лЗамена = Неопределено Тогда
	  	Выполнить(лЗамена);
	  	Возврат;
	  КонецЕсли;
	  ///////////////////////////////////////////////////////////////////////////
	
	
	Если РезультатВопроса = КодВозвратаДиалога.Да тогда  	
		ДействиеКнопкиЗавершениеНСервере(ПараметрыОбработки.ДокументСсылка,ПараметрыОбработки.Команда.Имя);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДействиеКнопкиЗавершениеНСервере(ДокументСсылка,ИмяКоманды)
	  лКлючАлгоритма = "РегистрСведений_ДокументыКорректировок_Форма_ИсторияКорретировокДокумента_ДействиеКнопкиЗавершениеНСервере";
	  лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	  Если Не лЗамена = Неопределено Тогда
	  	Выполнить(лЗамена);
	  	Возврат;
	  КонецЕсли;
	  ///////////////////////////////////////////////////////////////////////////
		
	Если ИмяКоманды = "ОтменаПроведения" тогда 
		ВыборкаДокументов  = ПолучитьВыборкуДокументовКОбработке(ДокументСсылка,Истина);
		Пока ВыборкаДокументов.Следующий() цикл 
			ДокументОбъект = ВыборкаДокументов.ДокументКорректировки.ПолучитьОбъект();
			ДокументОбъект.записать(РежимЗаписиДокумента.ОтменаПроведения)
		КонецЦикла;		
	Иначеесли  ИмяКоманды = "ПометитьНаУдаление" тогда 
		ВыборкаДокументов  = ПолучитьВыборкуДокументовКОбработке(ДокументСсылка,Истина);
		Пока ВыборкаДокументов.Следующий() цикл 
			ДокументОбъект = ВыборкаДокументов.ДокументКорректировки.ПолучитьОбъект();
			ДокументОбъект.УстановитьПометкуУдаления(Истина);
		КонецЦикла;	
		
	Иначеесли  ИмяКоманды = "Провести" тогда 
		ВыборкаДокументов  = ПолучитьВыборкуДокументовКОбработке(ДокументСсылка);
		Пока ВыборкаДокументов.Следующий() цикл 
			ДокументОбъект = ВыборкаДокументов.ДокументКорректировки.ПолучитьОбъект();
			ДокументОбъект.записать(РежимЗаписиДокумента.Проведение)
		КонецЦикла;		

	Конецесли;
	

	
	
КонецПроцедуры	

&НаСервере
Функция ПолучитьВыборкуДокументовКОбработке(знач ДокументСсылка,ОбратныйПорядок = ложь)
	
	ЗапросКорректировок = новый Запрос;
	ТекстЗапроса  = "ВЫБРАТЬ
	                |	ДокументыКорректировок.Период КАК Период,
	                |	ДокументыКорректировок.ДокументКорректировки
	                |ИЗ
	                |	РегистрСведений.ДокументыКорректировок КАК ДокументыКорректировок
	                |ГДЕ
	                |	ДокументыКорректировок.МоментВремени >= &ГраницаДокумента
	                |	И ДокументыКорректировок.Документ = &Документ
	                |
	                |УПОРЯДОЧИТЬ ПО
	                |	Период %1";
	 ЗапросКорректировок.УстановитьПараметр("ГраницаДокумента",ДокументСсылка.моментвремени());
	 
	 Если ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаказаПоставщику") или 
		 ТипЗнч(ДокументСсылка) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") тогда 
		 ДокументСсылка = ДокументСсылка.ДокументОснование;
	 КонецЕсли;	  
		
	 ЗапросКорректировок.УстановитьПараметр("Документ",ДокументСсылка);

	 ЗапросКорректировок.Текст = СтрШаблон(ТекстЗапроса,?(ОбратныйПорядок,"УБЫВ",""));
	 Возврат ЗапросКорректировок.выполнить().Выбрать();
	

	
Конецфункции	


&НаКлиенте
Процедура ИсторияИзменений(Команда)
	  лКлючАлгоритма = "РегистрСведений_ДокументыКорректировок_Форма_ИсторияКорретировокДокумента_ИсторияИзменений";
	  лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	  Если Не лЗамена = Неопределено Тогда
	  	Выполнить(лЗамена);
	  	Возврат;
	  КонецЕсли;
	  ///////////////////////////////////////////////////////////////////////////
	
	
	
	ТекущиеДанные = Элементы.КорректировкиДокумента.ТекущиеДанные;
	Если ТекущиеДанные.Свойство("ДокументКорректировки") тогда 
		ДокументСсылка = ТекущиеДанные.ДокументКорректировки;		 
	ИначеЕсли ТекущиеДанные.Свойство("Документ") тогда 
		ДокументСсылка = ТекущиеДанные.Документ;	
	КонецЕсли; 
	
	  ОбщегоНазначенияКлиент.ПоказатьИсториюИзмененияОбъекта(ДокументСсылка);	
КонецПроцедуры

