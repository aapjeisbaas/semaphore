FROM semaphoreui/semaphore:latest
USER root
ENV VERIFY_CHECKSUM=false
# Install kubectl, helm and oc

WORKDIR /root/
RUN apk add --no-cache curl gcompat bash build-base python3-dev krb5-dev libssh-dev libssh2-dev oniguruma-dev aws-cli openssl py3-pip git vim rsync wget aws-cli
RUN curl -fsSL -o openshift-client-linux.tar.gz "https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-4.16.3.tar.gz" ;\
    tar -xvzf openshift-client-linux.tar.gz ;\
    chmod +x ./oc ;\
    mv ./oc /usr/local/bin/oc ;\
    chmod +x ./kubectl ;\
    mv ./kubectl /usr/local/bin/kubectl ;\
    rm ./openshift-client-linux.tar.gz ;\
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 ;\
    chmod +x get_helm.sh ;\
    ./get_helm.sh ;\
    rm ./get_helm.sh

COPY requirements.txt .
COPY requirements.yml .
RUN pip3 install -r requirements.txt ; \
    ansible-galaxy collection install -r requirements.yml -p /usr/share/ansible/collections ; \
    ansible-galaxy role install -r requirements.yml -p /usr/share/ansible/roles
COPY pip-installer.sh .
RUN ./pip-installer.sh
RUN pip3 install 'urllib3<2' firewall
#USER semaphore

WORKDIR /home/semaphore