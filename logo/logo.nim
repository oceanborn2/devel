import sdl2, sdl2/gfx, pegs, strutils


#const TOKENS = "[]:?"
const KEYWORDS = @["[", "]", ":", "?", "end", "forward", "if", "output", "print", "repeat", "reverse", "right",  "to"]

type

  Instruction* = object
    opcode:char

  LogoParser* = object
    source* : string
    #compiled*: Array<Instruction>

  LogoEngine* = object
    window*: WindowPtr
    render*: RendererPtr
    fpsman*: FpsManager
    penForecolor* : uint32
    penBackcolor* : uint32

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
      self.render.arcColor(200,200,100,10,10, 0xfacddefc'u32)
      self.render.aacircleColor(100,100,100,  0xda42ac65'u32)
      for n in 1'i16..10'i16:
        self.render.aacircleColor(n*30,n*20,n*3, 0x42da65ac'u32)

      self.render.present
      self.fpsman.delay

  finally:
    self.release()

proc newEngine*() : LogoEngine =
  result = LogoEngine()

proc newParser*() : LogoParser =
  result = LogoParser()

method tokenize*(self:LogoParser, program:string): seq[string] {.base.} =
  result = newSeq[string]()
  var tokens = split(program, peg" \s+ / '[' / ']' / '?' / ':' / '<' / '>' / '='")
  for tok in tokens:
    result.add(tok)

method parse*(self:LogoParser, tokens:seq[string]): seq[Instruction] {.base.} =
  result = newSeq[Instruction]()
  for sym in tokens:
    result.add(Instruction())


let program="""repeat 4 [
right 10
forward 20  ]
if a > 100 [print '*' ]
"""

var lgp = newParser()
var tokens = lgp.tokenize(program)
echo tokens

#var code = lgp.parse(tokens)
#echo code

var lge = newEngine()
lge.run()

