﻿Процедура ОбработкаЗагрузки(КлючОбъекта, КлючНастроек, Настройка, ОписаниеНастройки, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХранилищеВариантовОтчетов.ВариантОтчета,
	               |	ХранилищеВариантовОтчетов.Наименование
	               |ИЗ
	               |	Справочник.ХранилищеВариантовОтчетов КАК ХранилищеВариантовОтчетов
	               |ГДЕ
	               |	ХранилищеВариантовОтчетов.КлючОбъекта = &КлючОбъекта
	               |	И ХранилищеВариантовОтчетов.Код = &Код";
				   
	Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
	Запрос.Параметры.Вставить("Код", КлючНастроек);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Настройка = Выборка.ВариантОтчета.Получить();
		
		Если ОписаниеНастройки <> Неопределено Тогда
			
			ОписаниеНастройки.Представление = Выборка.Наименование;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаСохранения(КлючОбъекта, КлючНастроек, Настройка, ОписаниеНастройки, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХранилищеВариантовОтчетов.Ссылка
	               |ИЗ
	               |	Справочник.ХранилищеВариантовОтчетов КАК ХранилищеВариантовОтчетов
	               |ГДЕ
	               |	ХранилищеВариантовОтчетов.КлючОбъекта = &КлючОбъекта
	               |	И ХранилищеВариантовОтчетов.Код = &Код";
				   
	Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
	Запрос.Параметры.Вставить("Код", КлючНастроек);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		НастройкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
		НастройкаОбъект.ВариантОтчета = Новый ХранилищеЗначения(Настройка, Новый СжатиеДанных());
		
		Если ОписаниеНастройки <> Неопределено Тогда
			
			НастройкаОбъект.Наименование = ОписаниеНастройки.Представление;
			
		КонецЕсли;
		
		НастройкаОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияОписания(КлючОбъекта, КлючНастроек, ОписаниеНастройки, Пользователь)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХранилищеВариантовОтчетов.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.ХранилищеВариантовОтчетов КАК ХранилищеВариантовОтчетов
	               |ГДЕ
	               |	ХранилищеВариантовОтчетов.КлючОбъекта = &КлючОбъекта
	               |	И ХранилищеВариантовОтчетов.Код = &Код";
				   
	Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
	Запрос.Параметры.Вставить("Код", КлючНастроек);
	
	ОписаниеНастройки.КлючОбъекта = КлючОбъекта;
	ОписаниеНастройки.КлючНастроек = КлючНастроек;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		ОписаниеНастройки.Представление = Выборка.Наименование;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУстановкиОписания(КлючОбъекта, КлючНастроек, ОписаниеНастройки, Пользователь)
	
	Перем НастройкаОбъект;
	
	ОписаниеНастройки.КлючОбъекта = КлючОбъекта;
	ОписаниеНастройки.КлючНастроек = КлючНастроек;
	
	Если КлючНастроек <> Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	ХранилищеВариантовОтчетов.Ссылка
		               |ИЗ
		               |	Справочник.ХранилищеВариантовОтчетов КАК ХранилищеВариантовОтчетов
		               |ГДЕ
		               |	ХранилищеВариантовОтчетов.КлючОбъекта = &КлючОбъекта
		               |	И ХранилищеВариантовОтчетов.Код = &Код";
					   
		Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
		Запрос.Параметры.Вставить("Код", КлючНастроек);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			НастройкаОбъект = Выборка.Ссылка.ПолучитьОбъект();
			
		КонецЕсли;
		
	Иначе
		
		НастройкаОбъект = Справочники.ХранилищеВариантовОтчетов.СоздатьЭлемент();
		НастройкаОбъект.КлючОбъекта = ОписаниеНастройки.КлючОбъекта;
		НастройкаОбъект.УстановитьНовыйКод();
		ОписаниеНастройки.КлючНастроек = НастройкаОбъект.Код;
		
	КонецЕсли;
	
	Если НастройкаОбъект <> Неопределено Тогда
		
		НастройкаОбъект.Наименование = ОписаниеНастройки.Представление;
		НастройкаОбъект.Записать();
		
	КонецЕсли;
	
КонецПроцедуры

