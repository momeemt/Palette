type
  tHue* = range[0.0..360.0]
  tSaturation* = range[0.0..100.0]
  tBrightness* = range[0.0..100.0]

  tColor* = object
    hue*: tHue
    saturation*: tSaturation
    brightness*: tBrightness