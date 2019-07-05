ARG SES_DL=https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v416_linux_x64.tar.gz
ARG SDK_DL=https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.2.0_9412b96.zip
FROM ubuntu:18.04
ARG SES_DL
ARG SDK_DL
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 python-pip xvfb curl wget unzip gcc ruby-full libc6-dev-i386 libc6-dev-i386-amd64-cross && \
	pip install gcovr nrfutil && \
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

RUN curl https://www.nordicsemi.com/-/media/Software-and-other-downloads/Desktop-software/nRF-command-line-tools/sw/Versions-10-x-x/nRFCommandLineTools1021Linuxamd64tar.gz -o nrftools.tar.gz && \
	tar -xvzf nrftools.tar.gz ./nRF-Command-Line-Tools_10_2_1_Linux-amd64.tar.gz && \
	rm nrftools.tar.gz && \
	tar -xvzf nRF-Command-Line-Tools_10_2_1_Linux-amd64.tar.gz ./mergehex && \
	rm nRF-Command-Line-Tools_10_2_1_Linux-amd64.tar.gz
ENV PATH="/mergehex:/nrfjprog:$PATH"

CMD ["/ses/bin/emBuild"]
