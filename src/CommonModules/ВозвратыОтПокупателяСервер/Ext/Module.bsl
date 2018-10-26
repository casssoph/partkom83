﻿
#Область Команды

Процедура ЗаполнитьКомандыНаФорме( пФорма, ТекущийСтатус, пИзменяетСохраняемыеДанные ) Экспорт
	
	новТаблицаКоманд = Справочники.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя.ТаблицаКомандДляТекущегоСтатуса(ТекущийСтатус);
	
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
			//новКоманда.Картинка                  = Справочники.упКоманды.ПолучитьКартинкуКоманды( цСтрока.имяКартинки );
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры	//СоздатьКомандыФормы

Процедура СоздатьКнопкиПодКомандыПроцесса( пФорма )
	
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
		
	КонецЦикла;
	
КонецПроцедуры	//СоздатьКнопкиПодКомандыПРоцесса


Функция ПрефиксКоманд()
	
	Возврат "КомандаПроцесса_";
	
КонецФункции	//ПрефиксКоманд

Функция ПрефиксКнопок()
	
	Возврат "Кнопка_";
	
КонецФункции	//ПрефиксКнопок


Функция ВыполнитьКомандуДляАРВ( пКоманда, пФорма = Неопределено, ДокументСсылка = Неопределено) Экспорт
	
	Успешно = Истина;
	
	Если пФорма <>  Неопределено Тогда
		ДокументОбъект = ДанныеФормыВЗначение(пФорма.Объект, Тип("ДокументОбъект.АктРассмотренияВозврата"));
	Иначе
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ЭтоКомандаИзмененияСтатуса = ТипЗнч(пКоманда) = Тип("СправочникСсылка.ВзаимосвязиСтатусовПроцессаВозвратаОтПокупателя");
	ИК = Справочники.ИменованныеКонстантыПроцессов.СтруктураКонстант();
	
	//Проверим что выполняются условия для изменения статуса
	Результат = Неопределено;
	Если ЭтоКомандаИзмененияСтатуса Тогда
		Для каждого СтрокаАлгоритма Из пКоманда.ТаблицаУсловий Цикл
			
			лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Условие);
			
			Выполнить(СтрокаАлгоритма.Условие.Алгоритм);
			
			Если Результат = Неопределено Тогда
				ТекстОшибки = "Команда "+пКоманда.Наименование+". Не определен результат в условии """+СтрокаАлгоритма.Условие.Наименование+""" ("+СтрокаАлгоритма.Условие.Код+")!";
				ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
				Успешно =  Ложь;
			КонецЕсли;
			
			Если Результат <>  СтрокаАлгоритма.Результат Тогда
				ТекстОшибки = "Команда "+пКоманда.Наименование+". Не выполнено условие """+СтрокаАлгоритма.Условие.Наименование+""" ("+СтрокаАлгоритма.Условие.Код+")!";
				ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
				Если ЗначениеЗаполнено(СтрокаАлгоритма.Условие.СообщениеПриНевыполнении) Тогда
					Сообщить(СтрокаАлгоритма.Условие.СообщениеПриНевыполнении);
				КонецЕсли;	
				Успешно =  Ложь;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	//Обработчики Команды
	Для каждого СтрокаАлгоритма Из пКоманда.Обработчики Цикл
		
		лИК = Справочники.АлгоритмыПроцессов.СтруктураКонстантАлгоритма(СтрокаАлгоритма.Обработчик);
		
		Попытка
			Выполнить(СтрокаАлгоритма.Обработчик.Алгоритм);
		Исключение
			ТекстОшибки = "Команда "+пКоманда.Наименование+". Ошибка выполнения алгоритма  """+СтрокаАлгоритма.Обработчик+""" ("+СтрокаАлгоритма.Обработчик.Код+")! Описание ошибки: "+ОписаниеОшибки();
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки,,,СтатусСообщения.Внимание);
			Успешно =  Ложь;
		КонецПопытки;
		
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
	Если ЭтоКомандаИзмененияСтатуса Тогда
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
		ПараметрыСобытия.Описание = "Выполнена команда: "+пКоманда;
		ЗаполнитьЗначенияСвойств(ПараметрыСобытия, ДокументОбъект);
		РегистрыСведений.СобытияАктовРассмотренияВозврата.ДобавитьСобытие(ДокументОбъект.Ссылка, ПараметрыСобытия); 
	КонецЕсли;

	
	Если пФорма <>  Неопределено И Успешно Тогда
		ЗначениеВДанныеФормы(ДокументОбъект, пФорма.Объект);
	КонецЕсли;

	
	Возврат успешно;
	
КонецФункции

Функция ВыполнитьКомандуДляАРВВТранзакции( пКоманда, пФорма = Неопределено, ДокументСсылка = Неопределено ) Экспорт
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	
	успешно = ВыполнитьКомандуДляАРВ(пКоманда, пФорма, ДокументСсылка);
	
	Если успешно Тогда
		ЗафиксироватьТранзакцию();
	Иначе
		ОтменитьТранзакцию();
	КонецЕсли;
	
	Возврат успешно;
	
КонецФункции

#КонецОбласти

#Область СозданиеНаОсновании

Функция СоздатьЭлектронноеПисьмоНаОсновании(АктСсылка) Экспорт
	
	ЭП = Документы.ЭлектронноеПисьмо.СоздатьДокумент();
	ЭП.Заполнить(АктСсылка);
	ЭП.ПолучитьФорму().Открыть();
	
КонецФункции





#КонецОбласти