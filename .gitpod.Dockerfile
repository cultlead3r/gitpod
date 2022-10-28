FROM archlinux/archlinux:base
# update all the packages
RUN yes | pacman -Sy
# update mirrors
RUN yes | pacman --noconfirm -S reflector rsync curl
RUN reflector -c US --latest 20 --sort rate --save /etc/pacman.d/mirrorlist

RUN yes | pacman -Syuu

# install gitpod dependencies
RUN yes | pacman --noconfirm -S sudo git-lfs 
# install gitpod user
RUN useradd -l -u 33333 -G wheel -md /home/gitpod -s /bin/bash -p gitpod gitpod 
# passwordless sudo for users in the 'sudo' group
RUN sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
# To emulate the workspace-session behavior within dazzle build env
RUN mkdir /workspace && chown -hR gitpod:gitpod /workspace

RUN git lfs install --system --skip-repo

# random utilities
RUN yes | pacman --noconfirm -S nodejs npm neovim unzip gcc docker

# setup nvim
RUN git clone https://github.com/cultlead3r/nvim /home/gitpod/.config/nvim
# RUN nvim --headless +PackerSync +qall
# RUN nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' 

# setup repo
WORKDIR /workspace
USER gitpod
# COPY package*.json /workspace/ 
# COPY requirements.txt /workspace/ 
# COPY . /workspace/
# RUN npm install
# RUN pip install -r requirements.txt
