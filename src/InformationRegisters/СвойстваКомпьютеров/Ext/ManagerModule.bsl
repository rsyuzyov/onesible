﻿Функция ЗаписатьСвойство(Компьютер, Знач Роль, Свойство, Значение, Лог = Неопределено) Экспорт

	Роль = Роль(Роль);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Компьютер.Установить(Компьютер, Истина);
	Набор.Отбор.Роль.Установить(Роль, Истина);
	Набор.Отбор.Свойство.Установить(Свойство, Истина);
	Набор.Прочитать();
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	Запись.Активность = Истина;
	Запись.Компьютер = Компьютер;
	Запись.Роль = Роль;
	Запись.Свойство = Свойство;
	Запись.Значение = Значение;
	Запись.ДатаОбновления = ТекущаяДата();
	Запись.Лог = Лог;
	Набор.Записать();

КонецФункции

Функция ПолучитьСвойство(Компьютер, Знач Роль, Свойство) Экспорт

	Роль = Роль(Роль);
	
	Набор = СоздатьНаборЗаписей();
	Набор.Отбор.Компьютер.Установить(Компьютер, Истина);
	Набор.Отбор.Роль.Установить(Роль, Истина);
	Набор.Отбор.Свойство.Установить(Свойство, Истина);
	Набор.Прочитать();
	Если Набор.Количество() = 0 Тогда
		Запись = Набор.Добавить();
	Иначе
		Запись = Набор[0];
	КонецЕсли;
	
	Возврат Новый Структура("Значение, ДатаОбновления", Запись.Значение, Запись.ДатаОбновления);

КонецФункции

Функция Роль(Роль)

	Если Роль = Неопределено Тогда
			Возврат Справочники.РолиКомпьютеров.ПустаяСсылка();
			
	ИначеЕсли ТипЗнч(Роль) = Тип("Строка") Тогда
		Если ПустаяСтрока(Роль) Тогда
			Возврат Справочники.РолиКомпьютеров.ПустаяСсылка();
		Иначе
			Возврат Справочники.РолиКомпьютеров.НайтиПоНаименованию(Роль);
		КонецЕсли;
		
	ИначеЕсли НЕ ТипЗнч(Роль) = Тип("СправочникСсылка.РолиКомпьютеров") ИЛИ Роль.Пустая() Тогда
		ВызватьИсключение "Не удалось найти роль: " + Роль;
		
	КонецЕсли;
	
	Возврат Роль;
	
КонецФункции // ()

