### Данный модуль создает ВМ.
## Требования:
Версия провайдера "yandex-cloud/yandex" >= 0.87.0"
Версия terraform >= 1.5.7"

## Переменные:
zone: description = "Yandex.Cloud network availability zones", type = string, default = "ru-central1-a"
platform_id: type = string, default = "standard-v3"
scheduling_policy: type = string, default = "false"
size: "Размер диска", type = number, default = "35"
image_id: type = string, default = "fd80qm01ah03dkqb14lc"
nat: type = bool, default = "false"
subnet_id: type = string

## Возвращаемые значения
ip_address (Адрес созданной ВМ)
zone (Yandex.Cloud network availability zones)