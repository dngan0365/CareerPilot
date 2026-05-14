# 🚀 CareerPilot — Microservice Project

A career guidance platform built with a microservice architecture, FastAPI, Kubernetes (kind), nginx ingress, and Kafka.

---
## 📌 Introduction

CareerPilot is a modern career guidance platform built using a microservice architecture.
The project is designed to provide scalable, maintainable, and cloud-native services for helping users explore career paths, manage profiles, and interact with intelligent recommendation systems.

This project leverages:

- ⚡ FastAPI for high-performance backend services
- ☸️ Kubernetes (kind) for local container orchestration
- 🌐 NGINX Ingress Controller for API gateway and routing
- 📩 Apache Kafka for asynchronous communication between services
- 🐳 Docker for containerization

The system is built with scalability, modularity, and DevOps best practices in mind, making it suitable for learning and production-like environments.

## ✨ Features
- 🔐 Authentication & Authorization
    - Secure JWT-based authentication
    - Role-based access control (RBAC)
    - User registration and login system
- 👤 User Management
    - User profile creation and management
    - Career preference tracking
    - Personalized dashboard support
- 🎯 Career Recommendation System
  - Intelligent career guidance engine
  - Recommendation service powered by microservices
  - Extensible AI/ML integration support
- 📩 Event-Driven Architecture
  - Asynchronous communication using Apache Kafka
  - Decoupled microservice interaction
  - Real-time event processing
- ☸️ Cloud-Native Infrastructure
  - Kubernetes-based deployment
  - Local development with kind cluster
  - Scalable and containerized services
- 🌐 API Gateway & Networking
  - NGINX Ingress Controller integration
  - Centralized routing and load balancing
  - Service exposure management
- 🐳 Containerization
  - Dockerized microservices
  - Consistent development and deployment environments
  - Easy scalability and portability
- 📊 Monitoring & Observability
  - Prometheus metrics collection
  - Grafana dashboards and visualization
  - Health checks and service monitoring
- 🚀 DevOps & Automation
  - CI/CD ready architecture
  - GitHub Actions integration
  - Infrastructure-as-Code friendly structure
- 🧩 Modular Microservice Design
  - Independent service deployment
  - Loosely coupled architecture
  - Easy maintenance and extensibility
- ⚡ High Performance Backend
  - FastAPI asynchronous APIs
  - High-speed request handling
  - Automatic OpenAPI/Swagger documentation
- 🔄 Scalable Architecture
  - Horizontal scaling support
  - Kubernetes orchestration
  - Ready for production-grade workloads

## 📁 Project Structure

```
CAREERPILOT/
├── apps/
│   ├── frontend/                  # Frontend app
│   └── services/
│       ├── cv_service/            # Resume parsing & analysis
│       ├── gateway/               # API gateway (routes all traffic)
│       ├── interview_service/     # Interview prep
│       ├── job_service/           # Job listings
│       ├── kafka/                 # Kafka event bus config
│       ├── roadmap_service/       # Career roadmaps
│       └── user_service/          # Auth & user profiles
├── deployment/
│   ├── local/                     # Local k8s manifests (kind)
│   └── cloud/                     # Cloud manifests (GKE/EKS)
├── infra/
│   ├── k8s/
│   │   ├── ingress/               # nginx ingress rules
│   │   └── monitoring/            # Prometheus / Grafana
│   ├── nginx/                     # Custom nginx Dockerfile & config
│   └── terraform/                 # Cloud infrastructure (IaC)
├── models/                        # Shared ML models
├── notebooks/                     # Jupyter notebooks
├── pipelines/                     # Data pipelines
├── tests/                         # Integration & e2e tests
├── utils/                         # Shared utilities
└── .env                           # Environment variables
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Services | Python + FastAPI |
| Containerization | Docker |
| Orchestration | Kubernetes (kind for local) |
| Ingress | nginx ingress controller |
| Event bus | Kafka |
| IaC (cloud) | Terraform |

---

## ⚙️ Local Development Setup

### Prerequisites

Make sure you have these installed:

```bash
docker --version      # Docker Desktop
kind --version        # kind
kubectl version       # kubectl
```

Install if missing:
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

### 1. Create the kind cluster

```bash
kind create cluster --config deployment/local/kind-config.yaml --image kindest/node:v1.31.6
```
**Note**: The image version should be compatible with your kind version
<!-- `deployment/local/kind-config.yaml`: -->

<!-- ```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: careerpilot
nodes:
  - role: control-plane
    kubeadmConfigPatches:
      - |
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
    extraPortMappings:
      - containerPort: 80
        hostPort: 80
        protocol: TCP
      - containerPort: 443
        hostPort: 443
        protocol: TCP
``` -->

---

### 2. Install nginx ingress controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for it to be ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

---

### 3. Build & load service images

> ⚠️ kind does NOT share your local Docker daemon. You must load images manually.

You can build and add any images into cluster, using those command.
```bash
# Build a service
### Add any available images in here
docker build -t user-service:latest ./apps/services/user_service 

# Load it into kind
kind load docker-image user-service:latest --name careerpilot
```

Or use the helper script to build & load all services at once for Linux only:

```bash
bash deployment/local/load-images.sh
```

---

### 4. Deploy to k8s

```bash
kubectl apply -f deployment/local/deployment.yaml
kubectl apply -f deployment/local/ingress.yaml
```

---

### 5. Verify everything is running

```bash
kubectl get pods       # all pods should be Running
kubectl get services   # check services
kubectl get ingress    # check ingress routes
```

---

### 6. Test the services

All services are available at `http://localhost` via nginx ingress:

| Service | URL |
|---|---|
| user_service | http://localhost/api/users/health |
| cv_service | http://localhost/api/cv/health |
| job_service | http://localhost/api/jobs/health |
| interview_service | http://localhost/api/interviews/health |
| roadmap_service | http://localhost/api/roadmap/health |

```bash
curl http://localhost/api/users/health
# {"status": "ok", "service": "user_service"}
```

---

## 🔁 Service → Ingress Mapping

| Service folder | Docker image | k8s Service name | Ingress path |
|---|---|---|---|
| `user_service` | `user-service:latest` | `user-service` | `/api/users` |
| `cv_service` | `cv-service:latest` | `cv-service` | `/api/cv` |
| `job_service` | `job-service:latest` | `job-service` | `/api/jobs` |
| `interview_service` | `interview-service:latest` | `interview-service` | `/api/interviews` |
| `roadmap_service` | `roadmap-service:latest` | `roadmap-service` | `/api/roadmap` |
| `gateway` | `gateway:latest` | `gateway` | `/api` |

---

## 📋 Adding a New Service

1. Create service folder under `apps/services/<service_name>/`
2. Add `main.py`, `requirements.txt`, `Dockerfile`
3. Add a new `Deployment` + `Service` block in `deployment/local/deployment.yaml`
4. Add a new `path` block in `deployment/local/ingress.yaml`
5. Build, load, and apply:

```bash
docker build -t <service-name>:latest ./apps/services/<service_name>
kind load docker-image <service-name>:latest --name careerpilot
kubectl apply -f deployment/local/deployment.yaml
kubectl apply -f deployment/local/ingress.yaml
```

---

## 🪵 Logs & Debugging

```bash
# Stream live logs
kubectl logs -f deployment/user-service

# Last 100 lines
kubectl logs deployment/user-service --tail=100

# Logs from crashed pod
kubectl logs deployment/user-service --previous

# Open a terminal inside the container
kubectl get pods                                      # get pod name
kubectl exec -it <pod-name> -- /bin/sh               # exec in

# Describe pod (useful when pod won't start)
kubectl describe pod <pod-name>
```

---

## 🗑️ Teardown

```bash
# Delete all deployed resources
kubectl delete -f deployment/local/

# Delete the entire kind cluster
kind delete cluster --name careerpilot
```

---

## 🗺️ Request Flow

```
Browser / Frontend
      ↓
nginx ingress (localhost:80)
      ↓
API Gateway (apps/services/gateway)
      ↓
┌─────────────┬──────────────┬─────────────┬──────────────┬──────────────┐
│ user_service│  cv_service  │ job_service │interview_svc │roadmap_svc   │
└─────────────┴──────────────┴─────────────┴──────────────┴──────────────┘
                              ↓
                         Kafka (async events)
```

---

## 📌 Common Issues

**Pod stuck in `ImagePullBackOff`**
→ You forgot to load the image into kind. Run:
```bash
kind load docker-image <image>:latest --name careerpilot
```
And make sure `imagePullPolicy: Never` is set in your deployment YAML.

**Port 80 already in use**
→ Something else is using port 80. Stop it or change `hostPort` in `kind-config.yaml`.

**Ingress not routing**
→ Check the nginx ingress controller is ready:
```bash
kubectl get pods -n ingress-nginx
```

**Changes not reflecting after rebuild**
→ Re-build, re-load into kind, then restart the deployment:
```bash
docker build -t user-service:latest ./apps/services/user_service
kind load docker-image user-service:latest --name careerpilot
kubectl rollout restart deployment/user-service
```
