module space.music.song;

import derelict.sdl2.mixer;
import std.string : toStringz;
import space.log.log;

class Song {
public:
	this(string file) {
		loadFile(file);
	}

	~this() {
		Mix_FreeMusic(music);
	}

	void Play(int times) {
		Mix_PlayMusic(music, times);
	}

private:
	Mix_Music * music;

	void loadFile(string file) {
		music = Mix_LoadMUS(file.toStringz);
		if (music is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);
		else
			Log.MainLogger.Info!loadFile("Loaded song '%s'", file);

	}

}

