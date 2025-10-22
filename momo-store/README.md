# Momo Store (Пельменная №2)  

<img width="900" alt="Momo Store Home" src="https://storage.yandexcloud.net/momo-static/home.png">  

Интернет-магазин "Пельменная №2" - полнофункциональное веб-приложение для продажи пельменей с современной микросервисной архитектурой и полным CI/CD пайплайном.  

## 🚀 Продуктивная среда  

- **Основное приложение**: https://std-momo-store.mooo.com/  
- **Метрики (Prometheus)**: https://prom.std-momo-store.mooo.com/  
- **Мониторинг (Grafana)**: https://grafana.std-momo-store.mooo.com/  
- **Бизнес-дашборд**: https://grafana.std-momo-store.mooo.com/d/oSBaIdRIz/momo-store-business  

## 📁 Структура проекта  

momo-store/  
├── backend/ - Go API сервер  
│ ├── cmd/api/ - Точка входа приложения  
│ ├── internal/ - Внутренние пакеты  
│ ├── Dockerfile - Образ Docker  
│ ├── go.mod - Зависимости Go  
│ └── .gitlab-ci.yml - CI/CD для бэкенда  
├── frontend/ - Vue.js приложение  
│ ├── src/ - Компоненты Vue  
│ ├── public/ - Статические файлы  
│ ├── Dockerfile - Образ Docker  
│ ├── package.json - Зависимости Node.js  
│ └── .gitlab-ci.yml - CI/CD для фронтенда  
├── infrastructure/ - Инфраструктура как код  
│ ├── terraform/ - Terraform конфигурации  
│ │ ├── main.tf - Основные ресурсы  
│ │ ├── variables.tf - Переменные  
│ │ ├── provider.tf - Провайдеры  
│ │ └── versions.tf - Версии провайдеров  
│ ├── momo-store-chart/ - Главный Helm chart  
│ │ ├── charts/ - Subcharts  
│ │ │ ├── backend/ - Chart для бэкенда  
│ │ │ ├── frontend/ - Chart для фронтенда  
│ │ │ ├── grafana/ - Chart для Grafana  
│ │ │ ├── prometheus/ - Chart для Prometheus  
│ │ │ └── ingress/ - Chart для Ingress  
│ │ ├── Chart.yaml - Метаданные chart  
│ │ └── values.yaml - Значения по умолчанию  
│ ├── service-account/ - Сервисные аккаунты K8s  
│ └── .gitlab-ci.yml - CI/CD для инфраструктуры  
├── .gitlab-ci.yml - Главный CI/CD пайплайн  
└── README.md - Документация  

## 🏗️ Развертывание инфраструктуры  

### Предварительные требования  

1. **Аккаунт Yandex Cloud** с доступом к:  
   - Yandex Managed Kubernetes  
   - Yandex Object Storage  
   - Service accounts  

2. **Установленное ПО**:  
```bash
   terraform >= 1.3.0
   kubectl >= 1.25.0
   helm >= 3.8.0
   yc CLI
```

### Настройка Terraform  

1. **Создать сервисный аккаунт для Terraform**:  
```bash
yc iam service-account create --name sa-terraform
yc resource-manager folder add-access-binding \
  --role editor \
  --subject serviceAccount:<sa-terraform-id>
```
2. **Создать статический ключ доступа**:  
```bash
yc iam access-key create --service-account-name sa-terraform
```
3. **Настроить файлы конфигурации**:  
infrastructure/terraform/backend.tfvars:  
```bash
access_key = "your_access_key_here"
secret_key = "your_secret_key_here"
bucket    = "tf-state-momo-store"
```  
infrastructure/terraform/secret.tfvars:  
```bash
token = "$(yc iam create-token)"
```  

### Создание инфраструктуры  

cd infrastructure/terraform  

 **Инициализация Terraform**  
```bash
terraform init -backend-config=backend.tfvars
```
 **Планирование развертывания**
```bash
terraform plan -var-file="secret.tfvars"
```
 **Применение конфигурации**
```bash
terraform apply -var-file="secret.tfvars"
```

## 🔄 Правила внесения изменений в инфраструктуру

### Процесс изменений

1. **Создание feature ветки от main:**  
```bash
git checkout -b feature/terraform-<change-description>
```  
2. **Внесение изменений в Terraform конфигурации**  
3. **Проверка плана изменений:**  

```bash 
terraform plan -var-file="secret.tfvars"
```
4. **Создание Merge Request с описанием:**  
- Какие ресурсы изменяются/создаются/удаляются  
- Причина изменений  
- Оценка влияния на стоимость  
- Ревью как минимум одним участником команды 
- Применение изменений после мержа:  
```bash
terraform apply -var-file="secret.tfvars"
```  

### Правила именования

- Ресурсы: **momo-{environment}-{resource-type}-{purpose}**
- Ветки: **feature/terraform-{description} или fix/terraform-{issue}**
- Коммиты: **terraform: {description}**

## 🚀 Развертывание приложения

### Подготовка Kubernetes  

1. **Настройка kubectl:**  
```bash
yc managed-kubernetes cluster get-credentials \
  --id <cluster-id> \
  --external
```  
2. **Создание namespace:**  
```bash
kubectl create namespace momo-store
```
3. **Установка cert-manager:**  
```bash
helm repo add jetstack https://charts.jetstack.io  
helm repo update  
helm upgrade --install --atomic \  
  -n momo-store \  
  cert-manager jetstack/cert-manager \  
  --set installCRDs=true  
``` 

### Настройка GitLab CI/CD  

 **Добавить переменные в GitLab (Settings → CI/CD → Variables):**
Переменная	Значение
KUBE_CONFIG	base64(kubeconfig)  
NEXUS_USER	nexus username  
NEXUS_PASS	nexus password  
NEXUS_HELM_REPO	nexus repo url  
GRAFANA_ADM_PWD	admin password  

### Установка приложения  

```bash
# Добавление Helm репозитория  
helm repo add momo-store \
  http://nexus.praktikum-services.tech/repository/std-041-34-momo-store-helm/
helm repo update

# Установка приложения
helm upgrade --install --atomic \
  -n momo-store \
  momo-store ./infrastructure/momo-store-chart \
  --set backend.image.tag=1.0.0 \
  --set frontend.image.tag=1.0.0
  --set grafana.adminPassword=momostore
```
 **Опционально указываем параметры:**
backend.image.tag=1.0.0 - версия контейнера backend  
frontend.image.tag=1.0.0 - версия контейнера frontend  
grafana.adminPassword=momostore - пароль пользователя grafana  

### Проверка установки  

```bash
# Статус подов
kubectl get pods -n momo-store

# Статус сервисов
kubectl get svc -n momo-store

# Логи приложения
kubectl logs -n momo-store -l app=frontend
```

## 🔄 Релизный цикл и версионирование  

### Правила версионирования (SemVer)  

- Формат: MAJOR.MINOR.PATCH  
- MAJOR: Критические изменения, ломающие обратную совместимость  
- MINOR: Новая функциональность с сохранением совместимости  
- PATCH: Исправления багов и мелкие улучшения  

### Установка версий  

В файле .gitlab-ci.yml:  
```bash
variables:  
  VERSION: "1.0.0"  # MAJOR.MINOR устанавливаются вручную
  # PATCH автоматически устанавливается из CI_PIPELINE_ID
```

### Процесс релиза  

1. Разработка в feature ветках  
2. Создание Merge Request в main:  
	- Прохождение code review  
	- Успешное выполнение CI/CD пайплайна  
	- Обновление версии при необходимости  
3. Автоматический деплой при мерже в main:  
	- Сборка Docker образов с тегом {VERSION}.{CI_PIPELINE_ID}  
	- Публикация в GitLab Container Registry  
	- Развертывание в Kubernetes кластере  
	- Публикация Helm chart в Nexus  

### CI/CD Pipeline этапы  

 **pre-build**:  
	- SAST анализ (Semgrep)  
	- Поиск секретов (Gitleaks)  
	- SCA анализ (Trivy)  
 **build**:  
	- Сборка Docker образов  
	- Тестирование образов на уязвимости  
 **test**:  
	- Unit тесты бэкенда  
	- Интеграционные тесты  
 **deploy**:  
	- Деплой в Kubernetes  
	- Публикация Helm chart  

## 📊 Мониторинг

### Доступ к системам мониторинга  
Prometheus: https://prom.std-momo-store.mooo.com/  
<img width="900" alt="Momo Store Home" src="https://storage.yandexcloud.net/momo-static/prom.png">  

Grafana: https://grafana.std-momo-store.mooo.com/  
Бизнес-дашборд: https://grafana.std-momo-store.mooo.com/d/oSBaIdRIz/momo-store-business  
<img width="900" alt="Momo Store Home" src="https://storage.yandexcloud.net/momo-static/grafanadashboard.png">  

## 🆘 Troubleshooting

### Частые проблемы  

**Проблема: Приложение не доступно**  
```bash
kubectl get ingress -n momo-store
kubectl describe ingress -n momo-store
```

**Проблема: Ошибки сертификатов**  

```bash
kubectl get certificaterequest -A
kubectl get certificate -A
```

**Проблема: Pods в статусе CrashLoopBackOff**  
```bash
kubectl logs -n momo-store <pod-name> --previous
kubectl describe pod -n momo-store <pod-name>
```

## 📞 Поддержка  

Репозиторий: https://gitlab.praktikum-services.ru/std-041-34/momo-store  
Production: https://std-momo-store.mooo.com/  
Helm Registry: http://nexus.praktikum-services.tech/repository/std-041-34-momo-store-helm/  


**Пельменная №2 © 2025 | Production**