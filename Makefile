INSTALL_PATH?=/usr/local

all: install

install:
	mkdir -p ${INSTALL_PATH}/bin
	install bin/copy_footage ${INSTALL_PATH}/bin
	install bin/list_files ${INSTALL_PATH}/bin
	install bin/parallelbang ${INSTALL_PATH}/bin
	install bin/post_processing ${INSTALL_PATH}/bin
	install bin/post_processing_truncated ${INSTALL_PATH}/bin
	install bin/stitching ${INSTALL_PATH}/bin
	install remote-scripts/paralog.sh ${INSTALL_PATH}/bin
	install remote-scripts/post_process.sh ${INSTALL_PATH}/bin
	install remote-scripts/stitch.sh ${INSTALL_PATH}/bin
	install corrxml/corrxml.sh ${INSTALL_PATH}/bin
