﻿&НаСервере
Процедура ОчиститьНаСервере()
	РегистрыСведений.ОбменыПоТипу.СоздатьНаборЗаписей().Записать();
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьНаСервере();
КонецПроцедуры
