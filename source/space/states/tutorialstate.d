module space.states.tutorialstate;

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

import space.graphics.scrollingbackground;

class TutorialState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		bg = new ScrollingBackground(engine, "res/img/background.png");
	}
	
	~this() {
		destroy(tex);
	}
	override void Update(double delta) {
		bg.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || fade == 0 ||
		    k.isDown(SDL_SCANCODE_SPACE) || k.isDown(SDL_SCANCODE_RETURN))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		bg.Render();
	}
	
private:
	Texture tex;
	double fade;
	Text text;
	ScrollingBackground bg;
}

