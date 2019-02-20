﻿Процедура ВыполнитьРегламентноеЗадание() Экспорт
	 Широты();
	//Разница();
КонецПроцедуры

Процедура Разница() Экспорт
	стрЛога = "";
	масКА = Новый Массив;
	
	Текст = "";
	пар_ПолноеИмяФайла = "X:\Личные папки\Денис Пушкин\переезд\01 Работа\ПартКом_201811\express_delivery_logins_test.txt";
	Попытка
		ТекстовыйФайл = Новый ЧтениеТекста(пар_ПолноеИмяФайла, "windows-1251");
		Текст = ТекстовыйФайл.Прочитать();
		ТекстовыйФайл.Закрыть();
	Исключение
	КонецПопытки;

	ВсегоСтрок = СтрЧислоСтрок(Текст);
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(ВсегоСтрок) + " строк в файле прочитано");
	
	cxcx = 0;
	cx = 0;
	Для ен = 1 по ВсегоСтрок цикл
		
		//Если ЭлементыФормы.Флажок1.Значение тогда
		//	Если ен > 100 тогда
		//		Прервать;
		//	КонецЕсли;
		//КонецЕсли;
		
		Если Цел(ен/100) = ен/100 тогда
			стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(ен);
			
			Сообщить(СокрЛП(ен));
		КонецЕсли;
		
		л_стр = СтрПолучитьСтроку(Текст, ен);
		
		Если НЕ ЗначениеЗаполнено(л_стр) тогда
			Продолжить;
		КонецЕсли;
		
		
		//РазложитьСтрокуНаМассивПодстрок
		мас = СтрРазделить(л_стр,",",);
		
		uuid = мас[1];  uuid = СтрЗаменить(uuid,"""","");
		login = мас[0]; login = СтрЗаменить(login,"""","");
		цена_в_руб = мас[2]; цена_в_руб = СтрЗаменить(цена_в_руб,"""","");
		цена_в_бонусах = мас[3]; цена_в_бонусах = СтрЗаменить(цена_в_бонусах,"""","");
		сумма_бесплатной = мас[4]; сумма_бесплатной = СтрЗаменить(сумма_бесплатной,"""","");
		код_маршрута = 0;//мас[5]; код_маршрута = СтрЗаменить(код_маршрута,"""","");
		
			УИДконтра = uuid;
			ИДконтра = Новый УникальныйИдентификатор( УИДконтра );
			Найденнаяконтра = Справочники.Контрагенты.ПолучитьСсылку( ИДконтра );
			ПараметрыКонтры = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Найденнаяконтра,"Код,Наименование");
			
			Если НЕ ЗначениеЗаполнено(ПараметрыКонтры.Код) тогда
				cx = cx + 1;
				стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрлП(cx) + ". КА не опознан: " + uuid );//+ "	"+login + "	"+цена_в_руб + "	"+цена_в_бонусах + "	"+сумма_бесплатной + "	"+код_маршрута);
				Продолжить;
			КонецЕсли;
			
			cxcx = cxcx + 1;
			
			масКА.Добавить(Найденнаяконтра);
			
			//////////////////Если НЕ ЭлементыФормы.Флажок1.Значение тогда

				//////////////Попытка
				//////////////	КА = Найденнаяконтра.ПолучитьОбъект();
				//////////////	КА.ДоступнаУслугаЭкспрессДоставки = Истина;
				//////////////	КА.СтоимостьУслугиЭДбонусы = Число(цена_в_бонусах);
				//////////////	КА.СтоимостьУслугиЭДрубли = Число(цена_в_руб);
				//////////////	КА.СуммаБесплатнойЭД = Число(сумма_бесплатной);
				//////////////	
				//////////////	ОбновлениеИнформационнойБазы.ЗаписатьДанные(КА);
				//////////////	
				//////////////	КА.Записать();
				//////////////Исключение
				//////////////	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрлП(cx) + ". КА не записан " + uuid );// + "	"+login + "	"+цена_в_руб + "	"+цена_в_бонусах + "	"+сумма_бесплатной + "	"+код_маршрута);
				//////////////КонецПопытки;
			
			//КонецЕсли;
			
	КонецЦикла;
	
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cxcx) + " записанных ссылок");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.ДоступнаУслугаЭкспрессДоставки = ИСТИНА
	|И  НЕ Контрагенты.Ссылка В (&масКА)";

	Запрос.УстановитьПараметр("масКА",масКА);
	Результат = Запрос.Выполнить().Выгрузить();
	
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(Результат.Количество()) + " найдено лишних галок");
	
	cx = 0;
	cxcx = 0;
	Для каждого стр_ка из  Результат цикл
		cxcx = cxcx + 1;
		
		Если Цел(cxcx/100) = cxcx/100 тогда
			стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(cxcx);
			
			Сообщить(СокрЛП(cxcx));
			
		КонецЕсли;
		
		Найденнаяконтра = стр_ка.Ссылка;
		
		Попытка
			КА = Найденнаяконтра.ПолучитьОбъект();
			КА.ДоступнаУслугаЭкспрессДоставки = Ложь;
			КА.СтоимостьУслугиЭДбонусы = 0;
			КА.СтоимостьУслугиЭДрубли = 0;
			КА.СуммаБесплатнойЭД = 0;
			
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(КА);
			
			КА.Записать();
		Исключение
			cx = cx+ 1;
			uuid = Найденнаяконтра.УникальныйИдентификатор();
			стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрлП(cx) + ". галка КА не снята " + uuid );// + "	"+login + "	"+цена_в_руб + "	"+цена_в_бонусах + "	"+сумма_бесплатной + "	"+код_маршрута);
		КонецПопытки;
	КонецЦикла;
	
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cxcx) + " снято лишних галок");
	
	ИмяФайла = пар_ПолноеИмяФайла;
	ИмяФайла = СтрЗаменить(ИмяФайла,".txt","_log.txt");
	Файл = Новый ЗаписьТекста(ИмяФайла);
	Файл.ЗаписатьСтроку(стрЛога);
	Файл.Закрыть();

КонецПроцедуры

Процедура Широты() Экспорт
	
	
	Текст = "";
	пар_ПолноеИмяФайла = "\\nng9-v-1c-07\ДляЗагрузкиОстатков\1c8_1c7\Test\clients_coord (1) копи.txt";
	Попытка
		ТекстовыйФайл = Новый ЧтениеТекста(пар_ПолноеИмяФайла, "windows-1251");
		Текст = ТекстовыйФайл.Прочитать();
		ТекстовыйФайл.Закрыть();
	Исключение
	КонецПопытки;

	стрЛога =  СокрЛП(ТекущаяДата()) + "  начало";
	
	ВсегоСтрок = СтрЧислоСтрок(Текст);
	
	cxcxcxcx = 0;
	cxcxcx = 0;
	cxcx = 0;
	cx = 0;
	Для ен = 1 по ВсегоСтрок цикл
		
		//Если ЭлементыФормы.Флажок1.Значение тогда
			//Если ен > 100 тогда
			//	Прервать;
			//КонецЕсли;
		//КонецЕсли;
		
		//Если Цел(ен/100) = ен/100 тогда
		//	Сообщить(ен);
		//КонецЕсли;
		
		л_стр = СтрПолучитьСтроку(Текст, ен);
		
		Если НЕ ЗначениеЗаполнено(л_стр) тогда
			Продолжить;
		КонецЕсли;
		
		//РазложитьСтрокуНаМассивПодстрок
		мас = СтрРазделить(л_стр,";",);
		
		uuid = мас[0];  uuid = СтрЗаменить(uuid,"""","");
		широта = мас[1]; широта = СтрЗаменить(широта,"""","");
		долгота = мас[2]; долгота = СтрЗаменить(долгота,"""","");
		
			УИДконтра = uuid;
			ИДконтра = Новый УникальныйИдентификатор( УИДконтра );
			Найденнаяконтра = Справочники.Контрагенты.ПолучитьСсылку( ИДконтра );
			ПараметрыКонтры = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(Найденнаяконтра,"Код,Наименование,Широта,Долгота");
			
			Если НЕ ЗначениеЗаполнено(ПараметрыКонтры.Код) тогда
				cx = cx + 1;
				//Сообщить(СокрлП(cx) + ". КА не опознан: " + uuid + "	"+широта + "	"+долгота);
				Продолжить;
			КонецЕсли;
			
			cxcx = cxcx + 1;
			
			Если СокрЛП(ПараметрыКонтры.Широта) = СокрЛП(широта) И СокрЛП(ПараметрыКонтры.Долгота) = СокрЛП(Долгота) Тогда 
				cxcxcxcx = cxcxcxcx + 1;
			Иначе
				Попытка
					КА = Найденнаяконтра.ПолучитьОбъект();
					КА.Широта = широта;
					КА.Долгота = долгота;
					
					ОбновлениеИнформационнойБазы.ЗаписатьДанные(КА);
					
					КА.Записать();
				Исключение
					
					uuid = Найденнаяконтра.УникальныйИдентификатор();
					стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрлП(cx) + ". координаты не указаны " + uuid );// + "	"+login + "	"+цена_в_руб + "	"+цена_в_бонусах + "	"+сумма_бесплатной + "	"+код_маршрута);
					
					cxcxcx = cxcxcx + 1;
				КонецПопытки;
			КонецЕсли;
	КонецЦикла;
	
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(ВсегоСтрок) + " ВсегоСтрок");
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cxcx) + " опознано");
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cx) + " НЕ опознано");
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cxcxcx) + " НЕ записано");
	стрЛога = стрЛога + Символы.ПС + ТекущаяДата() + " " + СокрЛП(СокрЛП(cxcxcxcx) + " совпало");
	
	
	ИмяФайла = пар_ПолноеИмяФайла;
	ИмяФайла = СтрЗаменить(ИмяФайла,".txt","_log.txt");
	Файл = Новый ЗаписьТекста(ИмяФайла);
	Файл.ЗаписатьСтроку(стрЛога);
	Файл.Закрыть();
	
КонецПроцедуры