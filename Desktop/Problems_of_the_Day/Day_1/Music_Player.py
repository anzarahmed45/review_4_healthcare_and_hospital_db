class Track:
    def __init__(self, title, artist, duration):
        self.title = title
        self.artist = artist
        self._seconds = self._to_seconds(duration)

    def _to_seconds(self, time_str):
        m, s = time_str.split(":")
        return int(m) * 60 + int(s)

    def _to_time(self, seconds):
        return f"{seconds//60}:{seconds%60:02d}"

    @property
    def seconds(self):
        return self._seconds

    @property
    def formatted(self):
        return self._to_time(self._seconds)

    def __str__(self):
        return f"{self.title} by {self.artist} [{self.formatted}]"


class Playlist:
    def __init__(self, name):
        self.name = name
        self.tracks = []

    def add(self, track):
        self.tracks.append(track)

    def remove(self, track):
        if track in self.tracks:
            self.tracks.remove(track)

    def _format(self, seconds):
        return f"{seconds//60}:{seconds%60:02d}"

    def total_duration(self):
        total = 0
        for t in self.tracks:
            total += t.seconds
        return self._format(total)

    def longest_track(self):
        longest = self.tracks[0]
        for t in self.tracks:
            if t.seconds > longest.seconds:
                longest = t
        return longest

    def shortest_track(self):
        shortest = self.tracks[0]
        for t in self.tracks:
            if t.seconds < shortest.seconds:
                shortest = t
        return shortest

    def average_duration(self):
        total = 0
        for t in self.tracks:
            total += t.seconds
        avg = total // len(self.tracks)
        return self._format(avg)

    def tracks_under(self, limit):
        result = []
        for t in self.tracks:
            if t.seconds < limit:
                result.append(t.title)
        return result

    def summary(self):
        return f"{self.name} | {len(self.tracks)} tracks | Total: {self.total_duration()} | Avg: {self.average_duration()}"