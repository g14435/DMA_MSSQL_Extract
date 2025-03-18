-- Query Server Instance max min MEM
SELECT [name], [value], [value_in_use]
FROM sys.configurations
WHERE [name] = 'max server memory (MB)' OR [name] = 'min server memory (MB)';