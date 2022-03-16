RPIFW_DATE = "20220316"
SRCREV = "7cb1aa0ff575959163e1cea042e5e3ab5a7a90d2"

SRC_URI[sha256sum] = "efa43d04a3813fc2ecdea1f7013c6869afa523b59ae063b30eb78e3faac2fd63"

do_deploy() {
    install -d ${DEPLOYDIR}/${PN}

    cp -Rf ${S}/* ${DEPLOYDIR}/${PN}
}
