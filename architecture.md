# n8n + AI Automation Architecture

## 1. Overview

This architecture provisions a **minimal but production-minded automation stack** on AWS using Terraform:

* **Compute:** EC2 running n8n Docker container
* **Networking:** ALB for HTTPS traffic
* **Security:** Security Groups, IAM least-privilege roles
* **Secrets Management:** OpenAI API key via AWS SSM Parameter Store
* **Logging & Observability:** CloudWatch logs for container logs
* **HTTPS:** Terminated at ALB with ACM certificate

---

## 2. Compute Choice

| Component               | Choice       | Reasoning                                                                           |
| ----------------------- | ------------ | ----------------------------------------------------------------------------------- |
| n8n Application         | EC2 + Docker | Simple, cost-effective, easily deployable; supports Docker-based workflow isolation |
| Load Balancer           | ALB          | Provides HTTPS termination, scalable traffic distribution, and centralized logging  |
| Container Orchestration | Docker only  | Lightweight, avoids complexity of ECS/EKS for small-scale deployment                |

---

## 3. Networking Diagram

```
          Internet
              |
        freedomain.one
              |
           ALB (HTTPS)
        /       |       \
   Security   Security   Security
    Group      Group      Group
      |          |          |
   EC2 n8n   EC2 n8n   EC2 n8n
     |          |          |
CloudWatch Logs Docker logs
```

* ALB listens on **443 (HTTPS)**.
* EC2 instances run **n8n Docker container** on port 5678.
* Security Groups restrict traffic to **ALB only** for incoming requests.

---

## 4. IAM & Security

| Resource    | IAM Role / Policy                   | Purpose                                           |
| ----------- | ----------------------------------- | ------------------------------------------------- |
| EC2         | `CloudWatchAgentServerPolicy`       | Push logs to CloudWatch                           |
| n8n Secrets | `AmazonSSMReadOnlyAccess` or custom | Read OpenAI API key securely from Parameter Store |
| ALB         | No IAM required                     | Serves traffic, terminates HTTPS                  |

**Principles Applied:**

* Least privilege IAM roles.
* Secrets stored in **SSM Parameter Store**; not hardcoded.
* Security groups allow only necessary ports (443 for ALB, 5678 internally).

---

## 5. ACM / HTTPS

* ACM certificate requested for your domain (`n8n.yourdomain.com`).
* ALB listener configured with `ELBSecurityPolicy-TLS13-1-2-Res-2021-06`.
* HTTPS traffic terminated at ALB → forwarded to EC2 Docker.
* Free domain used from freedomain.one; DNS record points to ALB DNS name.

---

## 6. Logging & Observability

* **CloudWatch log group:** `/n8n/docker`
* **CloudWatch agent** installed on EC2, pushing Docker container logs.
* **ALB access logs** optional; can be sent to S3.
* Logs can be monitored, filtered, and used for alarms.

---

## 7. Terraform Deployment

**Apply Infrastructure:**

```bash
terraform init
terraform plan -var-file=variables.example.tfvars
terraform apply -var-file=variables.example.tfvars
```

**Destroy Infrastructure:**

```bash
terraform destroy -var-file=variables.example.tfvars
```

---

## 8. Testing

1. Access `https://n8n/fittmeal.work.gd` → confirm n8n UI is up. or ALB (https://n8n-alb-293898734.ap-south-1.elb.amazonaws.com)
2. Trigger a webhook in n8n → check **CloudWatch logs** for workflow execution.
3. Verify IAM permissions: n8n can read secrets from SSM and EC2 can push logs.
4. Confirm HTTPS works with ACM certificate.

---

## 9. Estimated Monthly Cost (AED)

| Resource                   | Estimated Cost             |
| -------------------------- | -------------------------- |
| EC2 t3.medium (Docker)     | \~60 AED                   |
| ALB                        | \~35 AED                   |
| CloudWatch Logs (5GB free) | 0 AED (within free tier)   |
| SSM Parameter Store        | 0 AED (standard tier free) |
| Total                      | \~95 AED                   |

> Costs will vary based on traffic and log retention.

---

## 10. Future Improvements

* **Autoscaling EC2** or switch to **ECS/Fargate** for high availability.
* **ALB access logs** to S3 + Athena for deeper analytics.
* **Secrets rotation** for OpenAI keys using AWS Secrets Manager.
* **Metrics & alarms** for n8n workflows and EC2 health.
* **TLS certificate automation** via Terraform + DNS validation for zero manual steps.
