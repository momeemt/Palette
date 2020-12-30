import unittest
import Palette/[color, constantColor]


suite "hex converter":
  test "tColor to tHEX":
    let myColor: tColor = turquoise
    check myColor.hex == "#40e0d0"
  
  test "tRGB to tHex":
    let
      rgb: tRGB = turquoise.rgb
      right = newRGB(64.0, 224.0, 208.0)
    check rgb == right