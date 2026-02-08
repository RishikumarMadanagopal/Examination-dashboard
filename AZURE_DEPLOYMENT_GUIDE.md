# 🚀 Azure Deployment - Complete Step-by-Step Guide

**Goal**: Deploy your application to Azure AKS with automated CI/CD using GitHub Actions

**Time Required**: 30-40 minutes

**Prerequisites**: 
- ✅ Azure Student Account (you have this!)
- ✅ GitHub Account
- ✅ Local Docker working (you completed this!)

---

## 📋 **Overview of Steps**

```
1. GitHub Setup (5 min)
   └─> Create repository and push code

2. Azure Portal Setup (15 min)
   └─> Create AKS cluster via web interface

3. GitHub Secrets Configuration (5 min)
   └─> Add Azure credentials to GitHub

4. Update CI/CD Configuration (5 min)
   └─> Update workflow file with your details

5. Deploy via GitHub Actions (5 min)
   └─> Push code and watch it deploy!

6. Access Your Application (2 min)
   └─> Get public IP and test
```

---

## 🔥 **PHASE 1: GitHub Repository Setup**

### **Step 1.1: Create GitHub Repository**

1. **Open browser** and go to: https://github.com/new

2. **Fill in details**:
   - Repository name: `devops-az900-portal`
   - Description: `End-to-End DevOps Project: CI/CD with Azure AKS`
   - Visibility: **Public** (for free GitHub Actions)
   - **DO NOT** check "Add a README file"
   - Click **"Create repository"**

3. **Copy the repository URL** (you'll need this)
   - Example: `https://github.com/YOUR_USERNAME/devops-az900-portal.git`

### **Step 1.2: Connect Your Local Code to GitHub**

Open PowerShell in `C:\Users\Home\Downloads\project` and run:

```powershell
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/devops-az900-portal.git

# Or if remote already exists, update it:
git remote set-url origin https://github.com/YOUR_USERNAME/devops-az900-portal.git

# Check current branch
git branch

# If not on 'main', rename to main
git branch -M main

# Push to GitHub
git push -u origin main
```

**✅ Checkpoint**: Your code should now be visible on GitHub!

---

## ☁️ **PHASE 2: Azure AKS Setup (via Portal)**

Since you don't have Azure CLI installed, we'll use the Azure Portal (web interface).

### **Step 2.1: Login to Azure Portal**

1. Go to: https://portal.azure.com
2. Login with your student account credentials

### **Step 2.2: Create Resource Group**

1. In Azure Portal, search for **"Resource groups"** in the top search bar
2. Click **"+ Create"**
3. Fill in:
   - **Subscription**: Select your student subscription
   - **Resource group name**: `devops-learning-rg`
   - **Region**: `East US` (or closest to you)
4. Click **"Review + create"** → **"Create"**

### **Step 2.3: Create AKS Cluster**

1. In Azure Portal, search for **"Kubernetes services"**
2. Click **"+ Create"** → **"Create a Kubernetes cluster"**

3. **Basics Tab**:
   - **Subscription**: Your student subscription
   - **Resource group**: `devops-learning-rg` (select the one you just created)
   - **Cluster preset configuration**: `Dev/Test`
   - **Kubernetes cluster name**: `devops-learning-aks`
   - **Region**: `East US` (same as resource group)
   - **Availability zones**: None
   - **AKS pricing tier**: `Free`
   - **Kubernetes version**: (keep default, latest stable)
   - **Automatic upgrade**: `Disabled`
   - **Authentication and Authorization**: `Local accounts with Kubernetes RBAC`

4. **Node pools Tab**:
   - Click on the default node pool (agentpool)
   - **Node size**: Click "Choose a size"
     - Search for: `B2s` (2 vCPUs, 4GB RAM)
     - Select `Standard_B2s`
     - Click **"Select"**
   - **Scale method**: `Manual`
   - **Node count**: `1`
   - Click **"Update"**

5. **Networking Tab**:
   - **Network configuration**: `Azure CNI`
   - **Network policy**: `None`
   - **Load balancer**: `Basic` (IMPORTANT for cost savings!)
   - **DNS name prefix**: (keep default)

6. **Integrations Tab**:
   - **Container registry**: `None` (we'll use GitHub Container Registry)
   - **Azure Monitor**: `Disabled` (to save costs)

7. **Advanced Tab**:
   - Keep all defaults

8. **Tags Tab**:
   - Add tag (optional):
     - Name: `Project`
     - Value: `DevOps-Learning`

9. **Review + create**:
   - Review the configuration
   - **Estimated cost**: Should show ~$30/month
   - Click **"Create"**

**⏱️ Wait Time**: 5-10 minutes for AKS cluster to be created

**✅ Checkpoint**: You should see "Deployment complete" message

---

## 🔐 **PHASE 3: Create Service Principal for GitHub Actions**

We need to create credentials for GitHub Actions to access Azure.

### **Step 3.1: Open Cloud Shell in Azure Portal**

1. In Azure Portal, click the **Cloud Shell icon** (>_) in the top right
2. Select **"Bash"** (not PowerShell)
3. If prompted, create storage (click "Create storage")

### **Step 3.2: Get Your Subscription ID**

In Cloud Shell, run:

```bash
az account show --query id -o tsv
```

**Copy this Subscription ID** - you'll need it!

### **Step 3.3: Create Service Principal**

In Cloud Shell, run this command (replace `<SUBSCRIPTION_ID>` with your actual ID):

```bash
az ad sp create-for-rbac \
  --name "github-actions-sp" \
  --role contributor \
  --scopes /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/devops-learning-rg \
  --sdk-auth
```

**IMPORTANT**: Copy the **entire JSON output** that looks like this:

```json
{
  "clientId": "xxxxx-xxxxx-xxxxx-xxxxx",
  "clientSecret": "xxxxx~xxxxx",
  "subscriptionId": "xxxxx-xxxxx-xxxxx-xxxxx",
  "tenantId": "xxxxx-xxxxx-xxxxx-xxxxx",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  ...
}
```

**✅ Checkpoint**: Save this JSON somewhere safe temporarily!

---

## 🔑 **PHASE 4: Configure GitHub Secrets**

### **Step 4.1: Add Azure Credentials to GitHub**

1. Go to your GitHub repository
2. Click **"Settings"** tab
3. In left sidebar, click **"Secrets and variables"** → **"Actions"**
4. Click **"New repository secret"**

**Secret 1: AZURE_CREDENTIALS**
- Name: `AZURE_CREDENTIALS`
- Value: Paste the **entire JSON** from Step 3.3
- Click **"Add secret"**

### **Step 4.2: Create GitHub Personal Access Token (PAT)**

1. Go to: https://github.com/settings/tokens
2. Click **"Generate new token"** → **"Generate new token (classic)"**
3. Fill in:
   - Note: `GHCR Access for DevOps Project`
   - Expiration: `90 days`
   - Scopes: Check these boxes:
     - ✅ `write:packages`
     - ✅ `read:packages`
     - ✅ `delete:packages`
4. Click **"Generate token"**
5. **COPY THE TOKEN** (you won't see it again!)

**Secret 2: GHCR_TOKEN**
- Go back to your repository → Settings → Secrets and variables → Actions
- Click **"New repository secret"**
- Name: `GHCR_TOKEN`
- Value: Paste your Personal Access Token
- Click **"Add secret"**

**✅ Checkpoint**: You should have 2 secrets:
- `AZURE_CREDENTIALS`
- `GHCR_TOKEN`

---

## ⚙️ **PHASE 5: Update CI/CD Configuration**

### **Step 5.1: Update GitHub Actions Workflow**

Open the file: `.github/workflows/ci-cd.yml`

**Find and replace these values**:

1. **Line 17-18**: Update image name
   ```yaml
   # BEFORE:
   IMAGE_NAME: ${{ github.repository }}
   
   # AFTER (replace YOUR_USERNAME):
   IMAGE_NAME: YOUR_USERNAME/devops-az900-portal
   ```

2. **Line 75**: Update context path
   ```yaml
   # BEFORE:
   context: ./project
   
   # Keep as is (this is correct)
   context: ./project
   ```

**Save the file**

### **Step 5.2: Update Kubernetes Deployment**

Open the file: `k8s/deployment.yaml`

**Find line 46** and update the image placeholder:

```yaml
# BEFORE:
image: IMAGE_PLACEHOLDER

# AFTER (replace YOUR_USERNAME):
image: ghcr.io/YOUR_USERNAME/devops-az900-portal:latest
```

**Save the file**

---

## 🚀 **PHASE 6: Deploy to Azure!**

### **Step 6.1: Commit and Push Changes**

In PowerShell:

```powershell
cd C:\Users\Home\Downloads\project

# Add changes
git add .

# Commit
git commit -m "Configure CI/CD for Azure deployment"

# Push to GitHub
git push origin main
```

### **Step 6.2: Watch the Pipeline Run**

1. Go to your GitHub repository
2. Click the **"Actions"** tab
3. You should see a workflow running: **"CI/CD Pipeline - Build & Deploy"**
4. Click on it to watch the progress

**Pipeline Stages** (takes ~5-10 minutes):
1. ✅ Build Docker image
2. ✅ Security scan with Trivy
3. ✅ Push to GitHub Container Registry
4. ✅ Deploy to Azure AKS
5. ✅ Verify deployment

**✅ Checkpoint**: All stages should show green checkmarks!

---

## 🌐 **PHASE 7: Access Your Application**

### **Step 7.1: Get AKS Credentials (via Azure Portal)**

**Option A: Using Azure Cloud Shell**

1. In Azure Portal, open Cloud Shell (>_)
2. Run:
   ```bash
   az aks get-credentials \
     --resource-group devops-learning-rg \
     --name devops-learning-aks
   ```

3. Get the external IP:
   ```bash
   kubectl get svc az900-portal-service -n production
   ```

**Option B: Check GitHub Actions Output**

1. Go to GitHub → Actions → Latest workflow run
2. Click on the **"Deploy to AKS"** job
3. Expand the **"Get LoadBalancer Public IP"** step
4. Copy the external IP address

### **Step 7.2: Access Your Application**

1. **Wait 2-5 minutes** for the LoadBalancer to assign a public IP
2. Open browser and go to: `http://<EXTERNAL-IP>`
3. You should see your **AZ-900 Practice Assessment Portal**!

**✅ SUCCESS!** Your application is now live on Azure! 🎉

---

## 🧪 **PHASE 8: Verify Everything Works**

### **Test 1: Health Check**

```
http://<EXTERNAL-IP>/health
```
Should return: `healthy`

### **Test 2: Application**

```
http://<EXTERNAL-IP>
```
Should show the login page

### **Test 3: Auto-Scaling**

In Cloud Shell:
```bash
# Check HPA status
kubectl get hpa -n production

# Check pods
kubectl get pods -n production
```

---

## 📊 **What You've Accomplished**

✅ **Containerized** application with Docker  
✅ **Automated CI/CD** with GitHub Actions  
✅ **Deployed to Azure AKS** (managed Kubernetes)  
✅ **Public access** via LoadBalancer  
✅ **Auto-scaling** configured (2-5 pods)  
✅ **Security scanning** with Trivy  
✅ **Cost-optimized** deployment  

**This is a production-ready, resume-worthy project!** 🚀

---

## 🧹 **IMPORTANT: Cleanup (When Done Testing)**

**To avoid charges**, delete resources when not in use:

### **Option 1: Delete via Azure Portal**

1. Go to Azure Portal
2. Search for "Resource groups"
3. Click on `devops-learning-rg`
4. Click **"Delete resource group"**
5. Type the resource group name to confirm
6. Click **"Delete"**

### **Option 2: Stop AKS Cluster (Keep but Don't Pay)**

In Cloud Shell:
```bash
az aks stop \
  --resource-group devops-learning-rg \
  --name devops-learning-aks
```

To start again:
```bash
az aks start \
  --resource-group devops-learning-rg \
  --name devops-learning-aks
```

---

## 🐛 **Troubleshooting**

### **Issue: Pipeline Fails at "Deploy to AKS"**

**Solution**: Check GitHub Secrets are set correctly
- Go to Settings → Secrets and variables → Actions
- Verify `AZURE_CREDENTIALS` and `GHCR_TOKEN` exist

### **Issue: No External IP (shows <pending>)**

**Solution**: Wait 5 minutes, then check again
```bash
kubectl get svc az900-portal-service -n production --watch
```

### **Issue: Pods Not Starting**

**Solution**: Check pod logs
```bash
kubectl get pods -n production
kubectl describe pod <pod-name> -n production
kubectl logs <pod-name> -n production
```

### **Issue: Can't Access Application**

**Solution**: Check service and pods
```bash
kubectl get all -n production
kubectl get events -n production --sort-by='.lastTimestamp'
```

---

## 📞 **Need Help?**

- Check the main [README.md](./README.md)
- Review [COMMANDS.md](./COMMANDS.md) for command reference
- Check [QUICKSTART.md](./QUICKSTART.md) for troubleshooting

---

## 🎉 **Congratulations!**

You've successfully deployed a production-ready application to Azure AKS with automated CI/CD!

**Next Steps**:
1. ✅ Take screenshots for your portfolio
2. ✅ Update your resume (see INTERVIEW_GUIDE.md)
3. ✅ Study the architecture (see ARCHITECTURE.md)
4. ✅ Prepare for interviews (see INTERVIEW_GUIDE.md)

**Don't forget to cleanup Azure resources when done testing!**

---

**🌟 You're now a DevOps engineer with production experience! 🌟**
