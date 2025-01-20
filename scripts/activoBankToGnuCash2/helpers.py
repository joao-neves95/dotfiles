from datetime import datetime
import re

from nevespy import lists


def get_current_year():
    return datetime.now().year


def find_and_increment_idx(source: str, start_at_idx: int, query: str):
    query_len = len(query)

    for i in range(start_at_idx, len(source)):
        target = source[i : i + query_len]
        if target == query:
            return i

    return -1


def str_is_re(input_str: str, regex_pattern: str):
    return re.match(regex_pattern, input_str) is not None


def split_str_by_re(input_str: str, regex_pattern: str):
    parts = re.split(f"({regex_pattern})", input_str)
    return lists.strip_str_list(parts)
