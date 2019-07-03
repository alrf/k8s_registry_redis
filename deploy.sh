#!/usr/bin/env bash

# AWS ACM: arn:aws:acm:xxxxxxxxxxx
export ACM="arn:aws:acm:xxxxxxxxxxx"
# domain name for your docker registry without schema (http/https): your.docker-registry.com
export DOMAIN="your.docker-registry.com"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
envsubst < ./ingress-nginx/service-nlb.yaml.tmpl > /tmp/service-nlb.yaml
kubectl apply -f /tmp/service-nlb.yaml

kubectl apply -f ./common/namespace.yaml

kubectl apply -f ./redis/deployment.yaml
kubectl apply -f ./redis/service.yaml

kubectl apply -f ./registry/pvc.yaml
kubectl apply -f ./registry/deployment.yaml
kubectl apply -f ./registry/service.yaml
envsubst < ./registry/ingress.yaml.tmpl > /tmp/ingress.yaml
kubectl apply -f /tmp/ingress.yaml
kubectl apply -f ./registry/cronjob.yaml
