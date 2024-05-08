FROM semaphoreui/semaphore:latest
USER root
RUN apk add bash build-base python3-dev krb5-dev libssh-dev libssh2-dev oniguruma-dev
COPY requirements.txt .
COPY requirements.yml .
RUN apk add py3-pip git vim ; pip3 install -r requirements.txt ; \
    ansible-galaxy collection install -r requirements.yml -p /usr/share/ansible/collections ; \
    ansible-galaxy role install -r requirements.yml -p /usr/share/ansible/roles
RUN apk add vim rsync
COPY pip-installer.sh .
RUN ./pip-installer.sh
#USER semaphore