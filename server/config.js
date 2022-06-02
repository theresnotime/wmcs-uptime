const args = require("args-parser")(process.argv);
const demoMode = args["demo"] || false;

const badgeConstants = {
    naColor: "#999",
    defaultUpColor: "#66c20a",
    defaultDownColor: "#c2290a",
    defaultPingColor: "blue",  // as defined by badge-maker / shields.io
    defaultStyle: "flat",
    defaultPingValueSuffix: "ms",
    defaultPingLabelSuffix: "h",
    defaultUptimeValueSuffix: "%",
    defaultUptimeLabelSuffix: "h",
};

const casSettings = {
    cas_host: "idp.wmcloud.org",
    login_service: "/login",
    cas_port: 443,
    service: "https://uptime.wmcloud.org",
    validation_service: "/serviceValidate"
};

module.exports = {
    args,
    demoMode,
    badgeConstants,
    casSettings,
};
