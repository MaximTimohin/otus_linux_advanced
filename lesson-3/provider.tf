terraform {
  required_version = ">= 0.13.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.94.0"

    }
  }
}

// Configure the Yandex.Cloud provider
provider "yandex" {
  service_account_key_file     = var.service_account_key_file
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = "ru-central1-a"
}
