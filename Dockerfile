FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# 기본 환경 설정
ENV DEBIAN_FRONTEND=noninteractive
ENV PIP_PREFER_BINARY=1
ENV PYTHONUNBUFFERED=1

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    libgl1 \
    && ln -sf /usr/bin/python3.10 /usr/bin/python \
    && ln -sf /usr/bin/pip3 /usr/bin/pip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 필요한 Python 패키지 설치
RUN pip install -r /tmp/requirements.txt

# 작업 디렉토리 설정
WORKDIR /comfyui

# 필요한 파일들 복사
COPY src/rp_handler.py /comfyui/
COPY start.sh /comfyui/
RUN chmod +x /comfyui/start.sh

# 시작 스크립트 내용
RUN echo '#!/bin/bash\n\
cd /workspace/ComfyUI\n\
python main.py --port 8188 &\n\
sleep 10\n\
python /comfyui/rp_handler.py\n\
' > /comfyui/start.sh

# 실행 권한 부여
RUN chmod +x /comfyui/start.sh

# RunPod 핸들러를 직접 실행
CMD ["/comfyui/start.sh"]