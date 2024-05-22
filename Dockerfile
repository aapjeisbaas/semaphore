FROM semaphoreui/semaphore:latest
USER root
RUN apk add bash build-base python3-dev krb5-dev libssh-dev libssh2-dev oniguruma-dev aws-cli openssl py3-pip git vim rsync
COPY requirements.txt .
COPY requirements.yml .
RUN pip3 install -r requirements.txt ; \
    ansible-galaxy collection install -r requirements.yml -p /usr/share/ansible/collections ; \
    ansible-galaxy role install -r requirements.yml -p /usr/share/ansible/roles
COPY pip-installer.sh .
RUN ./pip-installer.sh
RUN pip3 install 'urllib3<2'
#USER semaphore