#!/bin/bash
CLUSTER=careerpilot
SERVICES=(user_service cv_service job_service interview_service roadmap_service gateway)

for svc in "${SERVICES[@]}"; do
  echo "Building $svc..."
  docker build -t ${svc}:latest ./apps/services/${svc}
  echo "Loading $svc into kind..."
  kind load docker-image ${svc}:latest --name $CLUSTER
done