﻿&НаСервере
Процедура ОбменНаСервере(ТекущаяСтрока)

	Узел = ТекущаяСтрока.Узел;
	
	Если Узел = Объект.ПланОбмена.ГлавныйУзел Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		Результат = КоннекторHTTP.GetJson(Узел.ПолучитьОбъект().Адрес() + "ping");
	Исключение
		Результат = ОписаниеОшибки();
	КонецПопытки;
	
	Если Результат = "Pong" Тогда
		Фастекс.ВыполнитьОбмен(Объект.ПланОбмена, Объект.ПланОбмена.ГлавныйУзел, Узел);
		Фастекс.ВыполнитьОбмен(Объект.ПланОбмена, Узел, Объект.ПланОбмена.ГлавныйУзел);

	Иначе
		Если ПустаяСтрока(Результат) Тогда
			Попытка
				Результат = КоннекторHTTP.Get(Узел.ПолучитьОбъект().Адрес() + "ping");
				Если Результат.КодСостояния = 404 Тогда
					Результат = "Запрашиваемый ресурс не найден";
				КонецЕсли;
			Исключение
				Результат = ОписаниеОшибки();
			КонецПопытки;
		КонецЕсли;
		
		Сообщить("" + Узел.Код + ": не удалось подключиться к ИБ: " + Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Обмен(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбменНаСервере(ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура PingНаСервере(ТекущаяСтрока)
	
	Узел = ТекущаяСтрока.Узел;
	Попытка
		ДополнительныеПараметры = Новый Структура("Таймаут", 5);
		Результат = КоннекторHTTP.GetJson(Узел.ПолучитьОбъект().Адрес() + "ping", , ДополнительныеПараметры);
	Исключение
		Сообщить("" + Узел.Код + ": не удалось проверить доступность. Команда проверки: ");
		Сообщить(Узел.ПолучитьОбъект().Адрес() + "ping");
	КонецПопытки;
	
	Если НЕ НРег(Результат) = "pong" Тогда
		Сообщить("" + Узел.Код + ": не удалось проверить доступность. Команда проверки: ");
		Сообщить(Узел.ПолучитьОбъект().Адрес() + "ping");
		Сообщить("Ошибка: " + Результат);
	КонецЕсли;
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(Узел);
	ФоновыеЗадания.Выполнить("Фастекс.ОбновитьДанныеУзла", ПараметрыЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура Ping(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		PingНаСервере(ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Очередь_Количество(Команда)
	
	ОткрытьФорму("Обработка.ДлинаОчереди.Форма.ДлинаОчереди", Новый Структура("ПланОбмена, Узел", Объект.ПланОбмена, Элементы.Список.ТекущиеДанные.Узел));
	
КонецПроцедуры

&НаСервере
Функция ГлавынйУзел()

	Возврат Объект.ПланОбмена.ГлавныйУзел;

КонецФункции

&НаКлиенте
Процедура Отладка(Команда)
	
	Попытка
		ТекущаяФорма = ПолучитьФорму(ПолноеИмяМетаданных() + ".Форма.НастройкаКонвертации");
		ТекущаяФорма.Узел1 = ГлавынйУзел();
		ТекущаяФорма.Узел2 = Элементы.Список.ТекущиеДанные.Узел;
		ТекущаяФорма.Открыть();
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКодНаСервере(ТекущаяСтрока)
	
	Результат = Фастекс.ВыполнитьКод(ТекущаяСтрока.Узел, Объект.Текст);
	Сообщить("" + ТекущаяСтрока.Узел.Код + ": " + Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьКод(Команда)
	
	Если ПустаяСтрока(Объект.Текст) Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьКодНаСервере(Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьРасширениеНаСервере(ТекущаяСтрока)
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(ТекущаяСтрока.Узел);
	ФоновыеЗадания.Выполнить("Фастекс.ОбновитьРасширение", ПараметрыЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьFastex(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбновитьРасширениеНаСервере(ТекущаяСтрока);
	КонецЦикла;
	Сообщить("Обновление Fastex запущено в фоновом режиме");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Список.Параметры.УстановитьЗначениеПараметра("Фастекс", Справочники.Расширения.НайтиПоНаименованию("Fastex"));
	Список.Параметры.УстановитьЗначениеПараметра("Дополнения", Справочники.Расширения.НайтиПоНаименованию("Дополнения"));
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДополненияНаСервере(ТекущаяСтрока)
	
	Узел = ТекущаяСтрока.Узел;
	
	Попытка
		Если Число(Узел.Версия) < 100 Тогда
			ИмяФайла = "\\192.168.20.18\public\cfe\retail\Дополнения99.cfe";
		Иначе
			ИмяФайла = "\\192.168.20.18\public\cfe\retail\Дополнения100.cfe";
		КонецЕсли;
	Исключение
		Сообщить("" + Узел.Код + ": " + ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
	ДвоичныеДанныеBase64 = Base64Строка(ДвоичныеДанные);
	
	ПараметрыЗадания = Новый Массив;
	ПараметрыЗадания.Добавить(Узел);
	ПараметрыЗадания.Добавить(ДвоичныеДанныеBase64);
	ПараметрыЗадания.Добавить("Дополнения");
	ФоновыеЗадания.Выполнить("Фастекс.ОбновитьРасширение", ПараметрыЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДополнения(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбновитьДополненияНаСервере(ТекущаяСтрока);
	КонецЦикла;
	Сообщить("Обновление Дополнений запущено в фоновом режиме");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокКоличествоОшибокВыгрузкиНажатие(Элемент, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СписокКоличествоОшибокВыгрузки" ИЛИ Поле.Имя = "СписокКоличествоОшибокЗагрузки" Тогда
		СтандартнаяОбработка = Ложь;
		ФормаЛога = ПолучитьФорму("РегистрСведений.ЛогОбмена.ФормаСписка");
		
		ЭлементОтбора = ФормаЛога.Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Узел");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ПравоеЗначение = Элементы.Список.ТекущиеДанные.Узел;
		
		ФормаЛога.Открыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбменПоВидуОбъектаНаСервере(ТекущаяСтрока)
	
	Узел1 = Объект.ПланОбмена.ГлавныйУзел;
	Узел2 = ТекущаяСтрока.Узел;
	
	ИмяТипа = Объект.ИмяТипа;
	ИмяТипа = СтрЗаменить(ИмяТипа, "CatalogObject", "Справочник");
	ИмяТипа = СтрЗаменить(ИмяТипа, "DocumentObject", "Документ");
	ИмяТипа = СтрЗаменить(ИмяТипа, "InformationRegisterRecordSet", "РегистрСведений");
	ИмяТипа = СтрЗаменить(ИмяТипа, "AccumulationRegisterRecordSet", "РегистрНакопления");
	ИмяТипа = СтрЗаменить(ИмяТипа, "AccuountingRegisterRecordSet", "РегистрБухгалтерии");
	
	Фастекс.ВыполнитьОбменПоВидуОбъектов(Объект.ПланОбмена.ПолучитьОбъект(), Узел1.ПолучитьОбъект(), Узел2.ПолучитьОбъект(), ИмяТипа, 3);
	Фастекс.ВыполнитьОбменПоВидуОбъектов(Объект.ПланОбмена.ПолучитьОбъект(), Узел2.ПолучитьОбъект(), Узел1.ПолучитьОбъект(), ИмяТипа, 3);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбменПоВидуОбъекта(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбменПоВидуОбъектаНаСервере(ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПланОбменаПриИзменении(Элемент)
	
	Список.Параметры.УстановитьЗначениеПараметра("ПланОбмена", Объект.ПланОбмена);
	Элементы.ИмяТипа.СписокВыбора.ЗагрузитьЗначения(Фастекс.СоставОчереди(Объект.ПланОбмена));
	Элементы.ИмяТипа.СписокВыбора.СортироватьПоЗначению();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Список.Параметры.УстановитьЗначениеПараметра("ПланОбмена", Объект.ПланОбмена);
	Элементы.ИмяТипа.СписокВыбора.ЗагрузитьЗначения(Фастекс.СоставОчереди(Объект.ПланОбмена));
	Элементы.ИмяТипа.СписокВыбора.СортироватьПоЗначению();

КонецПроцедуры

&НаСервере
Функция СтрокаЗапускаТонкогоКлиента(Знач Узел)

	Узел = Узел.ПолучитьОбъект();
	Результат = СтрШаблон("""C:\Program Files (x86)\1Cv8\common\1cestart.exe"" /WS %1 /N %2 /P %3 /DisableStartupMessages", Узел.Адрес(), Узел.Логин(), Узел.Пароль());
	Результат = СтрЗаменить(Результат, "hs/fastex/", "");
	Возврат Результат;

КонецФункции

&НаКлиенте
Процедура СписокУзелКомпьютерIP1Открытие(Элемент, СтандартнаяОбработка)

	Код = "";
	
	Попытка
		СтандартнаяОбработка = Ложь;
		Код = СтрокаЗапускаТонкогоКлиента(Элементы.Список.ТекущиеДанные.Узел);
		НачатьЗапускПриложения(Новый ОписаниеОповещения, Код);
		
	Исключение
		Сообщить("Ошибка подключения:");
		Сообщить(Код);
		Сообщить(ОписаниеОшибки());
		
	КонецПопытки;

КонецПроцедуры

&НаСервере
Функция ЭтоВнешняяОбработка()

	Возврат  СтрНайти(РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя(), "ВнешняяОбработка") > 0;

КонецФункции

&НаСервере
Функция ПолноеИмяМетаданных()

	Возврат  РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя();

КонецФункции

&НаСервере
Процедура ОбновитьVRDНаСервере(ТекущаяСтрока)
	
	Узел = ТекущаяСтрока.Узел.ПолучитьОбъект();
	
	ДвоичныеДанные = Новый ДвоичныеДанные("\\192.168.20.18\public\cfe\retail\fastex.cfe");
	ДвоичныеДанныеBase64 = Base64Строка(ДвоичныеДанные);
	
	ПараметрыЗапроса = Новый Структура("data", ДвоичныеДанныеBase64);
	Результат = КоннекторHTTP.PostJson(Узел.Адрес() + "service/do", ПараметрыЗапроса);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьVRD(Команда)
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбновитьVRDНаСервере(ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьСкриптНаСервере(ТекущаяСтрока, Скрипт)
	
	Узел = ТекущаяСтрока.Узел;
	Код = ТекущаяСтрока.Код;
	Выполнить(Скрипт.Текст);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСкрипт(Команда)
	
	Скрипт = ПредопределенноеЗначение("Справочник.Скрипты.ПустаяСсылка");
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ВыполнитьСкриптЗавершение", ЭтотОбъект, Новый Структура("Скрипт", Скрипт)), Скрипт);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьСкриптЗавершение(Скрипт, ДополнительныеПараметры) Экспорт
	
	Если Скрипт = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТекущаяСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыполнитьСкриптНаСервере(ТекущаяСтрока, Скрипт);
	КонецЦикла;
	
КонецПроцедуры

