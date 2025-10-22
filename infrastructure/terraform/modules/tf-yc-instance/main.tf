resource "yandex_compute_instance" "vm-1" {
    name = "chapter5-lesson2-std-041-34"

    zone = var.zone
    platform_id = var.platform_id
  
    # Конфигурация ресурсов:
    # количество процессоров и оперативной памяти
    resources {
        cores  = 2
        memory = 2
    }

    # Прерываемая ВМ
    scheduling_policy {
        preemptible = var.scheduling_policy
    }

    # Загрузочный диск:
    # здесь указывается образ операционной системы
    # для новой виртуальной машины
    boot_disk {
        initialize_params {
            image_id = var.image_id
            size = var.size
        }
    }

    # Сетевой интерфейс:
    # нужно указать идентификатор подсети, к которой будет подключена ВМ
    network_interface {
        subnet_id = var.subnet_id
        nat       = var.nat
    }

    # Метаданные машины:
    # здесь можно указать скрипт, который запустится при создании ВМ
    # или список SSH-ключей для доступа на ВМ
    #metadata = {
    #    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    #}
    metadata = {
        user-data = "${file("./modules/tf-yc-instance/cloud-config.yaml")}"
    }
} 