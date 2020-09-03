from datetime import datetime
from textwrap import dedent

from flourish.generators import mixins
from flourish.generators import atom
from flourish.generators import base
from flourish.generators import sass


def global_context(self):
    return {
        'publication_dates': self.publication_dates,
    }

GLOBAL_CONTEXT = global_context


class SourcePage(base.SourceGenerator):
    template_name  = 'base_template.html'


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


class AtomFeed(atom.AtomGenerator):
    def entry_content(self, object):
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


class AllGifsCSV(base.IndexGenerator):
    template_name = 'base.csv'
    sources_filter = {'published__set': ''}
    order_by = ('published')
    file_extension = '.csv'


PATHS = (
    SourcePage(
        path = '/#slug',
        name = 'source',
    ),
    TagIndex(
        path = '/tags/#tag/',
        name = 'tag-index',
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
    AtomFeed(
        path = '/index.atom',
        name = 'firehose',
    ),
    AllGifsCSV(
        path = '/index.csv',
        name = 'all-gifs-csv',
    ),
    sass.SassGenerator(
        path = '/css/#sass_source.css',
        name = 'css',
    ),
)
