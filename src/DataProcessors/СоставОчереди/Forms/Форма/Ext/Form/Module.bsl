﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ Параметры.ПланОбмена.Пустая() Тогда
		Объект.ПланОбмена = Параметры.ПланОбмена;
	КонецЕсли;
	
	Если НЕ Параметры.Узел.Пустая() Тогда
		Объект.Узел = Параметры.Узел;
	КонецЕсли;
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьДанныеНаСервере()
	
	Объект.СоставОчереди1.Очистить();
	Объект.СоставОчереди2.Очистить();
	
	Если Объект.ПланОбмена.Пустая() ИЛИ Объект.Узел.Пустая() Тогда
		Возврат;
	ИначеЕсли Объект.ПланОбмена.ГлавныйУзел = Объект.Узел Тогда
		Возврат;
	КонецЕсли;
	
	УзелЦБ = Объект.ПланОбмена.ГлавныйУзел.ПолучитьОбъект();
	УзелПБ = Объект.Узел.ПолучитьОбъект();
	
	Попытка
		Результат = Фастекс.ДлинаОчереди(Объект.ПланОбмена, УзелЦБ, УзелПБ);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Объект.СоставОчереди1.Загрузить(СервисHTTP.МассивСтруктурВТаблицуЗначений(Результат.КоличествоПоТипам));
		Иначе
			Сообщить("" + УзелЦБ.Код + " -> " + УзелПБ.Код + ": не удалось выполнить запрос
			|" + Результат);
		КонецЕсли;
		
	Исключение
		Сообщить("" + УзелЦБ.Код + " -> " + УзелПБ.Код + ": не удалось выполнить запрос");
		
	КонецПопытки;
	
	Попытка
		Результат = Фастекс.ДлинаОчереди(Объект.ПланОбмена, УзелПБ, УзелЦБ);
		Если ТипЗнч(Результат) = Тип("Структура") Тогда
			Объект.СоставОчереди2.Загрузить(СервисHTTP.МассивСтруктурВТаблицуЗначений(Результат.КоличествоПоТипам));
		Иначе
			Сообщить("" + УзелПБ.Код + " -> " + УзелЦБ.Код + ": не удалось выполнить запрос:
			|" + Результат);
		КонецЕсли;
		
	Исключение
		Сообщить("" + УзелПБ.Код + " -> " + УзелЦБ.Код + ": не удалось выполнить запрос:");
	КонецПопытки;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	ОбновитьДанныеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПередатьНаСервере(Знач ТекущаяСтрока, ИмяТаблицы)
	
	ПланОбмена = Объект.ПланОбмена.ПолучитьОбъект();
	ТекущаяСтрока = Объект[ИмяТаблицы].НайтиПоИдентификатору(ТекущаяСтрока);

	Если ИмяТаблицы = "СоставОчереди1" Тогда
		Отправитель = Объект.ПланОбмена.ГлавныйУзел.ПолучитьОбъект();
		Получатель = Объект.Узел.ПолучитьОбъект();
		
	Иначе
		Получатель = Объект.ПланОбмена.ГлавныйУзел.ПолучитьОбъект();
		Отправитель = Объект.Узел.ПолучитьОбъект();
	
	КонецЕсли;
	
	Фастекс.ВыполнитьОбменПоВидуОбъектов(ПланОбмена, Отправитель, Получатель, ТекущаяСтрока.Тип);
	
КонецПроцедуры

&НаКлиенте
Процедура Передать(Команда)
	
	Если ТекущийЭлемент = Элементы.СоставОчереди1 Тогда
		Для каждого ТекущаяСтрока Из Элементы.СоставОчереди1.ВыделенныеСтроки Цикл
			ПередатьНаСервере(ТекущаяСтрока, "СоставОчереди1");
		КонецЦикла;
		
	ИначеЕсли ТекущийЭлемент = Элементы.СоставОчереди2 Тогда
		Для каждого ТекущаяСтрока Из Элементы.СоставОчереди2.ВыделенныеСтроки Цикл
			ПередатьНаСервере(ТекущаяСтрока, "СоставОчереди2");
		КонецЦикла;
		
	КонецЕсли;
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УзелПриИзменении(Элемент)
	ОбновитьДанныеНаСервере();
КонецПроцедуры

