var Jimp = require('jimp');

function base64EncodeURL(bytes) {
    return toUrl(btoa(Array.from(bytes).map(val => {
        return String.fromCharCode(val);
    }).join('')));
}

function toUrl(str) {
    return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=/g, '');
}

self.imageToDataUrl = async function imageToDataUrl(params) {
    // [bytes, mimeType, sizeLimit]
    var bytes = params[0];
    var mimeType = params[1];
    var sizeLimit = params[2];

    if (bytes.byteLength > sizeLimit) {
        var image = (await Jimp.read(bytes.buffer)).quality(80);
        var len = (await image.getBufferAsync(Jimp.MIME_JPEG)).byteLength;

        while (len > sizeLimit) {
            var reduceFactor = Math.max(Math.sqrt(sizeLimit / len) * 0.9);
            // * 0.9 to reduce iteration.
            image.resize(image.bitmap.width * reduceFactor, Jimp.AUTO);

            // update len
            len = (await image.getBufferAsync(Jimp.MIME_JPEG)).byteLength;
        }
        return toUrl(await image.getBase64Async(Jimp.MIME_JPEG)).replace('_', '/');
    }
    return 'data:' + mimeType + ';base64,' + base64EncodeURL(bytes);
}
