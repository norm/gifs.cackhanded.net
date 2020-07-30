from datetime import datetime

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
    atom.AtomGenerator(
        path = '/index.atom',
        name = 'firehose',
    ),
    sass.SassGenerator(
        path = '/css/#sass_source.css',
        name = 'css',
    ),
)
