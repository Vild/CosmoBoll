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

		//player1 = new BlockTexture(engine, &renderHelper, SDL_Color(255, 0, 0, 255));
		//player2 = new BlockTexture(engine, &renderHelper, SDL_Color(0, 255, 0, 255));
		player1 = new Texture(engine, &renderHelper, "res/img/man/idle.png");
		player1.SetColor(255, 210, 210);
		player2 = new Texture(engine, &renderHelper, "res/img/man/idle.png");
		player2.SetColor(210, 210, 255);
		//playerPos1 = SDL_Rectd(1366/2-10/2+20, 768-90-40, 44, 73);
		playerPos1 = new AABB(1366/2-44/2+44, 768-90-73, 44, 73);
		playerPos2 = new AABB(1366/2-44/2-44, 768-90-73, 44, 73);

		ball = new Texture(engine, &renderHelper, "res/img/ball.png");
		ballPos = new AABB(1366/2-40/2, 768-90-50-100, 40, 40);

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
		playerPos1.VY += delta*speed/4;

		if (playerPos1.VX < 0)
			playerPos1.VX += delta*speed/4;
		else
			playerPos1.VX -= delta*speed/4;

		playerPos2.VY += delta*speed/4;

		if (playerPos2.VX < 0)
			playerPos2.VX += delta*speed/4;
		else
			playerPos2.VX -= delta*speed/4;


		ballPos.VY +=delta*speed/4;

		if (k.isDown(SDL_SCANCODE_W))
			playerPos1.VY -= delta*speed;
		if (k.isDown(SDL_SCANCODE_S))
			playerPos1.VY += delta*speed;
		if (k.isDown(SDL_SCANCODE_A))
			playerPos1.VX -= delta*speed;
		if (k.isDown(SDL_SCANCODE_D))
			playerPos1.VX += delta*speed;

		if (k.isDown(SDL_SCANCODE_UP))
			playerPos2.VY -= delta*speed;
		if (k.isDown(SDL_SCANCODE_DOWN))
			playerPos2.VY += delta*speed;
		if (k.isDown(SDL_SCANCODE_LEFT))
			playerPos2.VX -= delta*speed;
		if (k.isDown(SDL_SCANCODE_RIGHT))
			playerPos2.VX += delta*speed;
		if (k.isDown(SDL_SCANCODE_RETURN))
		    engine.ChangeState!MainMenuState(engine);

		AABB[] hitthingy = [platformPos, forceField1.R1, forceField1.R2, forceField2.R1, forceField2.R2];

		playerPos1.Update(delta, hitthingy);
		playerPos2.Update(delta, hitthingy);
		ballPos.Update(delta, hitthingy, SDL_Pointd(2, 2));
		//ballRot += delta/100;
		//playerPos1.VX = playerPos1.VY = 0;

		bg.Update(delta);
		forceField1.Update(delta);
		forceField2.Update(delta);
		//renderHelper.Update(playerPos1, playerPos2); //Todo: change
		fpstext.Text = format("%d fps, %f ms/frame p1: %f p2: %f", engine.FPS, engine.FPS_MS, playerPos1.VY, playerPos2.VY);

	}
	override void Render() {
		bg.Render();
		platform.Render(null, &platformPos.Rect(), false);
		//forceField.Render(null, &forceField2);

		player1.Render(null, &playerPos1.Rect(), false, 0, SDL_FLIP_NONE);
		player2.Render(null, &playerPos2.Rect(), false, 0, SDL_FLIP_HORIZONTAL);
		ball.Render(null, &ballPos.Rect(), false); //FIXME: add ballRot?

		forceField1.Render();
		forceField2.Render();
		SDL_Rectd __ = SDL_Rectd(10, 10, 0, 0);
		fpstext.Render(&__);
			

	}

private:
	RenderHelper renderHelper;
	ScrollingBackground bg;
	Texture platform;
	AABB platformPos;
	ForceField forceField1;
	ForceField forceField2;
	Texture player1;
	Texture player2;
	AABB playerPos1;
	AABB playerPos2;
	Texture ball;
	AABB ballPos;
	double ballRot;
	Text fpstext;
}

