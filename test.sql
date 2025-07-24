-- 펫 주인 테이블
CREATE TABLE PetOwners (
    ownerID INT AUTO_INCREMENT PRIMARY KEY, -- 펫 주인 고유 ID
    name VARCHAR(100) NOT NULL,             -- 이름
    contact VARCHAR(50) NOT NULL UNIQUE     -- 연락처 (중복 방지)
);

-- 펫 테이블
CREATE TABLE Pets (
    petID INT AUTO_INCREMENT PRIMARY KEY,   -- 펫 고유 ID
    ownerID INT NOT NULL,                   -- 펫 주인 ID (FK)
    name VARCHAR(100) NOT NULL,             -- 이름
    species VARCHAR(50) DEFAULT '개',       -- 종 (기본값 개)
    breed VARCHAR(50),                      -- 품종
    weight INT CHECK (weight > 0),          -- 무게 (0 이상)
    FOREIGN KEY (ownerID) REFERENCES PetOwners(ownerID)
);

-- 객실 테이블
CREATE TABLE Rooms (
    roomID INT AUTO_INCREMENT PRIMARY KEY,  -- 객실 고유 ID
    roomNumber VARCHAR(20) NOT NULL UNIQUE, -- 객실 번호 (중복 방지)
    roomType VARCHAR(50) DEFAULT '스탠다드', -- 객실 타입 (기본값 스탠다드)
    pricePerNight DECIMAL(10, 2) NOT NULL CHECK (pricePerNight >= 0) -- 1박당 가격
);

-- 서비스 테이블
CREATE TABLE Services (
    serviceID INT AUTO_INCREMENT PRIMARY KEY, -- 서비스 고유 ID
    serviceName VARCHAR(50) NOT NULL UNIQUE,  -- 서비스 이름 (중복 방지)
    servicePrice DECIMAL(10, 2) NOT NULL CHECK (servicePrice >= 0) -- 가격
);

-- 예약 테이블
CREATE TABLE Reservations (
    reservationID INT AUTO_INCREMENT PRIMARY KEY, -- 예약 고유 ID
    petID INT NOT NULL,                           -- 펫 ID (FK)
    roomID INT NOT NULL,                          -- 객실 ID (FK)
    startDate DATE NOT NULL,                      -- 시작일
    endDate DATE NOT NULL,                        -- 종료일
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 예약 생성일시 자동 기록
    CHECK (endDate > startDate),                  -- 종료일은 시작일 이후
    FOREIGN KEY (petID) REFERENCES Pets(petID),
    FOREIGN KEY (roomID) REFERENCES Rooms(roomID)
);

-- 예약-서비스 관계 테이블 (N:M)
CREATE TABLE Reservation_Services (
    reservationID INT NOT NULL,
    serviceID INT NOT NULL,
    PRIMARY KEY (reservationID, serviceID),
    FOREIGN KEY (reservationID) REFERENCES Reservations(reservationID) ON DELETE CASCADE,
    FOREIGN KEY (serviceID) REFERENCES Services(serviceID)
);

-- 펫 주인 삽입
INSERT INTO PetOwners (name, contact)
VALUES ('이주완', '010-1234-5678');

-- 펫 삽입
INSERT INTO Pets (ownerID, name, species, breed, weight)
VALUES (1, '초코', '개', '푸들', 5);

-- 객실 삽입
INSERT INTO Rooms (roomNumber, roomType, pricePerNight)
VALUES
('A101', '스탠다드', 50000),
('A102', '디럭스', 80000);

-- 서비스 삽입
INSERT INTO Services (serviceName, servicePrice)
VALUES
('목욕', 15000),
('미용', 25000);

-- 예약 삽입
INSERT INTO Reservations (petID, roomID, startDate, endDate)
VALUES (1, 1, '2025-08-01', '2025-08-03');

-- 예약-서비스 연결
INSERT INTO Reservation_Services (reservationID, serviceID)
VALUES (1, 1); -- 예약 1번에 목욕 추가