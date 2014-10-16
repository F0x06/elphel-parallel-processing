INSTALL_PATH?=/usr/local

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	ln -f bin/* ${INSTALL_PATH}/bin
	ln -f remote-scripts/* ${INSTALL_PATH}/bin
	ln -f corrxml/corrxml.sh ${INSTALL_PATH}/bin
