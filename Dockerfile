FROM debian:jessie
RUN \
  apt-get update -y && \
  apt-get install -y \
    build-essential=11.7 \
    curl=7.38.0-4+deb8u2 \
    git=1:2.1.4-2.1 \
    tmux=1.9-6 \
    vim=2:7.4.488-7  \
    sudo=1.8.10p3-1+deb8u2 \
  && \
  apt-get clean -y && \
  apt-get autoclean -y

RUN useradd dev -N -m -G sudo

# terminal setup
RUN git clone --depth=1 https://github.com/Bash-it/bash-it.git /home/dev/.bash_it
COPY config/bash_profile /home/dev/.bash_profile
COPY config/tmux.conf /home/dev/.tmux.conf

# vim setup
RUN \
  mkdir -p /home/dev/.vim/autoload /home/dev/.vim/bundle && \
  curl -LSso /home/dev/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

RUN git clone --depth=1 https://github.com/terryma/vim-multiple-cursors.git /home/dev/.vim/bundle/vim-multiple-cursors
RUN git clone --depth=1 https://github.com/bling/vim-airline.git /home/dev/.vim/bundle/vim-airline
RUN git clone --depth=1 https://github.com/tpope/vim-surround.git /home/dev/.vim/bundle/vim-surround
RUN git clone --depth=1 https://github.com/kien/ctrlp.vim.git /home/dev/.vim/bundle/vim-ctrlp

COPY config/vimrc /home/dev/.vimrc

# final setup
RUN chown -R dev:users /home/dev
USER dev
WORKDIR /home/dev
CMD bash --login -c "/usr/bin/tmux"
