do_deploy() {
    install -d ${DEPLOYDIR}/${PN}

    cp -Rf ${S}/* ${DEPLOYDIR}/${PN}
}
