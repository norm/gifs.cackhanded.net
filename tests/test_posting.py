import sys
from datetime import datetime, timezone
from textwrap import dedent

sys.path.insert(0, 'lib')

from flourish import Flourish

from posting import (
    calculate_weight,
    filter_pool,
    format_post_text,
    parse_history,
    select_random_gif,
)


fl = Flourish()


def get_gif(slug):
    return list(fl.sources.filter(slug=slug))[0]


class TestFormatPostText:
    def test_tv_show_format(self):
        gif = get_gif('ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit')
        text, description = format_post_text(gif)
        expected = dedent('''
            One from the archives: "Holy fucking shit" from Ted Lasso, episode 2x12 "Inverting the Pyramid of Success".

            Keeley, reading her computer screen, screams “Holy fucking shit!” and bounces in her chair excitedly.

            First posted 12 August 2022.
        ''').strip()
        assert text == expected

    def test_film_format(self):
        gif = get_gif('airplane/a-little-hot')
        text, description = format_post_text(gif)
        expected = dedent('''
            One from the archives: "A little hot" from Airplane! (1980).

            The “a little hot” warning light blinks.

            First posted 1 October 2020.
        ''').strip()
        assert text == expected

    def test_brand_format(self):
        gif = get_gif('advertising/tango/slap')
        text, description = format_post_text(gif)
        expected = dedent('''
            One from the archives: "Slap" from Tango.

            A big orange fella gives a chap holding a can of Tango a good old slapping.

            First posted 30 January 2022.
        ''').strip()
        assert text == expected

    def test_artist_format(self):
        gif = get_gif('thompson-twins/work-hard-on-machines')
        text, description = format_post_text(gif)
        expected = dedent('''
            One from the archives: "I know what it means to work hard on machines" from Thompson Twins, "You Take Me Up".

            Tom Bailey of the Thompson Twins singing “I know what it means to work hard on machines”.

            First posted 25 February 2021.
        ''').strip()
        assert text == expected

    def test_mission_format(self):
        gif = get_gif('nasa/apollo-11/moon-on-a-stick')
        text, description = format_post_text(gif)
        expected = dedent('''
            One from the archives: "Moon on a stick" from NASA, Apollo 11 (1969).

            Neil Armstrong and Buzz Aldrin plant the American flag on the moon. The image is vertically flipped so that it looks like the moon is on top of the stick.

            First posted 7 July 2015.
        ''').strip()
        assert text == expected


class TestFilterPool:
    @classmethod
    def setup_class(cls):
        cls.ted1 = get_gif('ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit')
        cls.ted2 = get_gif('ted-lasso/lavender/game-face')
        cls.airplane = get_gif('airplane/a-little-hot')
        cls.excluded = get_gif('lilo-and-stitch/yes-i-know')

    def test_excludes_recently_posted(self):
        now = datetime(2024, 1, 15, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-10T12:00:00+00:00 ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit
            2024-01-01T12:00:00+00:00 ted-lasso/lavender/game-face
            2024-01-01T12:00:00+00:00 airplane/a-little-hot
        '''))
        pool = [self.ted1, self.ted2, self.airplane]
        result = filter_pool(pool, history, now, recent_days=7)
        assert self.ted1 not in result
        assert self.ted2 in result
        assert self.airplane in result

    def test_includes_gif_posted_beyond_threshold(self):
        now = datetime(2024, 1, 15, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-01T12:00:00+00:00 ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit
            2024-01-01T12:00:00+00:00 ted-lasso/lavender/game-face
            2024-01-01T12:00:00+00:00 airplane/a-little-hot
        '''))
        pool = [self.ted1, self.ted2, self.airplane]
        result = filter_pool(pool, history, now, recent_days=7)
        assert self.ted1 in result
        assert self.ted2 in result
        assert self.airplane in result

    def test_excludes_gif_never_posted(self):
        now = datetime(2024, 1, 15, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-01T12:00:00+00:00 ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit
        '''))
        pool = [self.ted1, self.ted2, self.airplane]
        result = filter_pool(pool, history, now, recent_days=7)
        assert self.ted1 in result
        assert self.ted2 not in result
        assert self.airplane not in result

    def test_excludes_random_post_false(self):
        now = datetime(2024, 1, 15, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-01T12:00:00+00:00 ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit
            2024-01-01T12:00:00+00:00 lilo-and-stitch/yes-i-know
            2024-01-01T12:00:00+00:00 airplane/a-little-hot
        '''))
        pool = [self.ted1, self.excluded, self.airplane]
        result = filter_pool(pool, history, now, recent_days=7)
        assert self.ted1 in result
        assert self.excluded not in result
        assert self.airplane in result

    def test_empty_pool_when_all_excluded(self):
        now = datetime(2024, 1, 15, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-14T12:00:00+00:00 airplane/a-little-hot
            2024-01-01T12:00:00+00:00 lilo-and-stitch/yes-i-know
        '''))
        pool = [self.excluded, self.airplane]
        result = filter_pool(pool, history, now, recent_days=7)
        assert result == []


class TestCalculateWeight:
    @classmethod
    def setup_class(cls):
        cls.ted_holy = get_gif('ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit')
        cls.ted_game = get_gif('ted-lasso/lavender/game-face')
        cls.airplane_hot = get_gif('airplane/a-little-hot')
        cls.airplane_picked = get_gif('airplane/wrong-week')
        cls.tango = get_gif('advertising/tango/slap')
        cls.apollo = get_gif('nasa/apollo-11/moon-on-a-stick')
        cls.twins = get_gif('thompson-twins/work-hard-on-machines')

    def test_weights_reflect_recency_count_and_source(self):
        import random
        now = datetime(2024, 1, 15, 12, 0, 0, tzinfo=timezone.utc)
        history = parse_history(dedent('''
            2024-01-14T12:00:00+00:00 ted-lasso/inverting-the-pyramid-of-success/holy-fucking-shit
            2024-01-10T12:00:00+00:00 ted-lasso/lavender/game-face
            2023-10-15T12:00:00+00:00 airplane/a-little-hot
            2023-10-15T12:00:00+00:00 airplane/a-little-hot
            2023-10-15T12:00:00+00:00 airplane/a-little-hot
            2023-06-01T12:00:00+00:00 airplane/wrong-week
            2023-01-01T12:00:00+00:00 advertising/tango/slap
            2022-01-01T12:00:00+00:00 nasa/apollo-11/moon-on-a-stick
            2023-06-01T12:00:00+00:00 thompson-twins/work-hard-on-machines
        '''))
        pool = [
            self.ted_holy,
            self.ted_game,
            self.airplane_hot,
            self.airplane_picked,
            self.tango,
            self.apollo,
            self.twins,
        ]
        weights = [calculate_weight(gif, history, now) for gif in pool]
        assert weights == [
            1/1 + 1,        # ted_holy: 1 day, count=1, source=1 day
            5/1 + 1,        # ted_game: 5 days, count=1, source=1 day
            92/3 + 92,      # airplane_hot: 92 days, count=3, source=92 days
            228/1 + 92,     # airplane_picked: 228 days, count=1, source=92 days
            379/1 + 379,    # tango: 379 days, count=1, source=379 days
            744/1 + 744,    # apollo: 744 days, count=1, source=744 days
            228/1 + 228,    # twins: 228 days, count=1, source=228 days
        ]

        # run a monte carlo simulation to prove select_random_gif honours weights
        random.seed(42)
        selections = [
            select_random_gif(pool, history, now)
                for _ in range(10_000)
        ]
        counts = {
            gif: selections.count(gif)
                for gif in pool
        }

        # ~1488 > ~758: oldest gif wins
        assert counts[self.apollo] > counts[self.tango]
        # ~758 > ~456: tango's gif older (379 vs 228 days)
        assert counts[self.tango] > counts[self.twins]
        # ~456 > ~320: same gif age, but twins' source older (228 vs 92 days)
        assert counts[self.twins] > counts[self.airplane_picked]
        # ~320 > ~123: same source, but fewer posts
        assert counts[self.airplane_picked] > counts[self.airplane_hot]
        # ~123 > ~6: much older beats recent
        assert counts[self.airplane_hot] > counts[self.ted_game]
        # ~6 > ~2: 5 days beats 1 day
        assert counts[self.ted_game] > counts[self.ted_holy]
