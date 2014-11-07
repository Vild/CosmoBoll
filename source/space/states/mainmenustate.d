module space.states.mainmenustate;

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
import space.utils.mathhelper;

class MainMenuState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		song = new Song("res/song/mainmenu.mp3");
		bg = new ScrollingBackground(engine, "res/img/background.png");
		title = new Text(engine, "\x01 Cosmo Boll \x02", 10);
		titlePos = SDL_Rectd((engine.Size.w/2)-(title.Size.w/2), 100, title.Size.w, title.Size.h);
		//titlePos = SDL_Rect((engine.Size.w/2)-cast(int)(800/2), 10, cast(int)(800), cast(int)(250));
		buttonTex = new Texture(engine, null, "res/img/mainmenu_button.png");

		SDL_Rectd pos = SDL_Rectd((engine.Size.w/2)-(buttonTex.Size.w/2), 0/*placeholder*/, buttonTex.Size.w, buttonTex.Size.h);
		pos.y += pos.h + 250;
		addButton(0, pos, "Spela", 8, &onClick);
		pos.y += pos.h + 100;
		addButton(2, pos, "Avsluta", 8, &onClick);
	}
	
	~this() {
		destroy(buttons);
		destroy(buttonTex);
		destroy(title);
		destroy(bg);
		destroy(song);
	}

	override void Update(double delta) {
		import std.string : format;

		bg.Update(delta);

		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (m.JustClicked) {
			import space.utils.mathhelper;
			foreach(ref Button b; buttons)
				if (MathHelper.CheckCollision(b.hitbox, SDL_Rectd(m.X, m.Y, 1, 1)))
					b.onClick(b);
		}

		if (k.isDown(SDL_SCANCODE_SPACE))
		    engine.ChangeState!GameState(engine);

	}
	override void Render() {
		bg.Render();
		title.Render(&titlePos);
		//SDL_SetRenderDrawColor(engine.Renderer, 0, 255, 255, 255);
		//SDL_RenderFillRect(engine.Renderer, &titlePos);
		foreach (Button b; buttons) {
			//buttonTex.Render(null, &b.hitbox);
			b.text.SetColor(230, 200, 5, 50);
			b.textPos.x += 8;
			b.textPos.y -= 8;
			b.text.Render(&b.textPos);
			b.text.SetColor(255, 190, 10, 255);
			b.textPos.x -= 8;
			b.textPos.y += 8;
			b.text.Render(&b.textPos);

		}
	}

	void onClick(ref Button button) {
		Log.MainLogger.Info!onClick("ID: %d was clicked", button.id);
		if (button.id == 0)
			engine.ChangeState!GameState(engine);
		else if (button.id == 2)
			engine.Quit();
	}

private:
	Song song;
	ScrollingBackground bg;
	Text title;
	SDL_Rectd titlePos;

	Texture buttonTex;
	Button[] buttons;

	alias onClick_f = void delegate(ref Button button);

	static struct Button {
		int id;
		SDL_Rectd hitbox;
		Text text;
		SDL_Rectd textPos;
		onClick_f onClick;
	}

	void addButton(int id, SDL_Rectd pos, string str, double size, onClick_f onClick) {
		SDL_Rectd textPos;
		Text text = new Text(engine, str, size);
		textPos.x = pos.x + (pos.w/2) - (text.Size.w/2);
		textPos.y = pos.y + (pos.h/2) - (text.Size.h/2);
		textPos.w = 0;
		textPos.h = 0;
		text.SetColor(255, 190, 10);

		buttons ~= Button(id, pos, text, textPos, onClick);
	}
}