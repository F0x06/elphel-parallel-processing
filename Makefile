INSTALL_PATH?=/usr/local

all: install

install:
	cp bin/* ${INSTALL_PATH}/bin
	cp remote-scripts/* ${INSTALL_PATH}/bin
	cp corrxml/corrxml.sh ${INSTALL_PATH}/bin
