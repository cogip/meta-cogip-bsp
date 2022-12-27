RPIFW_DATE = "20221104"
SRC_URI[sha256sum] = "ce2b63610d8e7018f6837597cfe272ca4318d8864aa61ac1d79a7796222efec5"

do_deploy() {
    install -d ${DEPLOYDIR}/${PN}

    cp -Rf ${S}/* ${DEPLOYDIR}/${PN}
}
