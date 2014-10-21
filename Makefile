INSTALL_PATH?=/usr/local

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	ln -sf ${PWD}/bin/* ${INSTALL_PATH}/bin
	ln -sf ${PWD}/remote-scripts/* ${INSTALL_PATH}/bin
	ln -sf ${PWD}/corrxml/corrxml.sh ${INSTALL_PATH}/bin
