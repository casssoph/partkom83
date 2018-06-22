﻿Перем ТабРезультат;
Перем НашКод;
Перем текНастройка;

Функция ПолучитьСтруктуруНастроекФТП(вхКонтрагент)
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Т.СерверFTP,
	|	Т.ПортFTP,
	|	Т.Логин,
	|	Т.Пароль,
	|	Т.КаталогFTP,
	|	Т.ИмяФайла,
	|	Т.ДополнениеИмениФайла1,
	|	Т.ДополнениеИмениФайла2,
	|	Т.РасширениеФайла,
	|	Т.ТипФайла,
	|	Т.КодировкаФайла,
	|	Т.ИмяФайлаОтвета
	|ИЗ
	|	Справочник.НастройкиFTP.Контрагенты КАК Т
	|ГДЕ
	|	Т.Ссылка = &Ссылка
	|	И Т.Контрагент = &Контрагент"
	);
	Запрос.УстановитьПараметр("Ссылка", Настройка);
	Запрос.УстановитьПараметр("Контрагент", вхКонтрагент);
		
	Результат = Запрос.Выполнить().Выгрузить();
	
	Если Результат.Количество() = 0 Тогда 
		Возврат 0;
	КонецЕсли;
	
	Если Результат.Количество() > 1 Тогда 
		Возврат 1;
	КонецЕсли;
	
	выхСтруктура = Новый Структура;
	СтрокаРезультата = Результат[0];
	Для Каждого Кол Из Результат.Колонки Цикл
		выхСтруктура.Вставить(Кол.Имя, СтрокаРезультата[Кол.Имя]);
	КонецЦикла;
	
	Возврат выхСтруктура;
	
КонецФункции

Процедура ЗагрузитьФайл()
	Если текНастройка.ТипФайла <> Перечисления.ТипыФайлов.txt Тогда
		Возврат;
	КонецЕсли;
		
	FTPСоединение = Новый FTPСоединение(текНастройка.СерверFTP, Число(текНастройка.ПортFTP), текНастройка.Логин, текНастройка.Пароль);
	Если НЕ ПустаяСтрока(текНастройка.КаталогFTP) Тогда
		Если Лев(текНастройка.КаталогFTP,5) = "*/337" Тогда
			//костыль для Денсо
			FTPСоединение.УстановитьТекущийКаталог("337");
			FTPСоединение.УстановитьТекущийКаталог("Export");
		Иначе
			FTPСоединение.УстановитьТекущийКаталог(текНастройка.КаталогFTP);
		КонецЕсли;
	КонецЕсли;
	
	//ИмяФайла = текНастройка.ИмяФайла
	//	+ ?(ПустаяСтрока(текНастройка.ДополнениеИмениФайла1), "", "_" + текНастройка.ДополнениеИмениФайла1)
	//	+ ?(ПустаяСтрока(текНастройка.ДополнениеИмениФайла2), "", "_" + текНастройка.ДополнениеИмениФайла2)
	//	+ "." + текНастройка.РасширениеФайла;
	
	ИмяФайла = текНастройка.ИмяФайла + "*";
	
	ФайлыFTP = FTPСоединение.НайтиФайлы(ИмяФайла);
	Если ФайлыFTP.Количество() = 0 Тогда
		Сообщить("не найдено файлов");
		Возврат; 
	КонецЕсли;
	
	Если Настройка.ОбъектМетаданных = "ПереоценкаОстатковПоставщика" Тогда
		текФайл = ФайлыFTP[0];
		Для А = 0 По ФайлыFTP.Количество() - 1 Цикл
			Если ФайлыFTP[А].ПолучитьВремяИзменения() > текФайл.ПолучитьВремяИзменения() Тогда
				текФайл = ФайлыFTP[А];
			КонецЕсли;
		КонецЦикла;
		
		ВременныйФайл = ПолучитьИмяВременногоФайла("txt"); 
		FTPСоединение.Получить(текФайл.Имя, ВременныйФайл);
		ПрочитатьТекстФайл(ВременныйФайл);
			
		
		//Попытка
		//	//FTPСоединение.Удалить(текФайл.Имя);
		//	//FTPСоединение.Переместить(текФайл.Имя, "done_" + текФайл.Имя);
		//Исключение
		//	//скорее всего нет доступа на фтп
		//	
		//КонецПопытки;
		
	Иначе
		Для А = 0 По ФайлыFTP.Количество() - 1 Цикл
			текФайл = ФайлыFTP[А];
			ВременныйФайл = ПолучитьИмяВременногоФайла("txt"); 
			FTPСоединение.Получить(текФайл.Имя, ВременныйФайл);
			ПрочитатьТекстФайл(ВременныйФайл, Истина, текФайл.ПолучитьВремяИзменения());
		
		КонецЦикла;
		
	КонецЕсли;
	
	
	
	//Если Источник.ЭтоФайл() Тогда
	//	
	//	Если Настройка.ТипФайла = Перечисления.ТипыФайлов.xls Тогда
	//		ПрочитатьФайлXLS(Источник.ПолноеИмя);
	//	ИначеЕсли Настройка.ТипФайла = Перечисления.ТипыФайлов.xml Тогда
	//		ПрочитатьФайлXML(Источник.ПолноеИмя);
	//	ИначеЕсли Настройка.ТипФайла = Перечисления.ТипыФайлов.txt Тогда
	//		ПрочитатьТекстФайл(Источник.ПолноеИмя);
	//	Иначе
	//		Возврат;
	//		
	//	КонецЕсли;
	//	
	//ИначеЕсли Источник.ЭтоКаталог() Тогда
	//	
	//	СписокФайлов = НайтиФайлы(Источник.ПолноеИмя, "*.xml");
	//	Для Каждого ФайлДляЗагрузки Из СписокФайлов Цикл
	//		ПрочитатьФайлXML(ФайлДляЗагрузки.ПолноеИмя);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	
КонецПроцедуры

Процедура ВыгрузитьФайл()
	ТекстовыйДок = Новый ТекстовыйДокумент; 
	
	КолКолонок = ТабРезультат.Колонки.Количество();
	
	Для Каждого Стр Из ТабРезультат Цикл
		СтрокаФайла = "";
		Для а = 0 По КолКолонок - 1 Цикл
			Если а = 0 Тогда
				СтрокаФайла = СокрЛП(Стр[а]);
			Иначе
				СтрокаФайла = СтрокаФайла + ";" + СокрЛП(Стр[а]);
			КонецЕсли;
		КонецЦикла;
		ТекстовыйДок.ДобавитьСтроку(СтрокаФайла);
		
	КонецЦикла;
	
	ВременныйФайл = ПолучитьИмяВременногоФайла("txt"); 
	ТекстовыйДок.Записать(ВременныйФайл, текНастройка.КодировкаФайла); 
	
	ИмяФайла = текНастройка.ИмяФайла + ?(ПустаяСтрока(НашКод), "", "_" + НашКод) + "." + текНастройка.РасширениеФайла;
	FTPСоединение = Новый FTPСоединение(текНастройка.СерверFTP, Число(текНастройка.ПортFTP), текНастройка.Логин, текНастройка.Пароль);
	Если НЕ ПустаяСтрока(текНастройка.КаталогFTP) Тогда
		FTPСоединение.УстановитьТекущийКаталог(текНастройка.КаталогFTP);
	КонецЕсли;
	FTPСоединение.Записать(ВременныйФайл, ИмяФайла);

	
КонецПроцедуры

Функция ПрочитатьФайлыОтвета()
	FTPСоединение = Новый FTPСоединение(текНастройка.СерверFTP, текНастройка.ПортFTP, текНастройка.Логин, текНастройка.Пароль);
	Каталог = текНастройка.КаталогFTP;
	Если Настройка.ОбъектМетаданных = "ЗаказПоставщику" Тогда
		Каталог = "Export";
	КонецЕсли;
	Если НЕ ПустаяСтрока(Каталог) Тогда
		FTPСоединение.УстановитьТекущийКаталог(Каталог);
	КонецЕсли;
	
	ИмяФайлаОтвета = СокрЛП(ИмяФайлаОтвета);
	ИмяФайлаОтвета = ?(Прав(ИмяФайлаОтвета, 1) = "*", ИмяФайлаОтвета, ИмяФайлаОтвета + "*");
	ФайлыFTP = FTPСоединение.НайтиФайлы(ИмяФайлаОтвета);
	//ФайлыFTP = FTPСоединение.НайтиФайлы(FTPСоединение.ТекущийКаталог(), ИмяФайлаОтвета);
	
	Если ФайлыFTP.Количество() = 0 Тогда
		Сообщить("не найдено файлов");
		Возврат Ложь; 
	КонецЕсли;
	
	Для А = 0 По ФайлыFTP.Количество() - 1 Цикл
		текФайл = ФайлыFTP[А];
		ВременныйФайл = ПолучитьИмяВременногоФайла("txt"); 
		FTPСоединение.Получить(текФайл.Имя, ВременныйФайл);
		ПрочитатьТекстФайл(ВременныйФайл, Истина);
		FTPСоединение.Удалить(текФайл.Имя);
		
	КонецЦикла;
	
	Если Настройка.ФормаДокумента = Перечисления.ФормыОбъектовДляРегистрацииFTP.МХ3
		ИЛИ Настройка.ОбъектМетаданных = "ЗаказПоставщику" Тогда
		Возврат ТабРезультат;
	КонецЕсли;
	
	Если ТабРезультат.Количество() > 0 Тогда
		пар = Новый Структура("НашКод", ОбщегоНазначения.ПолучитьЗначениеРеквизита(ТекущийОбъект, "Номер"));
		Строки = ТабРезультат.НайтиСтроки(пар);
		Если Строки.Количество() = 0 Тогда
			Возврат Ложь;
		Иначе
			Возврат Истина;
		КонецЕсли;
	Иначе
		Возврат Ложь;
		
	КонецЕсли;
		
КонецФункции

Процедура ОбработатьЭлемент(ОбъектXML, Ключ)
	
КонецПроцедуры

Функция ПолучитьТекстЭлемента(ОбъектXML)

	Если ОбъектXML.Прочитать() И ОбъектXML.ТипУзла = ТипУзлаXML.Текст Тогда
		Возврат ОбъектXML.Значение;
	Иначе
		Возврат "";
	КонецЕсли;

КонецФункции

Процедура ПрочитатьСтруктуруКаталогов(ОбъектXML, ПрефиксНазванияГруппы = "")
	
	НаименованиеУзла = "";
	ИдУзла = "";
	ПолноеИмяУровня = "";
	
	Пока ОбъектXML.Прочитать() Цикл

		ТипУзла = ОбъектXML.ТипУзла;
		ИмяУзла = ОбъектXML.Имя;

		Если ТипУзла = ТипУзлаXML.НачалоЭлемента
			И ИмяУзла = "Группы" Тогда
			
			ПрочитатьСтруктуруКаталогов(ОбъектXML, ПолноеИмяУровня);
			
		ИначеЕсли ТипУзла = ТипУзлаXML.НачалоЭлемента
			И ИмяУзла = "Ид" Тогда
			
			ИдУзла = ПолучитьТекстЭлемента(ОбъектXML);
						
		ИначеЕсли ТипУзла = ТипУзлаXML.НачалоЭлемента
			И ИмяУзла = "Наименование" Тогда
			
			НаименованиеУзла = ПолучитьТекстЭлемента(ОбъектXML);
			ПолноеИмяУровня = ПрефиксНазванияГруппы + ?(Пустаястрока(ПрефиксНазванияГруппы), "", "\") + НаименованиеУзла;
			//мСоотвествияКаталогов.Вставить(ИдУзла, ПолноеИмяУровня);
			
		ИначеЕсли ТипУзла = ТипУзлаXML.КонецЭлемента
			И ИмяУзла = "Группы" Тогда
			
			Возврат;
			
		КонецЕсли;

	КонецЦикла;	
		
КонецПроцедуры

Процедура ПрочитатьФайлXLS(СтруктураФайла)
	
	Перем АртикулВНаименовании; 
	СтруктураФайла.Свойство("АртикулВНаименовании", АртикулВНаименовании);
	Если АртикулВНаименовании = Неопределено Тогда 
		АртикулВНаименовании = Ложь;
	КонецЕсли;
	
	Если СтруктураФайла.Свойство("ИмяФайла") = Неопределено Тогда
		Сообщить("не задано имя файла");
		Возврат;
	КонецЕсли;
	
	Если СтруктураФайла.Свойство("СтруктураТабЧасти") = Неопределено Тогда
		Сообщить("не задана структура считываемой табличной части");
		Возврат;
	КонецЕсли;
	Для Каждого КлючИЗначение Из СтруктураФайла.СтруктураТабЧасти Цикл
		Если КлючИЗначение.Ключ = "АртикулПоставщика" Тогда
			КС = Новый КвалификаторыСтроки(30);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		ИначеЕсли КлючИЗначение.Ключ = "ИзготовительПоставщика" Тогда
			КС = Новый КвалификаторыСтроки(100);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		ИначеЕсли КлючИЗначение.Ключ = "Изготовитель" Тогда
			КС = Новый КвалификаторыСтроки(100);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		ИначеЕсли КлючИЗначение.Ключ = "Артикул" Тогда
			КС = Новый КвалификаторыСтроки(25);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		ИначеЕсли КлючИЗначение.Ключ = "Количество" Тогда
			КЧ = Новый КвалификаторыЧисла(15,3);
			ТипДанных = Новый ОписаниеТипов("Число", КЧ);
		ИначеЕсли КлючИЗначение.Ключ = "Цена" 
			ИЛИ КлючИЗначение.Ключ = "Сумма" ИЛИ КлючИЗначение.Ключ = "СуммаНДС" Тогда
			КЧ = Новый КвалификаторыЧисла(15,2);
			ТипДанных = Новый ОписаниеТипов("Число", КЧ);
		ИначеЕсли КлючИЗначение.Ключ = "НомерЗаказа" Тогда
			КС = Новый КвалификаторыСтроки(20);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		Иначе
			КС = Новый КвалификаторыСтроки(1000);
			ТипДанных = Новый ОписаниеТипов("Строка", КС);
		КонецЕсли;
		
		ТабРезультат.Колонки.Добавить(КлючИЗначение.Ключ, ТипДанных);
		
	КонецЦикла;
	
	//Попытка
	Попытка
		Excel = Новый COMОбъект("Excel.Application");
		Excel.WorkBooks.Open(СтруктураФайла.ИмяФайла);
		#Если Клиент Тогда
			Состояние("Обработка файла Microsoft Excel...");
		#КонецЕсли
		
	Исключение
		#Если Клиент Тогда
			Сообщить("Ошибка при открытии файла с помощью Excel! Загрузка не будет произведена!");
			Сообщить(ОписаниеОшибки());
		#КонецЕсли
		Возврат;
		
	КонецПопытки;
	
	Попытка
		//Открываем необходимый лист
		Excel.Sheets(1).Select(); // лист 1, по умолчанию
		
	Исключение
		//Закрываем Excel
		Excel.ActiveWorkbook.Close();
		Excel = 0;
		#Если Клиент Тогда
			Сообщить("Файл "+Строка(ИмяФайла)+" не соответствует необходимому формату! Первый лист не найден!");
		#КонецЕсли
		ОтменитьТранзакцию();
		Возврат;
		
	КонецПопытки;
	
	Версия = Лев(Excel.Version,Найти(Excel.Version,".")-1);
	Если Версия = "8" тогда
		ФайлСтрок = Excel.Cells.CurrentRegion.Rows.Count;
		ФайлКолонок = Макс(Excel.Cells.CurrentRegion.Columns.Count, 13);
		
	Иначе
		ФайлСтрок = Excel.Cells(1,1).SpecialCells(11).Row;
		ФайлКолонок = Excel.Cells(1,1).SpecialCells(11).Column;
		
	Конецесли;
	
	Если АртикулВНаименовании И ТабРезультат.Колонки.Найти("Артикул") = Неопределено Тогда 
		КС = Новый КвалификаторыСтроки(25);
		ТипДанных = Новый ОписаниеТипов("Строка", КС);

		ТабРезультат.Колонки.Добавить("Артикул", ТипДанных); 
	КонецЕсли;
	
	Для НС = СтруктураФайла.НомерПервойСтроки по СтруктураФайла.НомерПоследнейСтроки Цикл // НС указываем с какой строки начинать обработку
		#Если Клиент Тогда
			Состояние("Файл "+Строка(ИмяФайла)+": Обрабатывается первый лист "+Строка(Формат(?(ФайлСтрок=0,0,((100*НС)/ФайлСтрок)),"ЧЦ=3; ЧДЦ=0"))+" %");
			ОбработкаПрерыванияПользователя(); //указав данный оператор, цикл можно прервать в любой момент нажатие ctrl+break
		#КонецЕсли
		
		НоваяСтрока = ТабРезультат.Добавить();
	    Для Каждого КлючИЗначение Из СтруктураФайла.СтруктураТабЧасти Цикл  
            НомерКолонки = КлючИЗначение.Значение;
			ИмяКолонки = КлючИЗначение.Ключ;
			
			//Для НомерКолонки = 1 по ТабРезультат.Колонки.Количество() Цикл
			//заполняем строку значениями
			//ИмяКолонки = ТабРезультат.Колонки[НомерКолонки-1].Имя;
			//ТекНомерКолонки = СтруктураФайла.СтруктураТабЧасти[ИмяКолонки];
			//ТекНомерКолонки = НомерКолонки;
			
			ТекущееЗначение = Excel.Cells(НС, НомерКолонки).Text;
			Попытка
				Если ТипЗнч(НоваяСтрока[ИмяКолонки]) = Тип("Число") Тогда
					ТекущееЗначение = СтрЗаменить(ТекущееЗначение, Символы.НПП, "");
					ТекущееЗначение = СтрЗаменить(ТекущееЗначение, " ", "");
					ТекущееЗначение = СтрЗаменить(ТекущееЗначение, ".", "");
					Если ТекущееЗначение="" Тогда ТекущееЗначение=0; КонецЕсли;
					НоваяСтрока[ИмяКолонки] = Число(ТекущееЗначение);
				Иначе
					Если ИмяКолонки = "Наименование" Тогда 
						Если АртикулВНаименовании Тогда 
							мМассивПодстрок = ОбщегоНазначения.РазложитьСтрокуВМассивПодстрок(ТекущееЗначение, " ");
							Если мМассивПодстрок.Количество() > 0 Тогда 
								НоваяСтрока.Артикул = ЭлектронныеДокументы.НормализоватьСтрокуАртикула(СокрЛП(мМассивПодстрок[мМассивПодстрок.ВГраница()])) 	
							КонецЕсли;
						КонецЕсли;
						НоваяСтрока[ИмяКолонки] = ТекущееЗначение;	
					ИначеЕсли ИмяКолонки="Артикул" Или ИмяКолонки="АртикулПоставщика" Тогда 
						НоваяСтрока[ИмяКолонки] = ЭлектронныеДокументы.НормализоватьСтрокуАртикула(ТекущееЗначение);
					ИначеЕсли ИмяКолонки="Изготовитель" Или ИмяКолонки="ИзготовительПоставщика" Тогда 
						НоваяСтрока[ИмяКолонки] = ЭлектронныеДокументы.НормализоватьСтрокуИзготовителя(ТекущееЗначение);
					Иначе 	
						НоваяСтрока[ИмяКолонки] = ТекущееЗначение;
					КонецЕсли;	
				КонецЕсли;
			Исключение
			КонецПопытки;
			
		КонецЦикла;
				
	КонецЦикла;
	//Исключение
	//КонецПопытки;
	Попытка
		Excel.ActiveWorkbook.Close();
		Excel = 0;
	Исключение
		Сообщить("не удалось закрыть файл");
	КонецПопытки;
	
КонецПроцедуры

Процедура ПрочитатьФайлXML(ИмяФайла)

	ОбъектXML = Новый ЧтениеXML;
	
	Попытка
		ОбъектXML.ОткрытьФайл(ИмяФайла);
		
		Пока ОбъектXML.Прочитать() Цикл

			ТипУзла = ОбъектXML.ТипУзла;
			ИмяУзла = ОбъектXML.Имя;

			Если ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ПолноеИмяУровня = СокрЛП(ИмяУзла) +"_" + ПолноеИмяУровня;
				ОбработатьЭлемент(ОбъектXML, ПолноеИмяУровня);

			ИначеЕсли ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				
				ПозицияРазделителя = Найти(ПолноеИмяУровня, "_");
				Если ПозицияРазделителя Тогда
					ПолноеИмяУровня = Сред(ПолноеИмяУровня, ПозицияРазделителя + 1);
				Иначе
					Прервать;
				КонецЕсли;
				
			КонецЕсли;

		КонецЦикла;
		
	Исключение
		ОписаниеОшибкиЗаписи = ОписаниеОшибки();
		ОбъектXML.Закрыть();		
		#Если клиент тогда
		Сообщить("Возникла ошибка при чтении данных для обмена: " + Символы.ПС + ОписаниеОшибкиЗаписи, СтатусСообщения.Важное);
		#КонецЕсли
		Возврат;
	КонецПопытки;
	
	ОбъектXML.Закрыть();

КонецПроцедуры

Процедура ПрочитатьТекстФайл(ТекИмяФайла, ФайлОтвет = Ложь, вхДатаФайла = Неопределено)
	
	//Если Настройка.ФормаДокумента = Перечисления.ФормыОбъектовДляРегистрацииFTP.МХ1 тогда
	//	Возврат;
	//КонецЕсли;
	
	Разделитель = ";";
		
	ЗагружаемыйФайл = Новый ТекстовыйДокумент;
	ЗагружаемыйФайл.Прочитать(ТекИмяФайла, текНастройка.КодировкаФайла);
	
	Если Настройка.ОбъектМетаданных = "ПоступлениеТоваровУслуг" И НЕ Настройка.ФормаДокумента = Перечисления.ФормыОбъектовДляРегистрацииFTP.МХ1 Тогда
	//Если Настройка.ОбъектМетаданных = "ПоступлениеТоваровУслуг" Тогда
		Для Каждого Стр Из Настройка.СоответствияПолей Цикл
			Если Стр.ФайлОтвет Тогда
				ТабРезультат.Колонки.Добавить(Стр.ПолеОбъекта);
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли Настройка.ОбъектМетаданных = "ЗаказПоставщику" Тогда
		ТабРезультат.Колонки.Очистить();
		ТабРезультат.Колонки.Добавить("КодОтгрузкиПоставщика");
		
		Если ЗагружаемыйФайл.КоличествоСтрок() = 1 Тогда
			Строка = ЗагружаемыйФайл.ПолучитьСтроку(1);
			МассивКол = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
			текЗначение = МассивКол[1];
			нс = ТабРезультат.Добавить();
			нс.КодОтгрузкиПоставщика = СокрЛП(текЗначение);
		КонецЕсли;
		
		Возврат;

		
	Иначе
		Если НЕ ПустаяСтрока(ИмяФайлаОтвета) Тогда
			ТабРезультат.Колонки.Добавить("НашКод");
			ТабРезультат.Колонки.Добавить("КодОтвета");
		КонецЕсли;
	КонецЕсли;
	
	ДописыватьДатуФайла = Ложь;//колонка ДатаФайла - всегда должна быть последней
	Если ТабРезультат.Колонки.Найти("ДатаФайла") <> Неопределено Тогда
		ДописыватьДатуФайла = Истина;
	КонецЕсли;
	
	Для НомерСтроки = 1 по ЗагружаемыйФайл.КоличествоСтрок() Цикл
		
		#Если Клиент Тогда
			//Состояние("Чтение файла. Обрабатывается "+Строка(Формат(?(ЗагружаемыйФайл.КоличествоСтрок()=0,0,((100*НомерСтроки)/ЗагружаемыйФайл.КоличествоСтрок())),"ЧЦ=3; ЧДЦ=0"))+" %");
			
			ОбработкаПрерыванияПользователя();
		#КонецЕсли
			
		// получить стрoку с указанным номером и преобразуем её в массив
		Строка = ЗагружаемыйФайл.ПолучитьСтроку(НомерСтроки);
		Если Лев(Строка, 1) = Символ(34) Тогда
			Строка = Прав(Строка, СтрДлина(Строка) - 1);
		КонецЕсли;
				
		Если Прав(Строка, 1) = Символ(34) Тогда
			Строка = Лев(Строка, СтрДлина(Строка) - 1);
		КонецЕсли;
		
		
		МассивКол = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Строка, Разделитель);
		
		нс = ТабРезультат.Добавить();
		Для а = 0 По МассивКол.Количество()-1 Цикл 
			текЗначение = МассивКол[а];
			Если ТабРезультат.Колонки[а].Имя = "Цена"
				ИЛИ ТабРезультат.Колонки[а].Имя = "Количество"
				ИЛИ ТабРезультат.Колонки[а].Имя = "Сумма" Тогда
				текЗначение = СтрЗаменить(текЗначение, ",", ".");
			КонецЕсли;
			нс[а] = текЗначение;
		КонецЦикла;
		
		Если ДописыватьДатуФайла Тогда
			нс.ДатаФайла = вхДатаФайла;
		КонецЕсли;
		
	КонецЦикла;
	
	//Если ТабРезультат.Количество() = ЗагружаемыйФайл.КоличествоСтрок() Тогда
	//	//удалить файл
	//	Возврат Истина;
	//Иначе
	//	Возврат Ложь;
	//КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьЗагруженныеДанные()
	
КонецПроцедуры

//основной обработчик
Функция ВыполнитьОбработку(СтруктураXLS = Неопределено) Экспорт
	Если СтруктураXLS <> Неопределено Тогда
		ПрочитатьФайлXLS(СтруктураXLS);
		Возврат ТабРезультат;
	Иначе
		Если ТипЗнч(ТекущийОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
			текНастройка = ПолучитьСтруктуруНастроекФТП(ТекущийОбъект);
		Иначе
			Если НЕ ОбщегоНазначения.ЕстьРеквизитДокумента("Контрагент", ТекущийОбъект.Метаданные()) Тогда
				Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
				|	отсутствует реквизит ""Контрагент"".");
				Возврат Неопределено;
			КонецЕсли;
			
			текНастройка = ПолучитьСтруктуруНастроекФТП(ТекущийОбъект.Контрагент);
			
		КонецЕсли;
		
		Если текНастройка = 0 Тогда
			Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
			|	настройка отсутствует.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если текНастройка = 1 Тогда
			Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
			|	задано более одной настройки.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если Настройка.Выгрузка Тогда
			
			Если НЕ ПустаяСтрока(ИмяФайлаОтвета) Тогда
				Возврат ПрочитатьФайлыОтвета();
			КонецЕсли;
			
			ТабРезультат.Колонки.Добавить("НашКод");
			ПараметрыДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ТекущийОбъект, "Номер,Дата");
			Если текНастройка.ДополнениеИмениФайла1 = "Номер" Тогда
				НашКод = НашКод + ПараметрыДокумента.Номер;
				
			КонецЕсли;
			Если текНастройка.ДополнениеИмениФайла2 = "Дата" Тогда
				Если ПустаяСтрока(НашКод) Тогда
					НашКод = НашКод + Формат(ПараметрыДокумента.Дата,"ДФ=ddMMyyyy");
				Иначе
					НашКод = НашКод + "_" + Формат(ПараметрыДокумента.Дата,"ДФ=ddMMyyyy");
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого Стр Из Настройка.СоответствияПолей Цикл
			Если Настройка.Выгрузка Тогда
				Если НЕ Стр.ФайлОтвет Тогда
					ТабРезультат.Колонки.Добавить(Стр.ПолеФайла);
				КонецЕсли;
			Иначе
				Если НЕ Стр.ФайлОтвет Тогда
					ТабРезультат.Колонки.Добавить(Стр.ПолеОбъекта);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если ТипЗнч(ТекущийОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
			
		Иначе
			Если  ТекущийОбъект.Контрагент = 
				Справочники.Контрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор("46b62c03-f29e-4247-82f7-a885b6f8cd37")) Тогда
				ТабРезультат.Колонки.Добавить("НомерГТД");
				ТабРезультат.Колонки.Добавить("КодСтраны");
				ТабРезультат.Колонки.Добавить("НомерМХ1");
				ТабРезультат.Колонки.Добавить("ДатаМХ1");
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Настройка.Выгрузка Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "Выбрать 
			|	&НашКод КАК НашКод";
			
			Если Настройка.ОбъектМетаданных = "ПоступлениеТоваровУслуг" Тогда
				Запрос.Текст = Запрос.Текст + ",
				|	НП.АртикулПоставщика КАК АртикулПоставщика,
				|	Таб.Количество,
				|	Таб.Цена";
				
				Если ТипЗнч(ТекущийОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
					
				Иначе
					Если ТекущийОбъект.Контрагент = 
						Справочники.Контрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор("46b62c03-f29e-4247-82f7-a885b6f8cd37")) Тогда
                    	Запрос.Текст = Запрос.Текст + ",
						|	Таб.НомерГТД,
						|	Таб.СтранаПроисхождения.Код КАК КодСтраны,
						|	Таб.СтрокаПрихода.Приход.НомерВходящегоДокумента КАК НомерМХ1,
						|	Таб.СтрокаПрихода.Приход.ДатаВходящегоДокумента КАК ДатаМХ1";
					КонецЕсли;
				КонецЕсли;
				
				Запрос.Текст = Запрос.Текст + "
				|ИЗ Документ.ПоступлениеТоваровУслуг.Товары КАК Таб
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НП
				|		ПО Таб.Ссылка.Контрагент = НП.Владелец
				|			И Таб.Номенклатура = НП.Номенклатура
				|ГДЕ	
				|	Таб.Ссылка = &Ссылка";
			ИначеЕсли Настройка.ОбъектМетаданных = "ЗаказПоставщику" Тогда
				Запрос.Текст = Запрос.Текст + ",
				|	Таб.Ссылка.Склад.Код КАК КодСклада,
				|	НК.АртикулПоставщика КАК АртикулПоставщика,
				|	НК.ИзготовительПоставщика КАК ИзготовительПоставщика,
				|	Таб.Количество КАК Количество
				|ИЗ Документ.ЗаказПоставщику.Товары КАК Таб
				|	ЛЕВОЕ СОЕДИНЕНИЕ
				|		Справочник.НоменклатураКонтрагентов КАК НК
				|		ПО Таб.Ссылка.Контрагент = НК.Владелец
				|			И Таб.Номенклатура =  НК.Номенклатура
				|ГДЕ	
				|	Таб.Ссылка = &Ссылка";
			Иначе
				Для Каждого Стр Из Настройка.СоответствияПолей Цикл
					Если НЕ Стр.ФайлОтвет Тогда
						Запрос.Текст = Запрос.Текст + ",
						|	Таб." + Стр.ПолеОбъекта + " КАК " + Стр.ПолеФайла;
					КонецЕсли;
					
				КонецЦикла;
				Запрос.Текст = Запрос.Текст + "
				|ИЗ Документ." + Настройка.ОбъектМетаданных + "." + Настройка.ТабличнаяЧастьОбъектаМетаданных + " КАК Таб
				|ГДЕ	
				|	Таб.Ссылка = &Ссылка";
				
			КонецЕсли;
			Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект);
			Запрос.УстановитьПараметр("НашКод", НашКод);
			ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабРезультат);		
			
			Для Каждого Стр Из ТабРезультат Цикл
				Если ТабРезультат.Колонки.Найти("КодСклада") <> Неопределено Тогда
					КодСклада = "";
					ПервыйНеНоль = Ложь;
					Для А = 0 По СтрДлина(Стр.КодСклада) - 1 Цикл
						Символ = Лев(Прав(Стр.КодСклада, СтрДлина(Стр.КодСклада)-А), 1);
						Если Символ = "0" И Не ПервыйНеНоль Тогда
							Продолжить;
						Иначе
							ПервыйНеНоль = Истина;
							КодСклада = КодСклада + Символ;
						КонецЕсли;
					КонецЦикла;
					Стр.КодСклада = КодСклада;
				КонецЕсли;
				
				Если ТабРезультат.Колонки.Найти("Цена") <> Неопределено Тогда
					тЦена = Строка(Стр.Цена);
					тЦена = СтрЗаменить(тЦена, Символы.НПП, "");
					тЦена = СтрЗаменить(тЦена, " ", "");
					Стр.Цена = тЦена;
					
				КонецЕсли;
				
				Если ТабРезультат.Колонки.Найти("ДатаМХ1") <> Неопределено Тогда
					Стр.ДатаМХ1 = Формат(Стр.ДатаМХ1, "ДФ=dd.MM.yy");
				КонецЕсли;
				
			КонецЦикла;
			
			Попытка 
				ВыгрузитьФайл();
				Возврат Истина;
				
			Исключение
				Возврат Ложь;
				
			КонецПопытки;
			
		Иначе
			ЗагрузитьФайл();
			
			Возврат ТабРезультат;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция ВыполнитьОбработкуСравнениеЗаказов(СтруктураXLS = Неопределено) Экспорт
	Если СтруктураXLS <> Неопределено Тогда
		ПрочитатьФайлXLS(СтруктураXLS);
		Возврат ТабРезультат;
	Иначе
		Если ТипЗнч(ТекущийОбъект) = Тип("СправочникСсылка.Контрагенты") Тогда
			текНастройка = ПолучитьСтруктуруНастроекФТП(ТекущийОбъект);
		Иначе
			Если НЕ ОбщегоНазначения.ЕстьРеквизитДокумента("Контрагент", ТекущийОбъект.Метаданные()) Тогда
				Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
				|	отсутствует реквизит ""Контрагент"".");
				Возврат Неопределено;
			КонецЕсли;
			
			текНастройка = ПолучитьСтруктуруНастроекФТП(ТекущийОбъект.Контрагент);
			
		КонецЕсли;
		
		Если текНастройка = 0 Тогда
			Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
			|	настройка отсутствует.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если текНастройка = 1 Тогда
			Сообщить("невозможно определить настройку выгрузки/загрузки для этого документа.
			|	задано более одной настройки.");
			Возврат Неопределено;
		КонецЕсли;
		
		Если Настройка.Выгрузка Тогда
			
			Если НЕ ПустаяСтрока(ИмяФайлаОтвета) Тогда
				Возврат ПрочитатьФайлыОтвета();
			КонецЕсли;
			
			ТабРезультат.Колонки.Добавить("НашКод");
			ПараметрыДокумента = ОбщегоНазначения.ПолучитьЗначенияРеквизитов(ТекущийОбъект, "Номер,Дата");
			Если текНастройка.ДополнениеИмениФайла1 = "Номер" Тогда
				НашКод = НашКод + ПараметрыДокумента.Номер;
				
			КонецЕсли;
			Если текНастройка.ДополнениеИмениФайла2 = "Дата" Тогда
				Если ПустаяСтрока(НашКод) Тогда
					НашКод = НашКод + Формат(ПараметрыДокумента.Дата,"ДФ=ddMMyyyy");
				Иначе
					НашКод = НашКод + "_" + Формат(ПараметрыДокумента.Дата,"ДФ=ddMMyyyy");
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Для Каждого Стр Из Настройка.СоответствияПолей Цикл
			Если Настройка.Выгрузка Тогда
				Если НЕ Стр.ФайлОтвет Тогда
					ТабРезультат.Колонки.Добавить(Стр.ПолеФайла);
				КонецЕсли;
			Иначе
				Если НЕ Стр.ФайлОтвет Тогда
					ТабРезультат.Колонки.Добавить(Стр.ПолеОбъекта);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если Настройка.Выгрузка Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "Выбрать 
			|	&НашКод КАК НашКод";
			
			Если Настройка.ОбъектМетаданных = "ПоступлениеТоваровУслуг" Тогда
				Запрос.Текст = Запрос.Текст + ",
				|	НП.АртикулПоставщика КАК АртикулПоставщика,
				|	Таб.Количество,
				|	Таб.Цена
				|ИЗ Документ.ПоступлениеТоваровУслуг.Товары КАК Таб
				|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НоменклатураКонтрагентов КАК НП
				|		ПО Таб.Ссылка.Контрагент = НП.Владелец
				|			И Таб.Номенклатура = НП.Номенклатура
				|ГДЕ	
				|	Таб.Ссылка = &Ссылка";
			Иначе
				Для Каждого Стр Из Настройка.СоответствияПолей Цикл
					Если НЕ Стр.ФайлОтвет Тогда
						Запрос.Текст = Запрос.Текст + ",
						|	Таб." + Стр.ПолеОбъекта + " КАК " + Стр.ПолеФайла;
					КонецЕсли;
					
				КонецЦикла;
				Запрос.Текст = Запрос.Текст + "
				|ИЗ Документ." + Настройка.ОбъектМетаданных + "." + Настройка.ТабличнаяЧастьОбъектаМетаданных + " КАК Таб
				|ГДЕ	
				|	Таб.Ссылка = &Ссылка";
				
			КонецЕсли;
			Запрос.УстановитьПараметр("Ссылка", ТекущийОбъект);
			Запрос.УстановитьПараметр("НашКод", НашКод);
			ОбщегоНазначения.ЗагрузитьВТаблицуЗначений(Запрос.Выполнить().Выгрузить(), ТабРезультат);		
			
			Попытка 
				ВыгрузитьФайл();
				Возврат Истина;
				
			Исключение
				Возврат Ложь;
				
			КонецПопытки;
			
		Иначе
			ЗагрузитьФайл();
			
			Возврат ТабРезультат;
			
		КонецЕсли;
	КонецЕсли;
КонецФункции

ТабРезультат = Новый ТаблицаЗначений;
НашКод = "";