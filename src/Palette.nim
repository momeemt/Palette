import Palette/color
import nigui

proc gui(hue: tHue, saturation: tBinaryRange, value: tBinaryRange): int =
  let color = newColor(hue, saturation, value)
  app.init()
  let rgb = color.rgb
  let control = newControl()
  control.widthMode = WidthMode_Fill
  control.heightMode = HeightMode_Fill
  control.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = nigui.rgb(rgb.red.byte, rgb.green.byte, rgb.blue.byte)
    canvas.fill()
  let window = newWindow($color)
  window.add(control)
  window.show()
  app.run()

when isMainModule:
  import cligen
  dispatch(gui)
