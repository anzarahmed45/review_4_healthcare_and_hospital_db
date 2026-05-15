reviews = [
    {"movie": "Inception", "user": "alice", "rating": 9},
    {"movie": "Dune", "user": "bob", "rating": 8},
    {"movie": "Inception", "user": "bob", "rating": 7},
    {"movie": "Interstellar","user":"alice", "rating": 10},
    {"movie": "Dune", "user": "charlie","rating": 9},
    {"movie": "Interstellar","user":"charlie","rating": 8},
]

movie_totals = {}
movie_counts = {}

for r in reviews:
    m = r["movie"]
    movie_totals[m] = movie_totals.get(m, 0) + r["rating"]
    movie_counts[m] = movie_counts.get(m, 0) + 1

avg_ratings = {}
for m in movie_totals:
    avg_ratings[m] = movie_totals[m] / movie_counts[m]

top_movie = None
top_rating = -1

for m in avg_ratings:
    if avg_ratings[m] > top_rating:
        top_rating = avg_ratings[m]
        top_movie = m

must_watch = []
for m in avg_ratings:
    if avg_ratings[m] >= 8.5:
        must_watch.append(m)

user_favs = {}

for r in reviews:
    u = r["user"]
    movie = r["movie"]
    rating = r["rating"]

    if u not in user_favs:
        user_favs[u] = (rating, movie)
    else:
        if rating > user_favs[u][0]:
            user_favs[u] = (rating, movie)

for u in user_favs:
    user_favs[u] = user_favs[u][1]

print(avg_ratings)
print(top_movie)
print(must_watch)
print(user_favs)