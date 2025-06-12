pipeline {
  agent any
  environment {
    IMAGE_NAME = 'bodukal/ecomm'
    IMAGE_TAG = "${BUILD_NUMBER}"
    FULL_IMAGE_NAME = "${IMAGE_NAME}:${IMAGE_TAG}"
  }
  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/bodukal/PM2.git'
      }
    }
    stage('Build JAR with Maven') {
      steps {
        sh 'mvn clean package -DskipTests'
      }
      post {
        success {
          archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
        }
      }
    }
    stage('Build & Push Docker Image') {
      steps {
        script {
          withCredentials([
            usernamePassword(
              credentialsId: 'docker-hub',
              usernameVariable: 'DOCKER_CREDENTIALS_USR',
              passwordVariable: 'DOCKER_CREDENTIALS_PSW'
            )
          ]) {
            sh """
              # Build Docker image with build number
              docker build -t ${FULL_IMAGE_NAME} .
              docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest
              
              # Authenticate and push to Docker Hub
              echo "${DOCKER_CREDENTIALS_PSW}" | docker login -u "${DOCKER_CREDENTIALS_USR}" --password-stdin
              docker push ${FULL_IMAGE_NAME}
              docker push ${IMAGE_NAME}:latest
              
              # Optional cleanup
              docker rmi ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest || true
            """
          }
        }
      }
    }
    stage('Deploy to Kubernetes') {
      steps {
        script {
          withKubeConfig([credentialsId: 'eks-kubeconfig']) {
            sh """
              kubectl cluster-info
              kubectl apply -f kbs/deployment.yaml
              kubectl apply -f kbs/service.yaml
              kubectl apply -f kbs/ingress.yaml
              kubectl set image deployment/ecomm ecomm=${FULL_IMAGE_NAME}
              kubectl rollout status deployment/ecomm --timeout=300s
              kubectl get pods -l app=ecomm
              kubectl get svc
              echo "🚀 Deployment completed successfully!"
              echo "📊 Check Grafana for metrics: kubectl port-forward -n monitoring svc/prometheus-grafana 3000:80"
            """
          }
        }
      }
    }
  }
  post {
    always {
      cleanWs()
    }
    success {
      echo "✅ Pipeline completed successfully!"
      echo "🏷️  Deployed Image: ${FULL_IMAGE_NAME}"
      echo "🔍 Verify deployment: kubectl get pods -l app=ecomm"
      echo "📈 Monitor in Grafana at http://localhost:3000 (after port-forward)"
    }
    failure {
      echo "❌ Pipeline failed. Please check the logs for details."
      echo "🔧 Debug commands:"
      echo "   kubectl get pods"
      echo "   kubectl describe deployment/ecomm"
      echo "   kubectl logs -l app=ecomm"
    }
  }
}
