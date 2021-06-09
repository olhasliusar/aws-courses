CREATE DATABASE course_db;

CREATE TABLE lessons(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

INSERT INTO lessons(name) VALUES ('EC2');
INSERT INTO lessons(name) VALUES ('S3');

SELECT * FROM lessons;
