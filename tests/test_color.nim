import unittest
import Palette

suite "color type":
  setup:
    let myColor = tColor(hue: 20, saturation: 30, brightness: 30)

  test "Apply operate `+` to color":
    check myColor.hue + 20 == tColor(hue: 40, saturation: 30, brightness: 30)
    check myColor.saturation + 20 == tColor(hue: 20, saturation: 50, brightness: 30)
    check myColor.brightness + 20 == tColor(hue: 20, saturation: 30, brightness: 50)
  
  test "Apply operate `-` to color"
    check myColor.hue - 10 == tColor(hue: 10, saturation: 30, brightness: 30)
    check myColor.saturation - 10 == tColor(hue: 20, saturation: 20, brightness: 30)
    check myColor.brightness - 10 == tColor(hue: 20, saturation: 30, brightness: 20)