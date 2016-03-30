#!/bin/bash
set -e

# parallel -j $(nproc) $1 'pip3 --no-cache-dir install --upgrade' git+https://github.com/{.}.git ::: \
#   msgpack/msgpack-python \
#   \
#   pycqa/pycodestyle GreenSteam/pep257 pyflakes/pyflakes \
#   \
#   pycqa/flake8 openstack-dev/hacking Robpol86/flake8-pep257 \
#   public/flake8-import-order zheller/flake8-quotes yandex-sysmon/flake8-double-quotes \
#   \
#   flintwork/mccabe rubik/radon \
#   \
#   hhatto/autopep8 myint/autoflake timothycrosley/isort myint/docformatter myint/pyformat

pip3 --no-cache-dir install --upgrade \
  git+https://github.com/neovim/python-client.git \
  git+https://github.com/msgpack/msgpack-python.git \
  \
  git+https://github.com/pycqa/pycodestyle.git \
  git+https://github.com/GreenSteam/pep257.git \
  git+https://github.com/pyflakes/pyflakes.git \
  \
  git+https://github.com/pycqa/pylint.git \
  git+https://github.com/pycqa/astroid.git \
  \
  git+https://gitlab.com/pycqa/flake8.git \
  git+https://github.com/public/flake8-import-order.git \
  git+https://github.com/Robpol86/flake8-pep257.git \
  git+https://github.com/schlamar/flake8-todo.git \
  git+http://github.com/openstack-dev/hacking.git \
  \
  git+https://github.com/flintwork/mccabe.git \
  git+https://github.com/rubik/radon.git \
  git+https://github.com/rubik/xenon.git \
  \
  git+https://github.com/hhatto/autopep8.git \
  git+https://github.com/myint/autoflake.git \
  git+https://github.com/timothycrosley/isort.git \
  git+https://github.com/myint/docformatter.git \
  git+https://github.com/myint/pyformat.git
