# 🚀 Quick Start Guide

This guide will help you deploy the project in **under 30 minutes**.

---

## 🎯 Prerequisites Checklist

Before starting, ensure you have:

- [ ] Docker Desktop installed and running
- [ ] Azure CLI installed (`az --version`)
- [ ] kubectl installed (`kubectl version --client`)
- [ ] Git installed (`git --version`)
- [ ] GitHub account created
- [ ] Azure Free Account created ($200 credits)

---

## 📦 Option 1: Local Deployment (5 minutes)

### Step 1: Build and Run with Docker

```powershell
# Navigate to project directory
cd C:\Users\Home\Downloads\project\project

# Build Docker image
docker build -t az900-portal:v1.0 .

# Run container
docker run -d --name az900-portal -p 8080:8080 az900-portal:v1.0

# Test
curl http://localhost:8080/health

# Open browser
start http://localhost:8080
```

### Step 2: Deploy to Local Kubernetes

```powershell
# Enable Kubernetes in Docker Desktop (Settings → Kubernetes → Enable)

# Create namespace
kubectl create namespace production

# Update k8s/deployment.yaml
# Replace IMAGE_PLACEHOLDER with: az900-portal:v1.0

# Deploy
kubectl apply -f k8s/ -n production

# Check status
kubectl get all -n production

# Port forward to access
kubectl port-forward svc/az900-portal-service 8080:80 -n production

# Open browser
start http://localhost:8080
```

---

## ☁️ Option 2: Azure AKS Deployment (20 minutes)

### Step 1: Setup GitHub Repository

```powershell
# Navigate to project root
cd C:\Users\Home\Downloads\project

# Initialize git (if not already)
git init
git add .
git commit -m "Initial commit: DevOps project"

# Create repository on GitHub (via web interface)
# Then push
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

### Step 2: Setup Azure

```powershell
# Login to Azure
az login

# Create resource group
az group create --name devops-learning-rg --location eastus

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

# Get credentials
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Verify connection
kubectl get nodes
```

### Step 3: Setup GitHub Secrets

```powershell
# Get subscription ID
az account show --query id -o tsv

# Create service principal for GitHub Actions
az ad sp create-for-rbac `
  --name "github-actions-sp" `
  --role contributor `
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/devops-learning-rg `
  --sdk-auth

# Copy the JSON output
```

**Add to GitHub Secrets**:
1. Go to: `GitHub Repo → Settings → Secrets and variables → Actions`
2. Click "New repository secret"
3. Name: `AZURE_CREDENTIALS`
4. Value: Paste the JSON output from above
5. Click "Add secret"

### Step 4: Setup GitHub Container Registry

```powershell
# Create Personal Access Token (PAT)
# Go to: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
# Click "Generate new token (classic)"
# Scopes: read:packages, write:packages, delete:packages
# Copy the token
```

**Add to GitHub Secrets**:
1. Name: `GHCR_TOKEN`
2. Value: Paste your PAT

### Step 5: Update GitHub Actions Workflow

Edit `.github/workflows/ci-cd.yml`:
- Replace `YOUR_USERNAME` with your GitHub username
- Replace `YOUR_REPO` with your repository name

### Step 6: Deploy via GitHub Actions

```powershell
# Make a change to trigger the pipeline
git add .
git commit -m "Trigger CI/CD pipeline"
git push

# Monitor pipeline
# Go to: GitHub → Actions tab
# Watch the workflow run
```

### Step 7: Get Public IP

```powershell
# Wait for deployment to complete (check GitHub Actions)

# Get external IP
kubectl get svc az900-portal-service -n production

# Wait for EXTERNAL-IP (not <pending>)
# This may take 2-5 minutes

# Once you have the IP, open browser
start http://<EXTERNAL-IP>
```

---

## 🧪 Option 3: Manual Deployment to AKS (15 minutes)

If you want to skip GitHub Actions:

### Step 1: Build and Push to GHCR

```powershell
# Login to GHCR
$env:GITHUB_TOKEN = "your_github_pat"
echo $env:GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Build image
cd C:\Users\Home\Downloads\project\project
docker build -t ghcr.io/YOUR_USERNAME/az900-portal:v1.0 .

# Push image
docker push ghcr.io/YOUR_USERNAME/az900-portal:v1.0
```

### Step 2: Deploy to AKS

```powershell
# Connect to AKS (if not already)
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Create namespace
kubectl create namespace production

# Create image pull secret
kubectl create secret docker-registry ghcr-secret `
  --docker-server=ghcr.io `
  --docker-username=YOUR_USERNAME `
  --docker-password=$env:GITHUB_TOKEN `
  --namespace=production

# Update k8s/deployment.yaml
# Replace IMAGE_PLACEHOLDER with: ghcr.io/YOUR_USERNAME/az900-portal:v1.0

# Deploy
cd C:\Users\Home\Downloads\project
kubectl apply -f k8s/ -n production

# Check status
kubectl get all -n production

# Get external IP
kubectl get svc az900-portal-service -n production --watch
```

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] Pods are running: `kubectl get pods -n production`
- [ ] Service has external IP: `kubectl get svc -n production`
- [ ] Health check works: `curl http://<EXTERNAL-IP>/health`
- [ ] Application loads: Open `http://<EXTERNAL-IP>` in browser
- [ ] HPA is active: `kubectl get hpa -n production`

---

## 🧹 Cleanup (IMPORTANT!)

### Delete Kubernetes Resources

```powershell
kubectl delete namespace production
```

### Delete Azure Resources

```powershell
# Delete entire resource group
az group delete --name devops-learning-rg --yes --no-wait

# Verify deletion
az group list --output table
```

### Delete Local Docker Resources

```powershell
docker stop az900-portal
docker rm az900-portal
docker rmi az900-portal:v1.0
```

---

## 🐛 Troubleshooting

### Issue: Docker build fails

```powershell
# Check Docker is running
docker version

# Check Dockerfile syntax
docker build -t test . --no-cache
```

### Issue: Pods not starting

```powershell
# Check pod status
kubectl get pods -n production

# Describe pod
kubectl describe pod <pod-name> -n production

# Check logs
kubectl logs <pod-name> -n production

# Common fix: Image pull secret
kubectl get secrets -n production
```

### Issue: Service has no external IP

```powershell
# Check service
kubectl describe svc az900-portal-service -n production

# Check events
kubectl get events -n production --sort-by='.lastTimestamp'

# Wait longer (can take 5 minutes)
kubectl get svc -n production --watch
```

### Issue: GitHub Actions fails

```powershell
# Check secrets are set correctly
# GitHub → Settings → Secrets and variables → Actions

# Check workflow syntax
# .github/workflows/ci-cd.yml

# Re-run workflow
# GitHub → Actions → Select workflow → Re-run jobs
```

---

## 📚 Next Steps

1. **Add HTTPS**: Use cert-manager and Let's Encrypt
2. **Add Monitoring**: Prometheus + Grafana
3. **Add Database**: Deploy PostgreSQL
4. **Add Ingress**: Nginx Ingress Controller
5. **Multi-environment**: Dev, Staging, Production

---

## 🎓 Learning Resources

- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Azure AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [GitHub Actions Documentation](https://docs.github.com/actions)

---

**🎉 Congratulations! You've deployed a production-ready DevOps project!**

**⭐ Don't forget to star the repository if this helped you!**
