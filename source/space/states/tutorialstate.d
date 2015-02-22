module space.states.tutorialstate;

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
import space.states.mainmenustate;
import space.utils.mathhelper;

class TutorialState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		enum string tutorialText = 
				"Gameplay:\n"
				"Put the ball in the opponents forcefield. "
				"When the ball has passes thru it, to the bottom. The player will earn a point. "
				"So if the red player puts the ball in the blues forcefield, red will earn a point.\n"
				"\n"
				"The player that gets the most points under %s minutes (%s seconds) wins.\n"
				"\n"
				"Controls:\n"
				"The red player uses: 'W', 'A', 'S', 'D' to move and 'SPACE' to fire the ball.\n"
				"The blue player uses: '\x18', '\x19', '\x1A', '\x1B' to move and '\x1E SHIFT' to fire the ball.\n"
				"\n"
				"Tips:\n"
				"The balls physics are challenging, to shoot it you need to look at that direction. "
				"The longer you hold the you hold the shoot key, the harder you will shoot. "
				"The ball will also get your momentum.\n"
				"\n"
				"Players and the ball will travel slower in the forcefields. "
				"If you are lucky you are able to save the ball.\n"
				"\n"
				"If you pass thru the bottom of any forcefield you will respawn on the top of the screen."
				;

		bg = new ScrollingBackground(engine);
		//tutorial = new Texture(engine, null, "res/img/tutorial.png");
		title = new Text(engine, _("Tutorial"), 4);
		title.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));
		red = new Text(engine, _("Red"), 4);
		red.SetColor(SDL_Color(255, 100, 100, 255), SDL_Color(200, 100, 100, 100));
		blue = new Text(engine, _("Blue"), 4);
		blue.SetColor(SDL_Color(100, 100, 255, 255), SDL_Color(100, 100, 200, 100));
		info = new Text(engine, _(tutorialText), 2, 900);
		pushButton = new Text(engine, _("Press Escape or click to go back"), 2);
	}
	
	~this() {
		destroy(pushButton);
		destroy(info);
		destroy(blue);
		destroy(red);
		destroy(title);
		//destroy(tutorial);
		destroy(bg);
	}
	override void Update(double delta) {
		bg.Update(delta);
		//tutorial.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked || k.isDown(SDL_SCANCODE_ESCAPE))
			engine.ChangeState!MainMenuState(engine);
	}
	override void Render() {
		bg.Render();
		//tutorial.Render(null, &engine.SizeRect());

		SDL_Rectd titlePos = SDL_Rectd(engine.Size.x/2 - title.Size.w/2, 10, 0, 0);
		SDL_Rectd redPos = SDL_Rectd(75, 300, 0, 0);
		SDL_Rectd bluePos = SDL_Rectd(engine.Size.x - 175, 300, 0, 0);
		SDL_Rectd infoPos = SDL_Rectd(engine.Size.x/2 - 900/2, 75, 0, 0);

		title.Render(&titlePos);
		red.Render(&redPos);
		blue.Render(&bluePos);
		info.Render(&infoPos);


		SDL_Rectd tmppos = SDL_Rectd(engine.Size.x - pushButton.Size.w, engine.Size.y - pushButton.Size.h, 0, 0);
		pushButton.Render(&tmppos);
	}
	
private:
	ScrollingBackground bg;
	//Texture tutorial;

	Text title;
	Text red;
	Text blue;
	Text info;


	Text pushButton;
}

