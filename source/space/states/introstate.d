module space.states.introstate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.states.mainmenustate;
import space.utils.mathhelper;

class IntroState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		tex = new Texture(engine, null, "res/img/intro.png");
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
		
		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || fade == 0 ||
		    k.isDown(SDL_SCANCODE_SPACE) || k.isDown(SDL_SCANCODE_RETURN) || k.isDown(SDL_SCANCODE_ESCAPE))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		tex.Render(null, &engine.SizeRect(), false);
	}
	
private:
	Texture tex;
	double fade;
}

