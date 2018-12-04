const path = require('path');
const exec = require('child_process').exec;

const isElectron = 'electron' in process.versions;
const isUsingAsar = isElectron && process.mainModule && process.mainModule.filename.includes('app.asar');
function fixPathForAsarUnpack(path) {
  return isUsingAsar ? path.replace('app.asar', 'app.asar.unpacked') : path;
}

const pickColor = (options) => {
  const BIN = options && options.execPath ? options.execPath : path.join(fixPathForAsarUnpack(__dirname), isElectron ? 'node_modules/colorio/bin' : 'bin');
  return new Promise((resolve,reject) => {
    exec(BIN,(err,stdout,stderr) => {
      if(err) {
          reject(err);
          return;
      }

      try {
          const json = JSON.parse(stderr);
          resolve(json);
      } catch(err) {
          reject(err);
      }
    });
  });
};

module.exports = {
    pickColor: pickColor
};
