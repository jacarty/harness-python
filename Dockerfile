FROM python:3

LABEL maintainer="Greg Taylor <gtaylor@gc-taylor.com>"

RUN mkdir -p /harness/wheeldir /opt/app/src && \
    pip install --no-cache-dir --upgrade pip setuptools wheel

COPY wheeldir /opt/app/wheeldir
COPY *requirements.txt /opt/app/src/

# Install dependencies from wheeldir or fallback to PyPI if necessary
RUN pip install --no-cache-dir --no-index --find-links=/opt/app/wheeldir -r /opt/app/src/requirements.txt || \
    pip install --no-cache-dir -r /opt/app/src/requirements.txt

RUN pip install --no-cache-dir --no-index --find-links=/opt/app/wheeldir -r /opt/app/src/test-requirements.txt || \
    pip install --no-cache-dir -r /opt/app/src/test-requirements.txt

COPY . /opt/app/src/
WORKDIR /opt/app/src
RUN python setup.py install

EXPOSE 5000
CMD ["dronedemo"]
