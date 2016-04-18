﻿//////////////////////////////////////////////////////////////////////////////// 
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ
//

&НаСервере
Функция НайтиНастройкуПоИмени(ИмяСохраняемойНастройки)

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ХранилищеВариантовОтчетов.Код КАК Код
	               |ИЗ
	               |	Справочник.ХранилищеВариантовОтчетов КАК ХранилищеВариантовОтчетов
	               |ГДЕ
	               |	ХранилищеВариантовОтчетов.КлючОбъекта = &КлючОбъекта
	               |	И ХранилищеВариантовОтчетов.Наименование = &Наименование";

	Запрос.Параметры.Вставить("КлючОбъекта", КлючОбъекта);
	Запрос.Параметры.Вставить("Наименование", ИмяСохраняемойНастройки);
	РезультатЗапроса = Запрос.Выполнить();

	Если РезультатЗапроса.Пустой() Тогда

		Возврат Неопределено;

	Иначе

		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Код;

	КонецЕсли;

КонецФункции

&НаСервере
Функция СоздатьНовуюНастройку(ИмяНастройки)

	Элемент = Справочники.ХранилищеВариантовОтчетов.СоздатьЭлемент();
	Элемент.КлючОбъекта = КлючОбъекта;
	Элемент.Наименование = ИмяНастройки;
	Элемент.Записать();
	Возврат Элемент.Код;

КонецФункции

&НаКлиенте
Процедура ВыбратьНастройкуСохранения()

	КодСохраняемойНастройки = НайтиНастройкуПоИмени(ИмяСохраняемойНастройки);

	// Уже была настройка с таким именем.
	Если КодСохраняемойНастройки <> Неопределено Тогда

		// Спросим у пользователя, нужно ли затереть настройку.
		ТекстВопроса = НСтр("ru = 'Заменить вариант ""%1""?'", "ru");
		ТекстВопроса = СтрЗаменить(ТекстВопроса, "%1", ИмяСохраняемойНастройки);
		Оповещение = Новый ОписаниеОповещения(
			"ВыбратьНастройкуСохраненияВопросЗавершение",
			ЭтотОбъект,
			КодСохраняемойНастройки);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;

	Иначе

		// Еще не было настройки с таким именем - сделаем новую
		КодСохраняемойНастройки = СоздатьНовуюНастройку(ИмяСохраняемойНастройки)

	КонецЕсли;

	Закрыть(Новый ВыборНастроек(КодСохраняемойНастройки));

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНастройкуСохраненияВопросЗавершение(Результат, КодСохраняемойНастройки) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		Закрыть(Новый ВыборНастроек(КодСохраняемойНастройки));
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УдалитьНастройку(Ссылка)

	Ссылка.ПолучитьОбъект().Удалить();

КонецПроцедуры

//////////////////////////////////////////////////////////////////////////////// 
// ОБРАБОТЧИКИ СОБЫТИЙ 
//

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Перем КлючТекущихНастроек;
	
	Инициализация = Истина;

	КлючОбъекта = Параметры.КлючОбъекта;
	КлючТекущихНастроек = Параметры.КлючТекущихНастроек;

	СписокНастроек.Параметры.УстановитьЗначениеПараметра("КлючОбъекта", КлючОбъекта);

	Элемент = Справочники.ХранилищеВариантовОтчетов.НайтиПоКоду(КлючТекущихНастроек);

	Если Элемент <> Справочники.ХранилищеВариантовОтчетов.ПустаяСсылка() Тогда

		Элементы.СписокНастроек.ТекущаяСтрока = Элемент;
		ИмяСохраняемойНастройки = Элемент.Наименование;
		
	Иначе
		// Не найден вариант. Дадим сделаем новое имя варианта	
		ИндексВарианта = 1;
		Пока Истина Цикл
			
			ИмяСохраняемойНастройки = "Вариант";
			
			Если ИндексВарианта <> 1 Тогда
				
				ИмяСохраняемойНастройки = ИмяСохраняемойНастройки + " " + Строка(ИндексВарианта);
				
			КонецЕсли;
			
			Если Справочники.ХранилищеВариантовОтчетов.НайтиПоНаименованию(ИмяСохраняемойНастройки) = Справочники.ХранилищеВариантовОтчетов.ПустаяСсылка() Тогда
				// Нет такого имени варианта
				
				Прервать;
				
			КонецЕсли;
			
			ИндексВарианта = ИндексВарианта + 1;
			
		КонецЦикла;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПриАктивизацииСтроки(Элемент)

	Если НЕ Инициализация Тогда
		
		Если Элемент.ТекущиеДанные <> Неопределено Тогда

			ИмяСохраняемойНастройки = Элемент.ТекущиеДанные.Наименование;

		Иначе

			ИмяСохраняемойНастройки = "";

		КонецЕсли;
		
	Иначе
		
		Инициализация = Ложь;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СохранитьВыполнить()

	ВыбратьНастройкуСохранения();

КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ВыбратьНастройкуСохранения();

КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;

КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередУдалением(Элемент, Отказ)

	Отказ = Истина;

	Если Элементы.СписокНастроек.ТекущаяСтрока <> Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения(
			"СписокНастроекПередУдалениемВопросЗавершение",
			ЭтотОбъект);
		ПоказатьВопрос(Оповещение,
			НСтр("ru = ""Удалить вариант """) + Элементы.СписокНастроек.ТекущиеДанные.Наименование + "?",
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередУдалениемВопросЗавершение(Результат) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		УдалитьНастройку(Элементы.СписокНастроек.ТекущаяСтрока);
		Элементы.СписокНастроек.Обновить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокНастроекПередНачаломДобавления(Элемент, Отказ, Копирование)

	Отказ = Истина;

КонецПроцедуры

