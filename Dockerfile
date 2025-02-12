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
RUN pip install runpod requests

# 작업 디렉토리 설정
WORKDIR /comfyui

# 스냅샷 및 기타 파일 복사
COPY *snapshot*.json /
COPY src/restore_snapshot.sh /
RUN chmod +x /restore_snapshot.sh && /restore_snapshot.sh

# RunPod 핸들러 복사
COPY src/rp_handler.py /

# 시작 스크립트 복사 및 실행 권한 부여
COPY src/start.sh /
RUN chmod +x /start.sh

# RunPod 핸들러를 직접 실행
CMD ["python", "/rp_handler.py"]