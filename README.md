# diplom
Добрый день релиз моей дипломной работы с использованием Terraform и Ansible
Terraform поднимает 7 инстансов c именами заданные в переменной, производлит первичную настройку, создание доступа пользователей установку софта путем meta-data н
на выходе получаем на 99 % готовые сервисы для RHEL подобных образов (проверял на fedore и centos7)
Создает первичные  группы безопасности с мин настройками портов и сетей затем помещает в них инстансы . 
Создает ALB для http1 и http2 сервера
создает подсети для zone-a и zone-b
