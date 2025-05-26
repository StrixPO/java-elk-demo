# Project Overview  
Deploy a Java web application (WAR) on a lightweight multi-node Kubernetes cluster using K3d, with centralized logging via the ELK stack (Elasticsearch + Kibana — Logstash skipped) and Filebeat. The goal: visualize application logs on Kibana without writing custom Filebeat configs.

---
# Tech Stack
  - Kubernetes: via K3d (lightweight k3s in Docker)
  - App: Java WAR deployed to a container
  - Logging: ELK Stack + Filebeat
  - OS: Windows 11 (WSL2 with Ubuntu)
  - Network Exposure: kubectl port-forward

# Steps Completed
### 1. Cluster Setup
Initialized a k3d cluster named java-app:
`
k3d cluster create java-app --agents 1 --api-port 43199
`
### 2. Deploy Java App
Dockerized the WAR using Tomcat:
#### Dockerfile
```
FROM tomcat:9.0
COPY ./java-sample.war /usr/local/tomcat/webapps/
```
Created K8s Deployment and Service for the app.

### 3. Install ELK Stack via Helm
Added Elastic Helm repo:
```
helm repo add elastic https://helm.elastic.co
helm repo update
```

Deployed:
```
helm install elasticsearch elastic/elasticsearch
helm install kibana elastic/kibana
```
### 4. Install Filebeat
Used Elastic’s Helm chart:
```
helm install filebeat elastic/filebeat 
```
### 5. Port-Forwarding for Access
Access Kibana locally:
```
kubectl port-forward service/kibana-kibana 5601:5601
```

Visit http://localhost:5601 in browser.

# Log Flow Diagram (Conceptual)
```
Java App Pod
   |
   | (log file)
   v
Filebeat DaemonSet
   |
   | (log events)
   v
Elasticsearch (indexed)
   |
   v
Kibana (visualized)
```
# Validation
- kubectl get pods → All services Running
- kubectl get svc → ClusterIP Services available
- Port-forward successful (curl localhost:5601)
- Logged into Kibana using retrieved password:
`kubectl get secret elasticsearch-master-credentials -o jsonpath="{.data.password}" | base64 --decode && echo`
- Discovered logs in .ds-filebeat-* index
- Created Kibana Data View and verified logs from Java app pod

# Improvements / Stretch Goals
  - Add Ingress Controller with custom domain names.
  - Setup Logstash for log enrichment.
  - Enable alerts in Kibana for error logs.
  - Automate everything with a Helmfile or GitOps approach.
# Screenshots

### Services

![services](https://github.com/user-attachments/assets/f0d4a5cf-04d9-4075-82ef-93f5fa3824e4)


### Pods

![pods](https://github.com/user-attachments/assets/6e51091e-466f-462e-b80d-2d674de5f39f)


### Elastic Dashboard

![elastic](https://github.com/user-attachments/assets/4603e12e-5354-4600-b652-6e41fe8bbeac)

