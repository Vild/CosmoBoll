module space.states.tutorialstate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.states.mainmenustate;
import space.utils.mathhelper;

class TutorialState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		bg = new ScrollingBackground(engine);
		tutorial = new Texture(engine, null, "res/img/tutorial.png");
		pushButton = new Text(engine, "Tryck ESC eller vänsterklicka för att gå tillbaka", 2);
	}
	
	~this() {
		destroy(pushButton);
		destroy(tutorial);
		destroy(bg);
	}
	override void Update(double delta) {
		bg.Update(delta);
		tutorial.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || k.isDown(SDL_SCANCODE_ESCAPE))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		bg.Render();
		tutorial.Render(null, &engine.SizeRect());
		SDL_Rectd tmppos = SDL_Rectd(engine.Size.x - pushButton.Size.w, engine.Size.y - pushButton.Size.h, 0, 0);
		pushButton.Render(&tmppos);
	}
	
private:
	ScrollingBackground bg;
	Texture tutorial;
	Text pushButton;
}

