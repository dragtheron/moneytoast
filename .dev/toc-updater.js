module.exports.readVersion = function (contents) {
    return contents.match(/(##\s*[Vv]ersion:\s+)(.+)/)[2]
}

module.exports.writeVersion = function(contents, version) {
    return contents.replace(/(##\s+[Vv]ersion:\s+)(.+)/, "$1" + version)
}
