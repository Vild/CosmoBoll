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
				"The blue player uses: '\x18', '\x1B', '\x19', '\x1A' to move and 'SHIFT' to fire the ball.\n"
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
		title = new Text(engine, _("Tutorial"), 4);
		title.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));
		red = new Text(engine, _("Red"), 4);
		red.SetColor(SDL_Color(255, 100, 100, 255), SDL_Color(200, 100, 100, 100));
		blue = new Text(engine, _("Blue"), 4);
		blue.SetColor(SDL_Color(100, 100, 255, 255), SDL_Color(100, 100, 200, 100));
		info = new Text(engine, format(_(tutorialText), engine.GameTime / 60, engine.GameTime), 2, 900);
		pushButton = new Text(engine, _("Press Escape or click to go back"), 2);
	}
	
	~this() {
		destroy(pushButton);
		destroy(info);
		destroy(blue);
		destroy(red);
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
		SDL_Rectd redPos = SDL_Rectd(125, 300, 0, 0);
		SDL_Rectd bluePos = SDL_Rectd(engine.Size.x - 225, 300, 0, 0);
		SDL_Rectd infoPos = SDL_Rectd(engine.Size.x/2 - 900/2, 75, 0, 0);
		SDL_Rectd redButtonPos = redPos;
		redButtonPos.y += 32+8;
		redButtonPos.x += red.Size.w/2-32/2;
		SDL_Rectd blueButtonPos = bluePos;
		blueButtonPos.y += 32+8;
		blueButtonPos.x += blue.Size.w/2-32/2;

		title.Render(&titlePos);
		red.Render(&redPos);
		blue.Render(&bluePos);
		info.Render(&infoPos);

		DrawBox(redButtonPos, "W", 32, true);
		redButtonPos.y += 32+8;
		redButtonPos.x -= 32+8;
		DrawBox(redButtonPos, "A", 32, true);
		redButtonPos.x += 32+8;
		DrawBox(redButtonPos, "S", 32, true);
		redButtonPos.x += 32+8;
		DrawBox(redButtonPos, "D", 32, true);
		redButtonPos.y += 32+8;
		redButtonPos.x -= (32+8)*3;
		DrawBox(redButtonPos, "SPACE", (32+8)*5-8, true);


		DrawBox(blueButtonPos, "\x18", 32, false);
		blueButtonPos.y += 32+8;
		blueButtonPos.x -= 32+8;
		DrawBox(blueButtonPos, "\x1B", 32, false);
		blueButtonPos.x += 32+8;
		DrawBox(blueButtonPos, "\x19", 32, false);
		blueButtonPos.x += 32+8;
		DrawBox(blueButtonPos, "\x1A", 32, false);
		blueButtonPos.y += 32+8;
		blueButtonPos.x -= (32+8)*3;
		DrawBox(blueButtonPos, "SHIFT", (32+8)*5-8, false);

		SDL_Rectd tmppos = SDL_Rectd(engine.Size.x - pushButton.Size.w, engine.Size.y - pushButton.Size.h, 0, 0);
		pushButton.Render(&tmppos);
	}

	void DrawBox(SDL_Rectd pos, string text, double width, bool isRed) {
		Text t = new Text(engine, text, 2);
		t.SetColor(SDL_Color((isRed) ? 200 : 0, 0, (isRed) ? 0 : 200, 255), SDL_Color((isRed) ? 50 : 0, 0, (isRed) ? 0 : 50, 100));
		SDL_Rect pos_ = SDL_Rectd(pos.x, pos.y, width, 32).Rect();
		SDL_SetRenderDrawColor(engine.Renderer, 200, 200, 200, 255);
		SDL_RenderFillRect(engine.Renderer, &pos_);
		pos_.x += 2;
		pos_.y += 2;
		pos_.w -= 2*2;
		pos_.h -= 2*2;
		SDL_SetRenderDrawColor(engine.Renderer, 150, 150, 150, 255);
		SDL_RenderFillRect(engine.Renderer, &pos_);

		pos.x += width/2 - t.Size.w/2;
		pos.y += 10;
		t.Render(&pos);
	}
private:
	ScrollingBackground bg;

	Text title;
	Text red;
	Text blue;
	Text info;

	Text pushButton;
}

