# Palette
Palette is a color library written in Nim.  

## Feature
- Able to handle HSV, RGB, and CRYK

```nim
let myColor: tColor = newColor(100, 100, 100)

echo myColor
echo myColor.rgb
echo myColor.hsv
echo myColor.cmyk
```

- Some primary colors are available
- Can give HSV to visually check the color

```bash:Check the color
palette --hue:<hue> --saturation:<saturation> --value:<value>
```

## Author
- [Momeemt](https://twitter.com/momeemt)