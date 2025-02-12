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

# 작업 디렉토리 설정
WORKDIR /app

# 필요한 파일들 복사
COPY src/ /app/
COPY requirements.txt /app/

# Python 패키지 설치
RUN pip install -r requirements.txt

# 스크립트 실행 권한 부여
RUN chmod +x /app/start.sh
RUN chmod +x /app/restore_snapshot.sh

# 스냅샷 복원 (실행 실패해도 빌드 중단하지 않도록 설정)
RUN /app/restore_snapshot.sh || true

# RunPod 핸들러를 직접 실행
CMD ["/app/start.sh"]