FROM ubuntu

# python and relevant tools
RUN apt-get update && apt-get install -y \ 
    build-essential \
    python3 \
    python \
    python-dev \
    libxml2-dev \
    libxslt-dev \
    libssl-dev \
    zlib1g-dev \
    libyaml-dev \
    libffi-dev \
    python-pip

# General dev tools
RUN apt-get install -y git

# Latest versions of python tools via pip
RUN pip install --upgrade pip \
                          virtualenv \
                          requests

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt ./
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:maxmind/ppa
RUN apt update
RUN apt install -y libgeoip1 libgeoip-dev geoip-bin
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "gunicorn", "geoip:app", "-b", "0.0.0.0:2626", "-w", "2", "--worker-class=\"egg:meinheld#gunicorn_worker\"" ]

EXPOSE 2626
