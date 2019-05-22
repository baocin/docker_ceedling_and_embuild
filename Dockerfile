FROM ubuntu:18.04
WORKDIR /usr/share/nRF5-SDK
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl wget unzip python-pip git zip bash-completion ruby-full && \
	pip install nrfutil && \
	gem install ceedling

RUN Xvfb :1 -screen 0 1024x768x16 &

RUN curl -X POST -F "fileid=8F19D314130548209E75EFFADD9348DB" https://www.nordicsemi.com/api/sitecore/Products/DownloadPlatform -o nrftools.tar && \
	tar -xvf nrftools.tar && \
	rm nrftools.tar
ENV PATH="/mergehex:/nrfjprog:$PATH"

RUN wget https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v416_linux_x64.tar.gz -qO ses.tar.gz && \
	tar -zxvf ses.tar.gz && \
	printf 'yes\n' | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
	rm ses.tar.gz && \
	rm -rf arm_segger_embedded_studio_*

RUN wget -qO nRF5-SDK.zip https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.2.0_9412b96.zip && \
    unzip nRF5-SDK.zip && \
    rm nRF5-SDK.zip && \
    sed -i "s|gcc-arm-none-eabi-6-2017-q2-update|${GNU_NAME}|g" /usr/share/nRF5-SDK/nRF5_SDK_15.2.0_9412b96/components/toolchain/gcc/Makefile.posix && \
    sed -i "s|6.3.1|${GNU_VERSION}|g" /usr/share/nRF5-SDK/nRF5_SDK_15.2.0_9412b96/components/toolchain/gcc/Makefile.posix

ENV SDK_ROOT="/usr/share/nRF5-SDK/nRF5_SDK_15.2.0_9412b96"

RUN curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

CMD ["/ses/bin/emBuild"]