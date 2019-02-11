﻿Перем мОснование;
Перем мПометкаУдаленияИзменилась;
Перем ЗарегистрироватьВОбмене;
Перем ЗарегистрироватьВОбмене_ОбменПартКом83_Сайт;
Перем ИзменениеБлокировки;
Перем ЗарегистрироватьВОбмене_ОбменПартКом83_77;

// Обработчик события ПриКопировании
//
Процедура ПриКопировании(ОбъектКопирования)

	Если НЕ ЭтотОбъект.ЭтоГруппа Тогда
		ЭтотОбъект.ОсновнойДоговорКонтрагента = Неопределено;
		ЭтотОбъект.ОсновнойДоговорКонтрагентаЗакупка = Неопределено;
		ЭтотОбъект.ОсновнойБанковскийСчет     = Неопределено;
		Если ОбъектКопирования.ГоловнойКонтрагент = ОбъектКопирования.Ссылка Тогда
			ЭтотОбъект.ГоловнойКонтрагент     = Неопределено;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

// Функция возвращает результат запроса по справочнику контрагентов с заданным головным контрагентом
//
// Параметры:
//  ГоловнойКонтрагент - заданный головной контрагент
//
// Возвращаемое значение:
//  Результат - результат работы запроса
// 
Функция ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(ГоловнойКонтрагент) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ГоловнойКонтрагент", ГоловнойКонтрагент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка КАК Контрагент,
	|	Контрагенты.ОбособленноеПодразделение КАК ОбособленноеПодразделение
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|
	|ГДЕ
	|	Контрагенты.ГоловнойКонтрагент = &ГоловнойКонтрагент
	|	И Контрагенты.ГоловнойКонтрагент <> Контрагенты.Ссылка
	|	И НЕ Контрагенты.ПометкаУдаления
	|	И НЕ Контрагенты.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	Контрагент";
	
	Результат = Запрос.Выполнить();
	
	Возврат Результат;
	
КонецФункции // ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту()

// Процедура - обработчик события "ОбработкаЗаполнения".
//
Процедура ОбработкаЗаполнения(Основание)

	Если ТипЗнч(Основание) = Тип("СправочникСсылка.Организации") Тогда
		
		Наименование           = Основание.Наименование;
		ЮрФизЛицо              = Основание.ЮрФизЛицо;
		НаименованиеПолное     = Основание.НаименованиеПолное;
		ОсновнойБанковскийСчет = Основание.ОсновнойБанковскийСчет;
		ИНН                    = Основание.ИНН;
		КПП                    = Основание.КПП;
		КодПоОКПО              = Основание.КодПоОКПО;
		мОснование             = Основание;
		
	КонецЕсли;

КонецПроцедуры // ОбработкаЗаполнения()

Процедура ПередЗаписью(Отказ)
		
	Перем мСсылкаНового;
	
	// ЛНА, Замер  APDEX ++(
	APDEX_ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("Контрагенты_Запись");
	//)--
	
	Если НЕ ЭтоГруппа И НЕ ЗначениеЗаполнено(ГоловнойКонтрагент) Тогда
		Если ЭтоНовый() Тогда
			ГоловнойКонтрагент = ЭтотОбъект.ПолучитьСсылкуНового();
		Иначе
			ГоловнойКонтрагент = Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И ЗначениеЗаполнено(ОсновнойДоговорКонтрагента) Тогда
		Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(ОсновнойДоговорКонтрагента, "Владелец") <> Ссылка Тогда
			ОсновнойДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И ЗначениеЗаполнено(ОсновнойДоговорКонтрагентаЗакупка) Тогда
		Если ОбщегоНазначения.ПолучитьЗначениеРеквизита(ОсновнойДоговорКонтрагентаЗакупка, "Владелец") <> Ссылка Тогда
			ОсновнойДоговорКонтрагентаЗакупка = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	//Есть же стандартная проверка реквизитов//
	ЗарегистрироватьВОбмене = Ложь;
	Если НЕ ЭтоНовый() Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Контрагенты.Код,
		|	Контрагенты.Наименование,
		|	Контрагенты.ИНН,
		|	Контрагенты.КПП,
		|	Контрагенты.Комментарий,
		|	Контрагенты.НаименованиеПолное,
		|	Контрагенты.Покупатель,
		|	Контрагенты.Поставщик,
		|	Контрагенты.ЮрФизЛицо
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	Контрагенты.Ссылка = &Ссылка"
		);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Результат = Запрос.Выполнить().Выбрать();
		Пока Результат.Следующий() Цикл
			Если Результат.Код <> Код
				ИЛИ СокрЛП(Результат.Наименование) <> СокрЛП(Наименование)
				ИЛИ Результат.ИНН <> ИНН
				ИЛИ Результат.КПП <> КПП
				ИЛИ ВРЕГ(СокрЛП(Результат.Комментарий)) <> ВРЕГ(Комментарий)
				ИЛИ СокрЛП(Результат.НаименованиеПолное) <> СокрЛП(НаименованиеПолное)
				ИЛИ Результат.Покупатель <> Покупатель
				ИЛИ Результат.Поставщик <> Поставщик
				ИЛИ Результат.ЮрФизЛицо <> ЮрФизЛицо Тогда
				ЗарегистрироватьВОбмене = Истина;
			КонецЕсли;
		КонецЦикла;
	Иначе 
		Попытка
			Если НЕ ЭтоГруппа Тогда 
				Если ЗначениеЗаполнено(Регион) Тогда 
					ММ=Регион.ГруппаМаршрутов;
					Запрос=Новый Запрос;
					Запрос.Текст="ВЫБРАТЬ ПЕРВЫЕ 1
					|	МаршрутыДоставки.Ссылка
					|ИЗ
					|	Справочник.МаршрутыДоставки КАК МаршрутыДоставки
					|ГДЕ
					|	МаршрутыДоставки.ИспользуетсяДляРегистрацииКлиентов = ИСТИНА
					|	И МаршрутыДоставки.Родитель = &Родитель
					|	И МаршрутыДоставки.ПометкаУдаления = ЛОЖЬ";
					Запрос.УстановитьПараметр("Родитель",ММ.Ссылка);
					Рез=Запрос.Выполнить().Выгрузить();
					Если Не рез.Количество()=0 Тогда 
						МаршрутДоставки=рез[0].Ссылка;
						
						// 14.11.18 Строганов Роман > XX-756 Ошибка регистрации клиентов - маршрут доставки.
						// В форме контрагента идет чтение и отображение маршрутов доставки из торговой точки. 
						// Запишу так же туда новое значение маршрута доставки.
						Если ЗначениеЗаполнено(ОсновнаяТорговаяТочка) И Не ЗначениеЗаполнено(ОсновнаяТорговаяТочка.МаршрутДоставки) Тогда
							ТорговаяТочка = ОсновнаяТорговаяТочка.ПолучитьОбъект();
							ТорговаяТочка.МаршрутДоставки = МаршрутДоставки;
							ТорговаяТочка.Записать();
						КонецЕсли;
						// 14.11.18 Строганов Роман < XX-756 Ошибка регистрации клиентов - маршрут доставки 
					КонецЕсли;	
				КонецЕсли;	
				Если Не ЗначениеЗаполнено(МаршрутДоставки) Тогда 
					МаршрутДоставки=Справочники.МаршрутыДоставки.НайтиПоКоду("232");
					Если ЗначениеЗаполнено(ЭтотОбъект.ОсновнаяТорговаяТочка) Тогда
						МД=ЭтотОбъект.ОсновнаяТорговаяТочка.МаршрутДоставки2;
						Попытка
							ТорговаяТочка = ЭтотОбъект.ОсновнаяТорговаяТочка.ПолучитьОбъект();
							ТорговаяТочка.МаршрутДоставки2= Справочники.МаршрутыДоставки.НайтиПоНаименованию(МаршрутДоставки);
							
							// 14.11.18 Строганов Роман > XX-756 Ошибка регистрации клиентов - маршрут доставки.
							Если Не ЗначениеЗаполнено(ТорговаяТочка.МаршрутДоставки) Тогда
								ТорговаяТочка.МаршрутДоставки = МаршрутДоставки;								
							КонецЕсли;
							// 14.11.18 Строганов Роман < XX-756 Ошибка регистрации клиентов - маршрут доставки.

							ТорговаяТочка.Записать();
						Исключение
						КонецПопытки;
						
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;	
		Исключение
		КонецПопытки;	
	КонецЕсли;
	
	//Обмен с сайтом
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Сайт", "Справочник: Контрагенты", Ложь) И НЕ ОбменДанными.Загрузка И НЕ ПометкаУдаления Тогда
		ЗарегистрироватьВОбмене_ОбменПартКом83_Сайт = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
		ИзменениеБлокировки = НЕ ЭтоГруппа И НЕ ЭтоНовый() И Блокировка <> Ссылка.Блокировка;
	КонецЕсли;
	Если ТекущаяДата() > Константы.ДатаЗаявкиСоздаютсяВ83.Получить() И НЕ  ОбменДанными.Загрузка Тогда
		ЗарегистрироватьВОбмене_ОбменПартКом83_77 = ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_77, ЭтотОбъект);
	КонецЕсли;
	
// + Пушкин 20181212 XX-1455
	ЛогПредставлениеРазличий = "";
	Если ОбменДаннымиКлиентСервер.ЕстьРазличияСсылкиИОбъекта(ЭтотОбъект, "ЛогированиеЗначенийЭД", ЛогПредставлениеРазличий) тогда
		Справочники.Контрагенты.ЗалогироватьЭД(ЭтотОбъект.Ссылка,ЛогПредставлениеРазличий);
	КонецЕсли;
// - Пушкин 20181212 XX-1455
	
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если (Не ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо) И ЗначениеЗаполнено(ФизЛицо) Тогда
		ФизЛицо = Неопределено
	КонецЕсли;
	
	Если НЕ ЭтоГруппа тогда
		Если ЗначениеЗаполнено(ОсновнаяТорговаяТочка) тогда
			лКодОсновнойТорговойТочки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ОсновнаяТорговаяТочка, "Код");
			Если (Код <> лКодОсновнойТорговойТочки) тогда
				Код = лКодОсновнойТорговойТочки;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;	
		
	мПометкаУдаленияИзменилась = ПометкаУдаления <> Ссылка.ПометкаУдаления;
	
	Если Не ЭтоГруппа Тогда 
		Если Не флРаботает_сКоррСФ Тогда 
			ДатаНачалаРаботыСКоррСчФактурами = дата(1,1,1);
		КонецЕсли;	
	КонецЕсли;
	Если Не ЭтоГруппа Тогда 
		Если АктСверкиПодписан И НЕ ЗначениеЗаполнено(ДатаПодписанногоАктаСверки) Тогда 
			Отказ=Истина;
			Сообщить("Необходимо проставить дату подписания акта сверки на вкладке Бухгалтерия!");
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
		
	Если ЗарегистрироватьВОбмене 
		// 28.12.18 Строганов Роман >  
		И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") = Ложь Тогда
		// 28.12.18 Строганов Роман <
		ОбменДаннымиКлиентСервер.ЗарегистрироватьКОбменуБИТ(Ссылка, ОбменДанными.Отправитель);
	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗарегистрироватьВОбмене_ОбменПартКом83_Сайт 	
		// 28.12.18 Строганов Роман > 
		И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") = Ложь Тогда
		// 28.12.18 Строганов Роман <
		Если НЕ ЭтоГруппа Или (ЭтоГруппа И Родитель.Код = "00000002") Тогда
			//Либо не группа, либо группа, находящаяся в папке "Покупатели"//
			ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, "Справочник.Контрагенты.МодульОбъекта.ПриЗаписи"); //Семенов И.П. 31.01.2019 XX-1768
		КонецЕсли;
		Если НЕ ЭтоГруппа И ИзменениеБлокировки Тогда
			ЗарегистрироватьВходящихВХолдинг(Ссылка);
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ РольДоступна("ПолныеПрава") И ЗначениеЗаполнено(ГоловнойКонтрагент) И ГоловнойКонтрагент <> Ссылка Тогда
		
		Если ЗначениеЗаполнено(ГоловнойКонтрагент.ГоловнойКонтрагент) И ГоловнойКонтрагент.ГоловнойКонтрагент <> ГоловнойКонтрагент Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Контрагент "+СокрЛП(ГоловнойКонтрагент)+" не может быть выбран головным, 
						|так как для него уже был назначен головной контрагент "+СокрЛП(ГоловнойКонтрагент.ГоловнойКонтрагент)+"!");
			Отказ = Истина;
			Возврат;
		Иначе
			
			// надо проверить, что если указываем головного контрагента, то этот элемент уже не был установлен
			// в качестве головного у другого контрагента.
			ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();
			Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
				
				СообщениеОНевозможностиЗаписи = "Контрагент "+СокрЛП(ЭтотОбъект)+" не может иметь головного контрагента!
				|Этот контрагент уже установлен головным для: ";
				Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
					СообщениеОНевозможностиЗаписи = СообщениеОНевозможностиЗаписи + Символы.ПС + СокрЛП(ВыборкаПоГоловномуКонтрагенту.Контрагент);
				КонецЦикла;
				
				ОбщегоНазначения.СообщитьОбОшибке(СообщениеОНевозможностиЗаписи);
				Отказ = Истина;
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	// проверим, что контрагент - физ. лицо уже не был установлен головным контрагентом для обособленных подразделений
	Если НЕ РольДоступна("ПолныеПрава") И НЕ ЭтоНовый() И ЮрФизЛицо = Перечисления.ЮрФизЛицо.ФизЛицо Тогда
		
		ЕстьОбособленныеПодразделения = Ложь;
		СообщениеОНевозможностиЗаписи = "Контрагент " + СокрЛП(ЭтотОбъект) + " не может быть физическим лицом!
			|Этот контрагент уже установлен головным для: ";
			
		ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();			
		Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
			Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
				Если ВыборкаПоГоловномуКонтрагенту.ОбособленноеПодразделение Тогда
					ЕстьОбособленныеПодразделения = Истина;
					СообщениеОНевозможностиЗаписи = СообщениеОНевозможностиЗаписи + Символы.ПС + СокрЛП(ВыборкаПоГоловномуКонтрагенту.Контрагент);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;	
		
		Если ЕстьОбособленныеПодразделения Тогда
			ОбщегоНазначения.СообщитьОбОшибке(СообщениеОНевозможностиЗаписи, Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(мОснование) Тогда
		НаборЗаписей = РегистрыСведений.СобственныеКонтрагенты.СоздатьНаборЗаписей();
		ЗаписьРегистра = НаборЗаписей.Добавить();
		ЗаписьРегистра.Контрагент = Ссылка;
		ЗаписьРегистра.ВидСвязи   = Перечисления.ВидыСобственныхКонтрагентов.Организация;
		ЗаписьРегистра.Объект     = мОснование;
		НаборЗаписей.Записать(Ложь);
		мОснование = "";
	КонецЕсли;
	
	// при изменении ИНН перепишем ИНН у обособленных подразделений контрагента
	Если НЕ ЭтоНовый() И ЮрФизЛицо = Перечисления.ЮрФизЛицо.ЮрЛицо Тогда
		
		ВыборкаПоГоловномуКонтрагенту = ПолучитьКонтрагентовПоЗаданномуГоловномуКонтрагенту(Ссылка).Выбрать();
		Если ВыборкаПоГоловномуКонтрагенту.Количество() <> 0 Тогда
			
			Пока ВыборкаПоГоловномуКонтрагенту.Следующий() Цикл
				
				Если ИНН = ВыборкаПоГоловномуКонтрагенту.Контрагент.ИНН
					ИЛИ НЕ ВыборкаПоГоловномуКонтрагенту.ОбособленноеПодразделение Тогда
					Продолжить;
				КонецЕсли;
				
				КонтрагентДляИзменения = ВыборкаПоГоловномуКонтрагенту.Контрагент.ПолучитьОбъект();
				КонтрагентДляИзменения.ИНН = ИНН;
				Попытка
					КонтрагентДляИзменения.Записать();
				Исключение
					ОписаниеОшибки = "Ошибка при записи обособленных подразделений контрагента.
					|Не удалось изменить ИНН у обособленного подразделения " + КонтрагентДляИзменения.Наименование;
					ОбщегоНазначения.СообщитьОбОшибке(ОписаниеОшибки);
				КонецПопытки;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		//при измении пометки удаления меняем ее у всех подчиненных объектов
		Если мПометкаУдаленияИзменилась Тогда
			
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("Владелец", Ссылка);
			Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
			Запрос.Текст = "ВЫБРАТЬ
			               |	ДоговорыКонтрагентов.Ссылка
			               |ИЗ
			               |	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
			               |ГДЕ
			               |	ДоговорыКонтрагентов.Владелец = &Владелец
			               |	И НЕ ДоговорыКонтрагентов.ПометкаУдаления = &ПометкаУдаления
			               |
			               |ОБЪЕДИНИТЬ ВСЕ
			               |
			               |ВЫБРАТЬ
			               |	ТорговыеТочки.Ссылка
			               |ИЗ
			               |	Справочник.ТорговыеТочки КАК ТорговыеТочки
			               |ГДЕ
			               |	ТорговыеТочки.Владелец = &Владелец
			               |	И НЕ ТорговыеТочки.ПометкаУдаления = &ПометкаУдаления
			               |
			               |ОБЪЕДИНИТЬ ВСЕ
			               |
			               |ВЫБРАТЬ
			               |	БанковскиеСчета.Ссылка
			               |ИЗ
			               |	Справочник.БанковскиеСчета КАК БанковскиеСчета
			               |ГДЕ
			               |	БанковскиеСчета.Владелец = &Владелец
			               |	И НЕ БанковскиеСчета.ПометкаУдаления = &ПометкаУдаления";
			Выборка = Запрос.Выполнить().Выбрать();
			
			Пока Выборка.Следующий() Цикл
				
				лОбъект = Выборка.Ссылка.ПолучитьОбъект();
				лОбъект.ПометкаУдаления = ПометкаУдаления;
				лОбъект.Записать();
				
			КонецЦикла;
			
		КонецЕсли;
	КонецЕсли;
	
	Если РегистрыСведений.НастройкиПодсистем.ЗначениеПараметра("Обмен 1С-Elma", "Выгружать контрагентов при записи", Ложь) И IDРозничногоПокупателя = 0 И Покупатель 
		// 25.12.18 Строганов Роман > 
		И ДополнительныеСвойства.Свойство("ОтключитьМеханизмРегистрацииОбъектов") = Ложь Тогда
		// 25.12.18 Строганов Роман <
		Обработки.Обмен1СЭлма.ВыгрузитьКонтрагента(Ссылка);
	КонецЕсли;
	
	// ЛНА, Замер  APDEX ++(
	Попытка		
		APDEX_ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("Контрагенты_Запись", СокрЛП(Ссылка), , Ссылка);
	Исключение
	КонецПопытки;
	//)--

	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	Если ЗарегистрироватьВОбмене_ОбменПартКом83_Сайт Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, "Справочник.Контрагенты.МодульОбъекта.ПередУдалением"); //Семенов И.П. 31.01.2019 XX-1768
	КонецЕсли;
	Если ЗарегистрироватьВОбмене_ОбменПартКом83_77 Тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_77, "Справочник.Контрагенты.МодульОбъекта.ПередУдалением"); //Семенов И.П. 31.01.2019 XX-1768
	КонецЕсли;
	
КонецПроцедуры

//Углев 11.07.2018
Функция ВыгрузитьВОбменТоплог() Экспорт
	
	СтруктураВозврата = Новый Структура;
	
	Ошибка = Ложь;
	СообщениеДиагностики = "";
	
	//Проверки
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Если ЭтоГруппа Тогда	
		СообщениеДиагностики = СообщениеДиагностики + "Группы регистрировать нельзя." + Символы.ПС;	
		Ошибка = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Ссылка.ОсновнаяТорговаяТочка) Тогда
		СообщениеДиагностики = СообщениеДиагностики + "Не заполнена основная торговая точка для контрагента." + Символы.ПС;	
		Ошибка = Истина;	
	КонецЕсли;
	
	Узел = ОбменДаннымиКлиентСервер.ПолучитьИсходящийУзелОбмена(Метаданные.ПланыОбмена.ОбменПартКом83_TopLog_РТУ, 3);
	Если НЕ ЗначениеЗаполнено(Узел) Тогда 
		СообщениеДиагностики = СообщениеДиагностики + "Не найден узел обмена для выгрузки в Топлог." + Символы.ПС;
		Ошибка = Истина;
	КонецЕсли;
		
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	Если Ошибка = Ложь Тогда  
		//Семенов И.П. 31.01.2019 XX-1768(
		//ПланыОбмена.ЗарегистрироватьИзменения(Узел, Ссылка.ОсновнаяТорговаяТочка);
		ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(Узел, Ссылка.ОсновнаяТорговаяТочка);
		//)Семенов И.П.
		СообщениеДиагностики = СообщениеДиагностики + "Контрагент зарегистрирован в обмене с Топ Лог";		
	Иначе
		СообщениеДиагностики = "Не удалось зарегистрировать элемент справочника в обмене с Топлог, по причине:" + Символы.ПС + СообщениеДиагностики;
	КонецЕсли;
	
	СтруктураВозврата.Вставить("Ошибка", Ошибка);
	СтруктураВозврата.Вставить("СообщениеДиагностики", СообщениеДиагностики);
	Возврат СтруктураВозврата;
	
КонецФункции


Процедура ЗарегистрироватьВходящихВХолдинг(ГоловнойКонтрагент)
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	Контрагенты.Ссылка
	                      |ИЗ
	                      |	Справочник.Контрагенты КАК Контрагенты
	                      |ГДЕ
	                      |	Контрагенты.ГоловнойКонтрагент = &ГоловнойКонтрагент
	                      |	И НЕ Контрагенты.ПометкаУдаления
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ОбменПартКом83_Сайт.Ссылка
	                      |ИЗ
	                      |	ПланОбмена.ОбменПартКом83_Сайт КАК ОбменПартКом83_Сайт
	                      |ГДЕ
	                      |	НЕ ОбменПартКом83_Сайт.ЭтотУзел
	                      |	И ОбменПартКом83_Сайт.Исходящий");
	Запрос.УстановитьПараметр("ГоловнойКонтрагент", ГоловнойКонтрагент);
	Результат = Запрос.ВыполнитьПакет();
	ВыборкаКонтрагентов = Результат[0].Выбрать();
	ВыборкаУзла = Результат[1].Выбрать();
	
	Если ВыборкаУзла.Следующий() Тогда
		Узел = ВыборкаУзла.Ссылка;
		Пока ВыборкаКонтрагентов.Следующий() Цикл
			//Семенов И.П. 31.01.2019 XX-1768(
			//ПланыОбмена.ЗарегистрироватьИзменения(Узел, ВыборкаКонтрагентов.Ссылка);
			ОбменДаннымиКлиентСервер.ЗарегистрироватьИзмененияВПланеОбмена(Узел, ВыборкаКонтрагентов.Ссылка);
			//)Семенов И.П.
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

ЗарегистрироватьВОбмене_ОбменПартКом83_Сайт = Ложь;
ИзменениеБлокировки = Ложь;
ЗарегистрироватьВОбмене_ОбменПартКом83_77 = Ложь;
