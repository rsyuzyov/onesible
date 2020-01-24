﻿&НаСервере
Процедура ОбменНаСервере(ТекущаяСтрока)

	Узел = ТекущаяСтрока.Узел;
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

&НаКлиенте
Процедура СоставОчереди(Команда)
	ОткрытьФорму("Обработка.СоставОчереди.Форма.Форма", Новый Структура("ПланОбмена, Узел", Объект.ПланОбмена, Элементы.Список.ТекущиеДанные.Узел));
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.ПланОбмена.Пустая() Тогда
		Объект.ПланОбмена = Справочники.ПланыОбменов.НайтиПоНаименованию("Розница");
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("ПланОбмена", Объект.ПланОбмена);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Список.Параметры.УстановитьЗначениеПараметра("ПланОбмена", Объект.ПланОбмена);
КонецПроцедуры

&НаКлиенте
Процедура ПланОбменаПриИзменении(Элемент)
	Список.Параметры.УстановитьЗначениеПараметра("ПланОбмена", Объект.ПланОбмена);
КонецПроцедуры

