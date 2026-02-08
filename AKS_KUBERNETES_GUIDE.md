# 🎓 Azure Kubernetes Service (AKS) - Complete Guide

This guide explains **how to use AKS and Kubernetes** to manage your containerized application.

---

## 📋 Table of Contents

1. [Understanding Kubernetes Concepts](#understanding-kubernetes-concepts)
2. [AKS Architecture](#aks-architecture)
3. [Setting Up AKS](#setting-up-aks)
4. [Managing Containers with Kubernetes](#managing-containers-with-kubernetes)
5. [Scaling Applications](#scaling-applications)
6. [Monitoring & Logging](#monitoring--logging)
7. [Advanced Topics](#advanced-topics)
8. [Best Practices](#best-practices)

---

## 🧠 Understanding Kubernetes Concepts

### **What is Kubernetes?**

Kubernetes (K8s) is a container orchestration platform that automates:
- **Deployment**: Rolling out containerized applications
- **Scaling**: Adjusting the number of running containers
- **Management**: Self-healing, load balancing, service discovery
- **Updates**: Zero-downtime deployments

### **Key Kubernetes Components**

#### **1. Pod**
- Smallest deployable unit
- Contains one or more containers
- Shares network and storage

```powershell
# View pods
kubectl get pods -n production

# Describe a pod
kubectl describe pod <pod-name> -n production
```

#### **2. Deployment**
- Manages pod replicas
- Handles rolling updates
- Ensures desired state

```powershell
# View deployments
kubectl get deployments -n production

# Scale deployment
kubectl scale deployment az900-portal --replicas=3 -n production
```

#### **3. Service**
- Exposes pods to network traffic
- Load balances across pods
- Provides stable endpoint

```powershell
# View services
kubectl get services -n production

# Get external IP
kubectl get svc az900-portal-service -n production
```

#### **4. Namespace**
- Virtual cluster for resource isolation
- Separates environments (dev, staging, prod)

```powershell
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace production
```

#### **5. ConfigMap**
- Stores configuration data
- Decouples config from container images

```powershell
# View configmaps
kubectl get configmap -n production

# Describe configmap
kubectl describe configmap az900-portal-config -n production
```

#### **6. HPA (Horizontal Pod Autoscaler)**
- Automatically scales pods
- Based on CPU/Memory metrics

```powershell
# View HPA
kubectl get hpa -n production

# Describe HPA
kubectl describe hpa az900-portal-hpa -n production
```

---

## 🏗️ AKS Architecture

### **How AKS Works**

```
┌─────────────────────────────────────────────────────────────┐
│                    Azure Kubernetes Service                  │
│                                                              │
│  ┌────────────────────────────────────────────────────┐     │
│  │              Control Plane (Managed by Azure)      │     │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────┐  │     │
│  │  │ API Server   │  │  Scheduler   │  │  etcd   │  │     │
│  │  └──────────────┘  └──────────────┘  └─────────┘  │     │
│  └────────────────────────────────────────────────────┘     │
│                            │                                 │
│                            ▼                                 │
│  ┌────────────────────────────────────────────────────┐     │
│  │              Node Pool (Your VMs)                  │     │
│  │  ┌──────────────┐  ┌──────────────┐  ┌─────────┐  │     │
│  │  │   Node 1     │  │   Node 2     │  │  Node N │  │     │
│  │  │              │  │              │  │         │  │     │
│  │  │ ┌──────────┐ │  │ ┌──────────┐ │  │ ┌─────┐ │  │     │
│  │  │ │  Pod 1   │ │  │ │  Pod 2   │ │  │ │ Pod │ │  │     │
│  │  │ └──────────┘ │  │ └──────────┘ │  │ └─────┘ │  │     │
│  │  │ ┌──────────┐ │  │ ┌──────────┐ │  │         │  │     │
│  │  │ │  Pod 3   │ │  │ │  Pod 4   │ │  │         │  │     │
│  │  │ └──────────┘ │  │ └──────────┘ │  │         │  │     │
│  │  └──────────────┘  └──────────────┘  └─────────┘  │     │
│  └────────────────────────────────────────────────────┘     │
│                            │                                 │
│                            ▼                                 │
│  ┌────────────────────────────────────────────────────┐     │
│  │              Azure Load Balancer                   │     │
│  │              (Public IP: x.x.x.x)                  │     │
│  └────────────────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                      Internet Users
```

### **Components Breakdown**

1. **Control Plane** (Managed by Azure, free)
   - API Server: Handles all API requests
   - Scheduler: Assigns pods to nodes
   - etcd: Stores cluster state

2. **Node Pool** (You pay for VMs)
   - Virtual machines running your containers
   - Each node can run multiple pods

3. **Load Balancer** (Azure-managed)
   - Distributes traffic across pods
   - Provides public IP address

---

## 🚀 Setting Up AKS

### **Step 1: Create Resource Group**

```powershell
# Login to Azure
az login

# Create resource group
az group create `
  --name devops-learning-rg `
  --location eastus
```

### **Step 2: Create AKS Cluster**

```powershell
# Create AKS cluster (takes 5-10 minutes)
az aks create `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --node-count 1 `
  --node-vm-size Standard_B2s `
  --enable-managed-identity `
  --generate-ssh-keys `
  --network-plugin azure `
  --load-balancer-sku basic
```

**Parameters Explained:**
- `--node-count 1`: Start with 1 node (VM)
- `--node-vm-size Standard_B2s`: Small VM (2 vCPU, 4GB RAM)
- `--enable-managed-identity`: Use Azure-managed identity
- `--network-plugin azure`: Use Azure CNI networking
- `--load-balancer-sku basic`: Use basic load balancer (free)

### **Step 3: Connect to AKS**

```powershell
# Get credentials
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Verify connection
kubectl get nodes
```

---

## 🐳 Managing Containers with Kubernetes

### **Deploying Your Application**

#### **Method 1: Using kubectl**

```powershell
# Create namespace
kubectl create namespace production

# Apply all manifests
kubectl apply -f k8s/ -n production

# Verify deployment
kubectl get all -n production
```

#### **Method 2: Using CI/CD** (Recommended)

The GitHub Actions workflow automatically:
1. Builds Docker image
2. Pushes to container registry
3. Deploys to AKS
4. Verifies deployment

### **Viewing Your Application**

```powershell
# Get pods
kubectl get pods -n production

# Get services
kubectl get svc -n production

# Get external IP
kubectl get svc az900-portal-service -n production -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
```

### **Updating Your Application**

#### **Rolling Update (Zero Downtime)**

```powershell
# Update image
kubectl set image deployment/az900-portal `
  az900-portal=ghcr.io/username/repo:v2.0 `
  -n production

# Watch rollout
kubectl rollout status deployment/az900-portal -n production

# Check rollout history
kubectl rollout history deployment/az900-portal -n production
```

#### **Rollback**

```powershell
# Rollback to previous version
kubectl rollout undo deployment/az900-portal -n production

# Rollback to specific revision
kubectl rollout undo deployment/az900-portal --to-revision=2 -n production
```

---

## 📈 Scaling Applications

### **Manual Scaling**

```powershell
# Scale to 5 replicas
kubectl scale deployment az900-portal --replicas=5 -n production

# Verify
kubectl get pods -n production
```

### **Auto-Scaling with HPA**

The HPA automatically scales based on metrics:

```yaml
# k8s/hpa.yaml
minReplicas: 2
maxReplicas: 5
metrics:
  - CPU: 70%
  - Memory: 80%
```

**How it works:**
1. Metrics server collects CPU/Memory usage
2. HPA checks every 15 seconds
3. If usage > threshold, scales up
4. If usage < threshold, scales down (after 5 min)

```powershell
# View HPA status
kubectl get hpa -n production

# Watch HPA in real-time
kubectl get hpa -n production --watch

# Describe HPA
kubectl describe hpa az900-portal-hpa -n production
```

### **Load Testing**

```powershell
# Install Apache Bench (if not installed)
# Windows: Download from https://www.apachelounge.com/download/

# Run load test
ab -n 10000 -c 100 http://<EXTERNAL-IP>/

# Watch pods scale
kubectl get pods -n production --watch
```

---

## 📊 Monitoring & Logging

### **Pod Logs**

```powershell
# View logs
kubectl logs <pod-name> -n production

# Follow logs (real-time)
kubectl logs -f <pod-name> -n production

# Logs from all pods
kubectl logs -l app=az900-portal -n production

# Previous container logs (if crashed)
kubectl logs <pod-name> -n production --previous
```

### **Pod Status**

```powershell
# Get pod details
kubectl describe pod <pod-name> -n production

# Get pod events
kubectl get events -n production --sort-by='.lastTimestamp'

# Check resource usage
kubectl top pods -n production
kubectl top nodes
```

### **Health Checks**

```powershell
# Test health endpoint
curl http://<EXTERNAL-IP>/health

# Port-forward for local testing
kubectl port-forward svc/az900-portal-service 8080:80 -n production
curl http://localhost:8080/health
```

### **Azure Monitor (Optional)**

```powershell
# Enable Container Insights
az aks enable-addons `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --addons monitoring

# View in Azure Portal
# Navigate to: AKS → Insights → Containers
```

---

## 🔧 Advanced Topics

### **1. ConfigMaps & Secrets**

#### **ConfigMap** (Non-sensitive data)

```powershell
# View configmap
kubectl get configmap az900-portal-config -n production -o yaml

# Edit configmap
kubectl edit configmap az900-portal-config -n production

# Restart pods to apply changes
kubectl rollout restart deployment/az900-portal -n production
```

#### **Secrets** (Sensitive data)

```powershell
# Create secret
kubectl create secret generic my-secret `
  --from-literal=password=mypassword `
  -n production

# View secrets
kubectl get secrets -n production

# Describe secret (values are base64 encoded)
kubectl describe secret my-secret -n production
```

### **2. Persistent Storage**

```yaml
# Create PersistentVolumeClaim
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: managed-premium
```

```powershell
# Apply PVC
kubectl apply -f pvc.yaml -n production

# View PVCs
kubectl get pvc -n production
```

### **3. Ingress Controller**

For advanced routing and HTTPS:

```powershell
# Install Nginx Ingress Controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.1/deploy/static/provider/cloud/deploy.yaml

# Create Ingress resource
kubectl apply -f k8s/ingress.yaml -n production
```

### **4. Network Policies**

```yaml
# Restrict pod-to-pod communication
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend
spec:
  podSelector:
    matchLabels:
      app: az900-portal
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
```

---

## ✅ Best Practices

### **1. Resource Management**

```yaml
# Always set resource limits
resources:
  requests:
    memory: "64Mi"
    cpu: "100m"
  limits:
    memory: "128Mi"
    cpu: "200m"
```

### **2. Health Checks**

```yaml
# Liveness probe (restart if unhealthy)
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 10

# Readiness probe (remove from service if not ready)
readinessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```

### **3. Security**

```yaml
# Run as non-root user
securityContext:
  runAsNonRoot: true
  runAsUser: 1001
  allowPrivilegeEscalation: false
  capabilities:
    drop:
      - ALL
```

### **4. Labels & Annotations**

```yaml
# Use meaningful labels
metadata:
  labels:
    app: az900-portal
    version: v1
    environment: production
```

### **5. Rolling Updates**

```yaml
# Zero-downtime deployments
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 0
```

---

## 🎯 Common Commands Cheat Sheet

### **Cluster Management**

```powershell
# Get cluster info
kubectl cluster-info

# Get nodes
kubectl get nodes

# Describe node
kubectl describe node <node-name>
```

### **Deployment Management**

```powershell
# Get deployments
kubectl get deployments -n production

# Scale deployment
kubectl scale deployment az900-portal --replicas=3 -n production

# Update image
kubectl set image deployment/az900-portal az900-portal=new-image -n production

# Rollback
kubectl rollout undo deployment/az900-portal -n production
```

### **Pod Management**

```powershell
# Get pods
kubectl get pods -n production

# Describe pod
kubectl describe pod <pod-name> -n production

# Logs
kubectl logs <pod-name> -n production

# Execute command in pod
kubectl exec -it <pod-name> -n production -- /bin/sh

# Delete pod (will be recreated)
kubectl delete pod <pod-name> -n production
```

### **Service Management**

```powershell
# Get services
kubectl get svc -n production

# Describe service
kubectl describe svc az900-portal-service -n production

# Port forward
kubectl port-forward svc/az900-portal-service 8080:80 -n production
```

### **Debugging**

```powershell
# Get events
kubectl get events -n production --sort-by='.lastTimestamp'

# Resource usage
kubectl top pods -n production
kubectl top nodes

# Check HPA
kubectl get hpa -n production
kubectl describe hpa az900-portal-hpa -n production
```

---

## 🧹 Cleanup

### **Delete Application**

```powershell
# Delete namespace (deletes all resources)
kubectl delete namespace production
```

### **Delete AKS Cluster**

```powershell
# Delete entire resource group
az group delete --name devops-learning-rg --yes --no-wait
```

---

## 📚 Additional Resources

- [Kubernetes Official Docs](https://kubernetes.io/docs/)
- [AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)

---

**🎉 You now understand how to use AKS and Kubernetes to manage containers!**
