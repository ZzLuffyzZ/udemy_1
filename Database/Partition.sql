-- // ***  partition ***
-- + Phân vùng ngang: Chia table theo các row - bản ghi.
-- + Phân vùng dọc: Chia table theo các column.

-- // Có 3 loại Partition 
-- + Range Partition
-- + List Partition
-- + Hash Partition

-- // Note:
-- + Partition sẽ được bắt đầu từ index bằng 0
-- + Số Partition có thể chia tối đa là 8192 partition
-- + partion name không phân biệt hoa thường, chẳng hạn partitionNumber1 & PARTITIONNUMBER1 sẽ báo lỗi

DROP TABLE Persons;

-- Range Partition --

CREATE TABLE Persons (
    id serial4 NOT NULL,
    name varchar(255) not null,
    age int2,
    created_date timestamp DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    PRIMARY KEY (id, age)
) PARTITION BY RANGE (age);
CREATE TABLE p_0 PARTITION OF Persons
    FOR VALUES from (0) to (1000);
CREATE TABLE p_1 PARTITION OF Persons
    FOR VALUES from (1000) to (2000);
CREATE TABLE p_2 PARTITION OF Persons
    FOR VALUES from (2000) to (3000);
select * from Persons where age = 2000

-- List Partition --
CREATE TABLE Person2 (
    id serial4 NOT NULL,
    name varchar(255) not null,
    month int2 not null,
    created_date timestamp  DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    PRIMARY KEY (id, month)
) PARTITION BY LIST (month);
PARTITION BY LIST (month) (
    PARTITION pX VALUES IN (1,2,3),
    PARTITION pH VALUES IN (4,5,6),
    PARTITION pT VALUES IN (7,8,9),
    PARTITION pD VALUES IN (10,11,12)
);

CREATE TABLE pX PARTITION OF sales_region FOR VALUES IN (1,2,3);

CREATE TABLE pY PARTITION OF sales_region FOR VALUES IN (4,5,6);

CREATE TABLE pZ PARTITION OF sales_region FOR VALUES IN (7,8,9);
-- value thuộc 1 tập constant, nếu insert ngoài giá trị thì bị lỗi,
-- nên chọn những cái cố định như ngày , tháng.

SELECT * FROM Person2 WHERE month = 2;

-- Hash Partition ---
CREATE TABLE Person3 (
    id serial4 NOT NULL,
    name VARCHAR(30),
    created_date timestamp DEFAULT CURRENT_TIMESTAMP,
    created_user VARCHAR(20) DEFAULT '9999',
    store_id int2,
    PRIMARY KEY (id, store_id)
)PARTITION BY HASH(store_id);
CREATE TABLE p1 PARTITION OF Person3 FOR VALUES WITH (MODULUS 5,REMAINDER 0);
CREATE TABLE p2 PARTITION OF Person3 FOR VALUES WITH (MODULUS 5,REMAINDER 1);
CREATE TABLE p3 PARTITION OF Person3 FOR VALUES WITH (MODULUS 5,REMAINDER 2);
CREATE TABLE p4 PARTITION OF Person3 FOR VALUES WITH (MODULUS 5,REMAINDER 3);
CREATE TABLE p5 PARTITION OF Person3 FOR VALUES WITH (MODULUS 5,REMAINDER 4);
-- Không giống như Range và List, Hash Partition không cần define trước value để quyết định xem row insert sẽ đc assign vào partition nào một cách tự động
-- Hash Partition chỉ sử dụng trên 1 column.
