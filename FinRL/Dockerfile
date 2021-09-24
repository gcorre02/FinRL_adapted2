FROM stablebaselines/rl-baselines3-zoo:0.11.0a4

COPY finrl_app /tmp/app/

RUN apt-get update && apt-get install python3.8 cmake libopenmpi-dev python3-dev zlib1g-dev libgl1-mesa-glx -y

RUN pip install stable-baselines3[extra]


RUN pip install /tmp/app/. --ignore-installed PyYAML


#new, without it it works
RUN pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html



RUN pip install jupyterlab


WORKDIR /home
# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''","--NotebookApp.password=''","--allow-root"]