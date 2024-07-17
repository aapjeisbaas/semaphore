FROM semaphoreui/semaphore:latest
USER root

# Install kubectl, helm and oc
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" ;\
    chmod +x ./kubectl ;\
    mv ./kubectl /usr/local/bin/kubectl ;\
    curl "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-amd64-rhel9-4.16.2.tar.gz" -o "openshift-client-linux.tgz" ;\
    tar -xvf ./openshift-client-linux.tgz ;\
    chmod +x ./oc ;\
    mv ./oc /usr/local/bin/oc ;\
    rm ./openshift-client-linux.tgz ;\
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 ;\
    chmod 700 get_helm.sh ;\
    ./get_helm.sh ;\
    rm ./get_helm.sh

RUN apk add bash build-base python3-dev krb5-dev libssh-dev libssh2-dev oniguruma-dev aws-cli openssl py3-pip git vim rsync wget
COPY requirements.txt .
COPY requirements.yml .
RUN pip3 install -r requirements.txt ; \
    ansible-galaxy collection install -r requirements.yml -p /usr/share/ansible/collections ; \
    ansible-galaxy role install -r requirements.yml -p /usr/share/ansible/roles
COPY pip-installer.sh .
RUN ./pip-installer.sh
RUN pip3 install 'urllib3<2' firewall
#USER semaphore