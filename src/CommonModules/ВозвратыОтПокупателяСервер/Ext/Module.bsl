﻿
#Область Команды

Процедура ЗаполнитьКомандыНаФорме( пФорма, ТекущийСтатус, пИзменяетСохраняемыеДанные ) Экспорт
	
	новТаблицаКоманд = Справочники.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТаблицаКомандДляТекущегоСтатуса(ТекущийСтатус);
	
	ДокументОбъект = ДанныеФормыВЗначение(пФорма.Объект, Тип("ДокументОбъект.АктРассмотренияВозврата"));
	Для каждого цСтрока ИЗ новТаблицаКоманд Цикл
		//Установим доступность кнопки. Если условие для перехода не выполнено, то кнопка недоступна
		ТекстОшибки = "";
		Если НЕ УсловияКомандыВыполнены(цСтрока.Команда, ДокументОбъект, ТекстОшибки, Ложь) Тогда
			цСтрока.Доступность = Ложь;
			цСтрока.Подсказка 	= ТекстОшибки;
		КонецЕсли;
	КонецЦикла;
	
	//удалить старые команды
	ОчиститьКомандыФормы( пФорма, новТаблицаКоманд );
	ОчиститьКнопкиПодКомандыПроцесса( пФорма, новТаблицаКоманд );
	
	//прочитать данные о командах
	пФорма.ТаблицаКоманд.Загрузить( новТаблицаКоманд );
	СоздатьКомандыФормы( пФорма, пИзменяетСохраняемыеДанные );
	СоздатьКнопкиПодКомандыПроцесса( пФорма );
	
КонецПроцедуры	//ЗаполнитьКомандыНаФорме


Процедура ОчиститьКомандыФормы( пФорма, пНовТаблицаКоманд )
	
	Для каждого цСтрока Из пФорма.ТаблицаКоманд Цикл
		
		командаФормы = пФорма.Команды.Найти( цСтрока.имяКомандыФормы );
		нетВНовойТаблице = пНовТаблицаКоманд.Найти( цСтрока.Команда, "Команда" ) = Неопределено;
		
		Если Не командаФормы = Неопределено
			И нетВНовойТаблице Тогда
			
			пФорма.Команды.Удалить( командаФормы );
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	//ОчиститьКомандыФормы

Процедура ОчиститьКнопкиПодКомандыПроцесса( пФорма, пНовТаблицаКоманд )
	
	Для каждого цСтрока Из пФорма.ТаблицаКоманд Цикл
		
		кнопка = пФорма.Элементы.Найти( цСтрока.ИмяКнопки );
		нетВНовойТаблице = пНовТаблицаКоманд.Найти( цСтрока.Команда, "Команда" ) = Неопределено;
		
		Если Не кнопка = Неопределено
			И нетВНовойТаблице Тогда
			
			пФорма.Элементы.Удалить( кнопка );
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	//ОчиститьКнопкиПодКомандыПроцесса


Процедура СоздатьКомандыФормы( пФорма, пИзменяетСохраняемыеДанные )
	
	Для каждого цСтрока Из пФорма.ТаблицаКоманд Цикл
		
		имяКомандыФормы = ПрефиксКоманд() + цСтрока.ИмяКоманды;
		
		цСтрока.имяКомандыФормы = имяКомандыФормы;
		
		новКоманда = пФорма.Команды.Найти( имяКомандыФормы );
		
		Если новКоманда = Неопределено Тогда
			
			новКоманда = пФорма.Команды.Добавить( имяКомандыФормы );
			новКоманда.Действие                  = "ВыполнитьКоманду";
			новКоманда.Заголовок                 = цСтрока.НаименованиеКоманды;
			новКоманда.Отображение               = ОтображениеКнопки.КартинкаИТекст;
			новКоманда.ИзменяетСохраняемыеДанные = пИзменяетСохраняемыеДанные;
			новКоманда.Подсказка				 = цСтрока.Подсказка;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	//СоздатьКомандыФормы

Процедура СоздатьКнопкиПодКомандыПроцесса(пФорма)
	

	Для каждого цСтрока Из пФорма.ТаблицаКоманд Цикл
		
		Если цСтрока.Расположение = Перечисления.РасположенияКомандыПроцесса.НеОтображатьНаФорме Тогда
			
			Продолжить;
			
		ИначеЕсли цСтрока.Расположение = Перечисления.РасположенияКомандыПроцесса.ВнизуФормы Тогда
			
			лЭлементРодитель = пФорма.Элементы.ГруппаКомандыПроцесса_ВнизуФормы;
			
		ИначеЕсли цСтрока.Расположение = Перечисления.РасположенияКомандыПроцесса.ВверхуФормы Тогда
			
			лЭлементРодитель = пФорма.Элементы.ГруппаКомандыПроцесса_ВверхуФормы;
			
		Иначе
			
			лЭлементРодитель = пФорма.Элементы.ГруппаКомандыПроцесса_Подменю;
			
		КонецЕсли;
		
		имяКнопки = ПрефиксКнопок() + цСтрока.ИмяКоманды;
		цСтрока.ИмяКнопки = имяКнопки;
		
		новКнопка = пФорма.Элементы.Найти( имяКнопки );
		
		Если новКнопка = Неопределено Тогда
			
			новКнопка = пФорма.Элементы.Добавить( имяКнопки , Тип( "КнопкаФормы" ), лЭлементРодитель);
			новКнопка.ИмяКоманды = цСтрока.имяКомандыФормы;
			
		КонецЕсли;
		
		новКнопка.Доступность 			= цСтрока.Доступность;
		новКнопка.ОтображениеПодсказки 	= ОтображениеПодсказки.Кнопка;
		
	КонецЦикла;
	
КонецПроцедуры	//СоздатьКнопкиПодКомандыПРоцесса


Функция ПрефиксКоманд()
	
	Возврат "КомандаПроцесса_";
	
КонецФункции	//ПрефиксКоманд

Функция ПрефиксКнопок()
	
	Возврат "Кнопка_";
	
КонецФункции	//ПрефиксКнопок

Функция УсловияКомандыВыполнены(пКоманда, ДокументОбъект, ТекстОшибки = "", СообщатьОбОшибке = Истина, Автомат = Ложь) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_ВозвратыОтПокупателяСервер_УсловияКомандыВыполнены";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	
	Успешно = Истина;
	
	ИК = Справочники.ИменованныеКонстантыПроцессов.СтруктураКонстант();
	
	//Проверим что выполняются условия для изменения статуса
	Результат = Неопределено;
	Для каждого СтрокаАлгоритма Из пКоманда.ТаблицаУсловий Цикл
		
		Если ТипЗнч(пКоманда) = Тип("СправочникСсылка.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя") Тогда
			Если Автомат И СтрокаАлгоритма.Ограничение = Перечисления.ОграниченияВыполненияУсловийПроцессов.ТолькоВручную Тогда
				Продолжить;
			КонецЕсли;
			Если НЕ Автомат И СтрокаАлгоритма.Ограничение = Перечисления.ОграниченияВыполненияУсловийПроцессов.ТолькоАвтоматически Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;

		лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Условие);
		
		Выполнить(СтрокаАлгоритма.Условие.Алгоритм);
		
		Если Результат = Неопределено Тогда
			ТекстОшибки = "Команда "+пКоманда.Наименование+". Не определен результат в условии """+СтрокаАлгоритма.Условие.Наименование+""" ("+СтрокаАлгоритма.Условие.Код+")!";
			Успешно =  Ложь;
			Прервать;
		КонецЕсли;
		
		Если Результат <>  СтрокаАлгоритма.Результат Тогда
			ТекстОшибки = "Команда "+пКоманда.Наименование+". Не выполнено условие """+СтрокаАлгоритма.Условие.Наименование+""" ("+СтрокаАлгоритма.Условие.Код+")!";
			Если ЗначениеЗаполнено(СтрокаАлгоритма.Условие.СообщениеПриНевыполнении) Тогда
				ТекстОшибки = ТекстОшибки + Символы.ПС + СтрокаАлгоритма.Условие.СообщениеПриНевыполнении;
			КонецЕсли;	
			Успешно =  Ложь;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если СообщатьОбОшибке Тогда
		ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
	КонецЕсли;
	
	Возврат Успешно;
	
КонецФункции

Функция ВыполнитьКомандуДляАРВ(пКоманда, пФорма = Неопределено, ДокументСсылка = Неопределено, ТекстОшибки = "", Автомат = Ложь) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_ВозвратыОтПокупателяСервер_ВыполнитьКомандуДляАРВ";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	Успешно = Истина;
	
	Если пФорма <>  Неопределено Тогда
		ДокументОбъект = ДанныеФормыВЗначение(пФорма.Объект, Тип("ДокументОбъект.АктРассмотренияВозврата"));
		ДокументОбъект.ДополнительныеСвойства.Вставить("ИзмененныеРеквизиты", пФорма.ИзмененныеРеквизиты);
	Иначе
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЭтоКомандаИзмененияСтатуса = ТипЗнч(пКоманда) = Тип("СправочникСсылка.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя");
	ИК = Справочники.ИменованныеКонстантыПроцессов.СтруктураКонстант();
	
	Если ЭтоКомандаИзмененияСтатуса Тогда
		Если НЕ УсловияКомандыВыполнены(пКоманда, ДокументОбъект, , Истина, Автомат) Тогда
			 Успешно =  Ложь;
		КонецЕсли;
	КонецЕсли;
	
	//Обработчики Команды
	ДополнительныйТекстСобытия = "";
	Для каждого СтрокаАлгоритма Из пКоманда.Обработчики Цикл
		
		ДопТекстСобытия = "";
		лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Обработчик);
		
		Попытка
			Выполнить(СтрокаАлгоритма.Обработчик.Алгоритм);
		Исключение
			ТекстОшибки = "Команда "+пКоманда.Наименование+". Ошибка выполнения алгоритма  """+СтрокаАлгоритма.Обработчик+""" ("+СтрокаАлгоритма.Обработчик.Код+")! Описание ошибки: "+ОписаниеОшибки();
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
			Успешно =  Ложь;
		КонецПопытки;
		
		ДополнительныйТекстСобытия = ДополнительныйТекстСобытия + ДопТекстСобытия;
	КонецЦикла;
	
	//Алгоритм перед установкой нового статуса
	Если ЭтоКомандаИзмененияСтатуса Тогда
		Для каждого СтрокаАлгоритма Из пКоманда.СледующийСтатус.ТаблицаАлгоритмов Цикл
			
			Если СтрокаАлгоритма.МоментВыполненияАлгоритма = Перечисления.МоментыВыполненияАлгоритма.ПередУстановкойСтатуса Тогда
				
				лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Алгоритм);
				
				Попытка
					Выполнить(СтрокаАлгоритма.Алгоритм.Алгоритм);
				Исключение
					ТекстОшибки = "Команда "+пКоманда.Наименование+". Ошибка выполнения алгоритма перед установкой статуса """+СтрокаАлгоритма.Алгоритм+""" ("+СтрокаАлгоритма.Алгоритм.Код+")! Описание ошибки: "+ОписаниеОшибки();
					ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
					Успешно =  Ложь;
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;	
	
	//Установим адресацию
	Если ЭтоКомандаИзмененияСтатуса Тогда
		НовыйОтвественныйГруппа = пКоманда.СледующийСтатус.Ответственный;
		Если ЗначениеЗаполнено(НовыйОтвественныйГруппа) Тогда
			
			Ответственный = ДокументОбъект.Ответственный;
			Если Не ЗначениеЗаполнено(Ответственный) Тогда
				
				ДокументОбъект.Ответственный = НовыйОтвественныйГруппа;
				
			Иначе //Меняем ответственного только если у текущего ответственного группа отличается от новой
				
				Если ТипЗнч(Ответственный) = Тип("СправочникСсылка.Пользователи") Тогда
					ОтветственныйГруппа = Ответственный.ГруппаДоступаКСтатусамПроцессаВозвратаОтПокупателя;
				Иначе //Группа
					ОтветственныйГруппа = Ответственный;
				КонецЕсли;
				
				Если ОтветственныйГруппа <>  НовыйОтвественныйГруппа Тогда
					ДокументОбъект.Ответственный = НовыйОтвественныйГруппа;
				КонецЕсли;
			КонецЕсли;

		КонецЕсли;
	КонецЕсли;
	
	СтарыйСтатус = Неопределено;
	Если успешно Тогда
		Если ЭтоКомандаИзмененияСтатуса Тогда
			СтарыйСтатус 					= ДокументОбъект.СтатусДокумента;
			ДокументОбъект.СтатусДокумента 	= пКоманда.СледующийСтатус;
		КонецЕсли;
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЕсли;
	
	
	//Алгоритм После установки нового статуса
	Если ЭтоКомандаИзмененияСтатуса И успешно Тогда
		Для каждого СтрокаАлгоритма Из пКоманда.СледующийСтатус.ТаблицаАлгоритмов Цикл
			
			Если СтрокаАлгоритма.МоментВыполненияАлгоритма = Перечисления.МоментыВыполненияАлгоритма.ПослеУстановкиСтатуса Тогда
				
				лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Алгоритм);
				
				Попытка
					Выполнить(СтрокаАлгоритма.Алгоритм.Алгоритм);
				Исключение
					ТекстОшибки = "Команда "+пКоманда.Наименование+". Ошибка выполнения алгоритма после установки статуса """+СтрокаАлгоритма.Алгоритм+""" ("+СтрокаАлгоритма.Алгоритм.Код+")! Описание ошибки: "+ОписаниеОшибки();
					ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
					Успешно =  Ложь;
				КонецПопытки;
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	//Запишем в события
	Если успешно Тогда
		ПараметрыСобытия = РегистрыСведений.СобытияАктовРассмотренияВозврата.ИнициализироватьСтруктуруПараметровСобытия();
		ПараметрыСобытия.Описание = "Выполнена команда: "+пКоманда+". "+ДополнительныйТекстСобытия;
		ЗаполнитьЗначенияСвойств(ПараметрыСобытия, ДокументОбъект);
		РегистрыСведений.СобытияАктовРассмотренияВозврата.ДобавитьСобытие(ДокументОбъект.Ссылка, ПараметрыСобытия); 
	КонецЕсли;

	
	Если пФорма <>  Неопределено И Успешно Тогда
		ЗначениеВДанныеФормы(ДокументОбъект, пФорма.Объект);
	КонецЕсли;

	
	Возврат успешно;
	
КонецФункции

Функция ВыполнитьКомандуДляАРВВТранзакции( пКоманда, пФорма = Неопределено, ДокументСсылка = Неопределено, ТекстОшибки = "", Автомат = Ложь) Экспорт
	
	лКлючАлгоритма = "ОбщийМодуль_ВозвратыОтПокупателяСервер_ВыполнитьКомандуДляАРВВТранзакции";
	лЗамена =  АлгоритмыПолучитьЗамену(лКлючАлгоритма);
	Если Не лЗамена = Неопределено Тогда
		АлгоритмыЗначениеВозврата = Неопределено;		
		Выполнить(лЗамена);		
		Возврат АлгоритмыЗначениеВозврата;		
	КонецЕсли;	
	///////////////////////////////////////////////////////////////////////////
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	успешно = ВыполнитьКомандуДляАРВ(пКоманда, пФорма, ДокументСсылка, ТекстОшибки, Автомат);
	
	Если успешно Тогда
		ЗафиксироватьТранзакцию();
	Иначе
		ОтменитьТранзакцию();
	КонецЕсли;
	
	Возврат успешно;
	
КонецФункции

#КонецОбласти

#Область СозданиеНаОсновании

Функция СоздатьЭлектронноеПисьмоНаОсновании(АктСсылка, Кому = "Покупатель", ВидКИ = Неопределено) Экспорт
	
	ЭП = Документы.ЭлектронноеПисьмо.СоздатьДокумент();
	СтруктураЗаполнения = Новый Структура("Основание, Кому, ВидКИ", АктСсылка, Кому, ВидКИ);
	ЭП.Заполнить(СтруктураЗаполнения);
	ЭП.ПолучитьФорму().Открыть();
	
КонецФункции


#КонецОбласти

Функция РазрешитьРучноеРедактированиеАРВ() Экспорт
	
	РазрешитьРучноеРедактированиеАРВ = НастройкаПравДоступа.ПолучитьЗначениеПраваПользователя(ПараметрыСеанса.ТекущийПользователь, 
	ПланыВидовХарактеристик.ПраваПользователей.РазрешитьРучноеРедактированиеАРВ);
	
	Возврат РазрешитьРучноеРедактированиеАРВ;
	
КонецФункции

Функция КаталогОбменаССайтом(СообщатьОбОшибке = Ложь, ВызыватьИсключение = Ложь, Тип = 1) Экспорт
	
	//Тип=1 - основной каталог
	//Тип=2 - каталог вырузки акта приема-передачи
	//Тип=3 - каталог вырузки отказов в возврате
	
	ТекстОшибки = "Не задан каталог обмена с сайтом";
	
	Если Тип = 1 Тогда
		Настройка = Справочники.НастройкиРеквизитовДляОбменов.Обмен_1С_Сайт_ВозвратыОсновной;
	ИначеЕсли Тип = 2 Тогда
		Настройка = Справочники.НастройкиРеквизитовДляОбменов.Обмен_1С_Сайт_ВозвратыАктыПриемаПередачи;
	ИначеЕсли Тип = 3 Тогда
		Настройка = Справочники.НастройкиРеквизитовДляОбменов.Обмен_1С_Сайт_ВозвратыОтказы;
	КонецЕсли;

	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда
		Адрес = Настройка.СтрокаДляРабочейБазы;
	Иначе
		Адрес = Настройка.СтрокаДляТестовойБазы;
	КонецЕсли;
	
	Если СообщатьОбОшибке И Не ЗначениеЗаполнено(Адрес) Тогда
		Сообщить(ТекстОшибки);
	КонецЕсли;
	
	Если ВызыватьИсключение И Не ЗначениеЗаполнено(Адрес) Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если Прав(Адрес, 1) <> "\" Тогда
		Адрес = Адрес + "\";
	КонецЕсли;
	
	Возврат Адрес;
	
КонецФункции

Функция МинутыВСтроку(КоличествоМинут) Экспорт
	
	Если Не ЗначениеЗаполнено(КоличествоМинут) Тогда
		Возврат ""		
	КонецЕсли;
	
	Дней 	= Цел(КоличествоМинут/1440);
	Часов 	= Цел((КоличествоМинут-Дней*1440)/60);
	Минут 	= Цел((КоличествоМинут - (Часов*60 + Дней*1440)));
	
	СтрокаВремениВыполнения = ?(Дней = 0, "", "" + Дней+" дн. ") + Часов + " час. " + ?(Минут = 0, "00", Формат(Минут, "ЧЦ=2; ЧДЦ=0; ЧВН="))+" мин.";
	
	Возврат  СтрокаВремениВыполнения;
	
КонецФункции

Функция УчетнаяЗаписьЭлектроннойПочтыВозвраты() Экспорт
	
	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда
		Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ВозвратыКлиентов;
	Иначе
		Возврат Справочники.УчетныеЗаписиЭлектроннойПочты.ВозвратыКлиентовТест;
	КонецЕсли;
	
	
КонецФункции

Функция АдресОтправкиПочтыКонтрагенту(Контрагент, ВидыКИ = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидыКИ) Тогда
		МассивВидовКИ = Новый Массив;
	ИначеЕсли ТипЗнч(ВидыКИ) = Тип("СправочникСсылка.ВидыКонтактнойИнформации") Тогда
		МассивВидовКИ = Новый Массив;
	    МассивВидовКИ.Добавить(ВидыКИ);
	ИначеЕсли ТипЗнч(ВидыКИ) = Тип("Массив") Тогда
	    МассивВидовКИ = ВидыКИ;
	Иначе
		Возврат "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА КонтактнаяИнформация.Вид = &ПочтаДляВозвратов
		|			ТОГДА 1
		|		КОГДА КонтактнаяИнформация.Вид = &ПочтаДляДокументов
		|			ТОГДА 2
		|		ИНАЧЕ 3
		|	КОНЕЦ КАК Приоритет,
		|	КонтактнаяИнформация.Представление
		|ИЗ
		|	РегистрСведений.КонтактнаяИнформация КАК КонтактнаяИнформация
		|ГДЕ
		|	КонтактнаяИнформация.Объект = &Объект
		|				И (КонтактнаяИнформация.Вид В (&СписокВидовКИ)
		|			ИЛИ &ВсеВиды)
		|    
		|УПОРЯДОЧИТЬ ПО
		|	Приоритет";
	
	Запрос.УстановитьПараметр("СписокВидовКИ", МассивВидовКИ);
	Запрос.УстановитьПараметр("ВсеВиды", МассивВидовКИ.Количество() = 0);
	Запрос.УстановитьПараметр("ПочтаДляВозвратов", Справочники.ВидыКонтактнойИнформации.EmailДляВозвратов);
	Запрос.УстановитьПараметр("ПочтаДляДокументов", Справочники.ВидыКонтактнойИнформации.EmailДляОбменаДокументамиСКонтрагентами);
	Запрос.УстановитьПараметр("Объект", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	ВозвращаемоеЗначение = "";
	Пока Выборка.Следующий() Цикл
		Если СтрНайти(Выборка.Представление, "@") > 0 Тогда
			ВозвращаемоеЗначение = Выборка.Представление;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция СрокВозвратаТовараКлиентомДней() Экспорт
	
	Возврат Константы.СрокВозвратаТовараКлиентомДней.Получить();
	
КонецФункции

Функция АдресВложенийСайта() Экспорт
	
	Если ОбщегоНазначения.ЭтоРабочаяИнформационнаяБаза() Тогда
		Возврат "http://www.part-kom.ru/parts/returnRequestImg.php?rrId=";
	Иначе
		Возврат "http://pre.part-kom.ru/parts/returnRequestImg.php?rrId=";
	КонецЕсли;
	
КонецФункции

Процедура ОтразитьВозвратПечатныхДокументов(ВозвратОтПокупателя, Возвращено = Истина, Знач ВидПД = Неопределено) Экспорт
	
	Если Возвращено = Ложь Тогда
		Возврат; //Снятие отметки пока не обрабатываем
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидПД) Тогда
		ВидПД = Перечисления.ВидыПечатныхДокументов.УКД;
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ВозвратОтПокупателя, "АктРассмотренияВозврата, АктРассмотренияВозврата.СтатусПроверкиДокументовПокупателя");
	НовыйСтатусПроверки = ?(Возвращено, Перечисления.АРВ_СтатусыПроверкиДокументовПокупателя.Проверены, Перечисления.АРВ_СтатусыПроверкиДокументовПокупателя.НеПроверены);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый); 
	
	РегистрыСведений.ДатыВозвратаДокументов.Добавить(ВозвратОтПокупателя, ВидПД);
	
	Если  ЗначениеЗаполнено(Реквизиты.АктРассмотренияВозврата)
		И НовыйСтатусПроверки <> Реквизиты.АктРассмотренияВозвратаСтатусПроверкиДокументовПокупателя Тогда
		
		АктОбъект =  Реквизиты.АктРассмотренияВозврата.ПолучитьОбъект();
		АктОбъект.Заблокировать();
		АктОбъект.СтатусПроверкиДокументовПокупателя = НовыйСтатусПроверки;
		АктОбъект.ДополнительныеСвойства.Вставить("СохранитьВИсториюИзменения", "Статус проверки документов покупателя: "+НовыйСтатусПроверки);
		АктОбъект.Записать();		
		
	КонецЕсли;	
	
	ЗафиксироватьТранзакцию();	
	
КонецПроцедуры

Функция ПредставлениеНоменклатурыДляСайта(
	Знач Изготовитель = Неопределено, 
	Знач Артикул = Неопределено, 
	Знач Наименование = Неопределено,
	Знач ЕдиницаИзмерения = Неопределено,
	Количество = 0, 
	Номенклатура = Неопределено, 
	ВключатьКоличество = Истина) Экспорт
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		
		Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Номенклатура, "Изготовитель.Наименование, Артикул, Наименование, ЕдиницаХраненияОстатков.Наименование");
		
		Изготовитель 		= Реквизиты.ИзготовительНаименование;
		Артикул 			= Реквизиты.Артикул;
		Наименование 		= Реквизиты.Наименование;
		ЕдиницаИзмерения	= Реквизиты.ЕдиницаХраненияОстатковНаименование
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЕдиницаИзмерения)
		И Прав(ЕдиницаИзмерения,1) <> "." Тогда
		ЕдиницаИзмерения = ЕдиницаИзмерения+".";		
	КонецЕсли;
	
	//Изготовитель|Артикул|Наименование|количество "шт."	
	ПредставлениеНоменклатурыДляСайта = ""+Изготовитель+" | "+Артикул+" | "+Наименование+
	?(ВключатьКоличество, " | "+Количество+" "+ЕдиницаИзмерения, "");
	
	Возврат ПредставлениеНоменклатурыДляСайта;	
	
КонецФункции
