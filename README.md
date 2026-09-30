# Multi-Cloud Deployment Platform

A Kubernetes-based deployment platform that runs an application on two independent clusters with automatic cross-cloud failover, published container images, and real-time monitoring.

![Build Status](https://github.com/suyog365/multi-cloud/actions/workflows/build.yml/badge.svg)
![GHCR](https://img.shields.io/badge/image-ghcr.io%2Fsuyog365%2Fmulti--cloud-blue)

---

## Architecture

![Architecture Diagram](./architecture.png)

The router tries cloud-a first. If cloud-a becomes unhealthy, it
automatically falls back to cloud-b within 5 seconds.

---

## Features

- **Multi-cluster deployment** — Same app runs on two independent Kubernetes clusters (`cloud-a`, `cloud-b`) provisioned via Terraform
- **Automatic failover** — nginx router detects cluster failure and reroutes traffic in <5s
- **Zero-downtime rolling updates** — Kubernetes `RollingUpdate` strategy verified during image upgrades
- **Self-healing** — Kubernetes automatically replaces pods that fail health checks
- **Container publishing** — Image built and pushed to GitHub Container Registry (GHCR) on every commit
- **Security scanning** — Trivy scans every build; blocks deployment on CRITICAL vulnerabilities
- **Observability** — Prometheus + Grafana dashboards showing live pod CPU, memory, and network metrics
- **Production hardening** — Non-root container user, Gunicorn WSGI server, readiness probes

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| App | Python 3.11, Flask |
| Container | Docker, Gunicorn (WSGI) |
| Orchestration | Kubernetes (Kind clusters) |
| Infrastructure as Code | Terraform |
| CI/CD | GitHub Actions |
| Container Registry | GitHub Container Registry (GHCR) |
| Traffic Routing | nginx |
| Monitoring | Prometheus, Grafana |
| Security | Trivy, non-root containers |

---

## Prerequisites

Install these tools before running:

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://developer.hashicorp.com/terraform/install)
- [Helm](https://helm.sh/docs/intro/install/)

## How to Run

1. Install: Docker, Kind, kubectl, Terraform, Helm
2. Create clusters: `cd terraform && terraform init && terraform apply`
3. Build image: `cd app && docker build -t my-hello-app:v1 . && cd ..`
4. Deploy to cloud-a: `kubectl config use-context kind-cloud-a && kubectl apply -f k8s/app/deployment-cloud-a.yaml && kubectl apply -f k8s/app/service.yaml`
5. Deploy to cloud-b: `kubectl config use-context kind-cloud-b && kubectl apply -f k8s/app/deployment-cloud-b.yaml && kubectl apply -f k8s/app/service.yaml`
6. Deploy router: `kubectl config use-context kind-cloud-a && kubectl apply -f k8s/router/`
7. Open three terminals and port-forward ports 9001, 9002, 8080
8. Visit http://localhost:8080

## Failover Demo

1. Open http://localhost:8080 — shows "Hello from kind-cloud-a!"
2. Stop the cloud-a port-forward (Ctrl+C)
3. Refresh the page after 5 seconds
4. Now shows "Hello from kind-cloud-b!"

## Tech Stack

Docker, Kubernetes (Kind), Terraform, GitHub Actions, nginx, Prometheus, Grafana, Trivy, Python/Flask

## Cleanup

    kind delete cluster --name cloud-a
    kind delete cluster --name cloud-b