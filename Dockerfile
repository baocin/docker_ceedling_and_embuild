FROM ubuntu:18.04
WORKDIR /usr/share/nRF5-SDK
RUN apt-get update && \
	apt-get install -y libx11-6 libfreetype6 libxrender1 libfontconfig1 libxext6 xvfb curl wget unzip ruby-full && \
	gem install rake ceedling

RUN wget https://www.segger.com/downloads/embedded-studio/Setup_EmbeddedStudio_ARM_v416_linux_x64.tar.gz -qO ses.tar.gz && \
	tar -zxvf ses.tar.gz && \
	printf 'yes\n' | DISPLAY=:1 $(find arm_segger_* -name "install_segger*") --copy-files-to /ses && \
	rm ses.tar.gz && \
	rm -rf arm_segger_embedded_studio_*

RUN wget -qO nRF5-SDK.zip https://developer.nordicsemi.com/nRF5_SDK/nRF5_SDK_v15.x.x/nRF5_SDK_15.2.0_9412b96.zip && \
    unzip nRF5-SDK.zip && \
    rm nRF5-SDK.zip

CMD ["/ses/bin/emBuild"]