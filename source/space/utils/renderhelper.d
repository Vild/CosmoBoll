module space.utils.renderhelper;

import derelict.sdl2.sdl;
import space.utils.mathhelper;

class RenderHelper {
public:
	this() {

	}

	void Update(SDL_Rectd p1, SDL_Rectd p2) {
		const double DISTANCE_MULTIPLYER = 1.3;

		middle = MathHelper.GetMiddle(p1.Pointd, p2.Pointd); //TODO: this need to be the middle of the screen.
		double distance = MathHelper.LengthTo(middle, p1.Pointd);

		scale = 1 - (distance * DISTANCE_MULTIPLYER); //Hope this works :3

		if (scale < 0)
			scale = 0.0001;


		middle = SDL_Pointd(0, 0);
		scale = 1.0;
	}

	@property SDL_Pointd Middle() { return middle; }
	@property double Scale() { return scale; }
private:
	SDL_Pointd middle; //aka xShift, yShift
	double scale = 0;
}

