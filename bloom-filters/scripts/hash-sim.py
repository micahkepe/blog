#!/usr/bin/env python
import time
from random import randint

# Initialize hash set
hash_set = set()

# Generate random malicious URLs
malicious_urls = [f"https://malicious.com/{randint(0, 1000000)}" for _ in range(1000000)]

# Generate random user URLs
user_urls = [f"https://user.com/{randint(0, 1000000)}" for _ in range(100000)]

# Measure hash set insertion time
start_time = time.time()
for url in malicious_urls:
    hash_set.add(url)
hash_set_insertion_time = time.time() - start_time

# Measure hash set query time
start_time = time.time()
false_positives = 0
for url in user_urls:
    if url in hash_set:
        false_positives += 1
hash_set_query_time = time.time() - start_time

print(f"Hash Set Insertion Time: {hash_set_insertion_time} seconds")
print(f"Hash Set Query Time: {hash_set_query_time} seconds")
print(f"False Positives: {false_positives}")
print(f"Memory Usage: {len(hash_set) * 50 / 1024 / 1024:.2f} MB")
