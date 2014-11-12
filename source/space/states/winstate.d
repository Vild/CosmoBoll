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
		pushButton = new Text(engine, "Tryck ESC eller vänsterklick för att gå tillbaka", 2);
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
		SDL_Rectd tmppos = SDL_Rectd(engine.Size.w/2-text.Size.w/2, 50, 0, 0);
		text.Render(&tmppos);
		tmppos = SDL_Rectd(engine.Size.x - pushButton.Size.w, engine.Size.y - pushButton.Size.h, 0, 0);
		pushButton.Render(&tmppos);
	}
	
private:
	ScrollingBackground bg;
	Text text;
	Text pushButton;
}
