module space.utils.renderhelper;

import derelict.sdl2.sdl;
import space.utils.mathhelper;
import std.algorithm;
import space.log.log;
import space.engine;
import std.math;

class RenderHelper {
public:
	this(Engine* engine) {
		this.engine = engine;
	}

	void Update(SDL_Rectd p1, SDL_Rectd p2) {
		const double CAMERA_FOCUS_PADDING = 50;

		/* 1) Compute the bounding box. */
		
		float boxX	= p1.x;
		float boxY	= p1.y; 
		float boxWidth	= boxX + p1.w;
		float boxHeight	= boxY + p1.h;


			boxX = min(boxX, p2.x);
			boxY = min(boxY, p2.y);
			
			boxWidth = max(boxWidth, p2.x + p2.w);
			boxHeight = max(boxHeight, p2.y + p2.h);
			boxWidth = boxWidth - boxX;
			boxHeight = boxHeight - boxY;

		
		/* 2) Apply a padding so that none of the focus objects are on the edges of the viewport.
			   
			   Probably better to use a 'static final' member of some important class.
			   
			   The padding should be a value in pixels (e.g. '20') of the thickness of 
			   the border that insets from the viewport. */
		
		boxX -= CAMERA_FOCUS_PADDING;
		boxY -= CAMERA_FOCUS_PADDING;
		boxWidth  += CAMERA_FOCUS_PADDING * 2;
		boxHeight += CAMERA_FOCUS_PADDING * 2;
		
		/* 3) Constrain the padded bounding-box to the stage. */
		
		boxX = max(boxX, 0);
		boxX = min(boxX, engine.Size.w - boxWidth); 			
		
		boxY = max(boxY, 0);
		boxY = min(boxY, engine.Size.h - boxHeight);
		
		/* 4) Set the scale. */
		
		/*if (boxWidth > boxHeight)
			scale = boxWidth / engine.Size.w;
		else
			scale = boxHeight / engine.Size.h;*/
		scale = ((boxWidth / engine.Size.w)+(boxHeight / engine.Size.h))/2;
		
		scale = min(1-scale, 1.0f); // Don't let scale factor be less than 1.0f.
		
		/* 5) Final step, compute the center of the box. */
		
		float middleX = boxX + (boxWidth / 2);
		float middleY = boxY + (boxHeight / 2);
		positionDiff.x = middleX-(engine.Size.w/2);
		positionDiff.y = min(middleY-(engine.Size.h/2), 0);

		positionDiff = SDL_Pointd(0, 0);
		scale = 1;
	}

	@property SDL_Pointd PositionDiff() { return positionDiff; }
	@property double Scale() { return scale; }
private:
	Engine* engine;
	SDL_Pointd positionDiff;
	double scale = 0;
}

