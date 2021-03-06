﻿Функция ПолучитьШтрихКод(Ссылка) Экспорт

	Если ЗначениеЗаполнено(Ссылка) Тогда
		ИдДокумента = СтрЗаменить(Строка(Ссылка.УникальныйИдентификатор()),"-","");
		Возврат ПолучитьДесятичноеПредставление(ИдДокумента);
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции // ПолучитьШтрихкод()

Функция ПолучитьДесятичноеПредставление(Значение)
	
	Значение = НРег(Значение);
	ДлинаСтроки = СтрДлина(Значение);
	
	Результат = 0;
	Для НомерСимвола = 1 По ДлинаСтроки Цикл
		Результат = Результат * 16 + СтрНайти("0123456789abcdef", Сред(Значение, НомерСимвола, 1)) - 1;
	КонецЦикла;
	
	Возврат Формат(Результат, "ЧГ=0");
	
КонецФункции

Функция НайтиДокументПоШтрихкоду(Штрихкод) Экспорт

	Если Не ТолькоЦифрыВСтроке(Штрихкод, Ложь, Ложь)
		ИЛИ СокрЛП(Штрихкод) = "" Тогда
		Возврат Неопределено;
	КонецЕсли;

	ШтрихкодВШестнаднадцатиричномВиде = ПреобразоватьДесятичноеЧислоВШестнадцатиричнуюСистемуСчисления(Число(Штрихкод));
	Пока СтрДлина(ШтрихкодВШестнаднадцатиричномВиде) < 32 Цикл
		ШтрихкодВШестнаднадцатиричномВиде = "0" + ШтрихкодВШестнаднадцатиричномВиде;
	КонецЦикла;
	
	Идентификатор =
	        Сред(ШтрихкодВШестнаднадцатиричномВиде, 1,  8)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 9,  4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 13, 4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 17, 4)
	+ "-" + Сред(ШтрихкодВШестнаднадцатиричномВиде, 21, 12);
	
	Если СтрДлина(Идентификатор) <> 36 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Для Каждого СТР Из Метаданные.Документы Цикл
		Элемент = Документы[СТР.Имя].ПолучитьСсылку(Новый УникальныйИдентификатор(Идентификатор));
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗРЕШЕННЫЕ
		                      |	_Тестовый.Ссылка
		                      |ИЗ
		                      |	Документ." + СТР.Имя + " КАК _Тестовый
		                      |ГДЕ
		                      |	_Тестовый.Ссылка = &Ссылка");
		Запрос.УстановитьПараметр("Ссылка", Элемент);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Продолжить;
		КонецЕсли;
		
		Возврат Элемент;
	КонецЦикла;
	
	Возврат Неопределено;
КонецФункции // НайтиДокументПоШтрихкоду()

Функция НайтиДокументПоШтрихкодуНомеру(Штрихкод,СПБ=Ложь) Экспорт

	Если СокрЛП(Штрихкод) = "" Или Лев(Штрихкод, 3) <> "pkd" Тогда
		Возврат Неопределено;
	КонецЕсли;
    тмп_начДанные = Штрихкод;
	
	Если СПБ Тогда 
		лок_ПрефиксИБ="С";
	Иначе 	
		лок_ПрефиксИБ="D";
		лок_ПрефиксИБ1="У";
		лок_ПрефиксИБ2="Н";
		лок_ПрефиксИБ3="O";
		лок_ПрефиксИБ4="N";
	КонецЕсли;	
	
	Если СПБ Тогда 
		лок_ПрефиксИБ="С";
	Иначе 	
		лок_ПрефиксИБ="D";
	КонецЕсли;	
	Если Лев(Штрихкод, 5) = "pkdsb" Тогда
		ДокИщем = "МХ_Сборка";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdno" Тогда
		ДокИщем = "ТребованиеНаСклад_АТ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdrn" Тогда
		ДокИщем = "Реализация";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdsf" Тогда
		ДокИщем = "СчетФактураВыданный";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzd" Тогда
		ДокИщем = "СлужебноеЗадание_СВН";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzs" Тогда
		ДокИщем = "СлужебноеЗадание_Снабжение";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdvs" Тогда
		ДокИщем = "ВозвратПоставщику";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdav" Тогда
		ДокИщем = "АктВозврата_АТ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdza" Тогда
		ДокИщем = "ЗаявкаПокупателя";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzp" Тогда
		ДокИщем = "ЗаказПоставщику";
	ИначеЕсли Лев(Штрихкод, 5) = "pkprm" Тогда
		ДокИщем = "ПеремещениеТМЦ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdvp" Тогда
		ДокИщем = "ВозвратТоваровОтПокупателя";
	Иначе
		Предупреждение("Не определен вид документа по отсканированному штрих-коду!", 10);
		Возврат тмп_начДанные;
	КонецЕсли;
	Если Не Сред(тмп_начДанные,6,1)="D" Тогда 
		ТмпКодФирмы = Сред(тмп_начДанные,6,2);
		НомерДок   = Сред(тмп_начДанные,8);
	Иначе
		ТмпКодФирмы = Сред(тмп_начДанные,7,2);
		НомерДок   = Сред(тмп_начДанные,9);
	КонецЕсли;
	
	РезЗапр=Новый Запрос;
	РезЗапр.Текст="ВЫБРАТЬ
	|	_ДляПереносаДанных.Объект
	|ИЗ
	|	РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
	|ГДЕ
	|	_ДляПереносаДанных.Число77 = &Число77
	|	И _ДляПереносаДанных.Строка77 = &Строка77";
	РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
	РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
	РезЗ=РезЗапр.Выполнить().Выгрузить();
	
	НетФирмы=Ложь;
	начДанные=Новый СписокЗначений;
	
	Если Не РезЗ.Количество()=0 Тогда 
		ЮЛ=РезЗ[0].Объект;
	Иначе
		ЮЛ=Неопределено;
	КонецЕсли;	
	Если ЮЛ = Неопределено Тогда
		ТмпКодФирмы = Сред(тмп_начДанные,6,1);
		начДанные   = Сред(тмп_начДанные,7);
		РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
		РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
		РезЗ=РезЗапр.Выполнить().Выгрузить();
		Если Не РезЗ.Количество()=0 Тогда 
			ЮЛ=РезЗ[0].Объект;
		Иначе
			ЮЛ=Неопределено;
		КонецЕсли;	
		Если ЮЛ = Неопределено Тогда
			Предупреждение("Не найдена фирма в справочнике ""Свои юр.лица"" по коду: "+ТмпКодФирмы, 10);
			НетФирмы=Истина;
		Иначе
			начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		КонецЕсли;
	Иначе
		начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок);
	КонецЕсли;
		
	Если НетФирмы Тогда 
		РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
		РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
		РезЗ=РезЗапр.Выполнить().Выгрузить();
		Если Не РезЗ.Количество()=0 Тогда 
			ЮЛ=РезЗ[0].Объект;
		Иначе
			ЮЛ=Неопределено;
		КонецЕсли;	
		Если ЮЛ = Неопределено Тогда
			ТмпКодФирмы = Сред(тмп_начДанные,7,1);
			начДанные   = Сред(тмп_начДанные,8);
			РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
			РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
			РезЗ=РезЗапр.Выполнить().Выгрузить();
			Если Не РезЗ.Количество()=0 Тогда 
				ЮЛ=РезЗ[0].Объект;
			Иначе
				ЮЛ=Неопределено;
			КонецЕсли;	
			Если ЮЛ = Неопределено Тогда
				Предупреждение("Не найдена фирма в справочнике ""Свои юр.лица"" по коду: "+ТмпКодФирмы, 10);
				Возврат "";
			Иначе
				начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			КонецЕсли;
		Иначе
			начДанные = лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные;
			начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
		КонецЕсли;
	КонецЕсли;	
	
	
	Запрос=Новый Запрос;
	Запрос.Текст="ВЫБРАТЬ
	|	РеализацияТоваровУслуг.Ссылка
	|ИЗ
	|	Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
	|ГДЕ
	|	РеализацияТоваровУслуг.Номер В(&Номер)
	|	И РеализацияТоваровУслуг.Дата МЕЖДУ &Дата1 И &Дата2";
	
	Запрос.УстановитьПараметр("Дата1",НачалоГода(НачалоГода(ТекущаяДата())-1));
	Запрос.УстановитьПараметр("Дата2",НачалоГода(ТекущаяДата())-1);
	Запрос.УстановитьПараметр("Номер",начДанные);
	Рез=Запрос.Выполнить().Выгрузить();
	Если Рез.Количество()=0 Тогда 
		Запрос.УстановитьПараметр("Дата1",НачалоГода(ТекущаяДата()));
		Запрос.УстановитьПараметр("Дата2",ТекущаяДата());
		Запрос.УстановитьПараметр("Номерта",начДанные);
		Рез=Запрос.Выполнить().Выгрузить();;
		Если Рез.Количество()=0 Тогда 
			ДЛя Каждого Стрр Из начДанные Цикл
				Сообщить("Не найден документ по номеру "+Строка(Стрр));
			КонецЦикла;	
			Возврат начДанные;
		Иначе 
			Если Рез.Количество()=1 Тогда 
				ДокИщем=Рез[0].Ссылка;
			Иначе 
				ДокИщем=Рез.ВыбратьСтроку("Найдено больше одного документа, выберите нужный из списка!");
			КонецЕсли;	
			Возврат ДокИщем;	
		КонецЕсли;	
	Иначе 
		Если Рез.Количество()=1 Тогда 
			ДокИщем=Рез[0].Ссылка;
		Иначе 
			ДокИщем=Рез.ВыбратьСтроку("Найдено больше одного документа, выберите нужный из списка!");
		КонецЕсли;	
		Возврат ДокИщем;	
	КонецЕсли;	
КонецФункции // НайтиДокументПоШтрихкоду()

Функция НайтиДокументПоШтрихкодуНомеруПериод(Штрихкод,СПБ=Ложь,ЭтотГод) Экспорт

	Если СокрЛП(Штрихкод) = "" Или Лев(Штрихкод, 3) <> "pkd" Тогда
		Возврат Неопределено;
	КонецЕсли;
    тмп_начДанные = Штрихкод;
	Если СтрДлина(тмп_начДанные)=14 Тогда 
		тмп_начДанные=Лев(тмп_начДанные,8)+"0"+Сред(тмп_начДанные,9);
	КонецЕсли;	
	лок_ПрефиксИБ="У";
	лок_ПрефиксИБ1="D";
	лок_ПрефиксИБ2="Н";
	лок_ПрефиксИБ3="O";
	лок_ПрефиксИБ4="N";
	лок_ПрефиксИБ5="С";
	
	Если Лев(Штрихкод, 5) = "pkdsb" Тогда
		ДокИщем = "МХ_Сборка";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdno" Тогда
		ДокИщем = "ТребованиеНаСклад_АТ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdrn" Тогда
		ДокИщем = "Реализация";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdsf" Тогда
		ДокИщем = "СчетФактураВыданный";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzd" Тогда
		ДокИщем = "СлужебноеЗадание_СВН";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzs" Тогда
		ДокИщем = "СлужебноеЗадание_Снабжение";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdvs" Тогда
		ДокИщем = "ВозвратПоставщику";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdav" Тогда
		ДокИщем = "АктВозврата_АТ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdza" Тогда
		ДокИщем = "ЗаявкаПокупателя";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdzp" Тогда
		ДокИщем = "ЗаказПоставщику";
	ИначеЕсли Лев(Штрихкод, 5) = "pkprm" Тогда
		ДокИщем = "ПеремещениеТМЦ";
	ИначеЕсли Лев(Штрихкод, 5) = "pkdvp" Тогда
		ДокИщем = "ВозвратТоваровОтПокупателя";
	Иначе
		Предупреждение("Не определен вид документа по отсканированному штрих-коду!", 10);
		Возврат тмп_начДанные;
	КонецЕсли;
	Если Не Сред(тмп_начДанные,6,1)="D" И  Не Сред(тмп_начДанные,6,1)="O" Тогда 
		ТмпКодФирмы = Сред(тмп_начДанные,6,2);
		НомерДок   = Сред(тмп_начДанные,8);
	Иначе
		ТмпКодФирмы = Сред(тмп_начДанные,7,2);
		НомерДок   = Сред(тмп_начДанные,9);
	КонецЕсли;
	НомерДок=Прав("00"+НомерДок,8);
	
	РезЗапр=Новый Запрос;
	РезЗапр.Текст="ВЫБРАТЬ
	|	_ДляПереносаДанных.Объект
	|ИЗ
	|	РегистрСведений._ДляПереносаДанных КАК _ДляПереносаДанных
	|ГДЕ
	|	_ДляПереносаДанных.Число77 = &Число77
	|	И _ДляПереносаДанных.Строка77 = &Строка77";
	Попытка
		КФ=Число(ТмпКодФирмы);
	Исключение
		КФ=0;
		НомерДок   = Сред(тмп_начДанные,7);
	КонецПопытки;	
	РезЗапр.УстановитьПараметр("Число77",КФ);
	РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
	РезЗ=РезЗапр.Выполнить().Выгрузить();
	
	НетФирмы=Ложь;
	начДанные=Новый СписокЗначений;
	Если Не РезЗ.Количество()=0 Тогда 
		ЮЛ=РезЗ[0].Объект;
	Иначе
		ЮЛ=Неопределено;
	КонецЕсли;	
	Если ЮЛ = Неопределено Тогда
		Если Не Сред(тмп_начДанные,6,1)="D" И  Не Сред(тмп_начДанные,6,1)="O" Тогда 
			ТмпКодФирмы = Сред(тмп_начДанные,6,1);
			НомерДок   = Сред(тмп_начДанные,8);
		Иначе
			ТмпКодФирмы = Сред(тмп_начДанные,7,1);
			НомерДок   = Сред(тмп_начДанные,9);
		КонецЕсли;
		НомерДок=Прав("00"+НомерДок,8);
		Попытка
			КФ=Число(ТмпКодФирмы);
		Исключение
			КФ=0;
			НомерДок   = Сред(тмп_начДанные,7);
		КонецПопытки;	
		РезЗапр.УстановитьПараметр("Число77",КФ);
		РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
		РезЗ=РезЗапр.Выполнить().Выгрузить();
		Если Не РезЗ.Количество()=0 Тогда 
			ЮЛ=РезЗ[0].Объект;
		Иначе
			ЮЛ=Неопределено;
		КонецЕсли;	
		Если ЮЛ = Неопределено Тогда
			//Предупреждение("Не найдена фирма в справочнике ""Свои юр.лица"" по коду: "+ТмпКодФирмы, 10);
			НетФирмы=Истина;
			НДД=Прав(Сред(тмп_начДанные,7),7);
		Иначе
			начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок);
			начДанные.Добавить(лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		КонецЕсли;
	Иначе
		начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) + НомерДок);
		начДанные.Добавить(лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) + НомерДок,лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) + НомерДок);
	КонецЕсли;
		
	Если НетФирмы Тогда 
		РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
		РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
		РезЗ=РезЗапр.Выполнить().Выгрузить();
		Если Не РезЗ.Количество()=0 Тогда 
			ЮЛ=РезЗ[0].Объект;
		Иначе
			ЮЛ=Неопределено;
		КонецЕсли;	
		Если ЮЛ = Неопределено Тогда
			ТмпКодФирмы = Сред(тмп_начДанные,7,1);
			начДанные   = Сред(тмп_начДанные,8);
			РезЗапр.УстановитьПараметр("Число77",Число(ТмпКодФирмы));
			РезЗапр.УстановитьПараметр("Строка77",ТмпКодФирмы);
			РезЗ=РезЗапр.Выполнить().Выгрузить();
			Если Не РезЗ.Количество()=0 Тогда 
				ЮЛ=РезЗ[0].Объект;
			Иначе
				ЮЛ=Неопределено;
			КонецЕсли;	
			Если ЮЛ = Неопределено Тогда
				Предупреждение("Не найдена фирма в справочнике ""Свои юр.лица"" по коду: "+ТмпКодФирмы, 10);
				НДД=Прав(Сред(тмп_начДанные,7),7);
				НетФирмы=Истина;
			Иначе
				начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
				начДанные.Добавить(лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			КонецЕсли;
		Иначе
			начДанные = лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные;
			начДанные.Добавить(лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ1 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ2 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ3 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ4 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
			начДанные.Добавить(лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные,лок_ПрефиксИБ5 + СокрЛП(ЮЛ.Префикс) +"0"+ начДанные);
		КонецЕсли;
	КонецЕсли;	
	
	
	Если ДокИщем = "Реализация" Тогда 
		Док=".РеализацияТоваровУслуг";
	ИначеЕсли ДокИщем = "СчетФактураВыданный" Тогда
		Док=".СчетФактураВыданный";
	ИначеЕсли ДокИщем = "СлужебноеЗадание_СВН" Тогда
		Док=".СлужебноеЗадание";
	ИначеЕсли ДокИщем = "СлужебноеЗадание_Снабжение" Тогда
		Док=".СлужебноеЗадание";
	ИначеЕсли ДокИщем = "ВозвратПоставщику" Тогда
		Док=".ВозвратТоваровПоставщику";
	ИначеЕсли ДокИщем = "ЗаявкаПокупателя" Тогда
		Док=".ЗаявкаПокупателя";
	ИначеЕсли ДокИщем = "ЗаказПоставщику" Тогда
		Док=".ЗаказПоставщику";
	ИначеЕсли ДокИщем = "ПеремещениеТМЦ" Тогда
		Док=".ПеремещениеТоваров";
	ИначеЕсли ДокИщем = "ВозвратТоваровОтПокупателя" Тогда
		Док=".ВозвратТоваровОтПокупателя";
	Иначе
		Возврат "";
	КонецЕсли;
	
	Запрос=Новый Запрос;
	Если НетФирмы Тогда 
		Запрос.Текст="ВЫБРАТЬ
		|	Док.Дата,
		|	Док.Ссылка";
		Если Не ДокИщем = "СлужебноеЗадание_СВН" И  Не ДокИщем = "СлужебноеЗадание_Снабжение" Тогда 
			Запрос.Текст=Запрос.Текст+"
			|	,Док.СуммаДокумента";
		КонецЕсли;	
		Запрос.Текст=Запрос.Текст+"
		|ИЗ
		|	Документ";
		Запрос.Текст=Запрос.Текст+Док+" КАК Док";
		Запрос.Текст=Запрос.Текст+"
		|ГДЕ
		|	Док.Дата МЕЖДУ &Дата1 И &Дата2
		|	И Док.Номер ПОДОБНО &Номер
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
	Иначе
		Запрос.Текст="ВЫБРАТЬ
		|	Док.Дата,
		|	Док.Ссылка";
		Если Не ДокИщем = "СлужебноеЗадание_СВН" И  Не ДокИщем = "СлужебноеЗадание_Снабжение" Тогда 
			Запрос.Текст=Запрос.Текст+"
			|	,Док.СуммаДокумента";
		КонецЕсли;	
		Запрос.Текст=Запрос.Текст+"
		|ИЗ
		|	Документ";
		Запрос.Текст=Запрос.Текст+Док+" КАК Док";
		Запрос.Текст=Запрос.Текст+"
		|ГДЕ
		|	Док.Дата МЕЖДУ &Дата1 И &Дата2
		|	И Док.Номер В(&Номер)
		|УПОРЯДОЧИТЬ ПО
		|	Дата УБЫВ";
	КонецЕсли;
	
	Если ЭтотГод Тогда 
		
		Запрос.УстановитьПараметр("Дата1",НачалоГода(ТекущаяДата()));
		Запрос.УстановитьПараметр("Дата2",ТекущаяДата());
		Если НетФирмы Тогда 
			Запрос.УстановитьПараметр("Номер","%"+НДД);
			начДанные=новый СписокЗначений;
			начДанные.Добавить(НДД,НДД);
		Иначе
			Запрос.УстановитьПараметр("Номер",начДанные);
			начДанные.Добавить(НДД,НДД);
		КонецЕсли;	
		Рез=Запрос.Выполнить().Выгрузить();
		Если Рез.Количество()=0 Тогда 
			Сообщить("Не найден документ по номеру #"+Прав(начДанные[0],10));
			Возврат начДанные;
		Иначе 
			Если Рез.Количество()=1 Тогда 
				ДокИщем=Рез[0].Ссылка;
			Иначе 
				ДокИщем=Рез.ВыбратьСтроку("Найдено больше одного документа, выберите нужный из списка!");
				ДокИщем=ДокИщем.Ссылка;
			КонецЕсли;	
			Возврат ДокИщем;	
		КонецЕсли;	
	Иначе	
		
		Запрос.УстановитьПараметр("Дата1",НачалоГода(НачалоГода(ТекущаяДата())-1));
		Запрос.УстановитьПараметр("Дата2",НачалоГода(ТекущаяДата())-1);
		Если НетФирмы Тогда 
			Запрос.УстановитьПараметр("Номер","%"+НДД);
			начДанные=новый СписокЗначений;
			начДанные.Добавить(НДД,НДД);
		Иначе
			Запрос.УстановитьПараметр("Номер",начДанные);
			начДанные.Добавить(НДД,НДД);
		КонецЕсли;	
		Рез=Запрос.Выполнить().Выгрузить();
		Если Рез.Количество()=0 Тогда 
			Запрос.УстановитьПараметр("Дата1",НачалоГода(ТекущаяДата()));
			Запрос.УстановитьПараметр("Дата2",ТекущаяДата());
			Если НетФирмы Тогда 
				Запрос.УстановитьПараметр("Номер","%"+НДД);
				начДанные=новый СписокЗначений;
				начДанные.Добавить(НДД,НДД);
			Иначе
				Запрос.УстановитьПараметр("Номер",начДанные);
				начДанные.Добавить(НДД,НДД);
			КонецЕсли;	
			Рез=Запрос.Выполнить().Выгрузить();;
			Если Рез.Количество()=0 Тогда 
				Сообщить("Не найден документ по номеру #"+Прав(начДанные[0],10));
				Возврат начДанные;
			Иначе 
				Если Рез.Количество()=1 Тогда 
					ДокИщем=Рез[0].Ссылка;
				Иначе 
					ДокИщем=Рез.ВыбратьСтроку("Найдено больше одного документа, выберите нужный из списка!");
					ДокИщем=ДокИщем.Ссылка;
				КонецЕсли;	
				Возврат ДокИщем;	
			КонецЕсли;	
		Иначе 
			Если Рез.Количество()=1 Тогда 
				ДокИщем=Рез[0].Ссылка;
			Иначе 
				ДокИщем=Рез.ВыбратьСтроку("Найдено больше одного документа, выберите нужный из списка!");
				ДокИщем=ДокИщем.Ссылка;
			КонецЕсли;	
			Возврат ДокИщем;	
		КонецЕсли;	
	КонецЕсли;	
КонецФункции // НайтиДокументПоШтрихкоду()

Функция ТолькоЦифрыВСтроке(Знач СтрокаПроверки, Знач УчитыватьЛидирующиеНули = Истина, Знач УчитыватьПробелы = Истина)
	
	Если ТипЗнч(СтрокаПроверки) <> Тип("Строка") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не УчитыватьПробелы Тогда
		СтрокаПроверки = СтрЗаменить(СтрокаПроверки, " ", "");
	КонецЕсли;
		
	Если ПустаяСтрока(СтрокаПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если Не УчитыватьЛидирующиеНули Тогда
		Позиция = 1;
		// Взятие символа за границей строки возвращает пустую строку.
		Пока Сред(СтрокаПроверки, Позиция, 1) = "0" Цикл
			Позиция = Позиция + 1;
		КонецЦикла;
		СтрокаПроверки = Сред(СтрокаПроверки, Позиция);
	КонецЕсли;
	
	// Если содержит только цифры, то в результате замен должна быть получена пустая строка.
	// Проверять при помощи ПустаяСтрока нельзя, так как в исходной строке могут быть пробельные символы.
	Возврат СтрДлина(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить(
		СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( СтрЗаменить( 
			СтрокаПроверки, "0", ""), "1", ""), "2", ""), "3", ""), "4", ""), "5", ""), "6", ""), "7", ""), "8", ""), "9", "")) = 0;
	
КонецФункции

Функция ПреобразоватьДесятичноеЧислоВШестнадцатиричнуюСистемуСчисления(Знач ДесятичноеЧисло)
	
	Результат = "";
	
	Пока ДесятичноеЧисло > 0 цикл
		ОстатокОтДеления = ДесятичноеЧисло % 16;
		ДесятичноеЧисло  = (ДесятичноеЧисло - ОстатокОтДеления) / 16;
		Результат        = Сред("0123456789abcdef", ОстатокОтДеления + 1, 1) + Результат;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

