# 🌐 Hosting & Deployment Guide

This guide covers **how to host your application** using different methods and platforms.

---

## 📋 Table of Contents

1. [Hosting Options Overview](#hosting-options-overview)
2. [Option 1: Azure Kubernetes Service (AKS)](#option-1-azure-kubernetes-service-aks)
3. [Option 2: Azure Container Instances (ACI)](#option-2-azure-container-instances-aci)
4. [Option 3: Azure App Service](#option-3-azure-app-service)
5. [Option 4: Azure Static Web Apps](#option-4-azure-static-web-apps)
6. [Comparison Table](#comparison-table)
7. [Cost Analysis](#cost-analysis)
8. [Production Checklist](#production-checklist)

---

## 🎯 Hosting Options Overview

### **What We're Hosting**

- **Type**: Static web application (HTML, CSS, JavaScript)
- **Server**: Nginx
- **Container**: Docker image
- **Requirements**: Public internet access

### **Available Azure Hosting Options**

1. **Azure Kubernetes Service (AKS)** - Full container orchestration
2. **Azure Container Instances (ACI)** - Simple container hosting
3. **Azure App Service** - Managed web app platform
4. **Azure Static Web Apps** - Optimized for static content

---

## 🚀 Option 1: Azure Kubernetes Service (AKS)

### **When to Use**
✅ Production applications requiring high availability  
✅ Need auto-scaling and load balancing  
✅ Multiple microservices  
✅ Learning Kubernetes and DevOps  

### **Architecture**

```
GitHub → CI/CD → Container Registry → AKS Cluster → Load Balancer → Internet
```

### **Setup Steps**

#### **1. Create AKS Cluster**

```powershell
# Create resource group
az group create --name devops-learning-rg --location eastus

# Create AKS cluster
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

#### **2. Connect to Cluster**

```powershell
# Get credentials
az aks get-credentials `
  --resource-group devops-learning-rg `
  --name devops-learning-aks

# Verify
kubectl get nodes
```

#### **3. Deploy Application**

```powershell
# Create namespace
kubectl create namespace production

# Deploy
kubectl apply -f k8s/ -n production

# Get external IP
kubectl get svc az900-portal-service -n production
```

### **Pros & Cons**

**Pros:**
- ✅ Auto-scaling (HPA)
- ✅ Self-healing
- ✅ Zero-downtime deployments
- ✅ Load balancing
- ✅ Industry-standard platform

**Cons:**
- ❌ Higher cost (~$30-40/month)
- ❌ More complex setup
- ❌ Requires Kubernetes knowledge

### **Cost**
- **Node (VM)**: ~$30-40/month (Standard_B2s)
- **Load Balancer**: Free (Basic SKU)
- **Total**: ~$30-40/month

---

## 📦 Option 2: Azure Container Instances (ACI)

### **When to Use**
✅ Simple containerized apps  
✅ Development/testing  
✅ Batch jobs  
✅ Quick deployments  

### **Architecture**

```
GitHub → CI/CD → Container Registry → ACI → Public IP → Internet
```

### **Setup Steps**

#### **1. Create Container Instance**

```powershell
# Login to Azure
az login

# Create resource group
az group create --name devops-learning-rg --location eastus

# Create container instance
az container create `
  --resource-group devops-learning-rg `
  --name az900-portal-aci `
  --image ghcr.io/YOUR_USERNAME/YOUR_REPO:latest `
  --dns-name-label az900-portal-unique `
  --ports 8080 `
  --cpu 1 `
  --memory 1 `
  --registry-login-server ghcr.io `
  --registry-username YOUR_USERNAME `
  --registry-password YOUR_GITHUB_TOKEN
```

#### **2. Get Public URL**

```powershell
# Get FQDN
az container show `
  --resource-group devops-learning-rg `
  --name az900-portal-aci `
  --query ipAddress.fqdn `
  --output tsv

# Access: http://az900-portal-unique.eastus.azurecontainer.io:8080
```

#### **3. View Logs**

```powershell
# View logs
az container logs `
  --resource-group devops-learning-rg `
  --name az900-portal-aci

# Attach to container
az container attach `
  --resource-group devops-learning-rg `
  --name az900-portal-aci
```

### **Pros & Cons**

**Pros:**
- ✅ Simple setup
- ✅ Pay-per-second billing
- ✅ Fast startup
- ✅ No cluster management

**Cons:**
- ❌ No auto-scaling
- ❌ No load balancing
- ❌ Single container (no orchestration)
- ❌ Less suitable for production

### **Cost**
- **vCPU**: $0.0000125/second (~$32/month for 1 vCPU)
- **Memory**: $0.0000014/GB/second (~$3/month for 1GB)
- **Total**: ~$35/month (running 24/7)

---

## 🌐 Option 3: Azure App Service

### **When to Use**
✅ Web applications without containers  
✅ Need managed platform  
✅ Built-in CI/CD  
✅ Don't want to manage infrastructure  

### **Architecture**

```
GitHub → Azure App Service → Internet
```

### **Setup Steps**

#### **1. Create App Service Plan**

```powershell
# Create App Service plan
az appservice plan create `
  --name devops-learning-plan `
  --resource-group devops-learning-rg `
  --sku B1 `
  --is-linux
```

#### **2. Create Web App**

```powershell
# Create web app with container
az webapp create `
  --resource-group devops-learning-rg `
  --plan devops-learning-plan `
  --name az900-portal-webapp `
  --deployment-container-image-name ghcr.io/YOUR_USERNAME/YOUR_REPO:latest
```

#### **3. Configure Container Registry**

```powershell
# Set registry credentials
az webapp config container set `
  --name az900-portal-webapp `
  --resource-group devops-learning-rg `
  --docker-custom-image-name ghcr.io/YOUR_USERNAME/YOUR_REPO:latest `
  --docker-registry-server-url https://ghcr.io `
  --docker-registry-server-user YOUR_USERNAME `
  --docker-registry-server-password YOUR_GITHUB_TOKEN
```

#### **4. Access Application**

```powershell
# Get URL
az webapp show `
  --name az900-portal-webapp `
  --resource-group devops-learning-rg `
  --query defaultHostName `
  --output tsv

# Access: https://az900-portal-webapp.azurewebsites.net
```

### **Pros & Cons**

**Pros:**
- ✅ Fully managed
- ✅ Built-in SSL/HTTPS
- ✅ Easy scaling
- ✅ Integrated monitoring

**Cons:**
- ❌ Less control
- ❌ Vendor lock-in
- ❌ Higher cost for advanced features

### **Cost**
- **B1 Plan**: ~$13/month
- **S1 Plan**: ~$70/month (production)
- **Total**: ~$13-70/month

---

## ⚡ Option 4: Azure Static Web Apps

### **When to Use**
✅ Static websites (no backend)  
✅ Lowest cost  
✅ Global CDN  
✅ Automatic HTTPS  

### **Architecture**

```
GitHub → Azure Static Web Apps → Global CDN → Internet
```

### **Setup Steps**

#### **1. Remove Docker (Not Needed)**

Since this is a static site, we can deploy HTML directly:

```powershell
# Create static web app
az staticwebapp create `
  --name az900-portal-static `
  --resource-group devops-learning-rg `
  --source https://github.com/YOUR_USERNAME/YOUR_REPO `
  --location eastus2 `
  --branch main `
  --app-location "/project" `
  --login-with-github
```

#### **2. Configure GitHub Actions**

Azure automatically creates a GitHub Actions workflow:

```yaml
# .github/workflows/azure-static-web-apps.yml
name: Azure Static Web Apps CI/CD

on:
  push:
    branches:
      - main

jobs:
  build_and_deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build And Deploy
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "/project"
```

#### **3. Access Application**

```powershell
# Get URL
az staticwebapp show `
  --name az900-portal-static `
  --resource-group devops-learning-rg `
  --query defaultHostname `
  --output tsv

# Access: https://az900-portal-static.azurestaticapps.net
```

### **Pros & Cons**

**Pros:**
- ✅ **FREE tier available**
- ✅ Global CDN
- ✅ Automatic HTTPS
- ✅ Custom domains
- ✅ Serverless APIs (optional)

**Cons:**
- ❌ Static content only
- ❌ No server-side processing
- ❌ Limited customization

### **Cost**
- **Free Tier**: $0/month (100GB bandwidth, 2 custom domains)
- **Standard Tier**: $9/month (unlimited bandwidth)
- **Total**: **FREE** or $9/month

---

## 📊 Comparison Table

| Feature | AKS | ACI | App Service | Static Web Apps |
|---------|-----|-----|-------------|-----------------|
| **Cost/Month** | $30-40 | $35 | $13-70 | **FREE**-$9 |
| **Setup Complexity** | High | Low | Medium | Very Low |
| **Auto-Scaling** | ✅ Yes | ❌ No | ✅ Yes | ✅ Yes (CDN) |
| **Load Balancing** | ✅ Yes | ❌ No | ✅ Yes | ✅ Yes (CDN) |
| **Container Support** | ✅ Yes | ✅ Yes | ✅ Yes | ❌ No |
| **HTTPS** | Manual | Manual | ✅ Built-in | ✅ Built-in |
| **Custom Domain** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| **Best For** | Production | Dev/Test | Web Apps | Static Sites |

---

## 💰 Cost Analysis

### **Monthly Cost Breakdown**

#### **AKS (Recommended for Learning)**
```
Node (Standard_B2s): $30-40
Load Balancer (Basic): $0
Total: $30-40/month
```

#### **ACI**
```
1 vCPU: $32
1GB Memory: $3
Total: $35/month
```

#### **App Service**
```
B1 Plan: $13
S1 Plan: $70
Total: $13-70/month
```

#### **Static Web Apps (Best Value)**
```
Free Tier: $0
Standard Tier: $9
Total: FREE or $9/month
```

### **Cost-Saving Tips**

1. **Use Free Tier First**
   - Static Web Apps has a generous free tier
   - Azure gives $200 credit for new accounts

2. **Stop Resources When Not in Use**
   ```powershell
   # Stop AKS cluster
   az aks stop --name devops-learning-aks --resource-group devops-learning-rg
   
   # Start AKS cluster
   az aks start --name devops-learning-aks --resource-group devops-learning-rg
   ```

3. **Use Spot Instances** (for non-production)
   ```powershell
   az aks create --enable-cluster-autoscaler --priority Spot
   ```

4. **Delete Resources After Learning**
   ```powershell
   az group delete --name devops-learning-rg --yes
   ```

---

## ✅ Production Checklist

### **Before Going Live**

- [ ] **Domain Name**: Register custom domain
- [ ] **HTTPS**: Enable SSL/TLS certificates
- [ ] **Monitoring**: Set up Azure Monitor
- [ ] **Backup**: Configure backup strategy
- [ ] **Security**: Enable firewall rules
- [ ] **Scaling**: Configure auto-scaling
- [ ] **Logging**: Enable application logs
- [ ] **Alerts**: Set up monitoring alerts
- [ ] **Cost Alerts**: Configure budget alerts
- [ ] **Documentation**: Update deployment docs

### **Security Checklist**

- [ ] Use managed identities (no passwords)
- [ ] Enable network policies
- [ ] Use private container registry
- [ ] Scan images for vulnerabilities
- [ ] Enable Azure Defender
- [ ] Use Key Vault for secrets
- [ ] Enable RBAC (Role-Based Access Control)
- [ ] Configure firewall rules
- [ ] Enable DDoS protection
- [ ] Regular security audits

---

## 🎯 Recommended Approach

### **For This Project (Learning DevOps)**

**Use AKS** because:
1. ✅ Learn Kubernetes (industry standard)
2. ✅ Practice CI/CD pipelines
3. ✅ Understand container orchestration
4. ✅ Experience production-grade infrastructure

### **For Production (Real Application)**

**Start with Static Web Apps** if:
- Static content only
- Want lowest cost
- Need global CDN

**Use App Service** if:
- Need managed platform
- Want easy scaling
- Don't need Kubernetes

**Use AKS** if:
- Multiple microservices
- Need advanced orchestration
- High availability requirements

---

## 🚀 Quick Start Commands

### **Deploy to AKS (Full Setup)**

```powershell
# 1. Create cluster
az aks create --resource-group devops-learning-rg --name devops-learning-aks --node-count 1

# 2. Get credentials
az aks get-credentials --resource-group devops-learning-rg --name devops-learning-aks

# 3. Deploy
kubectl create namespace production
kubectl apply -f k8s/ -n production

# 4. Get IP
kubectl get svc az900-portal-service -n production
```

### **Deploy to ACI (Simple)**

```powershell
az container create `
  --resource-group devops-learning-rg `
  --name az900-portal `
  --image ghcr.io/username/repo:latest `
  --dns-name-label az900-portal `
  --ports 8080
```

### **Deploy to Static Web Apps (Cheapest)**

```powershell
az staticwebapp create `
  --name az900-portal `
  --resource-group devops-learning-rg `
  --source https://github.com/username/repo `
  --branch main `
  --app-location "/project"
```

---

## 📚 Additional Resources

- [Azure Pricing Calculator](https://azure.microsoft.com/pricing/calculator/)
- [AKS Documentation](https://docs.microsoft.com/azure/aks/)
- [Azure Container Instances](https://docs.microsoft.com/azure/container-instances/)
- [Azure App Service](https://docs.microsoft.com/azure/app-service/)
- [Azure Static Web Apps](https://docs.microsoft.com/azure/static-web-apps/)

---

## 🧹 Cleanup

### **Delete All Resources**

```powershell
# Delete entire resource group (deletes everything)
az group delete --name devops-learning-rg --yes --no-wait

# Verify deletion
az group list --output table
```

---

**🎉 You now know all the hosting options for your application!**

**💡 Recommendation**: Start with **AKS** for learning, then use **Static Web Apps** for production if you don't need backend processing.
