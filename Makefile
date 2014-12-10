INSTALL_PATH?=/usr/local

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	install -m 0775 bin/* ${INSTALL_PATH}/bin
	install -m 0775 remote-scripts/* ${INSTALL_PATH}/bin
	install -m 0775 corrxml/corrxml.sh ${INSTALL_PATH}/bin
