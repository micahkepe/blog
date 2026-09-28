#!/usr/bin/env python
# /// script
# dependencies = ["mmh3", "bitarray"]
# ///
import math
import time
import mmh3
from bitarray import bitarray
from random import randint

class BloomFilter:
    def __init__(self, items_count, fp_prob):
        self.fp_prob = fp_prob
        self.size = self.get_size(items_count, fp_prob)
        self.hash_count = self.get_hash_count(self.size, items_count)
        self.bit_array = bitarray(self.size)
        self.bit_array.setall(0)

    def add(self, item):
        digests = []
        for i in range(self.hash_count):
            digest = mmh3.hash(item, i) % self.size
            digests.append(digest)
            self.bit_array[digest] = True

    def check(self, item):
        for i in range(self.hash_count):
            digest = mmh3.hash(item, i) % self.size
            if not self.bit_array[digest]:
                return False
        return True

    @classmethod
    def get_size(cls, n, p):
        m = -(n * math.log(p))/(math.log(2)**2)
        return int(m)

    @classmethod
    def get_hash_count(cls, m, n):
        k = (m/n) * math.log(2)
        return int(k)

# Initialize Bloom filter
bloom = BloomFilter(1000000, 0.01)

# Generate random malicious URLs
malicious_urls = [f"https://malicious.com/{randint(0, 1000000)}" for _ in range(1000000)]

# Generate random user URLs
user_urls = [f"https://user.com/{randint(0, 1000000)}" for _ in range(100000)]

# Measure Bloom filter insertion time
start_time = time.time()
for url in malicious_urls:
    bloom.add(url)
bloom_insertion_time = time.time() - start_time

# Measure Bloom filter query time
start_time = time.time()
false_positives = 0
for url in user_urls:
    if bloom.check(url):
        false_positives += 1
bloom_query_time = time.time() - start_time

print(f"Bloom Filter Insertion Time: {bloom_insertion_time} seconds")
print(f"Bloom Filter Query Time: {bloom_query_time} seconds")
print(f"False Positives: {false_positives}")
print(f"Memory Usage: {bloom.size / 8 / 1024 / 1024:.2f} MB")
