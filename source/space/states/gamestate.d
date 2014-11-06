module space.states.gamestate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.states.mainmenustate;
import space.utils.mathhelper;
import space.utils.renderhelper;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		renderHelper = new RenderHelper(engine);
		bg = new ScrollingBackground(engine, "res/img/background.png");
		platform = new Texture(engine, &renderHelper, "res/img/mainmenu_button.png"); //TODO: fix own texture
		platformPos = SDL_Rectd((engine.Size.w / -2) + (366/2), engine.Size.h/2-90, 366, 90);
		forceField = new BlockTexture(engine, &renderHelper, SDL_Color(255, 0, 255, 255));
		forceField1 = SDL_Rectd(-engine.Size.w/2, (768/2)-60, 500, 60);
		forceField2 = SDL_Rectd(500, (768/2)-60, 500, 60);
		player1 = new BlockTexture(engine, &renderHelper, SDL_Color(255, 0, 0, 255));
		player2 = new BlockTexture(engine, &renderHelper, SDL_Color(0, 255, 0, 255));
		playerPos1 = SDL_Rectd(0, 0, 10, 20);//SDL_Rectd(10/2+10, (768/2)-90-20, 10, 20);
		playerPos2 = SDL_Rectd(10/2-10, (768/2)-90-20, 10, 20);
	}
	
	~this() {
		destroy(platform);
		destroy(bg);
	}

	override void Update(double delta) {
		double speed = 100;
		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;
		if (k.isDown(SDL_SCANCODE_W))
			playerPos1.y -= delta*speed;
		if (k.isDown(SDL_SCANCODE_S))
			playerPos1.y += delta*speed;
		if (k.isDown(SDL_SCANCODE_A))
			playerPos1.x -= delta*speed;
		if (k.isDown(SDL_SCANCODE_D))
			playerPos1.x += delta*speed;

		bg.Update(delta);
		renderHelper.Update(playerPos1, playerPos2); //Todo: change

	}
	override void Render() {
		bg.Render();
		platform.Render(null, &platformPos);

		forceField.Render(null, &forceField1);
		forceField.Render(null, &forceField2);

		player1.Render(null, &playerPos1);
		player2.Render(null, &playerPos2);
	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture platform;
	SDL_Rectd platformPos;
	Texture forceField;
	SDL_Rectd forceField1;
	SDL_Rectd forceField2;
	Texture player1;
	Texture player2;
	SDL_Rectd playerPos1;
	SDL_Rectd playerPos2;
}

