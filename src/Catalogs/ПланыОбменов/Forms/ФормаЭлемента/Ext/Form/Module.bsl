﻿&НаСервере
Функция ЗаполнитьСписокУзлов(ИмяПланаОбмена) Экспорт
	
	ПланОбмена = Объект.Ссылка;
	
	Таблица = Фастекс.СписокУзлов(ПланОбмена);
	КоличествоНовых = 0;
	КоличествоИзмененных = 0;
	Набор = РегистрыСведений.УзлыОбмена.СоздатьНаборЗаписей();
	Набор.Отбор.ПланОбмена.Установить(ПланОбмена, Истина);
	Для каждого ТекущаяСтрока Из Таблица Цикл
		Узел = Справочники.ИнформационныеБазы.НайтиПоКоду(СокрЛП(ТекущаяСтрока.Код));
		Если НЕ Узел.ПометкаУдаления = ТекущаяСтрока.Архивный Тогда
			об = Узел.ПолучитьОбъект();
			об.ПометкаУдаления = ТекущаяСтрока.Архивный;
			об.Записать();
		КонецЕсли;
		
		Если Узел.Пустая() Тогда
			Сообщить("Не удалось найти ИБ с кодом " + ТекущаяСтрока.Код);
			
		Иначе
			Набор.Отбор.Узел.Установить(Узел, Истина);
			Если ТекущаяСтрока.Архивный Тогда
				Набор.Очистить();
			Иначе
				Набор.Прочитать();
				Если Набор.Количество() = 0 Тогда
					Запись = Набор.Добавить();
				Иначе
					Запись = Набор[0];
				КонецЕсли;
				Запись.ПланОбмена = ПланОбмена;
				Запись.Узел = Узел;
				Запись.Код = ТекущаяСтрока.Код;
			КонецЕсли;
			Набор.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

&НаКлиенте
Процедура ЗапроситьСписокУзлов(Команда)
	ЗаполнитьСписокУзлов(Объект.ИмяПланаОбмена);
КонецПроцедуры

&НаСервере
Процедура ЗапроситьСоставОбменаНаСервере()
	
	Фастекс.СоставОчереди(Объект.Ссылка, , Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапроситьСоставОбмена(Команда)
	ЗапроситьСоставОбменаНаСервере();
КонецПроцедуры
