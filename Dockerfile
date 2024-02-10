FROM runpod/kasm-docker:cuda11

RUN sudo apt-get update
RUN sudo apt-get install -y pipenv

RUN wget https://download.blender.org/release/Blender4.0/blender-4.0.2-linux-x64.tar.xz -O blender.tar.xz
RUN tar -xvf blender.tar.xz
RUN rm blender.tar.xz
RUN sudo mv blender-* /usr/local/lib/blender
RUN sudo ln -s /usr/local/lib/blender/blender /usr/local/bin/blender
