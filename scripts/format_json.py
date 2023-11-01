#!python3

try:
  import json5 as json_load
except ImportError:
  import json as json_load

import argparse
import json
from json import JSONEncoder
from typing import Any, Generator
import sys



# TODO determine if encoded dict/list is < certain length and if so just return as a single line
#    Otherwise do one item per line
# When Encoding a list or dictionary
#    if subitems encode < certain length, and sub items don't have newlines, then encode onto a single line

# Sort items by value type so scalars values appear first


def item_sort_key(item):
  key, val = item
  key = key.lower()
  if isinstance(val, dict):
    return (key.split(".")[0], 3, key)
  elif isinstance(val, (list, tuple)):
    return (key.split(".")[0], 2, key)
  else:
    return (key.split(".")[0], 1, key)


class Scope():
  def __init__(self, indent_lvl, indent, sep):
    self.total_len = 0
    self.indent_lvl = indent_lvl
    self.sep = sep
    self.indent = indent
    self.tokens = []

    self.nl_indent = "" if indent is None else "\n" + indent * (indent_lvl + 1)
    self.cl_indent = "" if indent is None else "\n" + indent * (indent_lvl)

  def add_token(self, token):
    self.total_len += len(token)
    self.tokens.append(token)

  def yield_all(self, force=0):
    if self.tokens[-1] in "]}" or force:
      while self.tokens:
        t = self.tokens.pop(0)

        if t == self.sep and self.total_len > 80:
          yield self.sep + self.nl_indent

        elif t in "[{" and self.total_len > 80:
          yield t + self.nl_indent

        elif t in "]}" and self.total_len > 80:
          yield self.cl_indent + t

        else:
          yield t


class MyJSONEncoder(JSONEncoder):
  item_separator = ', '
  key_separator = ': '

  def __init__(self, skipkeys=False, ensure_ascii=True,
               check_circular=True, allow_nan=True, sort_keys=False,
               indent=None, separators=None, default=None):

    self.skipkeys = skipkeys
    self.ensure_ascii = ensure_ascii
    self.check_circular = check_circular
    self.allow_nan = allow_nan
    self.sort_keys = sort_keys
    self.indent = indent

    if separators is not None:
      self.item_separator, self.key_separator = separators
    elif indent is not None:
      self.item_separator = ','

    if default is not None:
      self.default = default

    if self.indent is not None and not isinstance(self.indent, str):
      self.indent = ' ' * self.indent

  def default(self, o):
    raise TypeError(f'Object of type {o.__class__.__name__} is not JSON serializable')

  def encode(self, o):
    chunks = self.iterencode(o)
    if not isinstance(chunks, (list, tuple)):
      chunks = list(chunks)
    return ''.join(chunks)

  def iterencode(self, o):
    self.scopes = []

    self.markers = {} if self.check_circular else None
    return self._iterencode(o, 0)

  def _iterencode(self, o, current_indent_level):
    if isinstance(o, str):
      yield self.encode_str(o)
    elif isinstance(o, bool):
      yield self.encode_bool(o)
    elif isinstance(o, int):
      yield self.encode_int(o)
    elif isinstance(o, float):
      yield self.encode_float(o)
    elif o is None:
      yield self.encode_null(o)
    elif isinstance(o, (list, tuple)):
      yield from self.iterencode_list(o, current_indent_level)
    elif isinstance(o, dict):
      yield from self.iterencode_dict(o, current_indent_level)
    else:
      yield from self.iterencode_object(o, current_indent_level)

  def _encode_dict_key(self, key):
    if isinstance(key, str):
      pass
    elif isinstance(key, bool):
      key = self.encode_bool(key)
    elif isinstance(key, int):
      key = self.encode_int(key)
    elif isinstance(key, float):
      key = self.encode_float(key)
    elif key is None:
      key = self.encode_null(key)
    elif self.skipkeys:
      key = None
    else:
      raise TypeError(f'keys must be str, int, float, bool or None, not {key.__class__.__name__}')
    return key

  def check_circular_push(self, item):
    if self.markers is not None:
      markerid = id(item)
      if markerid in self.markers:
        raise ValueError("Circular reference detected")
      self.markers[markerid] = item

  def check_circular_pop(self, item):
    if self.markers is not None:
      markerid = id(item)
      del self.markers[markerid]

  def encode_str(self, o):
    if self.ensure_ascii:
      return json.encoder.encode_basestring_ascii(o)
    else:
      return json.encoder.encode_basestring(o)

  def encode_int(self, o):
    return int.__repr__(o)

  def encode_float(self, o):
    if o != o:
      text = 'NaN'
    elif o == float("inf"):
      text = 'Infinity'
    elif o == float("-inf"):
      text = '-Infinity'
    else:
      return float.__repr__(o)

    if not self.allow_nan:
      raise ValueError("Out of range float values are not JSON compliant: " + repr(o))

    return text

  def encode_bool(self, o):
    return "true" if o else "false"

  def encode_null(self, o):
    return "null"

  def open_scope(self, token, indent_lvl):
    scope = Scope(indent_lvl, self.indent, self.item_separator)
    self.scopes.append(scope)
    scope.add_token(token)
    yield from scope.yield_all()

  def close_scope(self, token):
    scope = self.scopes.pop(-1)
    scope.add_token(token)
    if self.scopes:
      outer = self.scopes[-1]
      outer.add_token("".join(scope.yield_all(1)))
      yield from outer.yield_all()
    else:
      yield from scope.yield_all(1)

  def add_cache(self, token):
    scope = self.scopes[-1]
    if isinstance(token, Generator):
      for t in token:
        scope.add_token(t)
    else:
      scope.add_token(token)

    yield from scope.yield_all()

  def iterencode_list(self, lst, current_indent_level):
    if not lst:
      yield from self.add_cache('[]')
      return

    self.check_circular_push(lst)
    yield from self.open_scope('[', current_indent_level)

    for i, value in enumerate(lst):
      if i > 0:
        yield from self.add_cache(self.item_separator)
      yield from self.add_cache(self._iterencode(value, current_indent_level + 1))

    yield from self.close_scope(']')

    self.check_circular_pop(lst)

  def iterencode_dict(self, dct, current_indent_level):
    if not dct:
      yield from self.add_cache('{}')
      return

    self.check_circular_push(dct)

    yield from self.open_scope("{", current_indent_level)

    if self.sort_keys:
      items = sorted(dct.items(), key=item_sort_key)
    else:
      items = dct.items()

    first = True
    for key, value in items:
      key = self._encode_dict_key(key)
      if key is None:
        continue
      if not first:
        yield from self.add_cache(self.item_separator)

      yield from self.add_cache(self.encode_str(key))
      yield from self.add_cache(self.key_separator)
      iter = self._iterencode(value, current_indent_level + 1)
      yield from self.add_cache(iter)

      first = False

    yield from self.close_scope('}')

    self.check_circular_pop(dct)

  def iterencode_object(self, obj, current_indent_level):
    self.check_circular_push(obj)
    iterable = self.default(obj)
    yield from self._iterencode(iterable, current_indent_level)
    self.check_circular_pop(obj)


def main(argv=None):
  parser = argparse.ArgumentParser()
  parser.add_argument("filename", nargs="?")
  args = parser.parse_args(argv)

  if(args.filename):
    filename = args.filename
    with open(filename, "r") as fp:
      data = json_load.load(fp)
  else:
    data = json_load.load(sys.stdin)

  encoder = MyJSONEncoder(indent="  ", sort_keys=True)
  print(encoder.encode(data))

if __name__ == "__main__":
  main()
