# Package

version       = "0.1.0"
author        = "momeemt"
description   = "Color Library"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["palette"]

# Dependencies

requires "nim >= 1.4.0"
requires "nigui >= 0.2.4"
requires "cligen >= 1.3.2"