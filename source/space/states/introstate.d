module space.states.introstate;

import space.engine;
import space.enginestate;
import space.graphics.texture;
import space.graphics.text;
import space.io.mouse;
import space.io.keyboard;

import space.states.mainmenustate;

import derelict.sdl2.sdl;
import space.log.log;

class IntroState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		tex = new Texture(engine.Renderer, null, "res/img/intro.png");
		fade = 1.0;
	}
	
	~this() {
		destroy(tex);
	}
	override void Update(double delta) {
		import std.string : format;
		fade -= delta / 6;
		if (fade < 0)
			fade = 0;
		tex.SetAlpha(fade);
		//count += delta*8;
		//fpstext.Text = format("%d fps, %f ms/frame", engine.FPS, engine.FPS_MS);
		
		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || fade == 0 ||
		    k.isDown(SDL_SCANCODE_SPACE) || k.isDown(SDL_SCANCODE_RETURN))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		tex.Render(null, &engine.Size());
	}
	
private:
	Texture tex;
	double fade;
}

