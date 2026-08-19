USE ott;

-- =====================================================
-- DATA VALIDATION
-- =====================================================

SELECT COUNT(*) AS total_users FROM users;
SELECT COUNT(*) AS total_movies FROM movies;
SELECT COUNT(*) AS total_watch_records FROM watch_history;
SELECT COUNT(*) AS total_reviews FROM reviews;
SELECT COUNT(*) AS total_recommendations FROM recommendation_logs;
SELECT COUNT(*) AS total_searches FROM search_logs;

-- =====================================================
-- USER ANALYSIS
-- =====================================================

SELECT COUNT(DISTINCT user_id) AS total_users
FROM users;

SELECT subscription_plan,
       COUNT(*) AS total_users
FROM users
GROUP BY subscription_plan
ORDER BY total_users DESC;

SELECT country,
       COUNT(*) AS total_users
FROM users
GROUP BY country
ORDER BY total_users DESC;

SELECT gender,
       COUNT(*) AS total_users
FROM users
GROUP BY gender
ORDER BY total_users DESC;

SELECT ROUND(AVG(age),2) AS average_age
FROM users;

SELECT primary_device,
       COUNT(*) AS users_count
FROM users
GROUP BY primary_device
ORDER BY users_count DESC;

-- =====================================================
-- WATCH BEHAVIOR ANALYSIS
-- =====================================================

SELECT ROUND(SUM(watch_duration_minutes),2) AS total_watch_time
FROM watch_history;

SELECT ROUND(AVG(watch_duration_minutes),2) AS avg_watch_duration
FROM watch_history;

SELECT user_id,
       ROUND(SUM(watch_duration_minutes),2) AS total_watch_time
FROM watch_history
GROUP BY user_id
ORDER BY total_watch_time DESC
LIMIT 10;

SELECT user_id,
       COUNT(*) AS total_sessions
FROM watch_history
GROUP BY user_id
ORDER BY total_sessions DESC
LIMIT 10;

SELECT
ROUND(
AVG(
CASE
WHEN progress_percentage >= 90 THEN 1
ELSE 0
END
)*100,2
) AS completion_rate
FROM watch_history;

SELECT HOUR(watch_date) AS viewing_hour,
       COUNT(*) AS total_views
FROM watch_history
GROUP BY viewing_hour
ORDER BY total_views DESC;

-- =====================================================
-- CONTENT PERFORMANCE ANALYSIS
-- =====================================================

SELECT m.title,
       COUNT(*) AS total_views
FROM watch_history w
JOIN movies m
ON w.movie_id = m.movie_id
GROUP BY m.title
ORDER BY total_views DESC
LIMIT 10;

SELECT m.genre_primary,
       COUNT(*) AS total_views
FROM watch_history w
JOIN movies m
ON w.movie_id = m.movie_id
GROUP BY m.genre_primary
ORDER BY total_views DESC;

SELECT m.genre_primary,
       ROUND(SUM(w.watch_duration_minutes),2) AS total_watch_time
FROM watch_history w
JOIN movies m
ON w.movie_id = m.movie_id
GROUP BY m.genre_primary
ORDER BY total_watch_time DESC;

SELECT m.content_type,
       COUNT(*) AS total_views
FROM watch_history w
JOIN movies m
ON w.movie_id = m.movie_id
GROUP BY m.content_type
ORDER BY total_views DESC;

-- =====================================================
-- REVIEW ANALYSIS
-- =====================================================

SELECT ROUND(AVG(rating),2) AS average_rating
FROM reviews;

SELECT sentiment,
       COUNT(*) AS review_count
FROM reviews
GROUP BY sentiment
ORDER BY review_count DESC;

SELECT m.title,
       ROUND(AVG(r.rating),2) AS avg_rating
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING COUNT(*) >= 5
ORDER BY avg_rating DESC
LIMIT 10;

SELECT m.title,
       ROUND(AVG(r.rating),2) AS avg_rating
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.title
HAVING COUNT(*) >= 5
ORDER BY avg_rating ASC
LIMIT 10;

SELECT m.genre_primary,
       ROUND(AVG(r.rating),2) AS avg_rating
FROM reviews r
JOIN movies m
ON r.movie_id = m.movie_id
GROUP BY m.genre_primary
ORDER BY avg_rating DESC;

-- =====================================================
-- RECOMMENDATION ANALYSIS
-- =====================================================

SELECT COUNT(*) AS total_recommendations
FROM recommendation_logs;

SELECT
ROUND(
AVG(
CASE
WHEN was_clicked = 'True' THEN 1
ELSE 0
END
)*100,2
) AS recommendation_ctr
FROM recommendation_logs;

SELECT recommendation_type,
       COUNT(*) AS total_recommendations
FROM recommendation_logs
GROUP BY recommendation_type
ORDER BY total_recommendations DESC;

SELECT movie_id,
       COUNT(*) AS recommendation_count
FROM recommendation_logs
GROUP BY movie_id
ORDER BY recommendation_count DESC
LIMIT 10;

SELECT algorithm_version,
       COUNT(*) AS recommendations
FROM recommendation_logs
GROUP BY algorithm_version
ORDER BY recommendations DESC;

-- =====================================================
-- SEARCH ANALYSIS
-- =====================================================

SELECT COUNT(*) AS total_searches
FROM search_logs;

SELECT
ROUND(
AVG(
CASE
WHEN clicked_result_position IS NOT NULL
THEN 1
ELSE 0
END
)*100,2
) AS search_success_rate
FROM search_logs;

SELECT search_query,
       COUNT(*) AS search_count
FROM search_logs
GROUP BY search_query
ORDER BY search_count DESC
LIMIT 20;

SELECT device_type,
       COUNT(*) AS searches
FROM search_logs
GROUP BY device_type
ORDER BY searches DESC;

SELECT ROUND(AVG(search_duration_seconds),2)
AS avg_search_duration
FROM search_logs;

SELECT location_country,
       COUNT(*) AS total_searches
FROM search_logs
GROUP BY location_country
ORDER BY total_searches DESC;

-- =====================================================
-- BUSINESS KPI DASHBOARD QUERIES
-- =====================================================

SELECT
COUNT(DISTINCT user_id) AS total_users
FROM users;

SELECT
ROUND(SUM(watch_duration_minutes),0)
AS total_watch_time
FROM watch_history;

SELECT
ROUND(AVG(watch_duration_minutes),2)
AS avg_watch_duration
FROM watch_history;

SELECT
ROUND(AVG(rating),2)
AS average_rating
FROM reviews;

SELECT
ROUND(
AVG(
CASE
WHEN progress_percentage >= 90
THEN 1
ELSE 0
END
)*100,2
)
AS completion_rate
FROM watch_history;

SELECT
ROUND(
AVG(
CASE
WHEN was_clicked = 'True'
THEN 1
ELSE 0
END
)*100,2
)
AS recommendation_ctr
FROM recommendation_logs;

SELECT
ROUND(
AVG(
CASE
WHEN clicked_result_position IS NOT NULL
THEN 1
ELSE 0
END
)*100,2
)
AS search_success_rate
FROM search_logs;