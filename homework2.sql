----с использованием агрегатных функций

SELECT 
    a.first_name,
    a.last_name,
    COUNT(DISTINCT p.id) AS post_count,
    JSON_AGG(DISTINCT p.title) AS post_titles
FROM 
    authors a
JOIN 
    posts p ON a.id = p.author_id
JOIN 
    post_tag pt ON p.id = pt.post_id
GROUP BY 
    a.id
ORDER BY 
    post_count DESC
LIMIT 1;



----с использованием оконных функций

WITH author_posts AS (
    SELECT 
        a.id AS author_id,
        a.first_name,
        a.last_name,
        COUNT(DISTINCT p.id) AS post_count,
        JSON_AGG(DISTINCT p.title) AS post_titles
    FROM 
        authors a
    JOIN 
        posts p ON a.id = p.author_id
    JOIN 
        post_tag pt ON p.id = pt.post_id
    GROUP BY 
        a.id
),
ranked_authors AS (
    SELECT 
        first_name,
        last_name,
        post_count,
        post_titles,
        RANK() OVER (ORDER BY post_count DESC) AS rank
    FROM 
        author_posts
)
SELECT 
    first_name,
    last_name,
    post_count,
    post_titles
FROM 
    ranked_authors
WHERE 
    rank = 1;



----с использованием подзапросов

SELECT 
    a.first_name,
    a.last_name,
    COUNT(DISTINCT p.id) AS post_count,
    JSON_AGG(DISTINCT p.title) AS post_titles
FROM 
    authors a
JOIN 
    posts p ON a.id = p.author_id
JOIN 
    post_tag pt ON p.id = pt.post_id
GROUP BY 
    a.id
HAVING 
    COUNT(DISTINCT p.id) = (
        SELECT 
            MAX(post_count)
        FROM (
            SELECT 
                COUNT(DISTINCT p.id) AS post_count
            FROM 
                posts p
            JOIN 
                post_tag pt ON p.id = pt.post_id
            GROUP BY 
                p.author_id
        ) subquery
    );


----с использованием CTE

WITH post_tag_count AS (
    SELECT 
        p.author_id,
        COUNT(DISTINCT pt.post_id) AS post_count,
        JSON_AGG(DISTINCT p.title) AS post_titles
    FROM 
        posts p
    JOIN 
        post_tag pt ON p.id = pt.post_id
    GROUP BY 
        p.author_id
),
max_posts AS (
    SELECT 
        author_id,
        post_count,
        post_titles
    FROM 
        post_tag_count
    WHERE 
        post_count = (SELECT MAX(post_count) FROM post_tag_count)
)
SELECT 
    a.first_name,
    a.last_name,
    max_posts.post_count,
    max_posts.post_titles
FROM 
    max_posts
JOIN 
    authors a ON a.id = max_posts.author_id;


