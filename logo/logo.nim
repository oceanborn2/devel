import sdl2, sdl2/gfx

type
  LogoEngine* = object
    window*: WindowPtr
    render*: RendererPtr
    fpsman*: FpsManager

method initEngine*(self:var LogoEngine) {.base.} =
  discard sdl2.init(INIT_EVERYTHING)
  self.window = createWindow("Logo", 100, 100, 640,480, SDL_WINDOW_SHOWN)
  self.render = createRenderer(self.window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)
  self.fpsman.init

method release*(self:LogoEngine) {.base.} =
  destroy self.render
  destroy self.window
  #destroy self.fpsman ?

method run(self:var LogoEngine) {.base.} =
  var evt = sdl2.defaultEvent
  self.initEngine()
  var runGame = true
  try:
   while runGame:
      while pollEvent(evt):
        if evt.kind == QuitEvent:
          runGame = false
          break

      let dt = self.fpsman.getFramerate() / 1000

      self.render.setDrawColor 220,210,121,255
      self.render.clear
      self.render.aacircleColor(100,100,10, 0xfacddefc'u32)
      self.render.present
      self.fpsman.delay

  finally:
    self.release()

proc newEngine*() : LogoEngine =
  result = LogoEngine()


var lge = newEngine()
lge.run()

