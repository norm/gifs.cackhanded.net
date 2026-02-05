import random
from datetime import datetime


def parse_history(text):
    history = {}
    for line in text.strip().split('\n'):
        if not line.strip():
            continue
        date_str, slug = line.strip().split(' ', 1)
        date = datetime.fromisoformat(date_str)
        if slug in history:
            if date > history[slug]['last']:
                history[slug]['last'] = date
            history[slug]['count'] += 1
        else:
            history[slug] = {'last': date, 'count': 1}
    return history


def filter_pool(pool, history, now, recent_days=7):
    result = []
    for gif in pool:
        if 'random_post' in gif and gif.random_post is False:
            continue
        path = gif.path.lstrip('/')
        if path not in history:
            continue
        days_since = (now - history[path]['last']).days
        if days_since < recent_days:
            continue
        result.append(gif)
    return result


def calculate_weight(gif, history, now):
    path = gif.path.lstrip('/')
    source = path.split('/')[0]

    days_since_gif = (now - history[path]['last']).days
    post_count = history[path]['count']

    source_last_posted = None
    for hist_path, data in history.items():
        if hist_path.startswith(source + '/'):
            if source_last_posted is None or data['last'] > source_last_posted:
                source_last_posted = data['last']
    days_since_source = (now - source_last_posted).days

    return days_since_gif / post_count + days_since_source


def select_random_gif(pool, history, now):
    weights = [
        calculate_weight(gif, history, now)
            for gif in pool
    ]
    return random.choices(pool, weights=weights)[0]


def get_source_info(gif):
    if 'show_fkey' in gif:
        return gif.show.title, gif.episode, None
    if 'artist_fkey' in gif:
        return gif.artist.title, gif.source.title, None
    if 'mission_fkey' in gif:
        year = None
        if 'start' in gif.mission:
            year = gif.mission.start.year
        return gif.agency.title, gif.mission.title, year
    if 'brand_fkey' in gif:
        return gif.brand.title, None, None
    year = None
    if 'year' in gif.source:
        year = gif.source.year
    return gif.source.title, None, year


def format_post_text(gif):
    source, secondary, year = get_source_info(gif)
    description = gif.body_markdown.replace('\n', ' ').strip()
    date = gif.published.strftime('%-d %B %Y')

    lines = []
    line = 'One from the archives: "%s" from %s' % (gif.title, source)
    if secondary and hasattr(secondary, 'season'):
        episode_num = '%dx%02d' % (secondary.season, secondary.episode)
        line += ', episode %s "%s".' % (episode_num, secondary.title)
    elif secondary:
        if year:
            line += ', %s (%s).' % (secondary, year)
        else:
            line += ', "%s".' % secondary
    elif year:
        line += ' (%s).' % year
    else:
        line += '.'
    lines.append(line)
    lines.append('')
    lines.append(description)
    lines.append('')
    lines.append('First posted %s.' % date)

    return '\n'.join(lines), description
