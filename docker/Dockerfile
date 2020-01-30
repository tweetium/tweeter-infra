FROM williamyeh/ansible:ubuntu18.04-onbuild

RUN apt-get update && apt-get install -y \
  # Needed locally for brianshumate.nomad role.
  python3 \
  # Needed to install netaddr, etc.
  python-pip \
  # Needed to use pip module, see:
  # https://github.com/ansible/ansible/issues/47361#issuecomment-431705748
  python3-pip \
  curl

RUN pip install netaddr

# Install the terraform and nomad binary
RUN apt-get update && apt-get install -y unzip wget && \
  \
  mkdir -p /tmp/downloads && \
  \
  wget https://releases.hashicorp.com/terraform/0.12.13/terraform_0.12.13_linux_amd64.zip && \
  unzip terraform_0.12.13_linux_amd64.zip -d /tmp/downloads && \
  mv /tmp/downloads/terraform /usr/local/bin/terraform && \
  rm terraform_0.12.13_linux_amd64.zip && \
  \
  wget https://releases.hashicorp.com/nomad/0.10.2/nomad_0.10.2_linux_amd64.zip && \
  unzip nomad_0.10.2_linux_amd64.zip -d /tmp/downloads && \
  # Renamed since usage should be wrapped with the nomad.sh script.
  mv /tmp/downloads/nomad /usr/local/bin/nomad-real && \
  rm nomad_0.10.2_linux_amd64.zip

# Install the packer binary
RUN wget https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip && \
  unzip packer_1.5.1_linux_amd64.zip && \
  mv packer /usr/local/bin/packer && \
  rm packer_1.5.1_linux_amd64.zip

# Install mitogen, an ansible plugin used for speedup.
RUN wget https://networkgenomics.com/try/mitogen-0.2.9.tar.gz && \
  tar -xf mitogen-0.2.9.tar.gz && \
  rm mitogen-0.2.9.tar.gz && \
  mv mitogen-0.2.9 /usr/lib/

# Install 3rd-party roles
RUN ansible-galaxy install \
  brianshumate.nomad \
  brianshumate.consul \
  geerlingguy.docker \
  geerlingguy.pip

WORKDIR /infra

# Add alias for `nomad` which routes to nomad.sh in scripts
RUN ln -s /infra/scripts/nomad.sh /usr/local/bin/nomad
