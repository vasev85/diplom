# diplom
Добрый день релиз моей дипломной работы с использованием Terraform и Ansible.
Terraform поднимает 7 инстансов в YA-cloud c именами заданные в переменной, производлит первичную настройку, создание доступа пользователей, установку софта путем meta-data
на выходе получаем на 99 % готовые сервисы для RHEL подобных образов (проверял на fedore и centos7).
Создает первичные  группы безопасности с мин настройками портов и сетей затем помещает в них инстансы . 
Создает ALB для http1 и http2 сервера.
создает подсети для zone-a и zone-b.
Все сервисы имеют при создании из Terraform скрипта имеют доступ к public сети и private сети. Затем после до-настройке шлюза безопасности через  Ansible
происходит выработка private/public key и отправка pub на инстансы. Остальное все делалось в ручном режиме.
Для просмотра сервисов напишите мне в Discord (Vasy ko#7828), сервисы прерываемые, они могут быть не доступны для теста.
