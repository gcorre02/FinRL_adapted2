FROM stablebaselines/rl-baselines3-zoo:0.11.0a4
ARG TORCH_CUDA_ARCH_LIST="8.6"
COPY finrl_app /tmp/app/
RUN apt-get update && apt-get install python3.8 cmake libopenmpi-dev python3-dev zlib1g-dev libgl1-mesa-glx -y
#new
RUN conda update -n base -c defaults conda
RUN pip install stable-baselines3[extra]
RUN pip install /tmp/app/. --ignore-installed PyYAML


#new, without it it works
RUN pip install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
#new
RUN conda install -c conda-forge ray-rllib -y
RUN conda install -c conda-forge pyfolio -y
RUN pip install git+https://github.com/AI4Finance-LLC/ElegantRL.git -y
RUN pip install jupyterlab


WORKDIR /home
# Add Tini. Tini operates as a process subreaper for jupyter. This prevents kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]


CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--NotebookApp.token=''","--NotebookApp.password=''","--allow-root"]