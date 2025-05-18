# Project Overview
Deploy a Java web application (WAR) on a Kubernetes (K3d) cluster and configure centralized logging using the ELK stack (Elasticsearch, Logstash [opted out], Kibana) with Filebeat.

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
`
FROM tomcat:9.0
COPY ./your-app.war /usr/local/tomcat/webapps/
`
Created K8s Deployment and Service for the app.

### 3. Install ELK Stack via Helm
Added Elastic Helm repo:
`
helm repo add elastic https://helm.elastic.co
helm repo update
`

Deployed:
`
helm install elasticsearch elastic/elasticsearch
helm install kibana elastic/kibana
`
### 4. Install Filebeat
Used Elastic’s Helm chart:
`
helm install filebeat elastic/filebeat -f filebeat-values.yaml
`
### 5. Port-Forwarding for Access
Access Kibana locally:
`
kubectl port-forward service/kibana-kibana 5601:5601
`

Visit http://localhost:5601 in browser.

# Log Flow Diagram (Conceptual)
`
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
`
# Validation
  - kubectl get pods shows all services running.
  - curl localhost:5601 succeeded (Kibana up).
  - App logs are being shipped to Elastic (can verify in Kibana > Discover).

# Improvements / Stretch Goals
  - Add Ingress Controller with custom domain names.
  - Setup Logstash for log enrichment.
  - Enable alerts in Kibana for error logs.
  - Automate everything with a Helmfile or GitOps approach.

# Submission Package (Optional Files to Include)
  - Dockerfile
  - deployment.yaml & service.yaml for the app
  - filebeat-values.yaml
  - README.md with these steps


