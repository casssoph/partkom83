﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт
		
	лКлючАлгоритма = "Обработка_ОтложенноеПроведениеДокументовИзТоплог_ВыполнитьРегламентноеЗадание";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		Выполнить(лЗамена);
		Возврат;
	КонецЕсли;

	АктуализацияОшибокТопЛог();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОтложенноеПроведениеДокументовИзТопЛог.СсылкаНаДокумент,
	|	ВЫБОР
	|		КОГДА ОтложенноеПроведениеДокументовИзТопЛог.СсылкаНаДокумент ССЫЛКА Документ.ПоступлениеТоваровУслуг
	|			ТОГДА 0
	|		КОГДА ОтложенноеПроведениеДокументовИзТопЛог.СсылкаНаДокумент ССЫЛКА Документ.ПеремещениеТоваров
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК Порядок,
	|	ОтложенноеПроведениеДокументовИзТопЛог.СтатусДокумента
	|ИЗ
	|	РегистрСведений.ОтложенноеПроведениеДокументовИзТопЛог КАК ОтложенноеПроведениеДокументовИзТопЛог
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	ОтложенноеПроведениеДокументовИзТопЛог.СсылкаНаДокумент.Дата";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
			Попытка
				Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.СсылкаНаДокумент, "Проведен,СтатусДокумента,ПометкаУдаления");
				Если Реквизиты.ПометкаУдаления = Истина Или (Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен И Реквизиты.Проведен = Истина И (Не ЗначениеЗаполнено(Выборка.СтатусДокумента) Или Выборка.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен))  
					Или ((Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче Или Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен) И Реквизиты.Проведен = Истина И Выборка.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче)
					Или  ((Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугУпакован Или Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугГотовКВыдаче Или Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен) И Реквизиты.Проведен = Истина И Выборка.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугУпакован) Тогда 
					лНаборЗаписей = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
					лНаборЗаписей.Отбор.СсылкаНаДокумент.Установить(Выборка.СсылкаНаДокумент);
					лНаборЗаписей.Записать(Истина);				
				Иначе
					ДокОбъект = Выборка.СсылкаНаДокумент.ПолучитьОбъект();
					Если Не ЗначениеЗаполнено(Выборка.СтатусДокумента) Или  Выборка.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен  Тогда 
						ДокОбъект.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен;
					Иначе
						ДокОбъект.СтатусДокумента = Выборка.СтатусДокумента;
					КонецЕсли;
					//Если ДокОбъект.СтатусДокумента <> Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен Тогда 
					//	ДокОбъект.Дата = ТекущаяДата();
					//КонецЕсли;
					ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
				КонецЕсли;
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
			КонецПопытки;
		ИначеЕсли ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда 
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.СсылкаНаДокумент, "ПометкаУдаления,Проведен,СтатусДокумента,ДокументОснование, ДокументОснование.СтатусДокумента, ДокументОснование.ОбновленИзТопЛог, ДокументОснование.Дата, ДокументОснование.Склад.СкладПриемки");
			
			УсловиеПоступление = ТипЗнч(Реквизиты.ДокументОснование) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") И (Реквизиты.ДокументОснованиеСтатусДокумента = Справочники.СтатусыДокументов.ПоступлениеТоваровПринят Или
			Реквизиты.ДокументОснованиеСтатусДокумента = Справочники.СтатусыДокументов.ПоступлениеТоваровРазмещен);
			УсловиеПеремещение =  ТипЗнч(Реквизиты.ДокументОснование) = Тип("ДокументСсылка.ПеремещениеТоваров") И (Реквизиты.ДокументОснование.ОбновленИзТопЛог = Истина Или СтрНачинаетсяС(Реквизиты.ДокументОснование.Номер, "D")
			Или ПроведениеДокументовКлиентСервер.ИсходящееПеремещениеРазрешеноРазмещениеБезСборки(Реквизиты.ДокументОснование));
			
			Если Реквизиты.ПометкаУдаления = Истина Или (Реквизиты.СтатусДокумента = Справочники.СтатусыДокументов.ПеремещениеТоваровПоступил И Реквизиты.Проведен = Истина) Тогда 
				лНаборЗаписей = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
				лНаборЗаписей.Отбор.СсылкаНаДокумент.Установить(Выборка.СсылкаНаДокумент);
				лНаборЗаписей.Записать(Истина);				
			ИначеЕсли  УсловиеПоступление Или УсловиеПеремещение Тогда 
				НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
				Попытка
					ДокОбъект = Выборка.СсылкаНаДокумент.ПолучитьОбъект();
					//Если ДокОбъект.Дата < Реквизиты.ДокументОснованиеДата Тогда 
					//	ДокОбъект.Дата = Реквизиты.ДокументОснованиеДата + 1;
					//КонецЕсли;	
					ДокОбъект.Дата = ТекущаяДата();
					
					Если УсловиеПоступление И ДокОбъект.СкладОтправитель <> Реквизиты.ДокументОснованиеСкладСкладПриемки Тогда 
						ДокОбъект.СкладОтправитель = Реквизиты.ДокументОснованиеСкладСкладПриемки;	
					КонецЕсли;
					
					ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
					
					лНаборЗаписей = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
					лНаборЗаписей.Отбор.СсылкаНаДокумент.Установить(Выборка.СсылкаНаДокумент);
					лНаборЗаписей.Записать(Истина);				
					
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
				КонецПопытки;
			КонецЕсли;
		ИначеЕсли  ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.ПоступлениеТоваровУслуг") Тогда 
			НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
			Попытка
				ДокОбъект = Выборка.СсылкаНаДокумент.ПолучитьОбъект();
				ДокОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ПоступлениеТоваровПринят;
				
				ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
				
				лНаборЗаписей = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
				лНаборЗаписей.Отбор.СсылкаНаДокумент.Установить(Выборка.СсылкаНаДокумент);
				лНаборЗаписей.Записать(Истина);				
				
				ЗафиксироватьТранзакцию();
			Исключение
				ОтменитьТранзакцию();
			КонецПопытки;
		ИначеЕсли  ТипЗнч(Выборка.СсылкаНаДокумент) = Тип("ДокументСсылка.ВозвратТоваровОтПокупателя") Тогда 
			
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Выборка.СсылкаНаДокумент, "СтатусДокумента");
			
			Если Реквизиты.СтатусДокумента =  Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяНовый Тогда
				
				НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
				Попытка
					ДокОбъект = Выборка.СсылкаНаДокумент.ПолучитьОбъект();
					//ДокОбъект.СтатусДокумента = Справочники.СтатусыДокументов.ВозвратТоваровОтПокупателяПринят;
					
					ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
					
					лНаборЗаписей = РегистрыСведений.ОтложенноеПроведениеДокументовИзТопЛог.СоздатьНаборЗаписей();
					лНаборЗаписей.Отбор.СсылкаНаДокумент.Установить(Выборка.СсылкаНаДокумент);
					лНаборЗаписей.Записать(Истина);				
					
					ЗафиксироватьТранзакцию();
				Исключение
					ОтменитьТранзакцию();
				КонецПопытки;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	
КонецПроцедуры

Процедура АктуализацияОшибокТопЛог()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ОшибкиПриОбменеСТопЛог.ОбъектXDTO,
	|	ОшибкиПриОбменеСТопЛог.GUID,
	|	ОшибкиПриОбменеСТопЛог.GUIDДоп,
	|	ОшибкиПриОбменеСТопЛог.ИмяОбъектаМетаданных,
	|	ОшибкиПриОбменеСТопЛог.СообщениеОбОшибке,
	|	ОшибкиПриОбменеСТопЛог.НомерСообщения,
	|	ОшибкиПриОбменеСТопЛог.ДатаЗагрузкиСообщения
	|ИЗ
	|	РегистрСведений.ОшибкиПриОбменеСТопЛог КАК ОшибкиПриОбменеСТопЛог
	|ГДЕ
	|	ОшибкиПриОбменеСТопЛог.GUID <> """"";
	Выборка = Запрос.Выполнить().Выбрать();
	Очищено = 0;
	Пока Выборка.Следующий() Цикл 
		Если Выборка.ИмяОбъектаМетаданных = "ПоступлениеТоваровУслуг" Тогда 
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ." +  Выборка.ИмяОбъектаМетаданных);
			
			ДокСсылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.GUID));
			
			Если ДокСсылка.Проведен И (ДокСсылка.СтатусДокумента = Справочники.СтатусыДокументов.ПоступлениеТоваровПринят
				или  ДокСсылка.СтатусДокумента = Справочники.СтатусыДокументов.ПоступлениеТоваровРазмещен) Тогда 
				НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
				НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
				НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
				НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
				НаборЗаписей.Записать();
				Очищено = Очищено + 1;
			КонецЕсли;
		ИначеЕсли Выборка.ИмяОбъектаМетаданных = "ПеремещениеТоваров" Тогда
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ." +  Выборка.ИмяОбъектаМетаданных);
			Если Выборка.ОбъектXDTO = "РезультатРазмещения" Тогда 
				Если ПустаяСтрока(Выборка.GUIDдоп) Тогда 
					Продолжить;
				КонецЕсли;
				ДокСсылка = Документы.ПоступлениеТоваровУслуг.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.GUIDдоп));
				
				Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ДокСсылка) Тогда 
					ДокСсылка = Документы.ПеремещениеТоваров.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.GUIDдоп));
				КонецЕсли;
				
				Если ОбменДаннымиКлиентСервер.ЭтоБитаяСсылка(ДокСсылка) Тогда
					Продолжить;
				КонецЕсли;
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	ПеремещениеТоваров.Ссылка
				|ИЗ
				|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
				|ГДЕ
				|	ПеремещениеТоваров.ДокументОснование = &ДокументОснование
				|	И ПеремещениеТоваров.РазмещениеСсылкаТопЛог = &РазмещениеСсылкаТопЛог
				|	И НЕ ПеремещениеТоваров.Проведен
				|;
				|
				|////////////////////////////////////////////////////////////////////////////////
				|ВЫБРАТЬ
				|	ПеремещениеТоваров.Ссылка
				|ИЗ
				|	Документ.ПеремещениеТоваров КАК ПеремещениеТоваров
				|ГДЕ
				|	ПеремещениеТоваров.ДокументОснование = &ДокументОснование
				|	И ПеремещениеТоваров.РазмещениеСсылкаТопЛог = &РазмещениеСсылкаТопЛог
				|	И ПеремещениеТоваров.Проведен";
				Запрос.УстановитьПараметр("ДокументОснование", ДокСсылка);
				Запрос.УстановитьПараметр("РазмещениеСсылкаТопЛог", Новый УникальныйИдентификатор(Выборка.GUID));
				Результаты = Запрос.ВыполнитьПакет();
				Если Результаты[0].Пустой() И Не Результаты[1].Пустой() Тогда 
					НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
					НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
					НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
					НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
					НаборЗаписей.Записать();
					Очищено = Очищено + 1;
				КонецЕсли;
			ИначеЕсли Выборка.ОбъектXDTO = "РезультатСборки" Тогда 
				ДокСсылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.GUID));
				Если ДокСсылка.Проведен И ДокСсылка.ОбновленИзТоплог Тогда 
					НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
					НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
					НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
					НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
					НаборЗаписей.Записать();
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли  Выборка.ИмяОбъектаМетаданных = "РеализацияТоваровУслуг" Тогда
			Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени("Документ." +  Выборка.ИмяОбъектаМетаданных);
			ДокСсылка = Менеджер.ПолучитьСсылку(Новый УникальныйИдентификатор(Выборка.GUID));
			Если ДокСсылка.Проведен И ДокСсылка.СтатусДокумента = Справочники.СтатусыДокументов.РеализацияТоваровУслугОтгружен Тогда  
				Если Не ДокСсылка.ПолныйОтказ Тогда 
					Запрос = Новый Запрос;
					Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
					|	Продажи.Регистратор
					|ИЗ
					|	РегистрНакопления.Продажи КАК Продажи
					|ГДЕ
					|	Продажи.Регистратор = &Регистратор";
					Запрос.УстановитьПараметр("Регистратор", ДокСсылка);
					Если Не Запрос.Выполнить().Пустой() Тогда 
						НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
						НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
						НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
						НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
						НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
						НаборЗаписей.Записать();
						Очищено = Очищено + 1;
					КонецЕсли;
				Иначе
					НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
					НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
					НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
					НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
					НаборЗаписей.Записать();
					Очищено = Очищено + 1;
				КонецЕсли;
			ИначеЕсли ДокСсылка.ПометкаУдаления Тогда 
				НаборЗаписей = РегистрыСведений.ОшибкиПриОбменеСТопЛог.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.ОбъектXDTO.Установить(Выборка.ОбъектXDTO);
				НаборЗаписей.Отбор.GUID.Установить(Выборка.GUID);
				НаборЗаписей.Отбор.GUIDДоп.Установить(Выборка.GUIDДоп);
				НаборЗаписей.Отбор.ИмяОбъектаМетаданных.Установить(Выборка.ИмяОбъектаМетаданных);
				НаборЗаписей.Записать();
				Очищено = Очищено + 1;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Сообщить("Очищено: " + Очищено);
КонецПроцедуры

