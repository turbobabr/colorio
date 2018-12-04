# colorio

Pick colors from the screen on macOS in Node or Electron.js applications.

## Installation

```
$ npm install aperture
```

*Requires macOS 10.12 or later.*

## Usage

```js
const pickColor = require('colorio').pickColor;

pickColor().then((res) => {
    console.log(res);
    //=> on color pick
    // {
    //     "result": "picked",
    //     "color": {
    //         "r": 0.2980392156862745,
    //         "g": 0.6078431372549019,
    //         "b": 0.2980392156862745
    //     }
    // }    

    //=> on hitting `Esc` key
    // {
    //     "result": "canceled",
    // }    
});
```

## API

### pickColor([options]) => `Promise`

Executes native binary file and returns a `Promise` for the result.

Fullfills when user picks color from the screen or aborts the action by hitting `Esc` key. 

#### options

##### execPath

Type: `string`<br>
Default: `undefined`

A custom path to the colorio's binary. Might be helpful in case of custom `dev` environment setup using `webpack`. If not set, path is resolved automatically based on `__dirname` with respect to `app.asar.unpacked` in case module is used in an `Electron` app.

###### Returns

Returns a promise with an object when promise is fullfilled. In case color is picked, the object will look like this, where `color` property contains `r`, `g`, `b` keys representing `rgb` color components in `0...1` range (0 === 0, 1 === 255):
```json
{
    "result": "picked",
    "color": {
        "r": 0.2980392156862745,
        "g": 0.6078431372549019,
        "b": 0.2980392156862745
    }
}  
```

In case user cancels the action by hitting `Esc` key, the resulting object's `result`'s key value will be set to `canceled`:
```json
{
    "result": "canceled"
}  
```

## Color Management

Currently `colorio` doesn't support custom color spaces. Picked colors are converted via [genericRGBColorSpace](https://developer.apple.com/documentation/appkit/nscolorspace/1412082-genericrgbcolorspace?language=objc), thus the resulting colors might be a bit different from color pickers in other apps.

## Maintainers

- [Andrey Shakhmin](https://github.com/turbobabr)

## License

MIT

