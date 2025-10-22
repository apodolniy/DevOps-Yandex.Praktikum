variable token {
  description = "IAM token for Yandex Cloud"
  type        = string
  sensitive = true
}

variable access_key {
  description = "access_key for Yandex Cloud"
  type        = string
  sensitive = true
}

variable secret_key {
  description = "secret_key for Yandex Cloud"
  type        = string
  sensitive = true
}

variable cloud_id {
  description = "ID of cloud"
  type        = string
  default     = "bpfuefc0l27kjb4r9mt3"
}

variable folder_id {
  description = "ID of folder"
  type        = string
  default     = "b1gsdm9dbf1eo4c862li"
}

variable zone {
  description = "Zone"
  type        = string
  default     = "ru-central1-a"
}

variable image_id {
  description = ""
  type = string
  default = "fd80qm01ah03dkqb14lc"
}