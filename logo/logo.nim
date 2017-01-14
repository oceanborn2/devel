## Bare-bones SDL2 example
import sdl2, sdl2/gfx

discard sdl2.init(INIT_EVERYTHING)

var
  window: WindowPtr
  render: RendererPtr

window = createWindow("SDL Skeleton", 100, 100, 640,480, SDL_WINDOW_SHOWN)
render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

var
  evt = sdl2.defaultEvent
  runGame = true
  fpsman: FpsManager
fpsman.init

while runGame:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      runGame = false
      break

  let dt = fpsman.getFramerate() / 1000

  render.setDrawColor 214,2,121,255
  render.clear
  render.aacircleColor(100,100,10, 0xfacddefc'u32)

  render.present
  fpsman.delay

destroy render
destroy window
