import strformat, math, strutils

type
  tPercentage* = range[0.0..100.0]
  tBinaryRange* = range[0.0..255.0]
  tHue* = range[0.0..360.0]
  tRGB* = tuple[red: tBinaryRange, green: tBinaryRange, blue: tBinaryRange]
  tHSV* = tuple[hue: tHue, saturation: tBinaryRange, value: tBinaryRange]
  tCMYK* = tuple[cyan: tPercentage, magenta: tPercentage, yellow: tPercentage, keyPlate: tPercentage]

  tColor* = object
    hsv*: tHSV

proc cmyk* (hsv: tHSV): tCMYK
proc cmyk* (rgb: tRGB): tCMYK
proc cmyk* (hex: string): tCMYK
proc hsv* (rgb: tRGB): tHSV
proc hsv* (cmyk: tCMYK): tHSV
proc hsv* (hex: string): tHSV
proc rgb* (cmyk: tCMYK): tRGB
proc rgb* (hsv: tHSV): tRGB
proc rgb* (hex: string): tRGB
proc hex* (hsv: tHSV): string
proc hex* (rgb: tRGB): string
proc hex* (cmyk: tCMYK): string

proc newColor* (hue: tHue, saturation, value: tBinaryRange): tColor =
  let hsv: tHSV = (hue, saturation, value)
  result = tColor(hsv: hsv)

proc newColor* (rgb: tRGB): tColor =
  result = tColor(hsv: hsv(rgb))

proc newRGB* (red, green, blue: tBinaryRange): tRGB =
  let rgb: tRGB = (red: red, green: green, blue: blue)
  result = rgb

proc `+`* (left, right: tBinaryRange): tBinaryRange = (left.float + right.float) mod 256
proc `+`*[T: SomeNumber] (left: T, right: tBinaryRange): tBinaryRange = (left.float + right.float) mod 256
proc `+`*[T: SomeNumber] (left: tBinaryRange, right: T): tBinaryRange = right + left

proc `-`* (left, right: tBinaryRange): tBinaryRange = (left.float - right.float) mod 256
proc `-`*[T: SomeNumber] (left: T, right: tBinaryRange): tBinaryRange = (left.float - right.float) mod 256
proc `-`*[T: SomeNumber] (left: tBinaryRange, right: T): tBinaryRange = (left.float - right.float) mod 256

proc `*`* (left, right: tBinaryRange): tBinaryRange = (left.float * right.float) mod 256
proc `*`*[T: SomeNumber] (left: T, right: tBinaryRange): tBinaryRange = (left.float * right.float) mod 256
proc `*`*[T: SomeNumber] (left: tBinaryRange, right: T): tBinaryRange = right * left

proc `/`* (left, right: tBinaryRange): tBinaryRange = (left.float / right.float) mod 256
proc `/`*[T: SomeNumber] (left: T, right: tBinaryRange): tBinaryRange = (left.float / right.float) mod 256
proc `/`*[T: SomeNumber] (left: tBinaryRange, right: T): tBinaryRange = (left.float / right.float) mod 256

proc round* (rgb: tRGB): tRGB =
  result = newRGB(rgb.red.round, rgb.green.round, rgb.blue.round)

proc `+`* (color: tColor, hsv: tHSV): tColor =
  let
    newHue: tHue = color.hsv.hue + hsv.hue
    newSaturation: tBinaryRange = color.hsv.saturation + hsv.saturation
    newValue: tBinaryRange = color.hsv.value + hsv.value
  result = newColor(newHue, newSaturation, newValue)

proc cmyk* (hsv: tHSV): tCMYK =
  result = hsv.rgb.cmyk

proc cmyk* (rgb: tRGB): tCMYK =
  let
    red = rgb.red / 255
    green = rgb.green / 255
    blue = rgb.blue / 255
    keyPlate: tPercentage = min(1-red, min(1-green, 1-blue))
    cyan: tPercentage = (1-red-keyPlate) / (1-keyPlate) * 100
    magenta: tPercentage = (1-green-keyPlate) / (1-keyPlate) * 100
    yellow: tPercentage = (1-blue-keyPlate) / (1-keyPlate) * 100
  result = (cyan, magenta, yellow, keyPlate)

proc cmyk* (hex: string): tCMYK =
  result = hex.rgb.cmyk

proc hsv* (rgb: tRGB): tHSV =
  let
    maxElem = max(rgb.red, max(rgb.green, rgb.blue))
    minElem = min(rgb.red, min(rgb.green, rgb.blue))
  
  var hue: tHue = 0.0
  if rgb.red == rgb.green and rgb.green == rgb.blue:
    hue = 0
  elif rgb.red == maxElem:
    hue = 60 * ((rgb.green - rgb.blue) / (maxElem - minElem))
  elif rgb.green == maxElem:
    hue = 60 * ((rgb.blue - rgb.red) / (maxElem - minElem)) + 120
  else:
    hue = 60 * ((rgb.red - rgb.green) / (maxElem - minElem)) + 240
  if hue < 0:
    hue += 360
  
  var
    saturation: tBinaryRange = (maxElem - minElem) / maxElem
    value: tBinaryRange = maxElem

  result = (hue, saturation, value)

proc hsv* (cmyk: tCMYK): tHSV =
  result = cmyk.rgb.hsv

proc hsv* (hex: string): tHSV =
  result = hex.rgb.hsv

proc rgb* (cmyk: tCMYK): tRGB =
  let
    red: tBinaryRange = (1 - min(1, cmyk.cyan / 100 * (1 - cmyk.keyPlate) + cmyk.keyPlate)) * 255.0
    green: tBinaryRange = (1 - min(1, cmyk.magenta / 100 * (1 - cmyk.keyPlate) + cmyk.keyPlate)) * 255.0
    blue: tBinaryRange = (1 - min(1, cmyk.yellow / 100 * (1 - cmyk.keyPlate) + cmyk.keyPlate)) * 255.0
  result = (red, green, blue)

proc rgb* (hsv: tHSV): tRGB =
  var
    maxElem = hsv.value
    minElem = maxElem - ((hsv.saturation / 255) * maxElem)
    hue = hsv.hue
    red, green, blue: tBinaryRange
  
  if 0 <= hue and hue < 60:
    red = maxElem
    green = (hue / 60) * (maxElem - minElem) + minElem
    blue = minElem
  elif 60 <= hue and hue < 120:
    red = ((120 - hue) / 60) * (maxElem - minElem) + minElem
    green = maxElem
    blue = minElem
  elif 120 <= hue and hue < 180:
    red = minElem
    green = maxElem
    blue = ((hue - 120) / 60) * (maxElem - minElem) + minElem
  elif 180 <= hue and hue < 240:
    red = minElem
    green = ((240 - hue) / 60) * (maxElem - minElem) + minElem
    blue = maxElem
  elif 240 <= hue and hue < 300:
    red = ((hue - 240) / 60) * (maxElem - minElem) + minElem
    green = minElem
    blue = maxElem
  else:
    red = maxElem
    green = minElem
    blue = ((360 - hue) / 60) * (maxElem - minElem) + minElem

  result = (red, green, blue)

proc rgb* (hex: string): tRGB =
  let
    red: tBinaryRange = hex[1..2].parseHexInt.tBinaryRange
    green: tBinaryRange = hex[3..4].parseHexInt.tBinaryRange
    blue: tBinaryRange = hex[5..6].parseHexInt.tBinaryRange
  result = newRGB(red, green, blue)

proc hex* (hsv: tHSV): string =
  result = hsv.rgb.hex

proc hex* (rgb: tRGB): string =
  var (red, green, blue) = rgb
  result = fmt"""#{red.int.toHex(2)}{green.int.toHex(2)}{blue.int.toHex(2)}"""

proc hex* (cmyk: tCMYK): string =
  result = cmyk.rgb.hex