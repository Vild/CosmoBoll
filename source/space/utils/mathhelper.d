module space.utils.mathhelper;

import derelict.sdl2.sdl;
import std.algorithm;
import std.math;
import std.traits;

class MathHelper {
	static bool CheckCollision(SDL_Rectd rect1, SDL_Rectd rect2){
		double left1 = rect1.x;
		double right1 = rect1.x + rect1.w;
		double top1 = rect1.y;
		double bottom1 = rect1.y + rect1.h;

		double left2 = rect2.x;
		double right2 = rect2.x + rect2.w;
		double top2 = rect2.y;
		double bottom2 = rect2.y + rect2.h;


		return !((left1 > right2) || (right1 < left2) || (top1 > bottom2) || (bottom1 < top2));
	}

	static SDL_Pointd GetMiddleDiff(SDL_Pointd p1, SDL_Pointd p2) {
		double xl = min(p1.x, p2.x);
		double xg = max(p1.x, p2.x);
		double x = ((xg-xl)/2);

		double yl = min(p1.y, p2.y);
		double yg = max(p1.y, p2.y);
		double y = ((yg-yl)/2);

		return SDL_Pointd(x, y);
	}

	static double LengthTo(SDL_Pointd p1, SDL_Pointd p2) {
		double xl = min(p1.x, p2.x);
		double xg = max(p1.x, p2.x);
		double xd = xg-xl;
		
		double yl = min(p1.y, p2.y);
		double yg = max(p1.y, p2.y);
		double yd = yg-yl;

		return sqrt(xd*xd + yd*yd);
	}
}

struct SDL_Rectd {
	double x, y;
	double w, h;

	this(SDL_Rect* a) {
		this.x = a.x;
		this.y = a.y;
		this.w = a.w;
		this.h = a.h;
	}

	this(SDL_Rectd* a) {
		this.x = a.x;
		this.y = a.y;
		this.w = a.w;
		this.h = a.h;
	}

	this(double x, double y, double w, double h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	SDL_Rectd opUnary(string s)() if (s == "-") {
		return SDL_Rectd(-x, -y, -w, -h);
	}

	SDL_Rectd opBinary(string op)(SDL_Rectd b) {
		return SDL_Rectd(mixin("x"~op~"b.x"), mixin("y"~op~"b.y"), mixin("w"~op~"b.w"), mixin("h"~op~"b.h"));
	}

	SDL_Rectd opBinary(string op)(SDL_Pointd b) {
		return SDL_Rectd(mixin("x"~op~"b.x"), mixin("y"~op~"b.y"), w, h);
	}

	SDL_Pointd opBinary(string op, T)(T b) if (isNumeric!T) {
		return SDL_Rectd(mixin("x"~op~"b"), mixin("y"~op~"b"), mixin("w"~op~"b"), mixin("h"~op~"b"), );
	}

	SDL_Rect Rect() {
		return SDL_Rect(cast(int)x.round, cast(int)y.round, cast(int)w.round, cast(int)h.round);
	}

	SDL_Pointd Pointd() {
		return SDL_Pointd(x, y);
	}
}

struct SDL_Pointd {
	double x, y;


	@property ref double w() { return x; }
	@property ref double h() { return y; }

	this(SDL_Point* p) {
		this.x = p.x;
		this.y = p.y;
	}

	this(SDL_Pointd* p) {
		this.x = p.x;
		this.y = p.y;
	}

	this(double x, double y) {
		this.x = x;
		this.y = y;
	}

	SDL_Pointd opUnary(string s)() if (s == "-") {
		return SDL_Pointd(-x, -y);
	}
	
	SDL_Pointd opBinary(string op)(SDL_Pointd b) {
		return SDL_Pointd(mixin("x"~op~"b.x"), mixin("y"~op~"b.y"));
	}

	SDL_Pointd opBinary(string op, T)(T b) if (isNumeric!T) {
		return SDL_Pointd(mixin("x"~op~"b"), mixin("y"~op~"b"));
	}

	SDL_Point Point() {
		return SDL_Point(cast(int)x.round, cast(int)y.round);
	}

	SDL_Rectd Rect(double w = 0, double h = 0) {
		return SDL_Rectd(x, y, w, h);
	}
}