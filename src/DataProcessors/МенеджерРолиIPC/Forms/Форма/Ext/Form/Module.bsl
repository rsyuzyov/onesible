﻿
&НаСервере
Процедура УстановитьРольНаСервере()
	
	Обработчик = РеквизитФормыВЗначение("Объект");
	Обработчик.УстановитьРоль(Компьютер);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРоль(Команда)
	УстановитьРольНаСервере();
КонецПроцедуры
