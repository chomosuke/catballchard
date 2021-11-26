importScripts('jimp.js');
var Jimp = self.Jimp;

function base64EncodeURL(bytes) {
    return toUrl(btoa(Array.from(bytes).map(val => {
        return String.fromCharCode(val);
    }).join('')));
}

function toUrl(str) {
    return str.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=/g, '');
}

async function imageToDataUrl(params) {
    // [bytes, mimeType, sizeLimit, imgSizeLimit]
    var bytes = params[0];
    var mimeType = params[1];
    var sizeLimit = params[2];
    var imgSizeLimit = params[3];
    if (bytes.byteLength > sizeLimit) {
        var image = await Jimp.read(bytes.buffer);
        if (image.getWidth() > image.getHeight()) {
            image.resize(imgSizeLimit, Jimp.AUTO);
        } else {
            image.resize(Jimp.AUTO, imgSizeLimit);
        }
        return toUrl(await image.getBase64Async(Jimp.MIME_JPEG)).replace('_', '/');
    } else {
        return 'data:' + mimeType + ';base64,' + base64EncodeURL(bytes);
    }
}