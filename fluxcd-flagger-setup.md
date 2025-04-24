# GitOps with FluxCD and Flagger

This documentation outlines how to set up a GitOps workflow using **FluxCD** and **Flagger** in a Kubernetes cluster. It includes automated deployment, canary rollout with Flagger, and observability integration with Prometheus.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Pre-requisites](#pre-requisites)
- [Setup Guide](#setup-guide)
  - [1. Bootstrap FluxCD](#1-bootstrap-fluxcd)
  - [2. Add Flagger HelmRepository and HelmRelease](#2-add-flagger-helmrepository-and-helmrelease)
  - [3. Setup Canary Deployment](#3-setup-canary-deployment)
- [Monitoring with Prometheus](#monitoring-with-prometheus)
- [Usage Guide](#usage-guide)
- [Troubleshooting](#troubleshooting)
- [References](#references)

---

## Overview

**FluxCD** is a GitOps operator that synchronizes your Kubernetes cluster with configuration stored in a Git repository.  
**Flagger** is a progressive delivery tool that automates the release process for applications using metrics and traffic shifting.

Together, they enable reliable and automated application rollouts.

---

##  Architecture

The following diagram illustrates the architecture of the GitOps deployment workflow using FluxCD and Flagger:

![FluxCD and Flagger Architecture](fluxcd-flagger-architecture.png)

```
Developer
   |
   v
Push YAML to GitHub Repo
   |
   v
GitRepository (FluxCD)
   |
   v
Flux Controller (kustomization, helmrelease)
   |
   v
Kubernetes Cluster
   |
   v
HelmRelease (Flagger watches this)
   |
   v
Canary Deployment (Flagger shifts traffic)
   |
   v
Prometheus (monitors metrics)
```

---

##  Pre-requisites

- Kubernetes cluster (AWS, GKE, etc.)
- GitHub repository with proper structure
- Optional: Prometheus installed for monitoring

---

##  Setup Guide

### 1. Bootstrap FluxCD

refer to README.md page in flux-cd folder in git repo.
We have set up the flux-cd using terraform, this set up would bootstrap fluxcd with gitrepo mentioned in the terraform variables file.

for more information about flux-cd please refer the original documentaion page.

https://fluxcd.io/flux/get-started/

---

git repo structure

├── clusters/
│   └── scout-gitops-aws-dev/
│       ├── flux-system/
│       ├── namespace-flagger-kustomization.yaml
        ├── flagger-kustomization.yaml
│       
├── apps/
│   └── flagger/
        ├── helm-release.yaml
        ├── helm-repository.yaml
		├── kustomization.yaml




### 2. Add Flagger HelmRepository and HelmRelease

Create a HelmRepository under `flagger-system`:

```yaml

apiVersion: source.toolkit.fluxcd.io/v1
kind: HelmRepository
metadata:
  name: flagger
  namespace: flagger-system
spec:
  url: https://flagger.app
  interval: 10m
```

Create a HelmRelease under `flagger-system`:

```yaml

apiVersion: helm.toolkit.fluxcd.io/v2
kind: HelmRelease
metadata:
  name: flagger
  namespace: flagger-system
spec:
  releaseName: flagger
  chart:
    spec:
      chart: flagger
      version: "1.38.0"
      sourceRef:
        kind: HelmRepository
        name: flagger
  interval: 5m
  install:
    crds: Create
  upgrade:
    crds: CreateReplace
  values:
    meshProvider: kubernetes
    prometheus:
      install: false
    metricsServer: "http://prometheus-operator-kube-p-prometheus.o11y:9090"
```

---


## Monitoring with Prometheus

Flagger requires metrics to make decisions. You can use Prometheus via:

```yaml
  values:
    prometheus:
      install: false
    metricsServer: "http://prometheus-service.namespace:9090"
```

Ensure your Prometheus setup is reachable within the cluster.

---

## Usage Guide

- Make changes in your Git repository (e.g., update image tag).
- Commit and push to `feature` branch, get the PR reviewed and merge it with main branch. dont push changes to main branch directly without a review by peer. 
- Flux will sync changes and apply them automatically on Kubernetes cluster.
- Flagger will detect changes to HelmRelease and start a canary deployment - Todo

You can observe the rollout using:

```bash
kubectl -n flagger-system logs deploy/flagger
```

---

## Troubleshooting

- Ensure HelmRepository is in the correct namespace and referenced properly.
- Check if Flux controllers are healthy:  
  `flux get all -A`

---

## References

- [FluxCD Documentation](https://fluxcd.io/)
- [Flagger Documentation](https://docs.flagger.app/)
- [GitOps Toolkit](https://toolkit.fluxcd.io/)
- [Helm Charts](https://artifacthub.io/packages/helm/flagger/flagger)
