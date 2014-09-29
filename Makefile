INSTALL_PATH?=~

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	ln bin/* ${INSTALL_PATH}/bin
	ln remote-scripts/* ${INSTALL_PATH}/bin
	ln corrxml/corrxml.sh ${INSTALL_PATH}/bin
