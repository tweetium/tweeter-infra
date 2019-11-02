FROM williamyeh/ansible:ubuntu18.04-onbuild

RUN ansible-galaxy install geerlingguy.docker geerlingguy.pip
