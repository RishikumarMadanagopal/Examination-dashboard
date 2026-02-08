# 🚀 Local Kubernetes Deployment - Complete Guide

**100% FREE - No Azure needed!**

Deploy your application to Kubernetes running on your local machine.

**Time**: 15 minutes  
**Cost**: **FREE** ✅  
**What you'll learn**: Same Kubernetes skills as Azure AKS!

---

## 📋 **What You'll Accomplish:**

✅ Enable Kubernetes in Docker Desktop  
✅ Deploy your app to local Kubernetes  
✅ Access via localhost  
✅ Learn Kubernetes concepts  
✅ Test auto-scaling  
✅ **100% FREE - No cloud costs!**  

---

## 🔧 **STEP 1: Enable Kubernetes in Docker Desktop**

### **1.1: Open Docker Desktop**

1. Look for **Docker Desktop** icon in your system tray (bottom right)
2. Right-click and select **"Open Docker Desktop"**
3. OR search for "Docker Desktop" in Windows Start menu

### **1.2: Enable Kubernetes**

1. In Docker Desktop, click the **⚙️ Settings** icon (top right)

2. In the left sidebar, click **"Kubernetes"**

3. Check the box: ✅ **"Enable Kubernetes"**

4. Click **"Apply & restart"**

5. **Wait 2-5 minutes** for Kubernetes to start
   - You'll see a green indicator when ready
   - Bottom left will show: "Kubernetes is running"

### **1.3: Verify Kubernetes is Running**

Open PowerShell and run:

```powershell
kubectl cluster-info
```

**Expected output**:
```
Kubernetes control plane is running at https://kubernetes.docker.internal:6443
CoreDNS is running at https://kubernetes.docker.internal:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```

✅ **If you see this, Kubernetes is ready!**

---

## 🐳 **STEP 2: Build Your Docker Image Locally**

### **2.1: Build the Image**

```powershell
cd C:\Users\Home\Downloads\project\project

# Build the Docker image
docker build -t az900-portal:v1.0 .
```

**Wait 1-2 minutes** for the build to complete.

### **2.2: Verify Image**

```powershell
docker images | Select-String "az900-portal"
```

**Expected output**:
```
az900-portal   v1.0   abc123   2 minutes ago   60MB
```

✅ **Image is ready!**

---

## ☸️ **STEP 3: Update Kubernetes Manifests for Local**

### **3.1: Update Deployment File**

We need to change the image reference to use your local image.

Open: `k8s/deployment.yaml`

**Find line 46** (the image line) and change it to:

```yaml
# BEFORE:
image: IMAGE_PLACEHOLDER

# AFTER:
image: az900-portal:v1.0
imagePullPolicy: Never  # Add this line too!
```

**Complete container section should look like**:

```yaml
      containers:
        - name: az900-portal
          image: az900-portal:v1.0
          imagePullPolicy: Never
          ports:
            - containerPort: 8080
              protocol: TCP
```

**Save the file**

### **3.2: Update Service File for Local**

Open: `k8s/service.yaml`

**Find the service type** and change it:

```yaml
# BEFORE:
type: LoadBalancer

# AFTER (for local):
type: NodePort
```

**Save the file**

---

## 🚀 **STEP 4: Deploy to Local Kubernetes**

### **4.1: Create Namespace**

```powershell
kubectl create namespace production
```

### **4.2: Apply Kubernetes Manifests**

```powershell
cd C:\Users\Home\Downloads\project

# Deploy all Kubernetes resources
kubectl apply -f k8s/ -n production
```

**Expected output**:
```
configmap/az900-portal-config created
deployment.apps/az900-portal created
horizontalpodautoscaler.autoscaling/az900-portal-hpa created
service/az900-portal-service created
```

### **4.3: Verify Deployment**

```powershell
# Check pods
kubectl get pods -n production

# Check services
kubectl get svc -n production

# Check all resources
kubectl get all -n production
```

**Wait 1-2 minutes** for pods to be in "Running" state.

---

## 🌐 **STEP 5: Access Your Application**

### **5.1: Get the NodePort**

```powershell
kubectl get svc az900-portal-service -n production
```

**Expected output**:
```
NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
az900-portal-service    NodePort   10.96.123.45    <none>        80:30123/TCP   1m
```

**Look for the port number** after `80:` - in this example it's `30123`

### **5.2: Access in Browser**

Open your browser and go to:

```
http://localhost:30123
```

(Replace `30123` with your actual NodePort number)

**OR use port-forward** (easier):

```powershell
kubectl port-forward svc/az900-portal-service 8080:80 -n production
```

Then open: **http://localhost:8080**

✅ **You should see your AZ-900 Practice Assessment Portal!** 🎉

---

## 🧪 **STEP 6: Test and Verify**

### **Test 1: Application Works**

```
http://localhost:8080
```

Should show your application!

### **Test 2: Health Check**

```
http://localhost:8080/health
```

Should return: `healthy`

### **Test 3: Check Pods**

```powershell
kubectl get pods -n production
```

Should show 2 pods running (as per deployment.yaml)

### **Test 4: Check HPA (Auto-scaling)**

```powershell
kubectl get hpa -n production
```

Should show the Horizontal Pod Autoscaler

### **Test 5: View Logs**

```powershell
# Get pod name
kubectl get pods -n production

# View logs (replace <pod-name> with actual name)
kubectl logs <pod-name> -n production
```

---

## 📊 **STEP 7: Explore Kubernetes**

### **View All Resources**

```powershell
kubectl get all -n production
```

### **Describe Deployment**

```powershell
kubectl describe deployment az900-portal -n production
```

### **Describe Service**

```powershell
kubectl describe svc az900-portal-service -n production
```

### **View Events**

```powershell
kubectl get events -n production --sort-by='.lastTimestamp'
```

### **Scale Manually**

```powershell
# Scale to 3 pods
kubectl scale deployment az900-portal --replicas=3 -n production

# Check pods
kubectl get pods -n production

# Scale back to 2
kubectl scale deployment az900-portal --replicas=2 -n production
```

---

## 🎯 **What You've Accomplished**

✅ **Enabled Kubernetes** on your local machine  
✅ **Built Docker image** locally  
✅ **Deployed to Kubernetes** with deployment, service, HPA  
✅ **Accessed application** via localhost  
✅ **Learned Kubernetes** concepts hands-on  
✅ **Tested scaling** manually  
✅ **100% FREE** - No cloud costs!  

**This is the SAME as deploying to Azure AKS, just local!** 🚀

---

## 🔄 **Common Commands**

### **Restart Deployment**

```powershell
kubectl rollout restart deployment az900-portal -n production
```

### **Update Image**

```powershell
# Rebuild image
docker build -t az900-portal:v1.0 ./project

# Restart deployment to use new image
kubectl rollout restart deployment az900-portal -n production
```

### **View Logs (Live)**

```powershell
kubectl logs -f deployment/az900-portal -n production
```

### **Execute into Pod**

```powershell
# Get pod name
kubectl get pods -n production

# Execute into pod
kubectl exec -it <pod-name> -n production -- /bin/sh
```

---

## 🧹 **Cleanup (When Done)**

### **Delete Everything**

```powershell
# Delete namespace (deletes all resources)
kubectl delete namespace production
```

### **Or Delete Individual Resources**

```powershell
kubectl delete -f k8s/ -n production
```

### **Stop Port Forward**

Press `Ctrl+C` in the PowerShell window running port-forward

---

## 🐛 **Troubleshooting**

### **Issue: Pods Not Starting**

```powershell
# Check pod status
kubectl get pods -n production

# Describe pod (replace <pod-name>)
kubectl describe pod <pod-name> -n production

# Check logs
kubectl logs <pod-name> -n production
```

**Common fixes**:
- Make sure `imagePullPolicy: Never` is set
- Rebuild Docker image: `docker build -t az900-portal:v1.0 ./project`
- Restart deployment: `kubectl rollout restart deployment az900-portal -n production`

### **Issue: Can't Access Application**

**Solution 1**: Use port-forward
```powershell
kubectl port-forward svc/az900-portal-service 8080:80 -n production
```

**Solution 2**: Check NodePort
```powershell
kubectl get svc az900-portal-service -n production
```

### **Issue: Image Pull Error**

**Solution**: Make sure you set `imagePullPolicy: Never` in deployment.yaml

### **Issue: Kubernetes Not Starting in Docker Desktop**

**Solutions**:
1. Restart Docker Desktop
2. In Docker Desktop Settings → Kubernetes → Click "Reset Kubernetes Cluster"
3. Disable and re-enable Kubernetes
4. Restart your computer

---

## 📚 **Next Steps**

### **Learn More Kubernetes**

1. **Explore ConfigMaps**:
   ```powershell
   kubectl get configmap -n production
   kubectl describe configmap az900-portal-config -n production
   ```

2. **Test Auto-scaling** (requires metrics-server):
   ```powershell
   kubectl get hpa -n production -w
   ```

3. **View Resource Usage**:
   ```powershell
   kubectl top pods -n production
   kubectl top nodes
   ```

### **Add to Your Resume**

You can now say:

✅ "Deployed containerized application to Kubernetes"  
✅ "Configured Kubernetes Deployments, Services, and HPA"  
✅ "Managed multi-pod deployments with replica sets"  
✅ "Implemented health checks and resource limits"  

---

## 🎓 **What You Learned**

### **Kubernetes Concepts**:
- [x] Namespaces
- [x] Deployments
- [x] Pods
- [x] Services (NodePort)
- [x] ConfigMaps
- [x] Horizontal Pod Autoscaler
- [x] Resource limits
- [x] Health checks
- [x] Scaling

### **kubectl Commands**:
- [x] `kubectl apply`
- [x] `kubectl get`
- [x] `kubectl describe`
- [x] `kubectl logs`
- [x] `kubectl scale`
- [x] `kubectl port-forward`
- [x] `kubectl delete`

---

## 💡 **Local vs Azure AKS**

| Feature | Local Kubernetes | Azure AKS |
|---------|------------------|-----------|
| **Cost** | FREE ✅ | ~$70/month |
| **Setup Time** | 5 minutes | 15 minutes |
| **Public Access** | No (localhost only) | Yes (public IP) |
| **Learning Value** | Same! ✅ | Same! ✅ |
| **Resume Worthy** | Yes ✅ | Yes ✅ |
| **Production** | No | Yes |

**For learning, local Kubernetes is perfect!** 🎯

---

## 🚀 **Want to Deploy to Azure Later?**

When you're ready for cloud deployment:

1. Follow `AZURE_DEPLOYMENT_GUIDE.md`
2. The Kubernetes manifests are the same!
3. Just need to:
   - Push image to GHCR
   - Create AKS cluster
   - Deploy same manifests

---

## 🎉 **Congratulations!**

You've successfully deployed your application to Kubernetes!

**You now have**:
✅ Working Kubernetes deployment  
✅ Hands-on Kubernetes experience  
✅ Resume-worthy project  
✅ **100% FREE setup!**  

---

## 📞 **Resources**

- **Main Documentation**: [README.md](./README.md)
- **Commands Reference**: [COMMANDS.md](./COMMANDS.md)
- **Interview Prep**: [INTERVIEW_GUIDE.md](./INTERVIEW_GUIDE.md)
- **Architecture**: [ARCHITECTURE.md](./ARCHITECTURE.md)

---

**🌟 You're now a Kubernetes user! Great job! 🌟**
