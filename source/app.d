module app;
import dtext;
import space.engine;
import space.log.log;
import space.states.introstate;
import std.math;
import std.getopt;
import std.stdio;

int main(string[] args){
	FloatingPointControl fpctrl;
	fpctrl.enableExceptions(FloatingPointControl.severeExceptions);

	string locale = "en_US";
	getopt(args, "lang|l", &locale);
	defaultLocale = locale;

	Log log = Log.MainLogger;
	log.LogFile = File("space.log", "a");
	scope (exit)
		log.LogFile.close();

	Engine engine = new Engine("Cosmo Boll", 1366, 768, false);
	engine.MouseState.SetEngine(&engine);
	engine.ChangeState!IntroState(&engine);
	engine.MainLoop();
	return 0;
}