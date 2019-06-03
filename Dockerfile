ARG SES_DL=https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v416_linux_x64.tar.gz
ARG SDK_DL=https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.2.0_9412b96.zip
FROM ubuntu:18.04
ARG SES_DL
ARG SDK_DL
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 python-pip xvfb curl wget unzip gcc ruby-full && \
	pip install gcovr && \
	gem install rake ceedling

RUN wget $SES_DL -qO ses.tar.gz && \
	tar -zxvf ses.tar.gz && \
	printf 'yes\n' | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
	rm ses.tar.gz && \
	rm -rf arm_segger_embedded_studio_*

RUN wget -qO nRF5-SDK.zip $SDK_DL && \
    unzip nRF5-SDK.zip && \
    rm nRF5-SDK.zip && \
	mv $(find ./ -name nRF5_* -type d -print -quit) /sdk

RUN curl https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF5-command-line-tools/sw/nRF-Command-Line-Tools_9_8_1_Linux-x86_64.tar -o nrftools.tar && \
	tar -xvf nrftools.tar && \
	rm nrftools.tar
ENV PATH="/mergehex:/nrfjprog:$PATH"

CMD ["/ses/bin/emBuild"]