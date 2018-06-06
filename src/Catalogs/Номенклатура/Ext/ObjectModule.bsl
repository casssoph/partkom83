﻿
Перем мЗарегистрироватьИзмененияДляСайта;

Функция ДопустимаРегистрацияИзменений(вхПланОбмена, вхОбъект)
	
	Результат = Ложь;
	Если (вхПланОбмена = Метаданные.ПланыОбмена.ОбменПартКом83_Сайт) тогда
		Если НЕ вхОбъект.ЭтоГруппа
			И НЕ вхОбъект.Услуга тогда
			
			лЗапрос = Новый Запрос;
			лЗапрос.УстановитьПараметр("Изготовитель", вхОбъект.Изготовитель);
			лЗапрос.Текст = 
			"ВЫБРАТЬ
			|	ИСТИНА
			|ИЗ
			|	РегистрСведений.НеВыгружаемыеИзготовители КАК НеВыгружаемыеИзготовители
			|ГДЕ
			|	НеВыгружаемыеИзготовители.Изготовитель = &Изготовитель";
			
			Результат = лЗапрос.Выполнить().Пустой();
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриЗаписи(Отказ)
	Если мЗарегистрироватьИзмененияДляСайта тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	мЗарегистрироватьИзмененияДляСайта = ДопустимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект)
	И ОбменДаннымиКлиентСервер.НеобходимаРегистрацияИзменений(Метаданные.ПланыОбмена.ОбменПартКом83_Сайт, ЭтотОбъект);
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//#PK83-700 Kalinin V.A. ( 2018-05-24 )	
	Если не ЭтоГруппа и ЭтоНовый() тогда 
		ДатаСоздания = ТекущаяДата();
	КонецЕсли;	
	// 	
	
	Если НЕ ЭтоГруппа и Не Услуга Тогда
		//Проверка уникальности по Бренд+Артикул
		ИмяОбъекта = ЭтотОбъект.Метаданные().Имя;
		СтрРеквизитов = Новый Структура; //
		СтрРеквизитов.Вставить("Артикул", Артикул);
		СтрРеквизитов.Вставить("Изготовитель", Изготовитель);
		Если Не УправлениеЗапасами.ПрошелКонтрольУникальностиСправочникаПоРеквизиту(ИмяОбъекта, СтрРеквизитов, Ссылка) Тогда
			Сообщить("Подобный элемент справочника /" + Наименование + "/ существует!
			|Модуль: Контроль уникальности элементов справочника." );
			Отказ = Истина;
		КонецЕсли;
		
		Если ЭтоНовый() Тогда
			ОбработатьАртикул();
			ПросвоитьИДССайта();
		Иначе
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	Номенклатура.Артикул,
			|	Номенклатура.Изготовитель
			|ИЗ
			|	Справочник.Номенклатура КАК Номенклатура
			|ГДЕ
			|	Номенклатура.Ссылка = &Ссылка");
			Запрос.УстановитьПараметр("Ссылка", Ссылка);
			Выборка = Запрос.Выполнить().Выбрать();
			Выборка.Следующий();
			Если Выборка.Артикул <> Артикул ИЛИ Выборка.Изготовитель <> Изготовитель Тогда
				Отказ = Истина;
				Сообщить("Артикул и изготовитель товара может менять только на сайте.");
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоГруппа=Ложь и ПроверитьНаименование() Тогда
		Отказ = Истина;
		Сообщить("Проверьте наименование. Оно не должно быть пустым, не иметь кириллицы, состоять из одного артикула и содержать только слова-паразиты.");
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПросвоитьИДССайта()
	//НомУ=Неопределено
	WinHttp = Новый COMОбъект("WinHttp.WinHttpRequest.5.1");
	WinHttp.Option(2, "utf-8");
	//http://exchange.pre.part-kom.ru/uuid/part - тестовый вариант
	//http://exchange.part-kom.ru/uuid/part - рабочий
	WinHttp.Open("POST", СокрЛП(Константы.URL_ДляЗапросаУИД_Номенклатуры.Получить()), Ложь);
	WinHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded; charset=utf-8");
	
	ТекИзготовитель=Изготовитель.УникальныйИдентификатор();
	ТекАртикул=Артикул;
	ТекНаименование=ПреобразованиеСтрокуВURL(Наименование);
	
	ТекПараметрыПОСТ = "brand_uuid="+ТекИзготовитель+"&number="+ТекАртикул+"&name="+ТекНаименование;
	
	WinHttp.Send(ТекПараметрыПОСТ);
	XML_УИД=WinHttp.ResponseText;
	
	Разделители = Новый Массив();
	Разделители.Добавить(">");
	РазделителиСтр = Новый Массив();
	РазделителиСтр.Добавить("<");
	Данные=УправлениеЗапасами.РазложитьСтрокуПоРазделителям(XML_УИД, Разделители);
	
	ОтветЗагрузки=0;
	Замена=0;
	ТекстОшибки="";
	Для Каждого Стр Из Данные Цикл
		Если Прав(Стр,8)="/success" Тогда 
			ОтветЗагрузки=Число(Лев(Стр,1));
		ИначеЕсли Прав(Стр,11)="/brand_uuid" Тогда 
			ТекИзготовитель=Лев(Стр,36);
		ИначеЕсли Прав(Стр,5)="/uuid" Тогда 
			УИД=Лев(Стр,36);
		ИначеЕсли Прав(Стр,4)="/msg" Тогда 
			ДанныеСтр=УправлениеЗапасами.РазложитьСтрокуПоРазделителям(Стр, РазделителиСтр);
			ТекстОшибки=ДанныеСтр[0];
		ИначеЕсли Прав(Стр,12)="replacement>" Тогда 
			Замена=1;
		ИначеЕсли Прав(Стр,5)="/name" И Замена=1 Тогда 
			ДанныеСтр=УправлениеЗапасами.РазложитьСтрокуПоРазделителям(Стр, РазделителиСтр);
			ТекИзготовитель=ДанныеСтр[0];
		КонецЕсли;	
		
	КонецЦикла;

	Если НЕ УИД="" Тогда 
		ИмяМетаданных="Номенклатура";
		
		НоваяСсылка = Справочники.Номенклатура.СоздатьЭлемент();                      
		УникальныйИдентификатор = Новый УникальныйИдентификатор(УИД);
		СС = Справочники.Номенклатура.ПолучитьСсылку(УникальныйИдентификатор);     
		ЭтотОбъект.УстановитьСсылкуНового(СС);
	Иначе 
		Отказ=Истина;
		Сообщить("При создании номенклатуры проводится синхронизация с сайтом по внутреннему ИД. Такой номенклатуры нет на сайте!!!");
		Возврат;
	КонецЕсли;	
		
КонецПроцедуры	

Процедура ПередУдалением(Отказ)
	Если НЕ ЭтоГруппа тогда
		ОбменДаннымиКлиентСервер.ЗарегистрироватьОбъект(ЭтотОбъект, Метаданные.ПланыОбмена.ОбменПартКом83_Сайт);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработатьАртикул()
	
	//алгоритм должен быть единый с сайтом
	
	//Текст Лабутина: как сейчас на сайте (версия от 10.10.2016)
	//АВЕКМНОРСТХавекмнорстх русские заменяются на 
	//ABEKMHOPCTXabekmhopctx (английские)
	//т.е. те, что по русски и по английски пишутся одинаково,
	//то автоматом заменяются на английские
	//дальше удаляется ВСЁ кроме английских букв, цифр и скобок ()
	
	Артикул = СокрЛП(Артикул);
	НовАрт  = "";
	Для сч=1 По СтрДлина(Артикул) Цикл
		
		Симв_Стр = Сред(Артикул,сч,1);
		Симв_Код = КодСимвола(Симв_Стр);
		тмп_Рез  = Найти("АВЕКМНОРСТХавекмнорстх", Симв_Стр);
		
		Если (Симв_Код>=48) и (Симв_Код<=57) Тогда 
			// можно: цифры от 0 до 9
		ИначеЕсли (Симв_Стр = "(") или (Симв_Стр = ")") Тогда
			// можно
		ИначеЕсли (Симв_Код >= 65) и (Симв_Код <= 90) Тогда
			// англ. ЗАГЛ
		ИначеЕсли (Симв_Код >= 97) и (Симв_Код <= 122) Тогда
			// англ. строчн.                       
		ИначеЕсли (тмп_Рез > 0) Тогда
			// это русская буква. её надо заменить на английскую
			Симв_Стр = Сред("ABEKMHOPCTXabekmhopctx", тмп_Рез, 1);
		Иначе
			Продолжить;
		КонецЕсли;
		
		НовАрт = НовАрт + Симв_Стр;
	КонецЦикла;
	
	Артикул = НовАрт;
	
КонецПроцедуры

Функция ПроверитьНаименование()
	Наименование = СокрЛП(Наименование);
	
	Если ПустаяСтрока(Наименование) Тогда
		//если наименование не заполнено - не сохраняем элемент
		Возврат Истина;
	КонецЕсли;
	
	СписокДляПроверкиНаименования = Новый СписокЗначений;
	СписокДляПроверкиНаименования.Добавить(СокрЛП(Врег(Артикул)));
	СписокДляПроверкиНаименования.Добавить("РАСПРОДАЖА");
	СписокДляПроверкиНаименования.Добавить("БЕЗ СКИДКИ");
	СписокДляПроверкиНаименования.Добавить("СУПЕРАКЦИЯ");
	СписокДляПроверкиНаименования.Добавить("АКЦИЯ");
	СписокДляПроверкиНаименования.Добавить("NEW!!!");
	СписокДляПроверкиНаименования.Добавить("----");
	
	Для Каждого ТекЗнач Из СписокДляПроверкиНаименования Цикл
		//удалить из наименования строки из списка
		Начало = СтрНайти(ВРЕГ(Наименование), ТекЗнач.Значение);
		Если Начало > 0 Тогда
   			Наименование = Лев(Наименование, Начало - 1) + Сред(Наименование, Начало + СтрДлина(ТекЗнач.Значение));
		КонецЕсли;
	КонецЦикла;
	
	Наименование = СокрЛП(Наименование);
	
	Если ПустаяСтрока(Наименование) Тогда
		//если содержит только слова из списка - не сохраняем элемент
		Возврат Истина;
	КонецЕсли;
	
	ЕстьКириллица = Ложь;
	Для А = 0 По СтрДлина(Наименование)-1 Цикл
		// русские буквы начинаются с кода 192
		// если в наименовании есть хоть одна русская буква, значит оставляем как есть
   		// иначе в нем только анг.буквы и символы - очищаем такое наименование
		Символ = Лев(Прав(Наименование, СтрДлина(Наименование) - А), 1);
		Если ПустаяСтрока(СокрЛП(Символ)) Тогда
			Продолжить;
		ИначеЕсли КодСимвола(Символ) >= 192 Тогда
   			ЕстьКириллица  = Истина;
			Прервать;
			
  		КонецЕсли;
 		
 	КонецЦикла;
	
	Возврат НЕ ЕстьКириллица;
 
КонецФункции

Функция ПреобразованиеСтрокуВURL(Стр) 
	//ScrCtrl = Новый COMОбъект("MSScriptControl.ScriptControl"); 
	//ScrCtrl.Language="JScript"; 
	//Сообщение = ScrCtrl.eval("var uri='"+Строка+"'; encodeURI(uri);") ; 
	//Возврат Сообщение; 
	Длина=СтрДлина(Стр);
	Итог="";
	Для Н=1 По Длина Цикл
		Знак=Сред(Стр,Н,1);
		КодС=КодСимвола(Знак);
		
		если ((Знак>="a")и(Знак<="z")) или
			 ((Знак>="A")и(Знак<="Z")) или
			 ((Знак>="0")и(Знак<="9")) тогда
			Итог=Итог+Знак;
		Иначе
			Если (КодС>=КодСимвола("А"))И(КодС<=КодСимвола("п")) Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(208,16)+"%"+ПреобразоватьвСистему(144+КодС-КодСимвола("А"),16);
			ИначеЕсли (КодС>=КодСимвола("р"))И(КодС<=КодСимвола("я")) Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(209,16)+"%"+ПреобразоватьвСистему(128+КодС-КодСимвола("р"),16);
			ИначеЕсли (Знак="ё") Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(209,16)+"%"+ПреобразоватьвСистему(145,16);
			ИначеЕсли (Знак="Ё") Тогда
				Итог=Итог+"%"+ПреобразоватьвСистему(208,16)+"%"+ПреобразоватьвСистему(129,16);
			Иначе
				Итог=Итог+"%"+ПреобразоватьвСистему(КодС,16);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Возврат Итог;
КонецФункции 

Функция ПреобразоватьвСистему(Число10,система)
	
	Если система > 36 или система < 2 тогда
		Сообщить("Выбранная система исчисления не поддерживается");
		Возврат -1;
	КонецЕсли;
	
	СтрокаЗначений = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	СтрокаСистема = "";
	Пока Число10 > 0 цикл
		РезДеления = Число10/система;
		ЧислоСистема = цел(РезДеления);
		остатокОтДеления = Число10 - система*(ЧислоСистема);
		СтрокаСистема = сред(СтрокаЗначений,остатокОтДеления+1,1)+ СтрокаСистема;
		Число10 = ?(ЧислоСистема=0,0,РезДеления); 
	КонецЦикла;
	
	//!!!!!!!!
	//[
	Нечётное = стрДлина(СтрокаСистема) - цел(стрДлина(СтрокаСистема)/2)*2;
	Если Нечётное тогда
		СтрокаСистема = "0"+СтрокаСистема;
	КонецЕсли;
	//]
	Возврат СтрокаСистема;
КонецФункции


// + 20170301 Пушкин
мЗарегистрироватьИзмененияДляСайта = Ложь;
// - 20170301 Пушкин