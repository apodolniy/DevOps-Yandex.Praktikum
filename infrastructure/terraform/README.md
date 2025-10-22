### Развертывание инфрастуктуры с помощью terraform.
## Требования:  
Версия провайдера "yandex-cloud/yandex" >= 0.87.0"  
Версия terraform >= 1.5.7"

## Переменные:
variable token: "IAM token for Yandex Cloud", тип = string
access_key: "access_key for Yandex Cloud", тип = string
secret_key: "secret_key for Yandex Cloud", тип = string
cloud_id: "ID of cloud", тип = string, default = "bpfuefc0l27kjb4r9mt3"
folder_id: "ID of folder", тип = string, default = "b1gsdm9dbf1eo4c862li"
zone: "Yandex.Cloud network availability zones", тип = string, default = "ru-central1-a"
image_id: тип = string, default = "fd80qm01ah03dkqb14lc"

## Возвращаемые значения
ip_address (Адрес созданной ВМ)