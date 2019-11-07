# SkybondsApp
Выполнение приложения согласно техническому заданию: [Тестовое приложение]()
## Краткое описание
Данное задание состоит из двух задач:
1. Долевое строительство
2. График облигации

## Задача 'Долевое строительство'
Реализация данного задания доступна по ссылке: [Файл playground]()

## Задача 'График облигации'
Приложение не работает с сетью, все данные берутся из файла bonds.json. Получаются через протокол 'MockDataFetcher' (реализованным MockDataSourceService). Для дополнительного приблежения к условиям симулирующим ответ по сети, в сервисе реализована задержка ответа с данными. Задержка в 3 секунды, ее можно изменить в файле MockDataSourceService (метод 'getBonds(response: @escaping (BondsResponse?, Error?) -> ())'). В файле представлены облигации трех видов: (Kamaz, Gazprombank, Russian Helicopters JSC). Каждая из облигаций имеет вид:
```
"title": "Kamaz",
"currency": "RUB",
"isin": "RU000A0JW126",
"items": [
    {"date": "2018-09-01T13:00:00+0300", "price": 56.177},
    {"date": "2018-09-01T15:00:00+0300", "price": 23.3697},
    ...
]
```
В массиве items создано 3000 элементов для каждого вида облигаций. Каждый элемент состоит из даты (date) и стоимости облигации на эту дату (price). При необходимости, эти данные можно редактировать (для отображения бОльшего количества облигаций, уменьшения набора дат).

Приложение состоит из экранов:
1. Экран отображения графика цены (доходности).
2. Модальное окно выбора начальной и конечной даты фильтрации данных для отображения.

### Экран отображения графика
Адаптирован под все размеры iPhone. Наследован от общего класса SKBViewController для поддержки возможности применения элемента загрузки (spinner), вывода сообщения с ошибкой (alert), применения общего стила оформления всех экранов проекта (например градиентной заливки). Включает в себя:
1. навигационную панель с названием экрана
2. график отображения цен и доходности облигации (вынесен в отдельное вью ReportsView)
3. элемент переключения вида отображаемого графика (вынесен в отдельное вью ChartTypeSelector), при взаиомдействии (по нажатию), отображает перечень доступных к выбору типов графиков отображения данных.
4. элемент отображения списка облигаций (вынесен в отдельную коллекцию BondsCollectionView)
5. элемент отображения выбранных дат (вынесен в отдельное вью PeriodsView)
Реализован показ элемента загрузки, в то время, пока нет данных, ошибку, в случае, если данные пришли некорректно (возможности проверить нет, в основном, реализуется при работе с сетью).

### Экран модального окна выбора дат
Адаптирован под все размеры iPhone. Наследован от общего класса SKBModalController для поддержки возможности применения элемента загрузки (spinner), вывода сообщения с ошибкой (alert), применения общего стила оформления всех экранов проекта (например прозрачного фона). Появлется модально, имеет размер вью меньше основного экрана, незаполненное поле имеет некоторую прозрачность.
Включает в себя:
1. ярлык заголовка
2. ярлыкы с предложением выбора даты начала/завершения периода
3. пикеры (UIPIcker) с выбором дат, формируются на основании текущих данных конкретной облигации.
4. кнопка применения выбранного периода
5. кнопка отмены выбора (закрытие окна, возврат к предыдущему экрану)
6. алерт с ошибкой в случае если: дата начала позже даты заврешения, дата начала и завершения совпадают или какая-то из дат не выбрана
Реализована логика закрытия окна по нажатию на "свободном" поле вне отображения данных (по нажатию на контейнер с данными ничего не происходит).

* Приложение полностью написано без использования сторибордов и ксибов (все в коде).
* В приложении реализована адаптация под разные размеры экранов (от 4 до 6 дюймов). 
* Обработано нажатие вне поля контейнера для скрытия модального окна. 
* Реализованы индикаторы загрузки для понимания процесса пользователем (activity indicator).
* Использованы расширения для кастомизации настроек: UIViewController, UICollectionView, UICollectionViewCell, UIColor, Date, String, UIView.

## Внешние зависимости
В проекте используется средство для управления зависимостями Carthage. Добавлена библиотке отрисовки гарфиков Charts и библиотека упрощенной работы констрейнтами и якорями SnapKit.

## Архитектура

Приложение разделено на модули (в данном случае, это модуль списка пользователей и модальное окно). Каждый модуль состоит из: 

### Assembly
Элемент, который отвечает за создание модуля, подготовку модели, подготовку вью, связывание их, имеет публичное свойство 'view', которое отдается вызывающему модулю, для правильной подготовке и показу модуля.

### Model (ViewModel)
Может включать в себя логику интерактора, презентера, вью модели и пр. (если таковые не представлены в проекте или выбран сокращенный архитектурный подход). Основной задачей модели является подготовка данных, работа с ними, передача данных о вью.

### View (ViewController)
Является классическим элементом отображения данных и работе с действиями пользователя. Имея связь с моделью, динамически реагирует на изменения модели, обновляя свое состояние, обращается к модели если контекст (действия пользователя) требуют обновления (изменения) данных.

<img src="/images/architecture.png">

## Демонстрация экранов
<img src="/images/sample.jpeg" width="1000" height="2000">

## Резюме
● Сложность задачи 3 из 10, (отсутствие источника данных и дизайна, все элементы рисовались разработчиком самостоятельно)
● Предварительная оценка трудозатрат 12-14 часов
● Фактические трудозатраты 15 часов
