= Тестирование

Для тестирования предложенного подхода и его реализации были получены поведенческие модели для классов нескольких библиотек:

- java.util.zip.ZipOutputStream
- java.lang.StringBuilder
- java.security.Signature
- java.net.Socket
- org.columba.ristretto.smtp.SMTPProtocol

Каждый из этих классов имеет модель разной сложности и, за исключением StringBuilder, рассматривался в упомянутых исследованиях@specforge@medv@tautoko, авторы которых сравнивали полученные КА с эталонными моделями. Эти модели расположены в репозитории GitHub#footnote("https://github.com/ModelInference/SpecForge"). Несмотря на то, что авторы использовали их как эталон, некоторые из представленных КА явно неполны и ограничены определенным набором вызовов (Signature и SMTPProtocol), а модель класса Socket, похоже, получена автоматически и вручную отредактирована. Дополнительно были реализованы собственные эталоны классов StringBuilder и  Signature. 

Оценка точности и полноты получаемых поведенческих моделей не проводилась, так как в работе не предложены собственные алгоритмы восстановления. Подробное сравнение алгоритмов проведено в исследовании "Automatic mining of specifications from invocation traces and method invariants"@medv. На качество моделей также влияет корректность получаемых трасс:
- Обход ICFG может получать все возможные пути исполнения, однако часто программы пишутся так, что не все состояния достижимы при реальном исполнении
- Фаззинг способен создавать некорректные входные объекты, что в теории может привести к появлению трасс, невозможных при реальном использовании (проблема, аналогичная предыдущему пункту)
- Анализ указателей имеет определенную погрешность

Влияние первых двух факторов сложно оценить и учесть. Что касается анализа указателей, то определением точности алгоритма Андерсена на практике занимались авторы работы "The Flow-Insensitive Precision of Andersen's Analysis in Practice"@andersen_prec. Результат показал, что точность очень сильно варьируется от проекта к проекту. 

== Полученные модели

Все модели восстановлены в результате объединения трасс, полученных статическим и динамическим путем. Сделано это по той причине, что динамические трассы в среднем не добавляют нового покрытия, но полученные таким образом последовательности вызовов более надежны.

В качестве источника проектов использовался GitHub, так как наиболее наглядными и понятными примерами являются классы стандартной библиотеки, отсутствующие в Maven Central. Однако эксперименты показали, что библиотеки из Maven Central демонстрируют наибольший процент успешного применения фаззинга, что положительно влияет на качество получаемых моделей.

Запуск инструмента для каждого целевого класса выполнялся в следующих условиях:
- Лимит получаемых проектов: 100
- Лимит получаемых трасс: 1000000
- Лимит длины трассы: 200 вызовов
- Ограничение глубины обхода: 10
- Параметр k для k-tail: 1 или 2
- Количество запусков фаззера: 10000
- Ограничение времени работы фаззера: 300 секунд
- Системные характеристики: 20 гигабайт оперативной памяти, процессор Intel Core i5-8300H CPU 2.30GHz, 4 физических ядра

=== ZipOutputStream

ZipOutputStream один из простых рассматриваемых классов. Полученная модель представлена на #ref(<own_zip>, supplement: "рисунке"), а эталонная -- на #ref(<ground_zip>, supplement: "рисунке"). Важно отметить, что данный эталон не вызывает сомнений в полноте и методе получения. Из рисунков видно, что обе модели покрывают все необходимые вызовы. Полученная модель не противоречит эталону и содержит основные переходы. Данный пример свидетельствует о том, что реализованный инструмент обеспечивает высокое качество результатов на несложных библиотеках.

#figure(
  image("../img/zip2.png", height: 40%),
  caption: "Полученная модель ZipOutputStream"
) <own_zip>


#figure(
  image("../img/zip_ground.png", height: 40%),
  caption: "Эталонная модель ZipOutputStream"
) <ground_zip>


=== StringBuilder

Для StringBuilder был вручную составлен эталон (#ref(<ground_strbuilder>, supplement: "рисунок")). Восстановленный КА представлен на #ref(<own_strbuilder>, supplement: "рисунке"). Легко заметить, что модель не противоречит реальному использованию StringBuilder. Получены явно не все возможные вызовы библиотеки, что допустимо -- попались не очень интересные и несодержательные проекты. Более длительное применение инструмента обогатит данную модель новыми состояниями и переходами. Примечательно, что восстановленный КА воспроизвёл наиболее популярные сценарии использования StringBuilder без каких-либо неточностей. Что касается эталона, он не содержит полного списка вызовов (для наглядности), но в нём учтены состояния и аргументы вызовов -- S1 имеет длину 0 (операции добавления данных выполнены с пустым аргументом), а S2 уже содержит данные. Подобный КА возможно получить, используя данные об аргументах вызовов при восстановлении. 

#figure(
  image("../img/strbuilder2.png", height: 35%),
  caption: "Полученная модель StringBuilder"
) <own_strbuilder>

#figure(
  image("../img/ground_strbuilder.png", height: 65%),
  caption: "Эталонная модель StringBuilder"
) <ground_strbuilder>


=== Signature

Signature содержит гораздо больше вызовов, чем рассмотренные ранее классы. Для полученной модели, представленной на #ref(<ground_signature>, supplement: "рисунке"), реализован собственный эталон (#ref(<own_signature>, supplement: "рисунок")). Из модели видно, что хоть КА и является аппроксимацией сверху, он содержит понятные паттерны переходов и сохраняет определенную обобщённость. При этом наблюдается явное сходство с эталоном.

#figure(
  image("../img/sign_rebuild.png"),
  caption: "Полученная модель Signature"
) <own_signature>

#figure(
  image("../img/sign_ground.png", height: 75%),
  caption: "Эталонная модель Signature"
) <ground_signature>

=== Socket

Socket также является интересным примером для тестирования, так как содержит много методов и требует определённого порядка работы с ними. При сравнении полученной модели с #ref(<own_socket>, supplement: "рисунка") и эталонной модели с #ref(<ground_socket>, supplement: "рисунка") видно, что полученный КА не содержит всех вызовов, что допустимо при сравнительно небольшой выборке случайных публичных проектов. Из полученного КА видны возможные направления ручной доработки. Например, объединение методов доступа к данным (get) в один переход.

Особый интерес представляет тот факт, что состояние S9 в эталоне является начальным (помимо S0), хотя вызова конструктора для него нет. Похожее поведение наблюдается в полученном КА -- из состояния 0 есть переходы помимо init. Это допускается, если объект был создан статическим методом или методом другого библиотечного класса. Из этого следует, что реализованный инструмент позволяет находить особенности поведения в нетривиальных классах.

#figure(
  image("../img/socket.png"),
  caption: "Полученная модель Socket"
) <own_socket>

#figure(
  image("../img/socket_ground.png"),
  caption: "Эталонная модель Socket"
) <ground_socket>

=== SMTPProtocol

Класс SMTPProtocol является одним из самых сложных среди рассматриваемых. Для полученного КА с #ref(<own_smtp>, supplement: "рисунка") существует неполная эталонная модель. Проводить сравнение с ней не имеет смысла, так как она содержит очень малое количество вызовов. 

Полученный КА, несмотря на слабую обобщённость, имеет явно выраженные повторяющиеся паттерны вызовов, которые, вероятно, могут быть объединены вручную. Также следует отметить наличие большинства методов класса, что говорит об успешном сборе трасс даже из небольшого количества проектов.

#figure(
  image("../img/smtp_rebuild.png"),
  caption: "Полученная модель SMTP"
) <own_smtp>

== Выводы

Возможность получения поведенческих моделей с помощью предложенного подхода и его реализации была успешно продемонстрирована на практике. Несмотря на то, что получаемые модели являются грубой аппроксимацией сверху, они отражают особенности поведения библиотек различной сложности и могут быть доработаны вручную. Более того, настройка параметров алгоритма восстановления, поиска проектов и входных точек может сильно улучшить результат. При этом восстановление КА выполняется в полностью автоматическом режиме, включая поиск проектов и извлечение трасс с помощью динамического и статического анализа. Но следует отметить, что представленный подход требует улучшений, особенно в области извлечения трасс и алгоритмов восстановления.