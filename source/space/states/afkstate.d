module space.states.afkstate;

import dtext;
import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.music.song;
import space.states.gamestate;
import space.states.tutorialstate;
import space.utils.mathhelper;

import space.states.mainmenustate;

class AFKState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		bg = new ScrollingBackground(engine);
		text = new Text(engine, "I'm AFK!\nWill be back soon \x02", 10);
	}
	
	~this() {
		destroy(text);
		destroy(bg);
	}

	override void Update(double delta) {
		bg.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || k.isDown(SDL_SCANCODE_ESCAPE))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		bg.Render();


		SDL_Rectd textPos = SDL_Rectd(engine.Size.x/2 - text.Size.w/2, engine.Size.y/2 - text.Size.h, 0, 0);
		text.Render(&textPos);
	}

private:
	ScrollingBackground bg;
	Text text;
}