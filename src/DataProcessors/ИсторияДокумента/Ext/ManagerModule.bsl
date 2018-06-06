﻿Функция ОткрытьФормуВыбораДокумента(ИсходныйДокумент, ТекущийДокумент) Экспорт
	
	Если ЗначениеЗаполнено(ИсходныйДокумент) и ЗначениеЗаполнено(ТекущийДокумент) Тогда
		_обр = Обработки.ИсторияДокумента.Создать();
		_обр.ИсходныйДокумент = ИсходныйДокумент;
		_обр.ТекущийДокумент = ТекущийДокумент;
		Возврат _обр.ПолучитьФорму("Форма").ОткрытьМодально();
	КонецЕсли;
	
	Возврат Неопределено
	
КонецФункции

Функция СформироватьИсториюИзменений(ИсходныйДокумент, ТаблицаОтчета, ТолькоИзменения) Экспорт
	
	МетаданныеДокумента = ИсходныйДокумент.Метаданные();
	Если МетаданныеДокумента.Имя = "ЗаявкаПокупателя" Тогда 
		МетаданныеКорректировки = Метаданные.Документы.КорректировкаЗаявкиПокупателя;  
	ИначеЕсли МетаданныеДокумента.Имя = "ЗаказПоставщику" Тогда
		МетаданныеКорректировки = Метаданные.Документы.КорректировкаЗаказаПоставщику;
	ИначеЕсли МетаданныеДокумента.Имя = "ПоступлениеТоваровУслуг" Тогда
		МетаданныеКорректировки = Метаданные.Документы.ПоступлениеТоваровУслуг;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Док.Ссылка,
	               |	Док.МоментВремени КАК МоментВремени
	               |ИЗ
	               |	Документ." + МетаданныеДокумента.Имя + " КАК Док
	               |ГДЕ
	               |	Док.Ссылка = &Документ
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	Док.Ссылка,
	               |	Док.МоментВремени
	               |ИЗ
	               |	Документ." + МетаданныеКорректировки.Имя + " КАК Док
	               |ГДЕ
	               |	Док.Проведен
	               |	И Док.ДокументОснование = &Документ
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	МоментВремени";
						  
	Запрос.УстановитьПараметр("Документ", ИсходныйДокумент);
	МассивКорректировок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Макет = Обработки.ИсторияДокумента.ПолучитьМакет("СтандартныйМакетПредставленияОбъекта");
	Область = Макет.ПолучитьОбласть("Шапка");
	Область.Параметры.НаименованиеОтчета = "История корректировок" ;
	ТаблицаОтчета.Вывести(Область);
	
	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("СвободнаяСтрока");
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	
	ПустаяЯчейка = Макет.ПолучитьОбласть("ПустаяЯчейка");
	ОбластьВерсии = Макет.ПолучитьОбласть("ЗаголовокВерсии");
	
	ТаблицаОтчета.Присоединить(ПустаяЯчейка);
	
	ТаблицаОтчета.Присоединить(ОбластьВерсии);
	
	ОбластьВерсии = Макет.ПолучитьОбласть("ПредставлениеВерсии");
	Для Каждого Документ Из МассивКорректировок Цикл 
		ОбластьВерсии.Параметры.ПредставлениеВерсии = Строка(Документ);
		ОбластьВерсии.Параметры.Документ = Документ;
		ТаблицаОтчета.Присоединить(ОбластьВерсии);
	КонецЦикла;	
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	
	ОбластьШапкаРеквизитов = Макет.ПолучитьОбласть("ШапкаРеквизитов");
	ТаблицаОтчета.Вывести(ОбластьШапкаРеквизитов);
	
	ТаблицаОтчета.НачатьГруппуСтрок("ГруппаРеквизитов");
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	
	ДанныеПоРеквизитам = ПолучитьДанныеПоРеквизитам(ИсходныйДокумент, МассивКорректировок, МетаданныеДокумента, МетаданныеКорректировки);
	Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл 
		Если Реквизит.Имя = "ДокументОснование" Тогда 
			Продолжить;
		КонецЕсли;
		Если ТолькоИзменения Тогда 
			ВремТаблица = ДанныеПоРеквизитам.Скопировать(,Реквизит.Имя);
			ВремТаблица.Свернуть(Реквизит.Имя);
			Если ВремТаблица.Количество() = 1 Тогда 
				Продолжить;
			КонецЕсли;
		КонецЕсли;                    
		ТаблицаОтчета.Вывести(ПустаяЯчейка);
		
		НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
		НаименованиеРеквизита.Параметры.НаименованиеРеквизитаПоля = Реквизит.Синоним;
		ТаблицаОтчета.Присоединить(НаименованиеРеквизита);
		
		СтрокаСравнения = Неопределено;

		Для Каждого Документ Из МассивКорректировок Цикл 
			
			СтрокаДанных = ДанныеПоРеквизитам.Найти(Документ, "Ссылка");
			
			Если Документ.Метаданные() = МетаданныеКорректировки Тогда
				Если СтрокаДанных[Реквизит.Имя] =  СтрокаСравнения[Реквизит.Имя] Тогда 
					ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
				Иначе	
					ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
				КонецЕсли;
			Иначе
				ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
			КонецЕсли;
			СтрокаСравнения = СтрокаДанных;
			ОбластьЗначениеРеквизита.Параметры.ЗначениеРеквизита = СтрокаДанных[Реквизит.Имя];
			ТаблицаОтчета.Присоединить(ОбластьЗначениеРеквизита);
		КонецЦикла;
	КонецЦикла;
	ТаблицаОтчета.ЗакончитьГруппуСтрок();
	
	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
	Область = Макет.ПолучитьОбласть("ШапкаТабличныхЧастей");
	ТаблицаОтчета.Вывести(Область);
	
	Для Каждого ТабличнаяЧасть Из МетаданныеДокумента.ТабличныеЧасти Цикл 
		ДанныеПоТабличнойЧасти = ПолучитьДанныеПоТабличнойЧасти(ТабличнаяЧасть, ИсходныйДокумент, МассивКорректировок, МетаданныеДокумента, МетаданныеКорректировки);
		Если ДанныеПоТабличнойЧасти.Количество() > 0 Тогда 
			ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
			ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(,"НомерСтроки");
			ВремТаблица.Сортировать("НомерСтроки Убыв");
			МаксНомерСтроки = ВремТаблица.Получить(0).НомерСтроки;
			
			Область = Макет.ПолучитьОбласть("ШапкаТабличнойЧасти");
			Область.Параметры.НаименованиеТабличнойЧасти = ТабличнаяЧасть.Синоним;
			ТаблицаОтчета.Вывести(Область);
			ТаблицаОтчета.НачатьГруппуСтрок(ТабличнаяЧасть.Синоним);

			Для НомерСтроки = 1 По МаксНомерСтроки Цикл
				Если ТолькоИзменения Тогда 
					Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтроки));
					ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(Строки);
					ВремТаблица.Колонки.Удалить("Ссылка");
					Колонки = "";
					Для Каждого Колонка Из ВремТаблица.Колонки Цикл 
						Если ПустаяСтрока(Колонки) Тогда 
							Колонки = Колонка.Имя;
						Иначе
							Колонки = Колонки + "," + Колонка.Имя;
						КонецЕсли;
					КонецЦикла;
					КоличествоСтрок = ВремТаблица.Количество(); 
					ВремТаблица.Свернуть(Колонки);
					Если КоличествоСтрок = МассивКорректировок.Количество() И ВремТаблица.Количество() = 1 Тогда 
						Продолжить;
					КонецЕсли;
				КонецЕсли;
				ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
				
				ОбластьСтроки = Макет.ПолучитьОбласть("ШапкаСтрокиТабличнойЧасти");
				//НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
				ОбластьСтроки.Параметры.НомерСтрокиТабличнойЧасти = Строка(НомерСтроки);
				ТаблицаОтчета.Вывести(ОбластьСтроки);
				
				ТаблицаОтчета.НачатьГруппуСтрок(ТабличнаяЧасть.Синоним + " Строка № " + Строка(НомерСтроки));
				
				Для Каждого Колонка Из ДанныеПоТабличнойЧасти.Колонки Цикл 
					Если Колонка.Имя = "Ссылка" Тогда 
						Продолжить;
					КонецЕсли;
					Если ТолькоИзменения Тогда 
						Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтроки));
						ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(Строки, Колонка.Имя);
						КоличествоСтрок = ВремТаблица.Количество(); 
						ВремТаблица.Свернуть(Колонка.Имя);
						Если КоличествоСтрок = МассивКорректировок.Количество() И ВремТаблица.Количество() = 1 Тогда 
							Продолжить;
						КонецЕсли;
					КонецЕсли;  
					ТаблицаОтчета.Вывести(ПустаяЯчейка);
					
					НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
					НаименованиеРеквизита.Параметры.НаименованиеРеквизитаПоля = Колонка.Заголовок;
					ТаблицаОтчета.Присоединить(НаименованиеРеквизита);
					
					ЗначениеСравнения = Неопределено;
					
					Для Каждого Документ Из МассивКорректировок Цикл
						Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("Ссылка,НомерСтроки",Документ,НомерСтроки));
						Если Строки.Количество() <> 0 Тогда 
							Если Строки.Получить(0)[Колонка.Имя] = ЗначениеСравнения ИЛИ Документ.Метаданные() = МетаданныеДокумента Тогда 
								ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
							Иначе
								ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
							КонецЕсли;
							ЗначениеСравнения = Строки.Получить(0)[Колонка.Имя];
						Иначе
							ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
							ЗначениеСравнения = Неопределено;
						КонецЕсли;
						ОбластьЗначениеРеквизита.Параметры.ЗначениеРеквизита = ЗначениеСравнения;
						ТаблицаОтчета.Присоединить(ОбластьЗначениеРеквизита);
					КонецЦикла;
				КонецЦикла;
				ТаблицаОтчета.ЗакончитьГруппуСтрок();
			КонецЦикла;
			ТаблицаОтчета.ЗакончитьГруппуСтрок();
		КонецЕсли;
	КонецЦикла;
	ТаблицаОтчета.ФиксацияСверху = 3;
		
	Возврат ТаблицаОтчета;
	

КонецФункции

Функция ПолучитьДанныеПоРеквизитам(Документ, МассивКорректировок, МетаданныеДокумента, МетаданныеКорректировки)
	
	ТекстЗапроса  = "ВЫБРАТЬ ";	
	
	Для Каждого Реквизит Из МетаданныеДокумента.Реквизиты Цикл 
		ТекстЗапроса = ТекстЗапроса + "Док." + Реквизит.Имя + ", ";		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "Док.Ссылка ";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса + " ИЗ Документ." + МетаданныеДокумента.Имя + " Как Док Где Док.Ссылка = &Документ";
	Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ " + ТекстЗапроса + " ИЗ Документ." + МетаданныеКорректировки.Имя + " Как Док Где Док.Ссылка В (&МассивКорректировок)";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("МассивКорректировок", МассивКорректировок);
	
	Выборка = Запрос.Выполнить().Выгрузить();
	Выборка.Индексы.Добавить("Ссылка");
	
	Возврат Выборка;
	
КонецФункции

Функция ПолучитьДанныеПоТабличнойЧасти(ТабличнаяЧасть, Документ, МассивКорректировок, МетаданныеДокумента, МетаданныеКорректировки)
	
	ТекстЗапроса  = "ВЫБРАТЬ ";	
	
	Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл 
		Если Реквизит.Имя = "ЦенаЗакупки" и Не РольДоступна("ПолныеПрава") Тогда 
			Продолжить;
		КонецЕсли;
		ТекстЗапроса = ТекстЗапроса + "Док." + Реквизит.Имя + ", ";		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + "Док.Ссылка,  Док.НомерСтроки";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса + " ИЗ Документ." + МетаданныеДокумента.Имя + "." + ТабличнаяЧасть.Имя + " Как Док Где Док.Ссылка = &Документ";
	Запрос.Текст = Запрос.Текст + " ОБЪЕДИНИТЬ ВСЕ " + ТекстЗапроса + " ИЗ Документ." + МетаданныеКорректировки.Имя + "." + ТабличнаяЧасть.Имя + " Как Док Где Док.Ссылка В (&МассивКорректировок)";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	Запрос.УстановитьПараметр("МассивКорректировок", МассивКорректировок);
	
	Выборка = Запрос.Выполнить().Выгрузить();
	Выборка.Индексы.Добавить("Ссылка,НомерСтроки");
	
	Возврат Выборка;
	
КонецФункции

//Функция СформироватьИсториюИзмененийЗаявки1(Заявка, ТаблицаОтчета, ТолькоИзменения) Экспорт
//	
//	Запрос = Новый Запрос;
//	Запрос.Текст = "ВЫБРАТЬ
//	               |	ЗаявкаПокупателя.Ссылка,
//	               |	ЗаявкаПокупателя.МоментВремени КАК МоментВремени
//	               |ИЗ
//	               |	Документ.ЗаявкаПокупателя КАК ЗаявкаПокупателя
//	               |ГДЕ
//	               |	ЗаявкаПокупателя.Ссылка = &Заявка
//	               |
//	               |ОБЪЕДИНИТЬ ВСЕ
//	               |
//	               |ВЫБРАТЬ
//	               |	КорректировкаЗаявкиПокупателя.Ссылка,
//	               |	КорректировкаЗаявкиПокупателя.МоментВремени
//	               |ИЗ
//	               |	Документ.КорректировкаЗаявкиПокупателя КАК КорректировкаЗаявкиПокупателя
//	               |ГДЕ
//	               |	КорректировкаЗаявкиПокупателя.Проведен
//	               |	И КорректировкаЗаявкиПокупателя.ДокументОснование = &Заявка
//	               |
//	               |УПОРЯДОЧИТЬ ПО
//	               |	МоментВремени";
//						  
//	Запрос.УстановитьПараметр("Заявка", Заявка);
//	МассивКорректировок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
//	
//	Макет = Обработки.ИсторияДокумента.ПолучитьМакет("СтандартныйМакетПредставленияОбъекта");
//	Область = Макет.ПолучитьОбласть("Шапка");
//	Область.Параметры.НаименованиеОтчета = "История корректировок заявки" ;
//	ТаблицаОтчета.Вывести(Область);
//	
//	ОбластьПустаяСтрока = Макет.ПолучитьОбласть("СвободнаяСтрока");
//	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//	
//	ПустаяЯчейка = Макет.ПолучитьОбласть("ПустаяЯчейка");
//	ОбластьВерсии = Макет.ПолучитьОбласть("ЗаголовокВерсии");
//	
//	ТаблицаОтчета.Присоединить(ПустаяЯчейка);
//	
//	ТаблицаОтчета.Присоединить(ОбластьВерсии);
//	
//	ОбластьВерсии = Макет.ПолучитьОбласть("ПредставлениеВерсии");
//	Для Каждого Документ Из МассивКорректировок Цикл 
//		ОбластьВерсии.Параметры.ПредставлениеВерсии = Строка(Документ);
//		ОбластьВерсии.Параметры.Документ = Документ;
//		ТаблицаОтчета.Присоединить(ОбластьВерсии);
//	КонецЦикла;	
//	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//	
//	ОбластьШапкаРеквизитов = Макет.ПолучитьОбласть("ШапкаРеквизитов");
//	ТаблицаОтчета.Вывести(ОбластьШапкаРеквизитов);
//	
//	ТаблицаОтчета.НачатьГруппуСтрок("ГруппаРеквизитов");
//	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//	
//	ДанныеПоРеквизитам = ПолучитьДанныеПоРеквизитам(Заявка, МассивКорректировок);
//	Для Каждого Реквизит Из Метаданные.Документы.ЗаявкаПокупателя.Реквизиты Цикл 
//		Если Реквизит.Имя = "ДокументОснование" Тогда 
//			Продолжить;
//		КонецЕсли;
//		Если ТолькоИзменения Тогда 
//			ВремТаблица = ДанныеПоРеквизитам.Скопировать(,Реквизит.Имя);
//			ВремТаблица.Свернуть(Реквизит.Имя);
//			Если ВремТаблица.Количество() = 1 Тогда 
//				Продолжить;
//			КонецЕсли;
//		КонецЕсли;                    
//		ТаблицаОтчета.Вывести(ПустаяЯчейка);
//		
//		НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
//		НаименованиеРеквизита.Параметры.НаименованиеРеквизитаПоля = Реквизит.Синоним;
//		ТаблицаОтчета.Присоединить(НаименованиеРеквизита);
//		
//		СтрокаСравнения = Неопределено;

//		Для Каждого Документ Из МассивКорректировок Цикл 
//			
//			СтрокаДанных = ДанныеПоРеквизитам.Найти(Документ, "Ссылка");
//			
//			Если ТипЗнч(Документ) = Тип("ДокументСсылка.КорректировкаЗаявкиПокупателя") Тогда
//				Если СтрокаДанных[Реквизит.Имя] =  СтрокаСравнения[Реквизит.Имя] Тогда 
//					ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
//				Иначе	
//					ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
//				КонецЕсли;
//			Иначе
//				ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
//			КонецЕсли;
//			СтрокаСравнения = СтрокаДанных;
//			ОбластьЗначениеРеквизита.Параметры.ЗначениеРеквизита = СтрокаДанных[Реквизит.Имя];
//			ТаблицаОтчета.Присоединить(ОбластьЗначениеРеквизита);
//		КонецЦикла;
//	КонецЦикла;
//	ТаблицаОтчета.ЗакончитьГруппуСтрок();
//	
//	ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//	Область = Макет.ПолучитьОбласть("ШапкаТабличныхЧастей");
//	ТаблицаОтчета.Вывести(Область);
//	
//	Для Каждого ТабличнаяЧасть Из Метаданные.Документы.ЗаявкаПокупателя.ТабличныеЧасти Цикл 
//		ДанныеПоТабличнойЧасти = ПолучитьДанныеПоТабличнойЧасти(ТабличнаяЧасть, Заявка, МассивКорректировок);
//		Если ДанныеПоТабличнойЧасти.Количество() > 0 Тогда 
//			ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//			ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(,"НомерСтроки");
//			ВремТаблица.Сортировать("НомерСтроки Убыв");
//			МаксНомерСтроки = ВремТаблица.Получить(0).НомерСтроки;
//			
//			Область = Макет.ПолучитьОбласть("ШапкаТабличнойЧасти");
//			Область.Параметры.НаименованиеТабличнойЧасти = ТабличнаяЧасть.Синоним;
//			ТаблицаОтчета.Вывести(Область);
//			ТаблицаОтчета.НачатьГруппуСтрок(ТабличнаяЧасть.Синоним);

//			Для НомерСтроки = 1 По МаксНомерСтроки Цикл
//				Если ТолькоИзменения Тогда 
//					Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтроки));
//					ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(Строки);
//					ВремТаблица.Колонки.Удалить("Ссылка");
//					Колонки = "";
//					Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл 
//						Если ПустаяСтрока(Колонки) Тогда 
//							Колонки = Реквизит.Имя;
//						Иначе
//							Колонки = Колонки + "," + Реквизит.Имя;
//						КонецЕсли;
//					КонецЦикла;
//					КоличествоСтрок = ВремТаблица.Количество(); 
//					ВремТаблица.Свернуть(Колонки);
//					Если КоличествоСтрок = МассивКорректировок.Количество() И ВремТаблица.Количество() = 1 Тогда 
//						Продолжить;
//					КонецЕсли;
//				КонецЕсли;
//				ТаблицаОтчета.Вывести(ОбластьПустаяСтрока);
//				
//				ОбластьСтроки = Макет.ПолучитьОбласть("ШапкаСтрокиТабличнойЧасти");
//				//НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
//				ОбластьСтроки.Параметры.НомерСтрокиТабличнойЧасти = Строка(НомерСтроки);
//				ТаблицаОтчета.Вывести(ОбластьСтроки);
//				
//				ТаблицаОтчета.НачатьГруппуСтрок(ТабличнаяЧасть.Синоним + " Строка № " + Строка(НомерСтроки));
//				
//				Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл 
//					Если ТолькоИзменения Тогда 
//						Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("НомерСтроки", НомерСтроки));
//						ВремТаблица = ДанныеПоТабличнойЧасти.Скопировать(Строки, Реквизит.Имя);
//						КоличествоСтрок = ВремТаблица.Количество(); 
//						ВремТаблица.Свернуть(Реквизит.Имя);
//						Если КоличествоСтрок = МассивКорректировок.Количество() И ВремТаблица.Количество() = 1 Тогда 
//							Продолжить;
//						КонецЕсли;
//					КонецЕсли;  
//					ТаблицаОтчета.Вывести(ПустаяЯчейка);
//					
//					НаименованиеРеквизита = Макет.ПолучитьОбласть("НаименованиеРеквизитаПоля");
//					НаименованиеРеквизита.Параметры.НаименованиеРеквизитаПоля = Реквизит.Синоним;
//					ТаблицаОтчета.Присоединить(НаименованиеРеквизита);
//					
//					ЗначениеСравнения = Неопределено;
//					
//					Для Каждого Документ Из МассивКорректировок Цикл
//						Строки = ДанныеПоТабличнойЧасти.НайтиСтроки(Новый Структура("Ссылка,НомерСтроки",Документ,НомерСтроки));
//						Если Строки.Количество() <> 0 Тогда 
//							Если Строки.Получить(0)[Реквизит.Имя] = ЗначениеСравнения ИЛИ ТипЗнч(Документ) = Тип("ДокументСсылка.ЗаявкаПокупателя") Тогда 
//								ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИсходноеЗначениеРеквизита");
//							Иначе
//								ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
//							КонецЕсли;
//							ЗначениеСравнения = Строки.Получить(0)[Реквизит.Имя];
//						Иначе
//							ОбластьЗначениеРеквизита = Макет.ПолучитьОбласть("ИзмененноеЗначениеРеквизита");
//							ЗначениеСравнения = Неопределено;
//						КонецЕсли;
//						ОбластьЗначениеРеквизита.Параметры.ЗначениеРеквизита = ЗначениеСравнения;
//						ТаблицаОтчета.Присоединить(ОбластьЗначениеРеквизита);
//					КонецЦикла;
//				КонецЦикла;
//				ТаблицаОтчета.ЗакончитьГруппуСтрок();
//			КонецЦикла;
//			ТаблицаОтчета.ЗакончитьГруппуСтрок();
//		КонецЕсли;
//	КонецЦикла;
//	ТаблицаОтчета.ФиксацияСверху = 3;
//		
//	Возврат ТаблицаОтчета;
//	

//КонецФункции

