# 🚀 AZ-900 Practice Portal - DevOps Project

A production-ready web application demonstrating **Docker containerization**, **Kubernetes orchestration**, and **CI/CD deployment** to **Azure Kubernetes Service (AKS)**.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Deployment Options](#deployment-options)
- [CI/CD Pipeline](#cicd-pipeline)
- [Kubernetes Configuration](#kubernetes-configuration)
- [Monitoring & Scaling](#monitoring--scaling)
- [Troubleshooting](#troubleshooting)
- [Cost Optimization](#cost-optimization)
- [Contributing](#contributing)

---

## 🎯 Overview

This project is an **AZ-900 Practice Assessment Portal** that demonstrates modern DevOps practices:

- **Containerization**: Docker multi-stage builds with security best practices
- **Orchestration**: Kubernetes deployment with auto-scaling
- **CI/CD**: Automated GitHub Actions pipeline
- **Cloud Deployment**: Azure Kubernetes Service (AKS)
- **Security**: Container scanning, non-root users, health checks
- **Monitoring**: HPA (Horizontal Pod Autoscaler) for dynamic scaling

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      GitHub Repository                       │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │   Source   │  │  Dockerfile  │  │  K8s Manifests   │    │
│  │    Code    │  │              │  │                  │    │
│  └────────────┘  └──────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Actions CI/CD                       │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │   Build    │→ │   Security   │→ │     Deploy       │    │
│  │   Docker   │  │   Scan       │  │     to AKS       │    │
│  └────────────┘  └──────────────┘  └──────────────────┘    │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              GitHub Container Registry (GHCR)                │
│                   ghcr.io/username/repo                      │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                  Azure Kubernetes Service                    │
│  ┌────────────────────────────────────────────────────┐     │
│  │                   Production Namespace              │     │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐         │     │
│  │  │  Pod 1   │  │  Pod 2   │  │  Pod N   │         │     │
│  │  │  (App)   │  │  (App)   │  │  (App)   │         │     │
│  │  └──────────┘  └──────────┘  └──────────┘         │     │
│  │         │              │              │            │     │
│  │         └──────────────┴──────────────┘            │     │
│  │                        │                           │     │
│  │                 ┌──────────────┐                   │     │
│  │                 │   Service    │                   │     │
│  │                 │ LoadBalancer │                   │     │
│  │                 └──────────────┘                   │     │
│  │                        │                           │     │
│  │                 ┌──────────────┐                   │     │
│  │                 │     HPA      │                   │     │
│  │                 │ (Auto-scale) │                   │     │
│  │                 └──────────────┘                   │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  Public IP    │
                    │  (Internet)   │
                    └───────────────┘
```

---

## 🛠️ Technologies Used

### **Application**
- HTML5, CSS3, JavaScript
- Nginx (Alpine-based web server)

### **Containerization**
- Docker
- Multi-stage builds
- Security hardening (non-root user, minimal image)

### **Orchestration**
- Kubernetes
- Horizontal Pod Autoscaler (HPA)
- ConfigMaps & Secrets

### **CI/CD**
- GitHub Actions
- Automated testing & security scanning
- Trivy vulnerability scanner

### **Cloud Platform**
- Azure Kubernetes Service (AKS)
- Azure Container Registry (or GHCR)
- Azure Load Balancer

---

## ✅ Prerequisites

Before you begin, ensure you have:

- [ ] **Docker Desktop** installed ([Download](https://www.docker.com/products/docker-desktop))
- [ ] **Azure CLI** installed ([Install Guide](https://docs.microsoft.com/cli/azure/install-azure-cli))
- [ ] **kubectl** installed ([Install Guide](https://kubernetes.io/docs/tasks/tools/))
- [ ] **Git** installed ([Download](https://git-scm.com/downloads))
- [ ] **GitHub account** ([Sign up](https://github.com/join))
- [ ] **Azure account** with free credits ([Sign up](https://azure.microsoft.com/free/))

### Verify Installation

```powershell
docker --version
az --version
kubectl version --client
git --version
```

---

## 🚀 Quick Start

See **[QUICKSTART.md](./QUICKSTART.md)** for detailed step-by-step instructions.

### Option 1: Local Docker (5 minutes)

```powershell
cd project
docker build -t az900-portal:v1.0 .
docker run -d -p 8080:8080 az900-portal:v1.0
start http://localhost:8080
```

### Option 2: Azure AKS with CI/CD (20 minutes)

1. **Fork this repository**
2. **Set up Azure resources** (see QUICKSTART.md)
3. **Configure GitHub secrets**
4. **Push to trigger deployment**

---

## 📦 Deployment Options

### 1️⃣ **Local Development**
- Run with Docker locally
- Test with local Kubernetes (Docker Desktop)

### 2️⃣ **Manual Deployment to AKS**
- Build and push image manually
- Deploy using kubectl

### 3️⃣ **Automated CI/CD** (Recommended)
- Push to GitHub
- Automated build, scan, and deployment
- Zero-downtime rolling updates

---

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/ci-cd.yml`) includes:

### **Build Stage**
1. Checkout code
2. Build Docker image
3. Push to GitHub Container Registry
4. Generate SBOM (Software Bill of Materials)

### **Security Stage**
5. Run Trivy vulnerability scan
6. Upload results to GitHub Security

### **Deploy Stage**
7. Login to Azure
8. Configure kubectl
9. Create namespace & secrets
10. Deploy to AKS
11. Verify deployment
12. Get public IP

### **Rollback Stage**
13. Automatic rollback on failure

---

## ☸️ Kubernetes Configuration

### **Deployment** (`k8s/deployment.yaml`)
- **Replicas**: 2 (minimum)
- **Strategy**: RollingUpdate (zero-downtime)
- **Health Checks**: Liveness & Readiness probes
- **Security**: Non-root user, dropped capabilities
- **Resources**: CPU/Memory limits

### **Service** (`k8s/service.yaml`)
- **Type**: LoadBalancer
- **Port**: 80 (external) → 8080 (container)
- **Session Affinity**: ClientIP

### **HPA** (`k8s/hpa.yaml`)
- **Min Replicas**: 2
- **Max Replicas**: 5
- **Metrics**: CPU (70%) & Memory (80%)

### **ConfigMap** (`k8s/configmap.yaml`)
- Application configuration
- Feature flags

---

## 📊 Monitoring & Scaling

### **Auto-Scaling**

The HPA automatically scales based on:
- **CPU Usage**: Scales up when > 70%
- **Memory Usage**: Scales up when > 80%

```powershell
# View HPA status
kubectl get hpa -n production

# View scaling events
kubectl describe hpa az900-portal-hpa -n production
```

### **Health Monitoring**

```powershell
# Check pod health
kubectl get pods -n production

# View pod logs
kubectl logs <pod-name> -n production

# Check health endpoint
curl http://<EXTERNAL-IP>/health
```

---

## 🐛 Troubleshooting

### **Docker Build Fails**

```powershell
# Check Docker is running
docker version

# Build with verbose output
docker build -t test . --progress=plain --no-cache
```

### **Pods Not Starting**

```powershell
# Describe pod
kubectl describe pod <pod-name> -n production

# Check logs
kubectl logs <pod-name> -n production

# Common issue: Image pull secret
kubectl get secrets -n production
```

### **No External IP**

```powershell
# Wait for IP assignment (can take 2-5 minutes)
kubectl get svc az900-portal-service -n production --watch

# Check service events
kubectl describe svc az900-portal-service -n production
```

### **GitHub Actions Fails**

1. Verify secrets are set: `GitHub → Settings → Secrets`
2. Check workflow logs: `GitHub → Actions`
3. Ensure Azure credentials are valid

---

## 💰 Cost Optimization

### **Azure Free Tier**
- New accounts get **$200 credit** for 30 days
- Free services for 12 months

### **Recommended Configuration**
- **AKS**: 1 node, Standard_B2s ($30-40/month)
- **Load Balancer**: Basic SKU (free)
- **Storage**: Minimal

### **Cost-Saving Tips**
1. **Delete resources when not in use**:
   ```powershell
   az group delete --name devops-learning-rg --yes
   ```

2. **Use spot instances** for non-production

3. **Set resource limits** in Kubernetes

4. **Monitor usage**:
   ```powershell
   az consumption usage list --output table
   ```

---

## 🧹 Cleanup

### **Delete Kubernetes Resources**

```powershell
kubectl delete namespace production
```

### **Delete Azure Resources**

```powershell
az group delete --name devops-learning-rg --yes --no-wait
```

### **Delete Local Docker Resources**

```powershell
docker stop az900-portal
docker rm az900-portal
docker rmi az900-portal:v1.0
```

---

## 📚 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [AZ-900 Certification](https://docs.microsoft.com/learn/certifications/azure-fundamentals/)

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

This project is licensed under the MIT License.

---

## 🎓 Project Structure

```
project/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # CI/CD pipeline
├── k8s/
│   ├── deployment.yaml        # Kubernetes deployment
│   ├── service.yaml           # LoadBalancer service
│   ├── configmap.yaml         # Configuration
│   └── hpa.yaml               # Auto-scaling
├── project/
│   ├── Dockerfile             # Container definition
│   ├── nginx.conf             # Nginx configuration
│   ├── .dockerignore          # Docker ignore rules
│   ├── index.html             # Main application
│   ├── login.html             # Login page
│   └── exams/                 # Exam content
├── QUICKSTART.md              # Quick start guide
└── README.md                  # This file
```

---

## 🎯 Key Features

✅ **Production-Ready**: Security hardening, health checks, resource limits  
✅ **Auto-Scaling**: HPA based on CPU/Memory  
✅ **Zero-Downtime**: Rolling updates  
✅ **Security**: Vulnerability scanning, non-root containers  
✅ **Monitoring**: Health endpoints, logging  
✅ **CI/CD**: Automated deployment pipeline  
✅ **Cost-Optimized**: Minimal resource usage  

---

## 🌟 Next Steps

1. **Add HTTPS**: Use cert-manager and Let's Encrypt
2. **Add Monitoring**: Prometheus + Grafana
3. **Add Database**: Deploy PostgreSQL
4. **Add Ingress**: Nginx Ingress Controller
5. **Multi-Environment**: Dev, Staging, Production

---

**🎉 Congratulations! You now have a production-ready DevOps project!**

**⭐ Star this repository if it helped you learn DevOps!**

---

## 📞 Support

For questions or issues:
- Open an issue on GitHub
- Check the [Troubleshooting](#troubleshooting) section
- Review the [QUICKSTART.md](./QUICKSTART.md) guide

---

**Made with ❤️ for DevOps learners**
