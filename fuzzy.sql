SET pg_trgm.similarity_threshold = 0.4;
EXPLAIN ANALYZE SELECT * FROM address WHERE street % 'peltopatu';