# ✅ Azure Deployment Checklist

Use this checklist to track your progress!

---

## 📋 **Pre-Deployment Checklist**

- [ ] Azure student account created and active
- [ ] GitHub account created
- [ ] Local Docker deployment completed ✅ (YOU'VE DONE THIS!)
- [ ] Code is ready in `C:\Users\Home\Downloads\project`

---

## 🚀 **Deployment Steps**

### **Phase 1: GitHub Setup**
- [ ] Created GitHub repository
- [ ] Repository name: `devops-az900-portal` (or your choice)
- [ ] Set to Public visibility
- [ ] Copied repository URL
- [ ] Connected local code to GitHub (`git remote add origin`)
- [ ] Pushed code to GitHub (`git push -u origin main`)
- [ ] Verified code is visible on GitHub

### **Phase 2: Azure AKS Setup**
- [ ] Logged into Azure Portal (portal.azure.com)
- [ ] Created Resource Group: `devops-learning-rg`
- [ ] Created AKS Cluster: `devops-learning-aks`
  - [ ] Selected Dev/Test preset
  - [ ] Chose Free pricing tier
  - [ ] Selected B2s VM size (1 node)
  - [ ] Selected Basic Load Balancer
  - [ ] Disabled Azure Monitor
- [ ] Waited for deployment to complete (5-10 min)
- [ ] Verified "Deployment complete" message

### **Phase 3: Service Principal Setup**
- [ ] Opened Azure Cloud Shell
- [ ] Got Subscription ID (`az account show --query id -o tsv`)
- [ ] Created Service Principal with `az ad sp create-for-rbac`
- [ ] Copied entire JSON output
- [ ] Saved JSON temporarily

### **Phase 4: GitHub Secrets**
- [ ] Went to GitHub repo → Settings → Secrets and variables → Actions
- [ ] Created secret: `AZURE_CREDENTIALS` (pasted JSON)
- [ ] Created GitHub Personal Access Token (PAT)
  - [ ] Scopes: write:packages, read:packages, delete:packages
  - [ ] Copied token
- [ ] Created secret: `GHCR_TOKEN` (pasted PAT)
- [ ] Verified both secrets exist

### **Phase 5: Update Configuration Files**
- [ ] Opened `.github/workflows/ci-cd.yml`
- [ ] Updated `IMAGE_NAME` with your GitHub username
- [ ] Saved file
- [ ] Opened `k8s/deployment.yaml`
- [ ] Updated `image:` line with your username
- [ ] Saved file

### **Phase 6: Deploy**
- [ ] Committed changes (`git add .` and `git commit`)
- [ ] Pushed to GitHub (`git push origin main`)
- [ ] Went to GitHub → Actions tab
- [ ] Watched pipeline run
- [ ] All stages completed successfully (green checkmarks)

### **Phase 7: Access Application**
- [ ] Got external IP from GitHub Actions output OR Cloud Shell
- [ ] Waited 2-5 minutes for LoadBalancer
- [ ] Opened browser: `http://<EXTERNAL-IP>`
- [ ] Application loaded successfully! 🎉

---

## 🧪 **Verification Checklist**

- [ ] Health check works: `http://<EXTERNAL-IP>/health`
- [ ] Application loads: `http://<EXTERNAL-IP>`
- [ ] Can login and see exam portal
- [ ] Checked pods are running: `kubectl get pods -n production`
- [ ] Checked HPA is active: `kubectl get hpa -n production`
- [ ] Took screenshots for portfolio

---

## 📸 **Portfolio Checklist**

- [ ] Screenshot of Azure Portal showing AKS cluster
- [ ] Screenshot of GitHub Actions successful pipeline
- [ ] Screenshot of application running
- [ ] Screenshot of `kubectl get all -n production`
- [ ] Noted the external IP address
- [ ] Saved GitHub repository URL

---

## 📝 **Documentation Checklist**

- [ ] Updated resume with project (see INTERVIEW_GUIDE.md)
- [ ] Prepared 30-second pitch
- [ ] Reviewed architecture diagrams
- [ ] Can explain request flow
- [ ] Can explain CI/CD pipeline
- [ ] Practiced interview questions

---

## 🧹 **Cleanup Checklist (When Done)**

⚠️ **IMPORTANT**: To avoid charges, cleanup when done testing!

- [ ] Took all screenshots needed
- [ ] Saved portfolio materials
- [ ] Deleted Azure Resource Group OR
- [ ] Stopped AKS cluster (`az aks stop`)
- [ ] Verified resources deleted in Azure Portal

---

## 🎯 **Your Information**

Fill this in as you go:

**GitHub**:
- Username: `___________________`
- Repository URL: `___________________`
- Repository is Public: ☐ Yes ☐ No

**Azure**:
- Subscription ID: `___________________`
- Resource Group: `devops-learning-rg`
- AKS Cluster: `devops-learning-aks`
- Region: `___________________`

**Application**:
- External IP: `___________________`
- Application URL: `http://___________________`
- Health Check URL: `http://___________________/health`

**Secrets Created**:
- ☐ AZURE_CREDENTIALS
- ☐ GHCR_TOKEN

---

## 📊 **Progress Tracker**

| Phase | Status | Time Spent | Notes |
|-------|--------|------------|-------|
| 1. GitHub Setup | ☐ | ___ min | |
| 2. Azure AKS | ☐ | ___ min | |
| 3. Service Principal | ☐ | ___ min | |
| 4. GitHub Secrets | ☐ | ___ min | |
| 5. Update Config | ☐ | ___ min | |
| 6. Deploy | ☐ | ___ min | |
| 7. Access App | ☐ | ___ min | |
| **TOTAL** | | ___ min | |

---

## 🎉 **Success Criteria**

You've successfully completed the deployment when:

✅ GitHub Actions pipeline shows all green checkmarks  
✅ Application is accessible at public IP  
✅ Health check returns "healthy"  
✅ Can login and use the exam portal  
✅ Pods are running in production namespace  
✅ HPA is monitoring and ready to scale  

---

## 🆘 **Quick Troubleshooting**

### Pipeline Fails?
→ Check GitHub Secrets are set correctly

### No External IP?
→ Wait 5 minutes, check again with `kubectl get svc -n production`

### Pods Not Starting?
→ Check logs: `kubectl logs <pod-name> -n production`

### Can't Access App?
→ Verify external IP, check firewall, wait a bit longer

---

## 📞 **Resources**

- **Main Guide**: [AZURE_DEPLOYMENT_GUIDE.md](./AZURE_DEPLOYMENT_GUIDE.md)
- **Commands**: [COMMANDS.md](./COMMANDS.md)
- **Troubleshooting**: [README.md](./README.md)
- **Interview Prep**: [INTERVIEW_GUIDE.md](./INTERVIEW_GUIDE.md)

---

## 🎯 **Next Steps After Deployment**

1. ☐ Take screenshots
2. ☐ Update resume
3. ☐ Study architecture
4. ☐ Practice interview questions
5. ☐ Cleanup Azure resources
6. ☐ Share on LinkedIn (optional)

---

**🌟 You've got this! Follow the steps one by one! 🌟**

**Current Status**: Local Docker ✅ → Azure Deployment 🚀
