﻿Перем КаталогКопий;
Перем глПользователь;

Процедура ВыполнитьРегламентноеЗадание() Экспорт
	// Вставить содержимое обработчика.
	глПользователь=глЗначениеПеременной("глТекущийПользователь");
	Если Строка(КаталогПоиска)="" Тогда 
		КаталогПоиска="\\1CSQL01-G9\1c_exchange\FromInventorTo1C\MovementToBranches\";
	КонецЕсли;	
	
	//Найдем нужные файлы
	НайденныеФайлы = НайтиФайлы(КаталогПоиска, "IO_*.csv");
	
	тхт_Дата = ""+День(ТекущаяДата());
	
	Для Каждого Файл Из НайденныеФайлы Цикл
		Рез_Обмена = 0;
		ТекстОшибки = "";
		
		НовоеИмя = тхт_Дата + "ошибка_"+Файл.Имя;
		
		ПереместитьФайл(КаталогПоиска+Файл.Имя, КаталогПоиска+НовоеИмя); 
		//Загрузим перемещение
		Рез_Обмена = ЗагрузитьПеремещение(НовоеИмя, Файл.Имя, ТекстОшибки);
		
		Если Рез_Обмена = 1 Тогда //все удачно
			//Скопируем в копию и удалим обработанный файл
			КаталогКопий=КаталогПоиска+"_Copy\";
			Каталог_Дата = ""+Год(ТекущаяДата())+"-"+месяц(ТекущаяДата())+"-"+День(ТекущаяДата())+"\";
			КаталогКопий = КаталогКопий + СтрЗаменить(Каталог_Дата,Символы.НПП,"");

			Если НЕ ПроверитьСуществованиеКаталога(КаталогКопий)  Тогда
				Сообщить("Каталог: "+КаталогКопий+" не существует!");
				Возврат;
			КонецЕсли;
			КопироватьФайл(КаталогПоиска+НовоеИмя, КаталогКопий+НовоеИмя);
			УдалитьФайлы(КаталогПоиска,НовоеИмя);
		ИначеЕсли Рез_Обмена = 2 Тогда 	// не успешно, надо повторить
			//СтароеИмя = Сред(НовоеИмя, СтрДлина(тхт_Дата) + 8);
			ПереместитьФайл(КаталогПоиска+НовоеИмя, КаталогПоиска+Файл.Имя);
		ИначеЕсли Рез_Обмена = 3 Тогда
			// отсутствует файл
			// ничего не делаем
		Иначе
			// ошибка - не найден код и т.д.
			//Файл = Сред(НовоеИмя, СтрДлина(тхт_Дата) + 8);
			Если ТекстОшибки = "" Тогда
				ПереместитьФайл(КаталогПоиска+НовоеИмя, ТекстОшибки + " - " + Файл.Имя);
			Иначе
				ПереместитьФайл(КаталогПоиска+НовоеИмя, "! Нельзя загрузить - "+Файл.Имя);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	

КонецПроцедуры

Функция ПроверитьСуществованиеКаталога(КаталогКопий) Экспорт
    КаталогНаДиске = Новый Файл(КаталогКопий);
    Если КаталогНаДиске.Существует() Тогда
        Возврат Истина;
    Иначе
		Попытка
			СоздатьКаталог(КаталогКопий);
			Возврат Истина
		Исключение
			Возврат Ложь;
		КонецПопытки;	
    КонецЕсли;
КонецФункции

Функция ЗагрузитьПеремещение(НовоеИмя, Файл, ТекстОшибки) Экспорт 
	Если НЕ ПроверитьСуществованиеКаталога(КаталогПоиска + НовоеИмя)  Тогда
		Возврат 3; // ошибка - нет файла
	КонецЕсли;
	Разделители = Новый Массив();
	Разделители.Добавить(";");
	
	ТекстДок=Новый ТекстовыйДокумент;
	ТекстДок.Прочитать(КаталогПоиска + НовоеИмя, КодировкаТекста.ANSI);//,"cp866");
	КолСтрок=ТекстДок.КоличествоСтрок();
	
	Если КолСтрок = 0 Тогда
		ТекстОшибки = "! Пустой файл";
		Сообщить("Пустой файл - "+НовоеИмя);
		Возврат 4;
	КонецЕсли;
	
	тзТовары = новый ТаблицаЗначений;
	тзТовары.Колонки.Добавить("Номенклатура");
	тзТовары.Колонки.Добавить("КолНач");
	тзТовары.Колонки.Добавить("Количество");
	тзТовары.Колонки.Добавить("КоличествоПлан");
	тзТовары.Колонки.Добавить("ЕдиницаИзмерения");
	тзТовары.Колонки.Добавить("Коэффициент");
	тзТовары.Колонки.Добавить("Цена");
	тзТовары.Колонки.Добавить("Сумма");
	тзТовары.Колонки.Добавить("СтавкаНДС");
	тзТовары.Колонки.Добавить("СуммаНДС");
	тзТовары.Колонки.Добавить("Организация");
	
	Если Не ЗначениеЗаполнено(ОрганизацияПоУмолчанию) Тогда 
		ОрганизацияПоУмолчанию = Справочники.Организации.НайтиПоКоду("000000024");
	КонецЕсли;	
	лок_ЦенаВклНДС = Справочники.ТипыЦенНоменклатуры.НайтиПоКоду("000000001").ЦенаВключаетНДС;
	Ошибки_вФайле="";
	Для счТ = 2 По КолСтрок Цикл
		//Состояние("Идет загрузка перемещения из файла от Инвентора. Обработано "+счТ+" строк из "+КолСтрок);
		
		ТекСтрока = ТекстДок.ПолучитьСтроку(счТ);
		Если ТекСтрока = "" Тогда
			Продолжить;
		КонецЕсли;
		
		Ошибки_вСтроке = "";
		
		ТекИзготовитель	= врег(ОбработкаСтр(ТекСтрока)); // номер отгрузки
		ТекАртикул		= врег(ОбработкаСтр(ТекСтрока));
		тмп				= ОбработкаСтр(ТекСтрока);
		ТекКолич 		= Число(ОбработкаСтр(ТекСтрока));
		ТекЦена 		= Число(ОбработкаСтр(ТекСтрока));
		тмп				= ОбработкаСтр(ТекСтрока);
		ТекКодСклада	= ОбработкаСтр(ТекСтрока);
		тмп				= ОбработкаСтр(ТекСтрока);
		ТекUID			= ОбработкаСтр(ТекСтрока);
		тмп				= ОбработкаСтр(ТекСтрока);
		тмп				= ОбработкаСтр(ТекСтрока);
		тмп				= ОбработкаСтр(ТекСтрока);
		
		Если ТекКолич = 0 Тогда
			Ошибки_вСтроке = Ошибки_вСтроке + " количество = 0,";
		КонецЕсли;
		
		Если ТекЦена = 0 Тогда
			Ошибки_вСтроке = Ошибки_вСтроке + " цена = 0,";
		КонецЕсли;
		
		ТекТовар = "";
		Если ТекUID = "" Тогда
			Ошибки_вСтроке = Ошибки_вСтроке + " не указан UID,";
		Иначе
			ТекТовар = ОпределитьОбъектПоУИД(ТекUID);
			Если ТекТовар=Неопределено Тогда
				Ошибки_вСтроке = Ошибки_вСтроке + " не найден товар,";
			Иначе
				Если ЗначениеЗаполнено(ТекАртикул) Тогда
					Если ТекАртикул <> врег(СокрЛП(ТекТовар.Артикул)) Тогда
						Ошибки_вСтроке = Ошибки_вСтроке + " другой артикул,";
					КонецЕсли;
				КонецЕсли;
				Если ЗначениеЗаполнено(ТекИзготовитель)  Тогда
					Если ТекИзготовитель <> врег(СокрЛП(ТекТовар.Изготовитель.Наименование)) Тогда
						Ошибки_вСтроке = Ошибки_вСтроке + " другой изготовитель,";
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если счТ = 2 Тогда
			Данные          = РазложитьСтрокуПоРазделителям(ТекСтрока,Разделители);
			ТекКодСкладаОтпр	= Данные[2];
			Если ЗначениеЗаполнено(ТекКодСклада) Тогда
				ТекСкладПол = справочники.Склады.НайтиПоКоду(Прав("000000000"+ТекКодСклада,9));
			КонецЕсли;
			Если ЗначениеЗаполнено(ТекКодСкладаОтпр) Тогда
				ТекСкладОтпр = справочники.Склады.НайтиПоКоду(Прав("000000000"+ТекКодСкладаОтпр,9));
			КонецЕсли;
			Если Не ЗначениеЗаполнено(ТекСкладПол) Тогда
				ТекстОшибки = "! Нет склада";
				Сообщить(НовоеИмя+", В 1С не найден склад по коду: " + ТекКодСклада);
				Возврат 4;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ошибки_вСтроке) Тогда
			Ошибки_вСтроке = Лев(Ошибки_вСтроке, СтрДлина(Ошибки_вСтроке)-1);
			Ошибки_вФайле = Ошибки_вФайле + "
			|Ошибки в строке №" + Строка(счТ) + ":" + Ошибки_вСтроке;
			
			ТекСтрока = ТекстДок.ПолучитьСтроку(счТ);
			ТекСтрока = ТекСтрока + ";" + Ошибки_вСтроке;
			ТекстДок.ЗаменитьСтроку(счТ, ТекСтрока);
			
			Продолжить;
		КонецЕсли;
		
		ЗапросОст=Новый запрос;
		ЗапросОст.Текст="ВЫБРАТЬ
		|	ПартииТоваровОстатки.КоличествоОстаток КАК Количество,
		|	ПартииТоваровОстатки.Организация
		|ИЗ
		|	РегистрНакопления.ПартииТоваров.Остатки(&Дата, ) КАК ПартииТоваровОстатки
		|ГДЕ
		|	ПартииТоваровОстатки.Номенклатура = &Номенклатура";
		
		ЗапросОст.УстановитьПараметр("Номенклатура", ТекТовар);
		ЗапросОст.УстановитьПараметр("Дата", ТекущаяДата());
		тзОстатки=ЗапросОст.Выполнить().Выгрузить();
		Если тзОстатки.Количество()>0 Тогда 
			тмп_ОбщийОстаток = тзОстатки.Итог("Количество");
		Иначе 	
			тмп_ОбщийОстаток=0;
		КонецЕсли;	
		
		ЗапросРез=Новый запрос;
		ЗапросРез.Текст="ВЫБРАТЬ
		|	РезервыТоваровОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.РезервыТоваров.Остатки(&Дата, ) КАК РезервыТоваровОстатки
		|ГДЕ
		|	РезервыТоваровОстатки.Номенклатура = &Номенклатура";
		
		ЗапросРез.УстановитьПараметр("Номенклатура", ТекТовар);
		ЗапросРез.УстановитьПараметр("Дата", ТекущаяДата());
		РезОст=ЗапросОст.Выполнить().Выгрузить();
		тзРезервы=ЗапросРез.Выполнить().Выгрузить();		
		
		Кол_вРезерве = Макс(0, тзРезервы.Итог("Количество"));
		
		КолДок = 0;
		
		Для Каждого СтрОст Из тзОстатки Цикл
			Если ТекКолич > 0 и тмп_ОбщийОстаток > 0 Тогда 
			
				// с 16.08.2016 проверка товара в резерве
				Если Кол_вРезерве >= СтрОст.Количество Тогда
					Кол_вРезерве  = ?(СтрОст.Количество > 0, Кол_вРезерве - СтрОст.Количество, Кол_вРезерве);
					Продолжить;
				ИначеЕсли Кол_вРезерве > 0 Тогда
					СтрОст.Количество = СтрОст.Количество - Кол_вРезерве;
					Кол_вРезерве = 0;
				КонецЕсли;
				
				СтртзТовары				= тзТовары.Добавить();
				СтртзТовары.Номенклатура 	= ТекТовар;
				СтртзТовары.ЕдиницаИзмерения 		= ТекТовар.ЕдиницаХраненияОстатков;
				СтртзТовары.Коэффициент 	= ТекТовар.ЕдиницаХраненияОстатков.Коэффициент;
				СтртзТовары.Цена 			= ТекЦена;
				СтртзТовары.Сумма 			= ТекЦена * ТекКолич;
				СтртзТовары.СтавкаНДС 		= ТекТовар.СтавкаНДС;
				СтртзТовары.СуммаНДС 		= Окр(СтртзТовары.Сумма * глВыделяемыйНДС(СтртзТовары.СтавкаНДС),2);
				СтртзТовары.Количество 		= Мин(СтрОст.Количество, ТекКолич, тмп_ОбщийОстаток);
				СтртзТовары.КолНач 			= СтртзТовары.Количество;
				СтртзТовары.КоличествоПлан	= СтртзТовары.Количество;
				СтртзТовары.Организация 	= ?(СтрОст.Организация = ОрганизацияПоУмолчанию, "", СтрОст.Организация);//лок_ОсновнаяФирма, "", СтрОст.Организация);
				
				ТекКолич = ТекКолич - СтрОст.Количество;
				КолДок = КолДок + СтрОст.Количество;
				тмп_ОбщийОстаток = тмп_ОбщийОстаток - СтрОст.Количество;
			КонецЕсли;	
		КонецЦикла;
		
		ТекСтрока = ТекстДок.ПолучитьСтроку(счТ);
		ТекСтрока = ТекСтрока + ";" + КолДок;
		ТекстДок.ЗаменитьСтроку(счТ, ТекСтрока);
		
	КонецЦикла;
	
	
	Если тзТовары.Количество() = 0 Тогда
	    ТекстДок.Записать(КаталогПоиска + НовоеИмя);
		Если ПустаяСтрока(Ошибки_вФайле) = 0 Тогда
			Сообщить(НовоеИмя+Ошибки_вФайле);
		КонецЕсли;
		Возврат 1;
	КонецЕсли;
	
	//НачатьТранзакцию();
	
	Док = документы.ПеремещениеТоваров.СоздатьДокумент();
	Док.Дата = ТекущаяДата();
	Док.Организация = ОрганизацияПоУмолчанию;//лок_ОсновнаяФирма;
	Док.Ответственный = глПользователь;
	Док.СкладОтправитель = ТекСкладОтпр;
	Док.ФилиалОтправитель = ТекСкладОтпр.Филиал;
	Запрос=новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	Склады.Ссылка
	|ИЗ
	|	Справочник.Склады КАК Склады
	|ГДЕ
	|	Склады.Филиал = &Филиал
	|	И Склады.Наименование ПОДОБНО &Наименование";
	Запрос.УстановитьПараметр("Филиал",ТекСкладПол.Филиал);
	Запрос.УстановитьПараметр("Наименование","Товар в пути%");
	Рез=Запрос.Выполнить().Выгрузить();
	Если Не Рез.Количество()=0 Тогда 
		Если Строка(ТекСкладПол.Филиал)="Москва" Тогда 
			Док.СкладПолучатель = Рез[Рез.Количество()-1].Ссылка;
		Иначе
			Если Рез.Количество()=1 Тогда 
				Док.СкладПолучатель = Рез[0].Ссылка;
			Иначе
				КП=ТекСкладПол.КонтрагентПополнениеСклада;
				Для Каждого Стрррр Из Рез Цикл
					Если КП=Стрррр.Ссылка.КонтрагентПополнениеСклада Тогда 
						Док.СкладПолучатель = Стрррр.Ссылка;
						Прервать;
					Иначе 
						Док.СкладПолучатель = ТекСкладПол;
					КонецЕсли;
				КонецЦикла;	
			КонецЕсли;	
		КонецЕсли;
	Иначе	
		Док.СкладПолучатель = ТекСкладПол;
	КонецЕсли;	
	Док.ФилиалПолучатель = ТекСкладПол.Филиал;
	Док.СтатусДокумента = Справочники.СтатусыДокументов.ПеремещениеТоваровНовый;
	Док.ВидОперации =Перечисления.ВидыОперацийПеремещенияТоваров.СвободноеПеремещение;
	
	Док.Товары.Загрузить(тзТовары); 
	Док.Комментарий=Строка(Файл)+", загружен - "+Строка(ТекущаяДата());
	
	Попытка
		Док.Записать();
		ДокОтвет=Новый ТекстовыйДокумент;
		ПутьДок = КаталогПоиска+"reply_"+Файл;
		КопироватьФайл(КаталогПоиска+НовоеИмя, ПутьДок);
		ДокОтвет.Прочитать(ПутьДок, КодировкаТекста.ANSI);
		ДокОтвет.Очистить();
		ДокОтвет.ДобавитьСтроку("Номер перемещения в 1с8;Код склада отправителя;Код склада получателя;Количество строк;Итого количество");
		ДокОтвет.ДобавитьСтроку(Док.Номер+";"+Число(Док.СкладОтправитель.Код)+";"+Число(Док.СкладПолучатель.Код)+";"+Док.Товары.Количество()+";"+Док.товары.Итог("Количество")+";");
		ДокОтвет.Записать(ПутьДок);
	Исключение
		//ОтменитьТранзакцию();
		Возврат 2;
	КонецПопытки;
	
	глДок_НеБыл_Проведен = 0;
	//Попытка
	//	Док.Записать(РежимЗаписиДокумента.Проведение);
	//Исключение
	//	ОтменитьТранзакцию();
	//	Если глДок_НеБыл_Проведен = 1 Тогда
	//		ТекстОшибки = "! Не проводится ";
	//		Сообщить(НовоеИмя+" Не проводится перемещение");
	//		Возврат 4;
	//	Иначе
	//		Возврат 2; // повторить
	//	КонецЕсли;
	//КонецПопытки;
	
	Попытка
		//ЗафиксироватьТранзакцию();
	Исключение
		Возврат 2;
	КонецПопытки;
	
	ТекстДок.Записать(КаталогПоиска + НовоеИмя);
	//глЗаписьИнформации_ДляОтправкиПоЭлПочте("Загружен документ " + Док + " из файла: " + НачальноеИмяФайла + ?(ПустаяСтрока(Ошибки_вФайле) = 1, "", "
	//|Ошибки при загрузке:" + Ошибки_вФайле) , Перечисление.СобытияДля_ЭлПисем.Программисту1С,, "Shabalin-SV@Part-kom.ru;Sokolov-AA@part-kom.ru",, "Загрузка перемещения из Инвентора");
	Возврат 1;
	
	
КонецФункции	

Функция РазложитьСтрокуПоРазделителям(Знач С, Разделители) Экспорт

	Перем Р, ЧислоВхождений, Инд, ПервоеВхождение;
	
	Р=Новый Массив;
	
	ТекС = С;
	Пока Истина Цикл
		МинПоз = Неопределено;
		Для Каждого Разделитель ИЗ Разделители Цикл
			Поз = Найти(ТекС, Разделитель);
			Если Поз <> 0 И (МинПоз = Неопределено ИЛИ Поз < МинПоз) Тогда
				МинПоз = Поз;
			КонецЕсли;
		КонецЦикла;
		Если МинПоз = Неопределено Тогда
			Р.Добавить(ТекС);
			Возврат Р;
		КонецЕсли;
		Если МинПоз > 1 Тогда
			Р.Добавить(Лев(ТекС, МинПоз-1));
		КонецЕсли;
		ТекС = Сред(ТекС, МинПоз + 1);
	КонецЦикла;
	
КонецФункции

Функция ОбработкаСтр(Стр)
	
	Нашли = Найти(Стр,";");
	Если Нашли = 0 Тогда
		Тмп = Стр;
		Стр = "";
	Иначе
		ТМП = Лев(Стр,Нашли-1);
		Стр = Сред(Стр, Нашли+1);
	КонецЕсли;
	
	Возврат ТМП;
	
КонецФункции	// ОбработкаСтр

Функция ОпределитьОбъектПоУИД(ИД)
	Элемент=Неопределено;
	Попытка
		Элемент=Справочники["Номенклатура"].ПолучитьСсылку(Новый УникальныйИдентификатор(ИД));
	Исключение
	КонецПопытки;
	Возврат Элемент;
КонецФункции

Функция глВыделяемыйНДС(Ставка)   Экспорт
	Если Не ЗначениеЗаполнено(Ставка) Тогда
		Возврат 0;
	ИначеЕсли(Ставка=Перечисления.СтавкиНДС.БезНДС) или (Ставка=Перечисления.СтавкиНДС.НДС0) Тогда
		Возврат 0;
	ИначеЕсли (Ставка=Перечисления.СтавкиНДС.НДС10) 
		  или (Ставка=Перечисления.СтавкиНДС.НДС10_110) Тогда
		Возврат  0.09090909090909090909090909091; // Это 1/11, только точнее
	ИначеЕсли (Ставка=Перечисления.СтавкиНДС.НДС20) 
		  или (Ставка=Перечисления.СтавкиНДС.НДС20_120) Тогда
		Возврат 0.166666666666666666666666666667; // Это 1/6, только точнее
	ИначеЕсли (Ставка=Перечисления.СтавкиНДС.НДС18) 
		  или (Ставка=Перечисления.СтавкиНДС.НДС18_118) Тогда
		Возврат 0.15254237288135593220338983050985  // Это округленный результат 18/118;
	Иначе
		Сообщить("Функция глВыделяемыйНДС(Ставка): неверная ставка");
		Возврат 0;
	КонецЕсли;
КонецФункции //глВыделяемыйНДС()      
