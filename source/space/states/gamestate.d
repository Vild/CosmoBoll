module space.states.gamestate;

import derelict.sdl2.sdl;
import space.engine;
import space.enginestate;
import space.graphics.forcefield;
import space.graphics.scrollingbackground;
import space.graphics.text;
import space.graphics.texture;
import space.io.keyboard;
import space.io.mouse;
import space.log.log;
import space.physics.aabb;
import space.states.mainmenustate;
import space.utils.mathhelper;
import space.utils.renderhelper;
import space.graphics.player;
import space.graphics.ball;

class GameState : EngineState {
public:
	this(Engine* engine) {
		super(engine);

		renderHelper = new RenderHelper(engine);
		bg = new ScrollingBackground(engine, "res/img/background.png");
		platform = new Texture(engine, &renderHelper, "res/img/mainmenu_button.png"); //TODO: fix own texture
		//platformPos = SDL_Rectd((engine.Size.w / 2) - (366/2), engine.Size.h-90, 366, 90);
		platformPos = new AABB((engine.Size.w / 2) - (366/2), engine.Size.h-90, 366, 90);
		forceField1 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(60, 84, 161, 180), SDL_Rectd(0, 768-60, 500, 60));
		forceField2 = new ForceField(engine, &renderHelper, "res/img/forcefieldwave.png", SDL_Color(60, 84, 161, 180), SDL_Rectd(1366-500, 768-60, 500, 60));

		player1 = new Player(engine, SDL_Color(255, 210, 210), new AABB(1366/2-44/2-44, 768-90-73, 44, 73), SDL_SCANCODE_W, SDL_SCANCODE_S, SDL_SCANCODE_A, SDL_SCANCODE_D, SDL_SCANCODE_B, SDL_SCANCODE_N, SDL_SCANCODE_M);
		player2 = new Player(engine, SDL_Color(210, 210, 255), new AABB(1366/2-44/2+44, 768-90-73, 44, 73), SDL_SCANCODE_UP, SDL_SCANCODE_DOWN, SDL_SCANCODE_LEFT, SDL_SCANCODE_RIGHT, SDL_SCANCODE_KP_0, SDL_SCANCODE_KP_COMMA, SDL_SCANCODE_KP_ENTER);
		player2.LookLeft = true;

		ball = new Ball(engine, new Texture(engine, &renderHelper, "res/img/ball.png"),new AABB(1366/2-40/2, 768-90-50-100, 40, 40));
		fpstext = new Text(engine, "FPS: UNKNOWN", 2);
	}
	
	~this() {
		destroy(platform);
		destroy(bg);
	}

	override void Update(double delta) {
		double speed = 400;
		Mouse m = engine.MouseState;
		Keyboard k = engine.KeyboardState;


		if (k.isDown(SDL_SCANCODE_RETURN))
		    engine.ChangeState!MainMenuState(engine);

		AABB[] hitthingy = [platformPos, forceField1.R1, forceField1.R2, forceField2.R1, forceField2.R2];

		player1.Update(delta, speed, delta*speed/4, hitthingy, &ball);
		player2.Update(delta, speed, delta*speed/4, hitthingy, &ball);

		ball.Update(delta, speed, delta*speed/4.5, hitthingy);

		bg.Update(delta);
		forceField1.Update(delta);
		forceField2.Update(delta);
		//renderHelper.Update(playerPos1, playerPos2); //Todo: change
		fpstext.Text = format("%d fps, %f ms/frame", engine.FPS, engine.FPS_MS);

	}
	override void Render() {
		bg.Render();
		platform.Render(null, &platformPos.Rect(), false);
		//forceField.Render(null, &forceField2);

		player1.Render();
		player2.Render();
		ball.Render();

		forceField1.Render();
		forceField2.Render();
		SDL_Rectd tmppos = SDL_Rectd(10, 10, 0, 0);
		fpstext.Render(&tmppos);
	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture platform;
	AABB platformPos;
	ForceField forceField1;
	ForceField forceField2;
	Player player1;
	Player player2;
	Ball ball;
	Text fpstext;
}

