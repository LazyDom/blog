---
layout: post
title: "How to Install Minikube on WSL2: A Step-by-Step Guide"
categories: [kubernetes, devops, wsl2, minikube]
description: Step-by-step guide to running Minikube on WSL2 for local Kubernetes development.
tagline: Run Minikube on WSL2 for local Kubernetes development.
medium_url: https://medium.com/@LazyDom/how-to-install-minikube-on-wsl2-a-step-by-step-guide-c843822744ac
author: LazyDom
date: 2025-04-27
---

Minikube is a popular tool for running Kubernetes locally, and with the power of WSL2 (Windows Subsystem for Linux 2), you can set up a lightweight Kubernetes cluster on your Windows machine. This guide will walk you through the process of installing Minikube on WSL2.

<!--more-->

# How to Install Minikube on WSL2: A Step-by-Step Guide

---

## Step 1: Install Prerequisites

### 1. Install WSL2

WSL2 is required to run Linux distributions on Windows. To verify if WSL2 is installed, open PowerShell or Command Prompt and run:

```sh
wsl --list --verbose
```

*Windows Terminal Output should look like this:*

![WSL2 List Output]({{ site.baseurl }}/images/wsl2-list-output.png)

If WSL2 is not installed, follow the [Microsoft WSL2 installation guide](https://learn.microsoft.com/en-us/windows/wsl/install).

### 2. Install a Linux Distribution

Choose and install a Linux distribution (e.g., Ubuntu) from the Microsoft Store.

### 3. Install Docker

Minikube requires Docker to run. Install Docker inside your WSL2 distribution:

```sh
sudo apt update
sudo apt install -y docker.io
```

### 4. Add Your User to the `docker` Group

To avoid using `sudo` with Docker commands, add your user to the `docker` group:

```sh
sudo usermod -aG docker $USER
```

### 5. Activate the Group Change

After adding your user to the `docker` group, activate the change by either:
- Logging out and logging back in, or
- Running the following command:

```sh
newgrp docker
```

### 6. Verify Docker Access

Ensure Docker is working without requiring `sudo`:

```sh
docker version
```

### 7. Install `conntrack`

Minikube requires the `conntrack` utility. Install it using:

```sh
sudo apt install -y conntrack
```

### 8. Install `curl` if not installed

```sh
sudo apt update && sudo apt install -y curl
```

---

## Step 2: Install Minikube

### 1. Download Minikube

Download the latest Minikube binary:

```sh
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```

### 2. Install Minikube

Move the downloaded binary to a directory in your `PATH` and make it executable:

```sh
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

### 3. Verify Installation

Check if Minikube is installed correctly:

```sh
minikube version
```

---

## Step 3: Start Minikube

### 1. Start Minikube with Docker Driver

Run the following command to start Minikube using the Docker driver:

```sh
minikube start --driver=docker
```

*Bash Output for the above command:*

![Minikube Start Output]({{ site.baseurl }}/images/minikube-start-output.png)

### 2. Verify Minikube is Running

Check the status of your Minikube cluster:

```sh
minikube status
```

*Bash Output for the above command:*

![Minikube Status Output]({{ site.baseurl }}/images/minikube-status-output.png)

---

## Step 4: Manual Installation of `kubectl`

This guide explains how to manually install the `kubectl` command-line tool on a Linux system.

### Installation Steps

1. Download the Latest `kubectl` Binary:

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
```

2. Make the Binary Executable:

```sh
chmod +x kubectl
```

3. Move the Binary to a Directory in Your `PATH`:

```sh
sudo mv kubectl /usr/local/bin/
```

4. Verify the Installation:

```sh
kubectl version --client
```

*Bash Output for the above command:*

![Kubectl Version Output]({{ site.baseurl }}/images/kubectl-version-output.png)

#### Updating `kubectl`

To update `kubectl` in the future, repeat the steps above to download and replace the binary with the latest version.

#### Uninstallation

To uninstall `kubectl`, simply remove the binary:

```sh
sudo rm /usr/local/bin/kubectl
```

#### Additional Resources

- [Kubernetes Official Documentation](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [kubectl Command Reference](https://kubernetes.io/docs/reference/kubectl/)

---

## Conclusion

Congratulations! You now have Minikube running on WSL2. This setup allows you to experiment with Kubernetes locally on your Windows machine. If you encounter any issues during the installation process, feel free to refer to the official documentation or leave a comment below.

For more guides and contributions, visit my [GitHub account](https://github.com/LazyDom).

Happy Kubernetes-ing!
