# 🚀 DevOps Commands Cheat Sheet

Quick reference for all commands used in this project.

---

## 📦 Docker Commands

### Build & Run

```powershell
# Build image
docker build -t az900-portal:v1.0 .

# Run container
docker run -d --name az900-portal -p 8080:8080 az900-portal:v1.0

# Run with environment variables
docker run -d --name az900-portal -p 8080:8080 -e NODE_ENV=production az900-portal:v1.0

# Run in interactive mode
docker run -it --rm az900-portal:v1.0 /bin/sh
```

### Manage Containers

```powershell
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# View logs
docker logs az900-portal
docker logs -f az900-portal  # Follow logs

# Execute command in container
docker exec -it az900-portal /bin/sh

# Stop container
docker stop az900-portal

# Start container
docker start az900-portal

# Restart container
docker restart az900-portal

# Remove container
docker rm az900-portal
docker rm -f az900-portal  # Force remove
```

### Manage Images

```powershell
# List images
docker images

# Remove image
docker rmi az900-portal:v1.0

# Remove unused images
docker image prune

# Remove all unused resources
docker system prune -a
```

### Inspect & Debug

```powershell
# Inspect container
docker inspect az900-portal

# View container stats
docker stats az900-portal

# View container processes
docker top az900-portal

# Check container health
docker inspect --format='{{.State.Health.Status}}' az900-portal
```

### Docker Registry (GHCR)

```powershell
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag image
docker tag az900-portal:v1.0 ghcr.io/USERNAME/az900-portal:v1.0

# Push image
docker push ghcr.io/USERNAME/az900-portal:v1.0

# Pull image
docker pull ghcr.io/USERNAME/az900-portal:v1.0
```

---

## ☸️ Kubernetes Commands

### Cluster Management

```powershell
# View cluster info
kubectl cluster-info

# View nodes
kubectl get nodes
kubectl describe node <node-name>

# View cluster resources
kubectl get all --all-namespaces
```

### Namespace Management

```powershell
# Create namespace
kubectl create namespace production

# List namespaces
kubectl get namespaces

# Delete namespace
kubectl delete namespace production

# Set default namespace
kubectl config set-context --current --namespace=production
```

### Deployment Management

```powershell
# Apply manifests
kubectl apply -f k8s/
kubectl apply -f k8s/deployment.yaml -n production

# Get deployments
kubectl get deployments -n production
kubectl get deploy -n production  # Short form

# Describe deployment
kubectl describe deployment az900-portal -n production

# Edit deployment
kubectl edit deployment az900-portal -n production

# Scale deployment
kubectl scale deployment az900-portal --replicas=3 -n production

# Rollout status
kubectl rollout status deployment/az900-portal -n production

# Rollout history
kubectl rollout history deployment/az900-portal -n production

# Rollback deployment
kubectl rollout undo deployment/az900-portal -n production

# Delete deployment
kubectl delete deployment az900-portal -n production
```

### Pod Management

```powershell
# Get pods
kubectl get pods -n production
kubectl get pods -n production -o wide  # More details
kubectl get pods -n production --watch  # Watch changes

# Describe pod
kubectl describe pod <pod-name> -n production

# View logs
kubectl logs <pod-name> -n production
kubectl logs -f <pod-name> -n production  # Follow logs
kubectl logs <pod-name> -c <container-name> -n production  # Specific container

# Execute command in pod
kubectl exec -it <pod-name> -n production -- /bin/sh
kubectl exec <pod-name> -n production -- ls /usr/share/nginx/html

# Port forward
kubectl port-forward <pod-name> 8080:8080 -n production
kubectl port-forward svc/az900-portal-service 8080:80 -n production

# Delete pod
kubectl delete pod <pod-name> -n production
```

### Service Management

```powershell
# Get services
kubectl get services -n production
kubectl get svc -n production  # Short form

# Describe service
kubectl describe service az900-portal-service -n production

# Get external IP
kubectl get svc az900-portal-service -n production -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Delete service
kubectl delete service az900-portal-service -n production
```

### ConfigMap & Secrets

```powershell
# Get ConfigMaps
kubectl get configmaps -n production
kubectl get cm -n production  # Short form

# Describe ConfigMap
kubectl describe configmap az900-portal-config -n production

# Create ConfigMap from file
kubectl create configmap app-config --from-file=config.json -n production

# Get Secrets
kubectl get secrets -n production

# Create Secret
kubectl create secret generic app-secret --from-literal=password=mypassword -n production

# Create Docker registry secret
kubectl create secret docker-registry ghcr-secret `
  --docker-server=ghcr.io `
  --docker-username=USERNAME `
  --docker-password=TOKEN `
  --namespace=production
```

### Horizontal Pod Autoscaler

```powershell
# Get HPA
kubectl get hpa -n production

# Describe HPA
kubectl describe hpa az900-portal-hpa -n production

# Watch HPA
kubectl get hpa -n production --watch

# Delete HPA
kubectl delete hpa az900-portal-hpa -n production
```

### Resource Monitoring

```powershell
# View node resources
kubectl top nodes

# View pod resources
kubectl top pods -n production

# View specific pod resources
kubectl top pod <pod-name> -n production
```

### Events & Troubleshooting

```powershell
# View events
kubectl get events -n production
kubectl get events -n production --sort-by='.lastTimestamp'

# View all resources
kubectl get all -n production

# Describe all resources
kubectl describe all -n production

# Debug pod
kubectl debug <pod-name> -n production -it --image=busybox
```

### YAML Management

```powershell
# Dry run (test without applying)
kubectl apply -f k8s/deployment.yaml --dry-run=client -n production

# Generate YAML
kubectl create deployment test --image=nginx --dry-run=client -o yaml > deployment.yaml

# Validate YAML
kubectl apply -f k8s/deployment.yaml --dry-run=server -n production

# Diff changes
kubectl diff -f k8s/deployment.yaml -n production
```

### Cleanup

```powershell
# Delete all resources in namespace
kubectl delete all --all -n production

# Delete specific resources
kubectl delete -f k8s/ -n production

# Force delete pod
kubectl delete pod <pod-name> -n production --grace-period=0 --force
```

---

## ☁️ Azure CLI Commands

### Authentication

```powershell
# Login to Azure
az login

# Login with service principal
az login --service-principal -u <app-id> -p <password> --tenant <tenant-id>

# List accounts
az account list --output table

# Set subscription
az account set --subscription "<subscription-id>"

# Show current subscription
az account show
```

### Resource Group Management

```powershell
# Create resource group
az group create --name devops-learning-rg --location eastus

# List resource groups
az group list --output table

# Show resource group
az group show --name devops-learning-rg

# Delete resource group
az group delete --name devops-learning-rg --yes --no-wait

# Check deletion status
az group exists --name devops-learning-rg
```

### AKS Cluster Management

```powershell
# Create AKS cluster (minimal)
az aks create `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --node-count 1 `
  --node-vm-size Standard_B2s `
  --enable-managed-identity `
  --generate-ssh-keys `
  --network-plugin azure `
  --load-balancer-sku basic

# List AKS clusters
az aks list --output table

# Show AKS cluster
az aks show --resource-group devops-learning-rg --name devops-learning-aks

# Get AKS credentials
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Get AKS credentials (overwrite)
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --overwrite-existing

# Scale AKS cluster
az aks scale `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --node-count 2

# Upgrade AKS cluster
az aks upgrade `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --kubernetes-version 1.28.5

# Stop AKS cluster (save costs)
az aks stop `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Start AKS cluster
az aks start `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Delete AKS cluster
az aks delete `
  --resource-group devops-learning-rg `
  --name devops-learning-aks `
  --yes `
  --no-wait
```

### Service Principal Management

```powershell
# Create service principal for GitHub Actions
az ad sp create-for-rbac `
  --name "github-actions-sp" `
  --role contributor `
  --scopes /subscriptions/<subscription-id>/resourceGroups/devops-learning-rg `
  --sdk-auth

# List service principals
az ad sp list --display-name "github-actions-sp"

# Delete service principal
az ad sp delete --id <app-id>
```

### Cost Management

```powershell
# Show cost analysis
az consumption usage list --output table

# Show budget
az consumption budget list --output table

# Create budget alert
az consumption budget create `
  --budget-name "monthly-budget" `
  --amount 50 `
  --time-grain Monthly `
  --start-date 2024-01-01 `
  --end-date 2024-12-31
```

---

## 🔧 Git Commands

### Basic Operations

```powershell
# Initialize repository
git init

# Clone repository
git clone https://github.com/USERNAME/REPO.git

# Check status
git status

# Add files
git add .
git add file.txt

# Commit changes
git commit -m "Commit message"

# Push changes
git push origin main

# Pull changes
git pull origin main
```

### Branch Management

```powershell
# Create branch
git branch feature-branch

# Switch branch
git checkout feature-branch
git switch feature-branch  # New syntax

# Create and switch
git checkout -b feature-branch

# List branches
git branch
git branch -a  # Include remote

# Delete branch
git branch -d feature-branch
git branch -D feature-branch  # Force delete

# Merge branch
git checkout main
git merge feature-branch
```

### Remote Management

```powershell
# Add remote
git remote add origin https://github.com/USERNAME/REPO.git

# List remotes
git remote -v

# Remove remote
git remote remove origin

# Change remote URL
git remote set-url origin https://github.com/USERNAME/NEW-REPO.git
```

### History & Logs

```powershell
# View commit history
git log
git log --oneline
git log --graph --oneline --all

# View changes
git diff
git diff file.txt

# View file history
git log --follow file.txt
```

---

## 🧪 Testing Commands

### Health Check

```powershell
# Test health endpoint
curl http://localhost:8080/health
curl http://<EXTERNAL-IP>/health

# Test application
curl http://localhost:8080
curl http://<EXTERNAL-IP>
```

### Load Testing

```powershell
# Using Apache Bench
ab -n 1000 -c 10 http://localhost:8080/

# Using curl (simple loop)
for ($i=1; $i -le 100; $i++) { curl http://localhost:8080/ }
```

---

## 📊 Monitoring Commands

### Docker Monitoring

```powershell
# Container stats
docker stats

# System info
docker system df
docker system info
```

### Kubernetes Monitoring

```powershell
# Resource usage
kubectl top nodes
kubectl top pods -n production

# Events
kubectl get events -n production --watch

# Logs
kubectl logs -f deployment/az900-portal -n production
```

---

## 🛠️ Troubleshooting Commands

### Docker Troubleshooting

```powershell
# Check Docker daemon
docker version
docker info

# View container logs
docker logs <container-name>

# Inspect container
docker inspect <container-name>

# Check network
docker network ls
docker network inspect bridge
```

### Kubernetes Troubleshooting

```powershell
# Check pod status
kubectl get pods -n production
kubectl describe pod <pod-name> -n production

# Check events
kubectl get events -n production --sort-by='.lastTimestamp'

# Check logs
kubectl logs <pod-name> -n production
kubectl logs <pod-name> -n production --previous  # Previous container

# Check service endpoints
kubectl get endpoints -n production

# Check DNS
kubectl run -it --rm debug --image=busybox --restart=Never -- nslookup az900-portal-service.production.svc.cluster.local
```

### Azure Troubleshooting

```powershell
# Check AKS status
az aks show --resource-group devops-learning-rg --name devops-learning-aks --query "powerState"

# View AKS logs
az aks get-credentials --resource-group devops-learning-rg --name devops-learning-aks
kubectl get events --all-namespaces

# Check node status
kubectl get nodes
kubectl describe node <node-name>
```

---

## 📝 Quick Workflows

### Complete Local Deployment

```powershell
# 1. Build image
docker build -t az900-portal:v1.0 ./project

# 2. Run locally
docker run -d --name az900-portal -p 8080:8080 az900-portal:v1.0

# 3. Test
curl http://localhost:8080/health

# 4. Deploy to Kubernetes
kubectl create namespace production
kubectl apply -f k8s/ -n production

# 5. Verify
kubectl get all -n production
```

### Complete Azure Deployment

```powershell
# 1. Login to Azure
az login

# 2. Create resources
az group create --name devops-learning-rg --location eastus
az aks create --resource-group devops-learning-rg --name devops-learning-aks --node-count 1 --node-vm-size Standard_B2s --generate-ssh-keys

# 3. Connect to AKS
az aks get-credentials --resource-group devops-learning-rg --name devops-learning-aks

# 4. Deploy application
kubectl create namespace production
kubectl create secret docker-registry ghcr-secret --docker-server=ghcr.io --docker-username=USERNAME --docker-password=TOKEN --namespace=production
kubectl apply -f k8s/ -n production

# 5. Get public IP
kubectl get svc az900-portal-service -n production
```

### Complete Cleanup

```powershell
# 1. Delete Kubernetes resources
kubectl delete namespace production

# 2. Delete Azure resources
az group delete --name devops-learning-rg --yes --no-wait

# 3. Delete local Docker resources
docker stop az900-portal
docker rm az900-portal
docker rmi az900-portal:v1.0
```

---

## 🔗 Useful Aliases (PowerShell)

Add to your PowerShell profile (`$PROFILE`):

```powershell
# Kubernetes aliases
function k { kubectl $args }
function kgp { kubectl get pods $args }
function kgs { kubectl get svc $args }
function kgd { kubectl get deployments $args }
function kl { kubectl logs $args }
function kd { kubectl describe $args }
function ka { kubectl apply -f $args }
function kdel { kubectl delete $args }

# Docker aliases
function d { docker $args }
function dps { docker ps $args }
function di { docker images $args }
function dl { docker logs $args }
function de { docker exec $args }

# Azure aliases
function azl { az login }
function azg { az group $args }
function azk { az aks $args }
```

---

**💡 Tip**: Bookmark this file for quick reference during development and interviews!
