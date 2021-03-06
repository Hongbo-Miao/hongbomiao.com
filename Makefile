# bin
setup:
	sh bin/setup.sh
build:
	sh bin/build.sh
clean:
	sh bin/clean.sh
setup-kubernetes:
	sh bin/setup-kubernetes.sh

# Docker
docker-build:
	docker build --file=web/Dockerfile --tag=hm-web .
	docker build --file=api-node/Dockerfile.development --tag=hm-api-node-dev .
	docker build --file=api-node/Dockerfile --tag=hm-api-node .
	docker build --file=api-go/build/package/Dockerfile.api-server --tag=hm-api-server .
	docker build --file=api-go/build/package/Dockerfile.grpc-server --tag=hm-grpc-server .
docker-run:
	docker run -p 80:80 web
	docker run -p 5000:5000 --name=hm_api_node_dev --rm --env-file=./api/.env.development.local.example.docker hm-api-node-dev
	docker run -p 5000:5000 --name=hm_api_node --rm --env-file=./api/.env.production.local.example hm-api-node
	docker run -p 5000:5000 --name=hm_api_go --rm --env=APP_ENV=production hm-api-server
	docker run -p 5000:5000 --name=hm_api_go_grpc --rm --env=APP_ENV=production --env=GRPC_HOST=0.0.0.0 hm-grpc-server
docker-sh:
	docker run --rm -it hm-api-server sh
docker-ps:
	docker ps
docker-ps-all:
	docker ps --all
docker-prune:
	docker system prune

# Docker Compose
docker-compose-build:
	docker-compose --file=docker-compose.development.yml build
	docker-compose --file=docker-compose.cypress.yml build
docker-compose-up:
	docker-compose --file=docker-compose.development.yml up --detach
	docker-compose --file=docker-compose.cypress.yml up --detach
docker-compose-stop:
	docker-compose --file=docker-compose.development.yml stop
	docker-compose --file=docker-compose.cypress.yml stop
docker-compose-down:
	docker-compose --file=docker-compose.development.yml down --volumes
	docker-compose --file=docker-compose.cypress.yml down --volumes

# minikube
minikube-config:
	minikube config set cpus 4
	minikube config set memory 8192
minikube-start:
	minikube start
minikube-start-hyperkit:
	minikube start --driver=hyperkit
minikube-start-virtualbox:
	minikube start --driver=virtualbox
minikube-enable-ingress:
	minikube addons enable ingress
minikube-mount:
	minikube mount ./kubernetes/data:/data
minikube-delete:
	minikube delete
minikube-dashboard:
	minikube dashboard
minikube-ip:
	minikube ip

# kind
kind-create:
	kind create cluster --name=west --config=kubernetes/kind/west-cluster-config.yaml
	kind create cluster --name=east --config=kubernetes/kind/east-cluster-config.yaml
kind-delete:
	kind delete cluster --name=west
	kind delete cluster --name=east
kind-list-clusters:
	kind get clusters
kubectl-get-context-info:
	kubectl cluster-info --context kind-west
kubectl-get-contexts:
	kubectl config get-contexts
kubectl-get-current-context:
	kubectl config current-context
kubectl-use-context:
	kubectl config use-context k3d-west
	kubectl config use-context k3d-east

# k3d
k3d-create:
	k3d cluster create west --config=kubernetes/k3d/west-cluster-config.yaml
	k3d cluster create east --config=kubernetes/k3d/west-cluster-config.yaml
k3d-list:
	k3d cluster list
k3d-delete:
	k3d cluster delete west
	k3d cluster delete east

# Kubernetes
kubectl-apply:
	kubectl apply --filename=kubernetes/config/hm-namespace.yaml
	kubectl apply --filename=kubernetes/config
kubectl-apply-with-linkerd:
	linkerd inject - | kubectl apply --filename=kubernetes/config
kubectl-delete:
	kubectl delete --filename=kubernetes/config
kubectl-get-pods-all:
	kubectl get pods --all-namespaces
kubectl-get-pods:
	kubectl get pods --namespace=hm
kubectl-get-services-all:
	kubectl get services --all-namespaces
kubectl-get-services:
	kubectl get services --namespace=hm
kubectl-get-services-yaml:
	kubectl get services api-server-service --namespace=hm --output=yaml
kubectl-get-deployments:
	kubectl get deployments --namespace=hm
kubectl-get-deployments-yaml:
	kubectl get deployments api-server-deployment --namespace=hm --output=yaml
kubectl-get-namespaces:
	kubectl get namespaces
kubectl-get-storageclasses:
	kubectl get storageclasses --all-namespaces
kubectl-get-persistentvolumeclaims:
	kubectl get persistentvolumeclaims --all-namespaces
kubectl-get-endpoints:
	kubectl get endpoints api-server-service --namespace=hm
kubectl-get-configmaps-all:
	kubectl get configmaps --all-namespaces
kubectl-get-configmaps:
	kubectl get configmaps --namespace=hm
kubectl-get-configmaps-yaml:
	kubectl get configmaps ingress-nginx-controller --namespace=ingress-nginx --output=yaml
kubectl-get-serviceaccounts:
	kubectl get serviceaccounts
kubectl-logs:
	kubectl logs --follow POD_NAME --namespace=hm
kubectl-sh:
	kubectl exec --stdin --tty POD_NAME --namespace=hm -- sh

kubectl-port-forward-api-go:
	kubectl port-forward service/api-server-service --namespace=hm 5000:5000
kubectl-port-forward-opa:
	kubectl port-forward service/api-server-service --namespace=hm 8181:8181
kubectl-port-forward-opal-client:
	kubectl port-forward service/api-server-service --namespace=hm 7000:7000
kubectl-port-forward-opal-server:
	kubectl port-forward service/opal-server-service --namespace=hm 7002:7002

list-port-forward:
	ps -ef | grep port-forward
kill-port:
	kill -9 PID

# Skaffold:
skaffold:
	skaffold dev

# Linkerd
linkerd-install-control-plane:
	linkerd install --values=kubernetes/linkerd/config.yaml --disable-heartbeat | kubectl apply --filename=-
linkerd-install-control-plane-prod:
	linkerd install --values=kubernetes/linkerd/config.yaml --disable-heartbeat --ha | kubectl apply --filename=-
linkerd-install-viz:
	linkerd viz install --set=jaegerUrl=jaeger.linkerd-jaeger:16686 | kubectl apply --filename=-
linkerd-install-jaeger:
	linkerd jaeger install | kubectl apply --filename=-
linkerd-viz-dashboard:
	linkerd viz dashboard &
linkerd-jaeger-dashboard:
	linkerd jaeger dashboard &
linkerd-get-yaml:
	linkerd install --disable-heartbeat > linkerd.yaml
linkerd-inject:
	kubectl get deployments --namespace=hm --output=yaml | linkerd inject - | kubectl apply --filename=-
linkerd-inject-nginx-controller:
	kubectl get deployment ingress-nginx-controller --namespace=ingress-nginx --output=yaml | linkerd inject --ingress - | kubectl apply --filename=-
linkerd-verify-inject-nginx-controller:
	kubectl describe pods/ingress-nginx-controller-xxx --namespace=ingress-nginx | grep "linkerd.io/inject: ingress"
linkerd-check:
	linkerd check
linkerd-check-pre:
	linkerd check --pre
linkerd-check-proxy: # includes linkerd-identity-data-plane
	linkerd check --proxy
linkerd-viz-tap:
	linkerd viz tap deployments/api-server-deployment --namespace=hm
linkerd-viz-tap-json:
	linkerd viz tap deployments/api-server-deployment --namespace=hm --output=json
linkerd-viz-tap-to:
	linkerd viz tap deployments/api-server-deployment --namespace=hm --to=deployment/grpc-server-deployment
linkerd-viz-tap-to-path:
	linkerd viz tap deployments/api-server-deployment --namespace=hm --to=deployment/grpc-server-deployment --path=/api.proto.greet.v1.GreetService/Greet
linkerd-viz-top: # shows traffic routes sorted by the most popular paths
	linkerd viz top deployments/api-server-deployment --namespace=hm
linkerd-viz-stat:
	linkerd viz stat deployments --namespace=hm
linkerd-viz-stat-wide: # includes extra READ_BYTES/SEC and WRITE_BYTES/SEC
	linkerd viz stat deployments --namespace=hm --output=wide
linkerd-viz-stat-from-to:
	linkerd viz stat --namespace=hm deployments/api-server-deployment --to deployments/grpc-server-deployment
linkerd-viz-stat-all-from: # views the metrics for traffic to all deployments that comes from api-server-deployment
	linkerd viz stat --namespace=hm deployments --from deployments/api-server-deployment
linkerd-viz-edges-deployments:
	linkerd viz edges deployments --namespace=hm
linkerd-viz-edges-deployments-json:
	linkerd viz edges deployments --namespace=hm --output=json
linkerd-viz-edges-pods:
	linkerd viz edges pods --namespace=hm
linkerd-viz-edges-pods-json:
	linkerd viz edges pods --namespace=hm --output=json
linkerd-viz-routes:
	linkerd viz routes deployments/api-server-deployment --namespace=hm
linkerd-viz-routes-wide: # includes EFFECTIVE_SUCCESS, EFFECTIVE_RPS, ACTUAL_SUCCESS, ACTUAL_RPS
	linkerd viz routes deployments/api-server-deployment --namespace=hm --to deployments/grpc-server-deployment --output=wide
linkerd-viz-routes-json:
	linkerd viz routes deployments/api-server-deployment --namespace=hm --output=json
linkerd-get-secrets:
	kubectl get secrets --namespace=linkerd
linkerd-get-secret-yaml:
	kubectl get secrets --namespace=linkerd linkerd-identity-issuer --output=yaml

# Argo CD
argocd-install:
	kubectl create namespace argocd
	kubectl apply --namespace=argocd --filename=https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
argocd-check:
	for deploy in "dex-server" "redis" "repo-server" "server"; \
	  do kubectl --namespace=argocd rollout status deployments/argocd-$${deploy}; \
	done
argocd-ui:
	kubectl port-forward service/argocd-server --namespace=argocd 31026:443 &
argocd-get-password: # username: admin
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
argocd-login:
	$(eval ARGOCD_PASSWORD := $(shell kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo))
	argocd login localhost:31026 --username=admin --password=$(ARGOCD_PASSWORD) --insecure
argocd-enable-auth-sync:
	argocd app set hm-application --sync-policy=automated
argocd-disable-auth-sync:
	argocd app set hm-application --sync-policy=none
argocd-diff:
	argocd app diff hm-application --local=kubernetes/config
argocd-apply:
	kubectl apply --filename=argocd/hm-application.yaml
argocd-sync:
	kubectl apply --filename=argocd/hm-application.yaml
	argocd app sync hm-application
argocd-sync-local:
	kubectl apply --filename=argocd/hm-application.yaml
	argocd app sync hm-application --local=kubernetes/config
argocd-list:
	argocd app list
argocd-delete:
	argocd app delete hm-application --yes

kubectl-get-pods-argocd:
	kubectl get pods --namespace=argocd
kubectl-get-rolebindings-argocd:
	kubectl get rolebindings --namespace=argocd
kubectl-describe-rolebinding-argocd:
	kubectl describe rolebinding argocd-application-controller --namespace=argocd
kubectl-get-roles-argocd:
	kubectl get roles --namespace=argocd
kubectl-describe-role-argocd:
	kubectl describe role argocd-application-controller --namespace=argocd

# Kafka
zookeeper-start:
	zookeeper-server-start /usr/local/etc/kafka/zookeeper.properties
kafka-start:
	kafka-server-start /usr/local/etc/kafka/server.properties

kafka-topic-create:
	kafka-topics --bootstrap-server=localhost:9092 --create --topic=my-topic --partitions=3 --replication-factor=1
kafka-topic-delete:
	kafka-topics --bootstrap-server=localhost:9092 --delete --topic=my-topic
kafka-topic-list:
	kafka-topics --bootstrap-server=localhost:9092 --list
kafka-topic-describe:
	kafka-topics --bootstrap-server=localhost:9092 --topic=my-topic --describe

kafka-console-producer:
	kafka-console-producer --bootstrap-server=localhost:9092 --topic=my-topic
kafka-console-consumer:
	kafka-console-consumer --bootstrap-server=localhost:9092 --topic=my-topic
kafka-console-consumer-from-beginning:
	kafka-console-consumer --bootstrap-server=localhost:9092 --topic=my-topic --from-beginning
kafka-console-consumer-group:
	kafka-console-consumer --bootstrap-server=localhost:9092 --topic=my-topic --group=my-group

kafka-consumer-group-list:
	kafka-consumer-groups --bootstrap-server=localhost:9092 --list
kafka-consumer-group-describe:
	kafka-consumer-groups --bootstrap-server=localhost:9092 --describe --group=my-group
kafka-consumer-group-reset-offset-to-earliest:
	kafka-consumer-groups --bootstrap-server=localhost:9092 --group=my-group --topic=my-topic --reset-offsets --to-earliest --execute
kafka-consumer-group-reset-offset-shift-by:
	kafka-consumer-groups --bootstrap-server=localhost:9092 --group=my-group --topic=my-topic --reset-offsets --shift-by=-1 --execute

# Prometheus
prom-curl:
	curl http://localhost:9464/metrics
prom-test:
	docker build --file=Dockerfile.prometheus.test .

# Lint
hadolint:
	hadolint $$(git ls-files '**/Dockerfile*')
shellcheck:
	shellcheck $$(git ls-files '**/*.sh')
kubeconform:
	kubeconform -kubernetes-version=1.21.0 $$(git ls-files 'kubernetes/config/*.yaml')
