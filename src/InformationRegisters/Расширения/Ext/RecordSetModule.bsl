﻿Процедура ПередЗаписью(Отказ)
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Если ПустаяСтрока(Запись.Версия) Тогда
			Запись.Версия = "?";
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры
