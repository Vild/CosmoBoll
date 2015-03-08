module space.states.creditsstate;

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

class CreditsState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		bg = new ScrollingBackground(engine);
		title = new Text(engine, "\x01 Credits \x02", 10);
		title.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));
		text = new Text(engine,
			"Dan Printzell - Programmer\n"
			"Otto Falk - Graphics\n"
			"\n\n\n\n"
			"Songs:\n"
			"Electro Chill A - Frank Nora (Main menu song)\n"
			"Trance G Dampen - Frank Nora (In game song)\n"
			, 3);
		text.SetColor(SDL_Color(255, 255, 255, 255), SDL_Color(200, 200, 200, 100));
	}
	
	~this() {
		destroy(text);
		destroy(title);
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


		SDL_Rectd titlePos = SDL_Rectd(engine.Size.x/2 - title.Size.w/2, 10, 0, 0);
		title.Render(&titlePos);

		SDL_Rectd textPos = SDL_Rectd(engine.Size.x/2 - text.Size.w/2, 150, 0, 0);
		text.Render(&textPos);
	}

private:
	ScrollingBackground bg;
	Text title;
	Text text;
}