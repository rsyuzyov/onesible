﻿// Массив - масиив значений типа Структура. В кажой структуре должен быть иентичный состав ключей
Функция МассивСтруктурВТаблицуЗначений(Массив) Экспорт

	Результат = Новый ТаблицаЗначений;
	
	Если Массив.Количество() = 0 Тогда
		Возврат Результат;
	КонецЕсли;
	
	ПерваяЗапись = Массив[0];
	Для каждого Ключ Из ПерваяЗапись Цикл
		Результат.Колонки.Добавить(Ключ.Ключ);
	КонецЦикла;
	
	Для каждого Запись Из Массив Цикл
		ТекущаяСтрока = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Запись);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ()

Функция ТаблицаЗначенийВМассивСтруктур(Таблица) Экспорт

	Результат = Новый Массив;
	ШаблонЗаписи = Новый Структура;
	Для каждого Колонка Из Таблица.Колонки Цикл
		ШаблонЗаписи.Вставить(Колонка.Имя, "");
	КонецЦикла;
	
	Для каждого ТекущаяСтрока Из Таблица Цикл
		Запись = ЗначениеИзСтрокиВнутр(ЗначениеВСтрокуВнутр(ШаблонЗаписи));;
		ЗаполнитьЗначенияСвойств(Запись, ТекущаяСтрока);
		Результат.Добавить(Запись);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции // ()

Функция ПреобразоватьВДопустимыйТипДляJSON(Тело) Экспорт

	Если ТипЗнч(Тело) = Тип("ТаблицаЗначений") Тогда
		Тело = ТаблицаЗначенийВМассивСтруктур(Тело);
	КонецЕсли;
		
	Возврат Тело;
	
КонецФункции // ()

// Формат тела запроса и ответа может быть json, 1c, либо binarydata; при этом данные могут передаваться в сжатом виде.
// По умолчанию формат - json (для изменения - ?format=1c для GET и format: 1c  в теле для POST)
// Также по умолчанию применяется сжатие gzip: заголовок запроса Accept-Encoding содержит gzip, заголовок ответа содержит 
Функция Ответ(Запрос, Код, Знач Тело) Экспорт

	Формат = ПолучитьЗначениеПараметра(Запрос, "format");
	Если Формат = Неопределено Тогда
		Формат = "json";
	КонецЕсли;
	
	Ответ = Новый HTTPСервисОтвет(Код);
	Ответ.Заголовки = ЗаголовкиПоУмолчанию();
	Если Формат = "json" Тогда
		Ответ.Заголовки.Вставить("Content-Type", "application/json; charset=UTF-8");
		Тело = ПреобразоватьВДопустимыйТипДляJSON(Тело) + "<META content=""text=; charset=windows-1251"" http-equiv=Content-Type>";
		Запись = Новый ЗаписьJSON;
		Запись.УстановитьСтроку();
		Попытка
			ЗаписатьJSON(Запись, Тело);
		Исключение
			ЗаписатьJSON(Запись, ОписаниеОшибки());
		КонецПопытки;
		Тело = Запись.Закрыть();
		
	ИначеЕсли Формат = "xml" Тогда
		Ответ.Заголовки.Вставить("Content-Type", "application/xml; charset=UTF-8");
		Запись = Новый ЗаписьXML;
		Запись.УстановитьСтроку();
		Попытка
			ЗаписатьXML(Запись, Тело);
		Исключение
			ЗаписатьXML(Запись, ОписаниеОшибки());
		КонецПопытки;
		Тело = Запись.Закрыть();
		
	ИначеЕсли Формат = "html" Тогда
		Ответ.Заголовки.Вставить("Content-Type", "text/html; charset=UTF-8");
		Тело = ПреобразоватьВДопустимыйТипДляJSON(Тело);
		Запись = Новый ЗаписьJSON;
		Запись.УстановитьСтроку();
		Попытка
			ЗаписатьJSON(Запись, Тело);
		Исключение
			ЗаписатьJSON(Запись, ОписаниеОшибки());
		КонецПопытки;
		Тело = "<html><head><META content=""text/html; charset=utf-8"" http-equiv=Content-Type></head><body><pre>"
				+ Запись.Закрыть()
				+ "</pre></body></html>";
		
	ИначеЕсли Формат = "1c" Тогда
		Ответ.Заголовки.Вставить("Content-Type", "text/plain; charset=UTF-8");
		Запись = Новый ЗаписьJSON;
		Запись.УстановитьСтроку();
		Попытка
			ЗаписатьJSON(Запись, Новый Структура("Значение", ЗначениеВСтрокуВнутр(Тело)));
		Исключение
			ЗаписатьJSON(Запись, ОписаниеОшибки());
		КонецПопытки;
		Тело = Запись.Закрыть();
		
	КонецЕсли;
	
	Заголовок = ПолучитьЗначениеЗаголовка("accept-encoding", Ответ.Заголовки);
	Если НЕ Заголовок = Ложь И СтрНайти(НРег(Заголовок), "1cstor") > 0 Тогда
		Хранилище = Новый ХранилищеЗначения(Тело, Новый СжатиеДанных(9));
		СтрокаBase64 = СериализаторXDTO.XMLСтрока(Хранилище);
		Тело = Base64Значение(СтрокаBase64);
		Ответ.Заголовки.Вставить("Content-Encoding", "1cstor");
	КонецЕсли;
	
	Если Формат = "binarydata" Тогда
		Ответ.УстановитьТелоИзДвоичныхДанных(Тело);
	Иначе
		Ответ.УстановитьТелоИзСтроки(Тело, КодировкаТекста.UTF8);
	КонецЕсли;
	
	Возврат Ответ;

КонецФункции

Функция ЗапаковатьТело(Тело)

    Архив = Новый ХранилищеЗначения(Тело, Новый СжатиеДанных(9));
    СтрокаBase64 = СериализаторXDTO.XMLСтрока(Архив);
    Возврат Base64Значение(СтрокаBase64);
	
КонецФункции

Функция ЗаголовкиПоУмолчанию() Экспорт
	
	Заголовки = Новый Соответствие;
	Возврат Заголовки;
	
КонецФункции

Функция ПолучитьЗначениеПараметра(Запрос, Знач ИмяПараметра) Экспорт

	Параметр = НРег(ИмяПараметра);
	
	Для каждого Параметр Из Запрос.ПараметрыURL Цикл
		Если НРег(Параметр.Ключ) = ИмяПараметра Тогда
			Возврат Параметр.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Параметр Из Запрос.ПараметрыЗапроса Цикл
		Если НРег(Параметр.Ключ) = ИмяПараметра Тогда
			Возврат Параметр.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Тело = Запрос.ПолучитьТелоКакСтроку(КодировкаТекста.UTF8);
	Если НЕ ПустаяСтрока(Тело) Тогда
		Попытка
			Чтение = Новый ЧтениеJSON;
			Чтение.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
			ПараметрыТела = ПрочитатьJSON(Чтение);
			Для каждого Параметр Из ПараметрыТела Цикл
				Если НРег(Параметр.Ключ) = ИмяПараметра Тогда
					Возврат Параметр.Значение;
				КонецЕсли;
			КонецЦикла;
		Исключение
		
		КонецПопытки;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции // ()

Функция ПолучитьЗначениеЗаголовка(Заголовок, ВсеЗаголовки, Ключ = Неопределено) Экспорт
	
	Для Каждого ОчереднойЗаголовок Из ВсеЗаголовки Цикл
		Если НРег(ОчереднойЗаголовок.Ключ) = НРег(Заголовок) Тогда
			Ключ = ОчереднойЗаголовок.Ключ;
			Возврат ОчереднойЗаголовок.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

