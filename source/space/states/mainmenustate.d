module space.states.mainmenustate;

import space.log.log;
import space.engine;
import space.enginestate;
import space.graphics.texture;
import space.graphics.text;
import space.music.song;
import space.io.mouse;
import space.states.gamestate;
import space.graphics.scrollingbackground;
import derelict.sdl2.sdl;


class MainMenuState : EngineState {
public:
	this(Engine* engine) {
		super(engine);
		song = new Song("res/song/mainmenu.mp3");
		bg = new ScrollingBackground(engine, "res/img/background.png");
		title = new Text(engine.Renderer, "\x01 Cosmo Boll \x02", 10);
		titlePos = SDL_Rect((engine.Size.w/2)-cast(int)(title.Text.length*title.Scale*8/2), 100, cast(int)(title.Text.length*title.Scale*8), cast(int)(title.Scale*8));
		//titlePos = SDL_Rect((engine.Size.w/2)-cast(int)(800/2), 10, cast(int)(800), cast(int)(250));
		buttonTex = new Texture(engine.Renderer, "res/img/mainmenu_button.png");

		SDL_Rect pos = SDL_Rect((engine.Size.w/2)-(buttonTex.Size.w/2), 0/*placeholder*/, buttonTex.Size.w, buttonTex.Size.h);
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
		if (m.JustClicked) {
			import space.utils.mathhelper;
			foreach(ref Button b; buttons)
				if (MathHelper.CheckCollision(b.hitbox, SDL_Rect(m.X, m.Y, 1, 1)))
					b.onClick(b);
		}

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
	SDL_Rect titlePos;

	Texture buttonTex;
	Button[] buttons;

	alias onClick_f = void delegate(ref Button button);

	static struct Button {
		int id;
		SDL_Rect hitbox;
		Text text;
		SDL_Rect textPos;
		onClick_f onClick;
	}

	void addButton(int id, SDL_Rect pos, string str, double size, onClick_f onClick) {
		SDL_Rect textPos;
		Text text = new Text(engine.Renderer, str, size);
		textPos.x = pos.x + (pos.w/2) - (text.Size.w/2);
		textPos.y = pos.y + (pos.h/2) - (text.Size.h/2);
		text.SetColor(255, 190, 10);

		buttons ~= Button(id, pos, text, textPos, onClick);
	}
}