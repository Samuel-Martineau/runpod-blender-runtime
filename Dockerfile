FROM runpod/kasm-docker:cuda11

RUN sudo apt-get update && sudo apt-get install -y python3-numpy python3-pandas blender
