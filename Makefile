INSTALL_PATH?=/usr/local

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	ln -sf bin/* ${INSTALL_PATH}/bin
	ln -sf remote-scripts/* ${INSTALL_PATH}/bin
	ln -sf corrxml/corrxml.sh ${INSTALL_PATH}/bin
