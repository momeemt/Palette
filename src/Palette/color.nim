import strformat, strutils

type
  tBinaryRange = range[0.0..255.0]
  tHue* = range[0.0..360.0]
  tRGB* = tuple[red: tBinaryRange, green: tBinaryRange, blue: tBinaryRange]
  tHSV* = tuple[hue: tHue, saturation: tBinaryRange, value: tBinaryRange]

  tColor* = object
    hsv*: tHSV

proc hsv* (rgb: tRGB): tHSV
proc rgb* (color: tColor): tRGB

proc newColor* (hue: tHue, saturation, value: tBinaryRange): tColor =
  let hsv: tHSV = (hue, saturation, value)
  result = tColor(hsv: hsv)

proc newColor* (rgb: tRGB): tColor =
  result = tColor(hsv: hsv(rgb))

proc `$`* (color: tColor): string =
  var
    (red, green, blue) = rgb(color)
  result = fmt"""#{red.int.toHex(2)}{green.int.toHex(2)}{blue.int.toHex(2)}"""

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

proc rgb* (color: tColor): tRGB =
  var
    maxElem = color.hsv.value
    minElem = maxElem - ((color.hsv.saturation / 255) * maxElem)
    hue = color.hsv.hue
    red: tBinaryRange
    green: tBinaryRange
    blue: tBinaryRange
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