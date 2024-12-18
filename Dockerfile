FROM python:3

# Metadata for maintainers
LABEL maintainer="Greg Taylor <gtaylor@gc-taylor.com>"

# Set up directories and install essential tools
RUN mkdir -p /harness/wheeldir /opt/app/src && \
    pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy wheel files and requirements
COPY wheeldir /opt/app/wheeldir
COPY *requirements.txt /opt/app/src/

# Install dependencies from wheel directory
RUN pip install --no-cache-dir --no-index --find-links=/opt/app/wheeldir -r /opt/app/src/requirements.txt && \
    pip install --no-cache-dir --no-index --find-links=/opt/app/wheeldir -r /opt/app/src/test-requirements.txt

# Copy application source code
COPY . /opt/app/src/

# Set the working directory and install the app
WORKDIR /opt/app/src
RUN python setup.py install

# Expose the application port
EXPOSE 5000

# Run the application
CMD ["dronedemo"]
