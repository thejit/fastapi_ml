FROM python:3.8

WORKDIR /app

RUN apt-get -y update  && apt-get install -y \
  gcc \
  g++ \
  python3-dev \
  apt-utils \
  python-dev \
  build-essential \
&& rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade setuptools
RUN pip install --upgrade pip
RUN pip install \
    cython==0.29.28 \
    numpy==1.22.3 \
    pystan==2.19.1.1

RUN pip install \
    pandas \
    convertdate \
    lunarcalendar \
    holidays \
    tqdm \
    matplotlib

#If you are using a VM, be aware that you will need at least 4GB of memory to install prophet, 
#and at least 2GB of memory to use prophet.
#If you are using docker-for-windows or docker-for-mac you can easily increase it from the Whale 🐳 icon in the task bar, 
#then go to Preferences -> Resource -> Advanced:
#
RUN pip install fbprophet

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .

CMD gunicorn -w 3 -k uvicorn.workers.UvicornWorker main:app --bind 0.0.0.0:$PORT