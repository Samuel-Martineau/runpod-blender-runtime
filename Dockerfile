FROM nytimes/blender:2.82-gpu-ubuntu18.04

COPY start.sh /
RUN chmod +x /start.sh

CMD ["/start.sh"]
