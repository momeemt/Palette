import unittest
import Palette

suite "color type":
  setup:
    var myColor = tColor(hue: 20, saturation: 30, value: 30)

  test "Apply operate `+` to color":
    myColor.hue += 20
    check myColor == tColor(hue: 40, saturation: 30, value: 30)

    myColor.saturation += 20
    check myColor == tColor(hue: 40, saturation: 50, value: 30)

    myColor.value += 20
    check myColor == tColor(hue: 40, saturation: 50, value: 50)
  
  test "Apply operate `-` to color":
    myColor.hue -= 20
    check myColor == tColor(hue: 0, saturation: 30, value: 30)

    myColor.saturation -= 20
    check myColor == tColor(hue: 0, saturation: 10, value: 30)

    myColor.value -= 20
    check myColor == tColor(hue: 0, saturation: 10, value: 10)