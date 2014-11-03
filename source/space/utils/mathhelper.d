module space.utils.mathhelper;

import derelict.sdl2.sdl;

class MathHelper {
	static bool CheckCollision(SDL_Rect rect1, SDL_Rect rect2){
		int left1 = rect1.x;
		int right1 = rect1.x + rect1.w;
		int top1 = rect1.y;
		int bottom1 = rect1.y + rect1.h;

		int left2 = rect2.x;
		int right2 = rect2.x + rect2.w;
		int top2 = rect2.y;
		int bottom2 = rect2.y + rect2.h;


		return !((left1 > right2) || (right1 < left2) || (top1 > bottom2) || (bottom1 < top2));
	}
}

