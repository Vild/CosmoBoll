module space.music.song;

import derelict.sdl2.mixer;
import space.log.log;
import std.string : toStringz;

static ~this() {
	foreach(tex; cacheChunk.keys)
		Mix_FreeChunk(cacheChunk[tex]);

	foreach(tex; cacheMusic.keys)
		Mix_FreeMusic(cacheMusic[tex]);
}

static Mix_Chunk*[string] cacheChunk;
static Mix_Music*[string] cacheMusic;

class Song {
public:
	this(string file, bool music = false) {
		this.music = music;
		loadFile(file);
		this.current = file;
		volume = MIX_MAX_VOLUME;
	}

	~this() {
		Stop();
	}

	void Play(int times) {
		if (music) {
			Mix_PlayMusic(mus, -1);
			Mix_VolumeMusic(volume);
		} else {
			if (channel == -1) {
				channel = Mix_PlayChannel(-1, chunk, times);
				Mix_Volume(channel, volume);
			}
		}
	}

	void Stop() {
		if (!music) {
			if (channel != -1) {
				Mix_HaltChannel(channel);
				channel = -1;
			}
		}
	}

	void SetVolume(int volume) {
		this.volume = volume;
		if (music)
			Mix_VolumeMusic(volume);
		else
			Mix_Volume(channel, volume);
	}

	@property string Current() { return current; }

private:
	bool music;
	Mix_Chunk * chunk;
	Mix_Music * mus;
	int channel;
	int volume;
	string current;
	void loadFile(string file) {
		if (music) {
			if (auto tmp = file in cacheMusic) {
				mus = *tmp;
				return;
			}
		} else {
			if (auto tmp = file in cacheChunk) {
				chunk = *tmp;
				return;
			}
		}

		if (music)
			cacheMusic[file] = mus = Mix_LoadMUS(file.toStringz);
		else
			cacheChunk[file] = chunk = Mix_LoadWAV(file.toStringz);

		if (mus is null && chunk is null)
			Log.MainLogger.Critical!loadFile("Failed to load '%s', aborting!", file);
		else
			Log.MainLogger.Info!loadFile("Loaded song '%s'", file);

	}

}

Song allTheTime = null;
