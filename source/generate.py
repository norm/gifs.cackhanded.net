from datetime import datetime
import random
from textwrap import dedent

from flourish.generators import mixins
from flourish.generators import atom
from flourish.generators import calendar
from flourish.generators import csv
from flourish.generators import base
from flourish.generators import sass


def global_context(self):
    return {
        'publication_dates': self.publication_dates,
    }

GLOBAL_CONTEXT = global_context


class SourcePage(base.SourceGenerator):
    template_name  = 'base_template.html'

    def get_context_data(self):
        source = self.source_objects[0]
        # don't generate GIF sources (eg tv shows, movies, etc)
        # that have no published GIFs attached
        if 'type' in source and source.type != 'static':
            if not (
                   source.agency_set.count()
                or source.brand_set.count()
                or source.artist_set.count()
                or source.episode_set.count()
                or source.mission_set.count()
                or source.show_set.count()
                or source.source_set.count()
            ):
                raise self.DoNotGenerate
        return super().get_context_data()


class MostRecentFirstMixin:
    order_by = ('-published')


class TagIndex(MostRecentFirstMixin, base.IndexGenerator):
    template_name = 'base_template.html'


class AllTags(base.IndexGenerator):
    template_name = 'base_template.html'

    def get_objects(self, tokens):
        tags = [
            tag['tag']
            for tag in 
                self.flourish.get_valid_filters_for_tokens(['tag'])
        ]
        self.source_objects = sorted(tags)


class AllSources(base.IndexGenerator):
    template_name = 'base_template.html'
    sources_filter = {'source': True}
    order_by = ('title')


class Homepage(MostRecentFirstMixin, base.IndexGenerator):
    template_name = 'base_template.html'
    sources_filter = {'published__set': ''}
    limit = 18


class GifsByYear(calendar.CalendarYearGenerator):
    template_name = 'base_template.html'
    sources_filter = {'published__set': ''}

    def get_context_data(self):
        context = super().get_context_data()

        # choose up to 24 GIFs to be displayed (24 thumbnails is a
        # manageable page size; 300+ thumbnails not so much)
        max_sample = 24
        if max_sample > len(context['pages']):
            max_sample = len(context['pages'])
        sample = random.sample(
            list(context['pages']),
            k = max_sample,
        )
        for gif in context['pages']:
            if gif in sample:
                gif.in_sample = True

        # group content into months for easier templating
        context['months'] = {}
        for page in context['pages']:
            month = page.published.month
            if month not in context['months']:
                context['months'][month] = {'pages': []}
            context['months'][month]['pages'].append(page)

        return context


class GifsByMonth(calendar.CalendarMonthGenerator):
    template_name = 'base_template.html'
    sources_filter = {'published__set': ''}


class AtomFeed(atom.AtomGenerator):
    def get_entry_content(self, object):
        template = dedent("""\
            <p><img src="{url}.gif" alt=''></p>
            {body}
            <ul>
              <li>{tags}</li>
            </ul>
            <hr>
            <p>
                The config that produced this GIF is on 
                <a href='https://github.com/norm/gifs.cackhanded.net/blob/main/source{path}.toml'>GitHub</a>.
            </p>
        """)
        return template.format(
            url = object.absolute_url,
            body = object.body,
            path = object.path,
            tags = '</li><li>'.join(object.tag),
        )

    def get_feed_title(self):
        return 'All GIFs'


class SourceAtomFeed(AtomFeed):
    sources_filter = {'source': True}

    def get_objects(self, tokens):
        source = self.flourish.get(tokens['slug'])
        self.feed_title = source.title
        if source.show_set.count():
            _filtered = source.show_set.filter(type__unset=True)
        elif source.artist_set.count():
            _filtered = source.artist_set.filter(type__unset=True)
        elif source.agency_set.count():
            _filtered = source.agency_set.filter(type__unset=True)
        elif source.parent_set.count():
            _filtered = source.parent_set.filter(type__unset=True)
        else:
            _filtered = source.source_set.order_by('-published')

        if _filtered.count() == 0:
            raise self.DoNotGenerate

        _ordered = _filtered.order_by(self.order_by)

        if self.limit is not None:
            self.source_objects = _ordered[0:self.limit]
        else:
            self.source_objects = _ordered

        return self.source_objects

    def get_feed_title(self):
        return '%s GIFs' % self.feed_title


class AllGifsCSV(csv.CSVGenerator):
    sources_filter = {'published__set': ''}
    order_by = ('published')
    fields = ['title', 'published', 'url', 'gif', 'thumbnail', 'tag']

    def get_field_value(self, object, field):
        if field == 'url':
            return object.absolute_url
        if field == 'gif':
            return '%s.gif' % object.absolute_url
        if field == 'thumbnail':
            return '%s.tn.gif' % object.absolute_url
        return super().get_field_value(object, field)


class NotFound(base.StaticGenerator):
    template_name  = 'base_template.html'

    def get_context_data(self):
        context = super().get_context_data()
        context['candidate_gifs'] = self.flourish.sources.filter(
                tag='404-page-candidate'
            )
        context['gif'] = random.sample(
            list(context['candidate_gifs']),
            k = 1,
        )[0]
        return context


PATHS = (
    SourcePage(
        path = '/#slug',
        name = 'source',
    ),
    SourceAtomFeed(
        path = '/#slug.atom',
        name = 'source-atom',
    ),
    TagIndex(
        path = '/tags/#tag/',
        name = 'tag-index',
    ),
    AtomFeed(
        path = '/tags/#tag/index.atom',
        name = 'tag-atom',
    ),
    AllTags(
        path = '/tags/',
        name = 'tags',
    ),
    Homepage(
        path = '/',
        name = 'homepage',
    ),
    AllSources(
        path = '/sources',
        name = 'sources',
    ),
    GifsByYear(
        path = '/#year/',
        name = 'year-index',
    ),
    GifsByMonth(
        path = '/#year/#month/',
        name = 'month-index',
    ),
    AtomFeed(
        path = '/index.atom',
        name = 'firehose',
    ),
    AllGifsCSV(
        path = '/index.csv',
        name = 'all-gifs-csv',
    ),
    NotFound(
        path = '/404',
        name = 'not-found',
    ),
    sass.SassGenerator(
        path = '/css/#sass_source.css',
        name = 'css',
    ),
)
