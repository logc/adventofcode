import unittest

from utils import pairwise


class ExampleTests(unittest.TestCase):

    def test_react(self):
        result = react('aA')
        self.assertEquals(result, '')

    def test_recursive_react(self):
        result = react('abBA')
        self.assertEquals(result, '')

def must_react(a, b):
    return a == b.lower()
