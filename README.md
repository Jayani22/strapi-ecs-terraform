# Strapi ECS EC2 Deployment using Terraform and GitHub Actions

This repository contains a complete setup to deploy a **Strapi application** on **AWS ECS (EC2 launch type)** using **Terraform** and **GitHub Actions CI/CD**.


---

## 📦 What this repository includes

### Strapi Application
- Dockerized Strapi project inside the `app/` folder.
- Container runs on port `1337`.

### Terraform Infrastructure
- Modular Terraform structure.
- ECR repository module.
- ECS EC2 cluster and service module.
- EC2 instance registration to ECS cluster.
- Security group configuration for application access.

### GitHub Actions CI/CD
- Builds Docker image on push.
- Tags image using commit SHA.
- Pushes image to Amazon ECR.
- Runs Terraform apply.
- Updates ECS task definition automatically.

---

## 🚀 Deployment Flow

1. Push code to GitHub.
2. GitHub Actions builds Docker image.
3. Image is pushed to Amazon ECR.
4. Terraform updates ECS task definition.
5. ECS service deploys the new task revision.

---

## 🌐 Application Access

After deployment, Strapi is accessible via:

http://<EC2_PUBLIC_IP>:1337


Loom video: https://www.loom.com/share/c6fbca93a5fa479e930ae85f90681e3b