module app;
import std.stdio;
import space.log.log;
import space.engine;
import space.states.introstate;
import std.math;


int main(string[] args){
	FloatingPointControl fpctrl;
	fpctrl.enableExceptions(FloatingPointControl.severeExceptions);

	Log log = Log.MainLogger;
	log.LogFile = File("space.log", "a");

	Engine engine = new Engine("Cosmo Boll", 1366, 768, false);
	engine.ChangeState!IntroState(&engine);
	engine.MainLoop();

	log.LogFile.close();
	return 0;
}