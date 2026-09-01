FROM ubuntu:26.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gcc-riscv64-unknown-elf python3 python3-venv python3-pip make git

CMD ["/bin/bash"]
