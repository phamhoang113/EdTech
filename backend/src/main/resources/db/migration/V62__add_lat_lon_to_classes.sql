-- V62: Add latitude and longitude to classes

ALTER TABLE classes 
    ADD COLUMN latitude DECIMAL(10, 7),
    ADD COLUMN longitude DECIMAL(10, 7);
