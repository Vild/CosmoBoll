module space.states.winstate;

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
import std.string;

class WinState : EngineState {
public:
	this(Engine* engine, int p1, int p2) {
		super(engine);
		this.bg = new ScrollingBackground(engine);
		string t;
		this.text = new Text(engine, "", 10);
		if (p1 > p2) {
			this.text.Text = "Röd vann";
			this.text.SetColor(SDL_Color(255, 100, 100, 255), SDL_Color(200, 100, 100, 100));
		} else if (p1 < p2) {
			this.text.Text = "Blå vann";
			this.text.SetColor(SDL_Color(100, 100, 255, 255), SDL_Color(100, 100, 200, 100));
		} else {
			this.text.Text = "Det blev lika";
			this.text.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));
		}
		line = new Text(engine, "-", 10);
		score1 = new Text(engine, format("%d", p1), 10);
		score2 = new Text(engine, format("%d", p2), 10);
		line.SetColor(SDL_Color(255, 190, 10, 255), SDL_Color(230, 200, 5, 50));
		score1.SetColor(SDL_Color(255, 100, 100, 255), SDL_Color(200, 100, 100, 100));
		score2.SetColor(SDL_Color(100, 100, 255, 255), SDL_Color(100, 100, 200, 100));
		pushButton = new Text(engine, "Tryck ESC eller vänsterklicka för att gå tillbaka", 2);
	}
	
	~this() {
		destroy(pushButton);
		destroy(score2);
		destroy(score1);
		destroy(line);
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
		SDL_Rectd tmppos = SDL_Rectd(engine.Size.w/2-text.Size.w/2, 50, 0, 0);
		text.Render(&tmppos);
		tmppos = SDL_Rectd(engine.Size.x/2 - line.Size.w/2, engine.Size.y/2 - line.Size.h/2, 0, 0);
		line.Render(&tmppos);
		tmppos.x -= score1.Size.w + 20;
		score1.Render(&tmppos);
		tmppos.x += score1.Size.w + line.Size.w + 30;
		score2.Render(&tmppos);
		tmppos = SDL_Rectd(engine.Size.x - pushButton.Size.w, engine.Size.y - pushButton.Size.h, 0, 0);
		pushButton.Render(&tmppos);
	}
	
private:
	ScrollingBackground bg;
	Text text;
	Text line;
	Text score1, score2;
	Text pushButton;
}
